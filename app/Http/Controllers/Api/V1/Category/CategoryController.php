<?php

namespace App\Http\Controllers\Api\V1\Category;

use App\Http\Controllers\Controller;
use App\Http\Requests\Category\StoreCategoryRequest;
use App\Http\Requests\Category\UpdateCategoryRequest;
use App\Models\Category;
use App\Services\Category\CategoryService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    /**
     * Create a new category controller instance.
     *
     * @param CategoryService $categoryService
     */
    public function __construct(
        protected CategoryService $categoryService
    ) {}

    /**
     * Display active categories for customers.
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function index(Request $request): JsonResponse
    {
        $categories = $this->categoryService->getCategories(
            $request->only([
                'merchant_profile_id',
                'search',
                'per_page',
            ])
        );

        return response()->json([
            'success' => true,
            'message' => 'Daftar kategori berhasil diambil.',
            'data' => $categories->items(),
            'meta' => [
                'current_page' => $categories->currentPage(),
                'per_page' => $categories->perPage(),
                'total' => $categories->total(),
                'last_page' => $categories->lastPage(),
            ],
        ], 200);
    }

    /**
     * Display an active category detail.
     *
     * @param string $category
     * @return JsonResponse
     */
    public function show(string $category): JsonResponse
    {
        $result = $this->categoryService->getCategory($category);

        return response()->json([
            'success' => true,
            'message' => 'Detail kategori berhasil diambil.',
            'data' => $result,
        ], 200);
    }

    /**
     * Display categories owned by the authenticated merchant.
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function myCategories(Request $request): JsonResponse
    {
        $profile = $request->user('api')->profile;

        $categories = $this->categoryService
            ->getMerchantCategories($profile);

        return response()->json([
            'success' => true,
            'message' => 'Kategori merchant berhasil diambil.',
            'data' => $categories,
        ], 200);
    }

    /**
     * Store a new category for the authenticated merchant.
     *
     * @param StoreCategoryRequest $request
     * @return JsonResponse
     */
    public function store(StoreCategoryRequest $request): JsonResponse
    {
        $profile = $request->user('api')->profile;

        $category = $this->categoryService->createCategory(
            $profile,
            $request->validated()
        );

        return response()->json([
            'success' => true,
            'message' => 'Kategori berhasil ditambahkan.',
            'data' => $category,
        ], 201);
    }

    /**
     * Update a merchant-owned category.
     *
     * @param UpdateCategoryRequest $request
     * @param Category $category
     * @return JsonResponse
     */
    public function update(
        UpdateCategoryRequest $request,
        Category $category
    ): JsonResponse {
        $updatedCategory = $this->categoryService->updateCategory(
            $category,
            $request->validated()
        );

        return response()->json([
            'success' => true,
            'message' => 'Kategori berhasil diperbarui.',
            'data' => $updatedCategory,
        ], 200);
    }

    /**
     * Delete a merchant-owned category.
     *
     * @param Request $request
     * @param Category $category
     * @return JsonResponse
     */
    public function destroy(
        Request $request,
        Category $category
    ): JsonResponse {
        $request->user('api')->can('delete', $category)
            || abort(403, 'Anda tidak memiliki akses ke kategori ini.');

        $deleted = $this->categoryService->deleteCategory($category);

        if (!$deleted) {
            return response()->json([
                'success' => false,
                'message' => 'Kategori tidak dapat dihapus karena masih digunakan oleh menu.',
                'error' => [
                    'code' => 'CATEGORY_IN_USE',
                    'details' => null,
                ],
            ], 409);
        }

        return response()->json([
            'success' => true,
            'message' => 'Kategori berhasil dihapus.',
            'data' => null,
        ], 200);
    }
}
