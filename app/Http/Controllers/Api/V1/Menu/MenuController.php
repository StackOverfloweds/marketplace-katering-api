<?php

namespace App\Http\Controllers\Api\V1\Menu;

use App\Http\Controllers\Controller;
use App\Http\Requests\Menu\StoreMenuRequest;
use App\Http\Requests\Menu\UpdateMenuRequest;
use App\Models\Menu;
use App\Services\Menu\MenuService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MenuController extends Controller
{
    /**
     * Create a new menu controller instance.
     *
     * @param MenuService $menuService
     */
    public function __construct(
        protected MenuService $menuService
    ) {}

    /**
     * Display the public menu list.
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function index(Request $request): JsonResponse
    {
        $menus = $this->menuService->getMenus(
            $request->only([
                'category_id',
                'search',
                'per_page',
            ])
        );

        return response()->json([
            'success' => true,
            'message' => 'Daftar menu berhasil diambil.',
            'data' => $menus->items(),
            'meta' => [
                'current_page' => $menus->currentPage(),
                'per_page' => $menus->perPage(),
                'total' => $menus->total(),
                'last_page' => $menus->lastPage(),
            ],
        ], 200);
    }

    /**
     * Display the detail of an available menu.
     *
     * @param string $menu
     * @return JsonResponse
     */
    public function show(string $menu): JsonResponse
    {
        $result = $this->menuService->getMenu($menu);

        return response()->json([
            'success' => true,
            'message' => 'Detail menu berhasil diambil.',
            'data' => $result,
        ], 200);
    }

    /**
     * Store a newly created menu.
     *
     * @param StoreMenuRequest $request
     * @return JsonResponse
     */
    public function store(StoreMenuRequest $request): JsonResponse
    {
        $user = $request->user('api');
        $profile = $user->profile;

        $menu = $this->menuService->createMenu(
            $profile,
            $request->validated()
        );

        return response()->json([
            'success' => true,
            'message' => 'Menu berhasil ditambahkan.',
            'data' => $menu,
        ], 201);
    }

    /**
     * Update an existing merchant menu.
     *
     * @param UpdateMenuRequest $request
     * @param Menu $menu
     * @return JsonResponse
     */
    public function update(
        UpdateMenuRequest $request,
        Menu $menu
    ): JsonResponse {
        $profile = $request->user('api')->profile;

        $updatedMenu = $this->menuService->updateMenu(
            $menu,
            $profile,
            $request->validated()
        );

        return response()->json([
            'success' => true,
            'message' => 'Menu berhasil diperbarui.',
            'data' => $updatedMenu,
        ], 200);
    }

    /**
     * Delete an existing merchant menu.
     *
     * @param Request $request
     * @param Menu $menu
     * @return JsonResponse
     */
    public function destroy(
        Request $request,
        Menu $menu
    ): JsonResponse {
        $request->user('api')->can('delete', $menu)
            || abort(403, 'Anda tidak memiliki izin untuk menghapus menu ini.');

        $this->menuService->deleteMenu($menu);

        return response()->json([
            'success' => true,
            'message' => 'Menu berhasil dihapus.',
            'data' => null,
        ], 200);
    }
}
