<?php

namespace App\Http\Controllers\Api\V1\Invoice;

use App\Http\Controllers\Controller;
use App\Models\Invoice;
use App\Services\Invoice\InvoiceQueryService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class InvoiceController extends Controller
{
    /**
     * Create a new controller instance.
     */
    public function __construct(
        protected InvoiceQueryService $invoiceQueryService
    ) {}

    /**
     * Display invoices belonging to the authenticated user.
     */
    public function index(Request $request): JsonResponse
    {
        $this->authorize('viewAny', Invoice::class);

        $perPage = min(
            max((int) $request->query('per_page', 10), 1),
            100
        );

        $invoices = $this->invoiceQueryService
            ->getUserInvoices($request->user(), $perPage);

        return response()->json([
            'success' => true,
            'message' => 'Invoices retrieved successfully.',
            'data' => $invoices,
        ]);
    }

    /**
     * Display the specified invoice.
     */
    public function show(Invoice $invoice): JsonResponse
    {
        $this->authorize('view', $invoice);

        $invoice = $this->invoiceQueryService
            ->getInvoiceDetail($invoice);

        return response()->json([
            'success' => true,
            'message' => 'Invoice retrieved successfully.',
            'data' => $invoice,
        ]);
    }
}

