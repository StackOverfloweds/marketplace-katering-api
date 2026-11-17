<?php

namespace App\Http\Controllers\Api\V1\Merchant;

use App\Http\Controllers\Controller;
use App\Services\Merchant\MerchantService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class MerchantController extends Controller
{
    public function __construct(
        protected MerchantService $merchantService
    ) {}

    /**
     * Display merchant listings with search and filters.
     */
    public function index(Request $request): JsonResponse
    {
        $filters = $request->validate([
            'search' => ['nullable', 'string', 'max:150'],
            'location' => ['nullable', 'string', 'max:150'],
            'category_id' => ['nullable', 'uuid', 'exists:categories,id'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:50'],
        ]);

        $merchants = $this->merchantService->getMerchants($filters);

        return response()->json([
            'message' => 'Merchant listings retrieved successfully.',
            'data' => $merchants,
        ]);
    }
}