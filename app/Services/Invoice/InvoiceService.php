<?php

namespace App\Services\Invoice;

use App\Models\Invoice;
use App\Models\Order;
use Illuminate\Support\Str;

class InvoiceService
{
    /**
     * Generate invoice automatically from an order.
     */
    public function generate(Order $order): Invoice
    {
        return $order->invoice()->firstOrCreate(
            ['order_id' => $order->id],
            [
                'invoice_number' => $this->generateInvoiceNumber(),
                'invoice_date' => now()->toDateString(),
                'subtotal' => $order->subtotal,
                'total' => $order->total,
                'status' => 'issued',
            ]
        );
    }

    /**
     * Generate a unique invoice number.
     */
    private function generateInvoiceNumber(): string
    {
        return 'INV-' . now()->format('Ymd') . '-'
            . Str::upper(Str::random(8));
    }
}
