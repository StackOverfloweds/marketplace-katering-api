<?php

namespace App\Services\Merchant;

use App\Models\Profile;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Database\Eloquent\Builder;

class MerchantService
{
    /**
     * Get merchant listings with search and filters.
     *
     * @param array $filters
     * @return LengthAwarePaginator
     */
    public function getMerchants(array $filters = []): LengthAwarePaginator
    {
        $search = trim($filters['search'] ?? '');
        $location = trim($filters['location'] ?? '');
        $categoryId = $filters['category_id'] ?? null;

        $query = Profile::query()
            ->whereHas('user', function (Builder $userQuery) {
                $userQuery
                    ->where('role', 'merchant')
                    ->where('is_active', true);
            })
            ->with([
                'categories' => function ($categoryQuery) {
                    $categoryQuery
                        ->where('is_active', true)
                        ->select([
                            'id',
                            'merchant_profile_id',
                            'name',
                            'slug',
                        ]);
                },

                'menus' => function ($menuQuery) {
                    $menuQuery->where('is_available', true)
                        ->select([
                            'id',
                            'merchant_profile_id',
                            'category_id',
                            'name',
                            'slug',
                            'description',
                            'photo',
                            'price',
                            'is_available',
                        ])
                        ->orderByRaw('CASE WHEN photo IS NOT NULL THEN 0 ELSE 1 END')
                        ->latest()
                        ->limit(3);
                },
            ])
            ->withCount([
                'categories as active_categories_count' => function (Builder $categoryQuery) {
                    $categoryQuery->where('is_active', true);
                },
                'menus as available_menus_count' => function (Builder $menuQuery) {
                    $menuQuery
                        ->where('is_available', true)
                        ->whereNull('deleted_at');
                },
            ]);

        if ($search !== '') {
            $query->where(function (Builder $searchQuery) use ($search) {
                $keyword = "%{$search}%";

                $searchQuery
                    ->where('company_name', 'ilike', $keyword)
                    ->orWhere('full_name', 'ilike', $keyword)
                    ->orWhere('description', 'ilike', $keyword)
                    ->orWhereHas('categories', function (Builder $categoryQuery) use ($keyword) {
                        $categoryQuery
                            ->where('is_active', true)
                            ->where('name', 'ilike', $keyword);
                    })
                    ->orWhereHas('menus', function (Builder $menuQuery) use ($keyword) {
                        $menuQuery
                            ->where('is_available', true)
                            ->whereNull('deleted_at')
                            ->where('name', 'ilike', $keyword);
                    });
            });
        }

        if ($location !== '') {
            $query->where(function (Builder $locationQuery) use ($location) {
                $keyword = "%{$location}%";

                $locationQuery
                    ->where('city', 'ilike', $keyword)
                    ->orWhere('address', 'ilike', $keyword);
            });
        }

        if ($categoryId) {
            $query->whereHas('categories', function (Builder $categoryQuery) use ($categoryId) {
                $categoryQuery
                    ->where('id', $categoryId)
                    ->where('is_active', true);
            });
        }

        $merchants = $query
            ->orderBy('company_name')
            ->orderBy('full_name')
            ->paginate((int) ($filters['per_page'] ?? 12));

        // Generate public photo URL for each menu.
        $merchants->getCollection()->each(function ($merchant) {
            $merchant->menus->each(function ($menu) {
                $menu->photo_url = $menu->photo
                    ? asset('storage/' . $menu->photo)
                    : null;
            });
        });

        return $merchants;
    }

    
    /**
     * Get merchant detail with categories and available menus.
     *
     * @param string $id
     * @return Profile
     */
    public function getMerchant(string $id): Profile
    {
        $merchant = Profile::query()
            ->where('id', $id)
            ->whereHas('user', function (Builder $query) {
                $query
                    ->where('role', 'merchant')
                    ->where('is_active', true);
            })
            ->with([
                'categories' => function ($query) {
                    $query
                        ->where('is_active', true)
                        ->orderBy('sort_order');
                },
                'menus' => function ($query) {
                    $query
                        ->where('is_available', true)
                        ->latest();
                },
            ])
            ->firstOrFail();

        // Generate public photo URL for each menu.
        $merchant->menus->each(function ($menu) {
            $menu->photo_url = $menu->photo
                ? asset('storage/' . $menu->photo)
                : null;
        });

        return $merchant;
    }


    /**
     * Search merchants by keyword, location, and category.
     *
     * @param array $filters
     * @return LengthAwarePaginator
     */
    public function searchMerchants(array $filters = []): LengthAwarePaginator
    {
        $search = trim($filters['search'] ?? '');
        $location = trim($filters['location'] ?? '');
        $categoryId = $filters['category_id'] ?? null;

        $query = Profile::query()
            ->whereHas('user', function (Builder $userQuery) {
                $userQuery
                    ->where('role', 'merchant')
                    ->where('is_active', true);
            })
            ->with([
                'categories' => function ($categoryQuery) {
                    $categoryQuery
                        ->where('is_active', true)
                        ->select([
                            'id',
                            'merchant_profile_id',
                            'name',
                            'slug',
                        ]);
                },
                'menus' => function ($menuQuery) {
                    $menuQuery
                        ->where('is_available', true)
                        ->select([
                            'id',
                            'merchant_profile_id',
                            'category_id',
                            'name',
                            'slug',
                            'description',
                            'photo',
                            'price',
                            'is_available',
                        ])
                        ->orderByRaw(
                            'CASE WHEN photo IS NOT NULL THEN 0 ELSE 1 END'
                        )
                        ->latest()
                        ->limit(3);
                },
            ])
            ->withCount([
                'categories as active_categories_count' => function (Builder $query) {
                    $query->where('is_active', true);
                },
                'menus as available_menus_count' => function (Builder $query) {
                    $query->where('is_available', true);
                },
            ]);

        // Search merchant, category, and menu names.
        if ($search !== '') {
            $query->where(function (Builder $searchQuery) use ($search) {
                $keyword = "%{$search}%";

                $searchQuery
                    ->where('company_name', 'ILIKE', $keyword)
                    ->orWhere('full_name', 'ILIKE', $keyword)
                    ->orWhere('description', 'ILIKE', $keyword)
                    ->orWhereHas('categories', function (Builder $categoryQuery) use ($keyword) {
                        $categoryQuery
                            ->where('is_active', true)
                            ->where('name', 'ILIKE', $keyword);
                    })
                    ->orWhereHas('menus', function (Builder $menuQuery) use ($keyword) {
                        $menuQuery
                            ->where('is_available', true)
                            ->where('name', 'ILIKE', $keyword);
                    });
            });
        }

        // Search merchant location.
        if ($location !== '') {
            $query->where(function (Builder $locationQuery) use ($location) {
                $keyword = "%{$location}%";

                $locationQuery
                    ->where('city', 'ILIKE', $keyword)
                    ->orWhere('address', 'ILIKE', $keyword);
            });
        }

        // Filter by category ID.
        if ($categoryId) {
            $query->whereHas('categories', function (Builder $categoryQuery) use ($categoryId) {
                $categoryQuery
                    ->where('id', $categoryId)
                    ->where('is_active', true);
            });
        }

        $merchants = $query
            ->orderBy('company_name')
            ->orderBy('full_name')
            ->paginate((int) ($filters['per_page'] ?? 12));

        // Generate public URL for menu photos.
        $merchants->getCollection()->each(function ($merchant) {
            $merchant->menus->each(function ($menu) {
                $menu->photo_url = $menu->photo
                    ? asset('storage/' . $menu->photo)
                    : null;
            });
        });

        return $merchants;
    }


}
