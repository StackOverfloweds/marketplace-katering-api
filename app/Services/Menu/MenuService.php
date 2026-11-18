<?php

namespace App\Services\Menu;

use App\Models\Menu;
use App\Models\Profile;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

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
            $photo = $data['photo'] ?? null;

            unset($data['photo']);

            $data['slug'] = $this->generateSlug(
                $profile,
                $data['name']
            );

            if ($photo instanceof UploadedFile) {
                $data['photo'] = $photo->store(
                    'menus/' . $profile->id,
                    'public'
                );
            }

            return $profile->menus()
                ->create($data)
                ->load('category:id,name,slug');
        });
    }

    /**
     * Update an existing menu and replace its photo when provided.
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
        $newPhoto = $data['photo'] ?? null;
        unset($data['photo']);

        $oldPhoto = $menu->photo;
        $storedPhoto = null;

        try {
            if ($newPhoto instanceof UploadedFile) {
                $storedPhoto = $newPhoto->store(
                    'menus/' . $profile->id,
                    'public'
                );

                if ($storedPhoto === false) {
                    throw new \RuntimeException('Gagal menyimpan foto menu.');
                }

                $data['photo'] = $storedPhoto;
            }

            if (
                isset($data['name'])
                && $data['name'] !== $menu->name
            ) {
                $data['slug'] = $this->generateSlug(
                    $profile,
                    $data['name'],
                    $menu->id
                );
            }

            $updatedMenu = DB::transaction(function () use (
                $menu,
                $data
            ): Menu {
                $menu->update($data);

                return $menu->refresh()
                    ->load('category:id,name,slug');
            });

            // Remove the old photo only after the database transaction succeeds.
            if (
                $storedPhoto !== null
                && $oldPhoto !== null
                && $oldPhoto !== $storedPhoto
            ) {
                Storage::disk('public')->delete($oldPhoto);
            }

            return $updatedMenu;

        } catch (\Throwable $exception) {
            // Remove the newly uploaded file if the database update fails.
            if ($storedPhoto !== null) {
                Storage::disk('public')->delete($storedPhoto);
            }

            throw $exception;
        }
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

    /**
     * Permanently delete a menu and its associated photo.
     *
     * @param Menu $menu
     * @return bool
     */
    public function forceDeleteMenu(Menu $menu): bool
    {
        $photo = $menu->photo;

        $deleted = DB::transaction(function () use ($menu): bool {
            return (bool) $menu->forceDelete();
        });

        if ($deleted && $photo !== null) {
            Storage::disk('public')->delete($photo);
        }

        return $deleted;
    }


    /**
     * Get menus belonging to the authenticated merchant with pagination.
     *
     * @param Profile $profile
     * @param array $filters
     * @return LengthAwarePaginator
     */
    public function getMerchantMenus(
        Profile $profile,
        array $filters = []
    ): LengthAwarePaginator {
        return Menu::query()
            ->with('category:id,name,slug')
            ->where('merchant_profile_id', $profile->id)
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
            ->when(
                isset($filters['is_available'])
                    && $filters['is_available'] !== '',
                fn (Builder $query) =>
                    $query->where(
                        'is_available',
                        filter_var($filters['is_available'], FILTER_VALIDATE_BOOLEAN)
                    )
            )
            ->latest()
            ->paginate($filters['per_page'] ?? 15);
    }

}
