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



        /**
         * Display merchant detail.
         *
         * @param string $merchant
         * @return JsonResponse
         */
        public function show(string $merchant): JsonResponse
        {
            $result = $this->merchantService->getMerchant($merchant);

            $result->menus->each(function ($menu) {
                $menu->photo_url = $menu->photo
                    ? asset('storage/' . $menu->photo)
                    : null;
            });

            return response()->json([
                'success' => true,
                'message' => 'Detail merchant berhasil diambil.',
                'data' => $result,
            ], 200);
        }


        /**
         * Search merchants.
         *
         * @param Request $request
         * @return JsonResponse
         */
        public function search(Request $request): JsonResponse
        {
            $filters = $request->validate([
                'search' => ['nullable', 'string', 'max:150'],
                'location' => ['nullable', 'string', 'max:150'],
                'category_id' => ['nullable', 'uuid', 'exists:categories,id'],
                'per_page' => ['nullable', 'integer', 'min:1', 'max:50'],
                'page' => ['nullable', 'integer', 'min:1'],
            ]);

            $merchants = $this->merchantService->searchMerchants($filters);

            return response()->json([
                'success' => true,
                'message' => 'Hasil pencarian merchant berhasil diambil.',
                'data' => $merchants->items(),
                'meta' => [
                    'current_page' => $merchants->currentPage(),
                    'per_page' => $merchants->perPage(),
                    'total' => $merchants->total(),
                    'last_page' => $merchants->lastPage(),
                ],
            ], 200);
        }


}