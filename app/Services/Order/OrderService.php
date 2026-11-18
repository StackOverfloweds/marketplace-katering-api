<?php

namespace App\Services\Order;

use App\Models\Order;
use App\Models\Profile;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Str;
use App\Services\Invoice\InvoiceService;
class OrderService
{

    public function __construct(
        protected InvoiceService $invoiceService
    ) {}
    /**
     * Create a new order with its order items.
     *
     * @param User $user
     * @param array $data
     * @return Order
     *
     * @throws ValidationException
     */
    public function createOrder(User $user, array $data): Order
    {
        return DB::transaction(function () use ($user, $data) {

            $customerProfile = $user->profile;

            if (!$customerProfile) {
                throw ValidationException::withMessages([
                    'customer' => 'Profil customer tidak ditemukan.',
                ]);
            }

            $merchantProfile = Profile::query()
            ->with('user')
            ->where('id', $data['merchant_profile_id'])
            ->first();

            if (!$merchantProfile || !$merchantProfile->user || $merchantProfile->user->role !== 'merchant'
            ) {
                throw ValidationException::withMessages([
                    'merchant_profile_id' => 'Merchant tidak valid atau tidak ditemukan.',
                ]);
            }

            $menuIds = collect($data['items'])
                ->pluck('menu_id')
                ->unique()
                ->values();

            $menus = \App\Models\Menu::query()
                ->whereIn('id', $menuIds)
                ->where('merchant_profile_id', $merchantProfile->id)
                ->where('is_available', true)
                ->lockForUpdate()
                ->get()
                ->keyBy('id');

            if ($menus->count() !== $menuIds->count()) {
                throw ValidationException::withMessages([
                    'items' => 'Beberapa menu tidak tersedia atau bukan milik merchant yang dipilih.',
                ]);
            }

            $subtotalCents = 0;
            $orderItems = [];

            foreach ($data['items'] as $item) {
                $menu = $menus->get($item['menu_id']);

                $priceCents = (int) round(
                    (float) $menu->price * 100
                );

                $itemSubtotalCents = $priceCents * (int) $item['quantity'];

                $subtotalCents += $itemSubtotalCents;

                $orderItems[] = [
                    'menu_id' => $menu->id,
                    'menu_name' => $menu->name,
                    'price' => number_format(
                        $priceCents / 100,
                        2,
                        '.',
                        ''
                    ),
                    'quantity' => (int) $item['quantity'],
                    'subtotal' => number_format(
                        $itemSubtotalCents / 100,
                        2,
                        '.',
                        ''
                    ),
                ];
            }

            $subtotal = number_format(
                $subtotalCents / 100,
                2,
                '.',
                ''
            );

            $order = Order::create([
                'order_number' => $this->generateOrderNumber(),
                'customer_profile_id' => $customerProfile->id,
                'merchant_profile_id' => $merchantProfile->id,
                'delivery_date' => $data['delivery_date'],
                'delivery_address' => $data['delivery_address'],
                'subtotal' => $subtotal,
                'total' => $subtotal,
                'status' => 'pending',
                'notes' => $data['notes'] ?? null,
            ]);

            $order->orderItems()->createMany($orderItems);
            // Generate invoice dalam transaksi checkout yang sama.
            $this->invoiceService->generate($order);

            return $order->load([
                'customerProfile',
                'merchantProfile',
                'orderItems',
                'invoice',
            ]);
        }, 3);
    }

    /**
     * Generate a unique order number.
     *
     * @return string
     */
    private function generateOrderNumber(): string
    {
        return 'ORD-' . now()->format('Ymd') . '-' . Str::upper(Str::random(8));
    }

    
    /**
     * Get orders belonging to the authenticated user.
     *
     * @param User $user
     * @param int $perPage
     * @return \Illuminate\Contracts\Pagination\LengthAwarePaginator
     */
    public function getOrders(User $user, int $perPage = 15)
    {
        $profile = $user->profile;

        if (!$profile) {
            throw ValidationException::withMessages([
                'profile' => 'Profil pengguna tidak ditemukan.',
            ]);
        }

        $query = Order::query()
            ->with([
                'customerProfile',
                'merchantProfile',
                'orderItems',
                'invoice',
            ])
            ->latest('created_at');

        if ($user->role === 'customer') {
            $query->where('customer_profile_id', $profile->id);
        } elseif ($user->role === 'merchant') {
            $query->where('merchant_profile_id', $profile->id);
        } else {
            throw ValidationException::withMessages([
                'role' => 'Role tidak memiliki akses ke pesanan.',
            ]);
        }

        return $query->paginate($perPage);
    }


    
    /**
     * Get order details.
     *
     * @param Order $order
     * @return Order
     */
    public function getOrderDetail(Order $order): Order
    {
        return $order->load([
            'customerProfile',
            'merchantProfile',
            'orderItems',
            'invoice',
        ]);
    }


    
    /**
     * Cancel a pending order.
     *
     * @param Order $order
     * @return Order
     *
     * @throws ValidationException
     */
    public function cancelOrder(Order $order): Order
    {
        return DB::transaction(function () use ($order) {
            $lockedOrder = Order::query()
                ->lockForUpdate()
                ->findOrFail($order->id);

            if ($lockedOrder->status !== 'pending') {
                throw ValidationException::withMessages([
                    'status' => 'Pesanan hanya dapat dibatalkan ketika masih pending.',
                ]);
            }

            $lockedOrder->update([
                'status' => 'cancelled',
            ]);

            return $lockedOrder->load([
                'customerProfile',
                'merchantProfile',
                'orderItems',
                'invoice',
            ]);
        });
    }


    /**
     * Update order status by merchant.
     *
     * @param Order $order
     * @param string $status
     * @return Order
     *
     * @throws ValidationException
     */

     public function updateOrderStatus(Order $order, string $status): Order
    {
        return DB::transaction(function () use ($order, $status) {
            $lockedOrder = Order::query()
                ->lockForUpdate()
                ->findOrFail($order->id);

            $allowedTransitions = [
                'pending' => ['confirmed'],
                'confirmed' => ['preparing'],
                'preparing' => ['ready'],
                'ready' => ['completed'],
            ];

            $currentStatus = $lockedOrder->status;

            if (!in_array(
                $status,
                $allowedTransitions[$currentStatus] ?? [],
                true
            )) {
                throw ValidationException::withMessages([
                    'status' => "Status tidak dapat diubah dari {$currentStatus} menjadi {$status}.",
                ]);
            }

            $lockedOrder->update([
                'status' => $status,
            ]);

            return $lockedOrder->load([
                'customerProfile',
                'merchantProfile',
                'orderItems',
            ]);
        });
    }
}
