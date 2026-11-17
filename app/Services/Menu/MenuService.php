<?php

namespace App\Services\Menu;

use App\Models\Menu;
use App\Models\Profile;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class MenuService
{
    /**
     * Get the public menu list with pagination.
     *
     * @param array $filters
     * @return LengthAwarePaginator
     */
    public function getMenus(array $filters = []): LengthAwarePaginator
    {
        return Menu::query()
            ->with('category:id,name,slug')
            ->where('is_available', true)
            ->whereHas('category', function (Builder $query): void {
                $query->where('is_active', true);
            })
            ->when(
                $filters['category_id'] ?? null,
                fn (Builder $query, string $categoryId) =>
                    $query->where('category_id', $categoryId)
            )
            ->when(
                $filters['search'] ?? null,
                fn (Builder $query, string $search) =>
                    $query->where('name', 'ilike', "%{$search}%")
            )
            ->latest()
            ->paginate($filters['per_page'] ?? 15);
    }

    /**
     * Find an available menu by its UUID.
     *
     * @param string $menuId
     * @return Menu
     */
    public function getMenu(string $menuId): Menu
    {
        return Menu::query()
            ->with('category:id,name,slug')
            ->where('is_available', true)
            ->whereHas('category', function (Builder $query): void {
                $query->where('is_active', true);
            })
            ->findOrFail($menuId);
    }

    /**
     * Create a new menu for the authenticated merchant profile.
     *
     * @param Profile $profile
     * @param array $data
     * @return Menu
     */
    public function createMenu(Profile $profile, array $data): Menu
    {
        return DB::transaction(function () use ($profile, $data): Menu {
            $data['slug'] = $this->generateSlug(
                $profile,
                $data['name']
            );

            $menu = $profile->menus()->create($data);

            return $menu->load('category:id,name,slug');
        });
    }

    /**
     * Update an existing menu.
     *
     * @param Menu $menu
     * @param Profile $profile
     * @param array $data
     * @return Menu
     */
    public function updateMenu(
        Menu $menu,
        Profile $profile,
        array $data
    ): Menu {
        return DB::transaction(function () use ($menu, $profile, $data): Menu {
            if (isset($data['name']) && $data['name'] !== $menu->name) {
                $data['slug'] = $this->generateSlug(
                    $profile,
                    $data['name'],
                    $menu->id
                );
            }

            $menu->update($data);

            return $menu->refresh()->load('category:id,name,slug');
        });
    }

    /**
     * Delete a menu using soft deletion.
     *
     * @param Menu $menu
     * @return bool
     */
    public function deleteMenu(Menu $menu): bool
    {
        return DB::transaction(function () use ($menu): bool {
            return (bool) $menu->delete();
        });
    }

    /**
     * Generate a unique slug within a merchant profile.
     *
     * @param Profile $profile
     * @param string $name
     * @param string|null $ignoreMenuId
     * @return string
     */
    private function generateSlug(
        Profile $profile,
        string $name,
        ?string $ignoreMenuId = null
    ): string {
        $baseSlug = Str::slug($name);
        $baseSlug = $baseSlug !== '' ? $baseSlug : 'menu';

        $slug = $baseSlug;
        $counter = 1;

        while (
            $profile->menus()
                ->when(
                    $ignoreMenuId,
                    fn (Builder $query) =>
                        $query->where('id', '!=', $ignoreMenuId)
                )
                ->where('slug', $slug)
                ->exists()
        ) {
            $slug = $baseSlug . '-' . $counter;
            $counter++;
        }

        return $slug;
    }
}
