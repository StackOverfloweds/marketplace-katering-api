<?php

namespace App\Http\Controllers\Api\V1\Order;

use App\Http\Controllers\Controller;
use App\Http\Requests\Order\StoreOrderRequest;
use App\Http\Requests\Order\UpdateOrderStatusRequest;
use App\Models\Order;
use App\Services\Order\OrderService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Create a new order.
     *
     * @param StoreOrderRequest $request
     * @param OrderService $orderService
     * @return JsonResponse
     */
    public function store(
        StoreOrderRequest $request,
        OrderService $orderService
    ): JsonResponse {
        $user = $request->user('api');

        $this->authorize('create', Order::class);

        $order = $orderService->createOrder(
            $user,
            $request->validated()
        );

        return response()->json([
            'success' => true,
            'message' => 'Pesanan berhasil dibuat.',
            'data' => $order,
        ], 201);
    }

    /**
     * Get orders belonging to the authenticated user.
     *
     * @param Request $request
     * @param OrderService $orderService
     * @return JsonResponse
     */
    public function index(
        Request $request,
        OrderService $orderService
    ): JsonResponse {
        $this->authorize('viewAny', Order::class);

        $perPage = min(
            max((int) $request->query('per_page', 15), 1),
            100
        );

        $orders = $orderService->getOrders(
            $request->user('api'),
            $perPage
        );

        return response()->json([
            'success' => true,
            'message' => 'Daftar pesanan berhasil diambil.',
            'data' => $orders,
        ], 200);
    }

    /**
     * Get order details.
     *
     * @param Order $order
     * @param OrderService $orderService
     * @return JsonResponse
     */
    public function show(
        Order $order,
        OrderService $orderService
    ): JsonResponse {
        $this->authorize('view', $order);

        $order = $orderService->getOrderDetail($order);

        return response()->json([
            'success' => true,
            'message' => 'Detail pesanan berhasil diambil.',
            'data' => $order,
        ], 200);
    }

    /**
     * Cancel a pending order.
     *
     * @param Order $order
     * @param OrderService $orderService
     * @return JsonResponse
     */
    public function cancel(
        Order $order,
        OrderService $orderService
    ): JsonResponse {
        $this->authorize('cancel', $order);

        $order = $orderService->cancelOrder($order);

        return response()->json([
            'success' => true,
            'message' => 'Pesanan berhasil dibatalkan.',
            'data' => $order,
        ], 200);
    }

    /**
     * Update order status by merchant.
     *
     * @param UpdateOrderStatusRequest $request
     * @param Order $order
     * @param OrderService $orderService
     * @return JsonResponse
     */
    public function updateStatus(
        UpdateOrderStatusRequest $request,
        Order $order,
        OrderService $orderService
    ): JsonResponse {
        $this->authorize('updateStatus', $order);

        $order = $orderService->updateOrderStatus(
            $order,
            $request->validated('status')
        );

        return response()->json([
            'success' => true,
            'message' => 'Status pesanan berhasil diperbarui.',
            'data' => $order,
        ], 200);
    }
}
