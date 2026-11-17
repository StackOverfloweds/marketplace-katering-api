<?php

namespace App\Services\Category;

use App\Models\Category;
use App\Models\Profile;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class CategoryService
{
    /**
     * Get active categories for public browsing.
     *
     * @param array $filters
     * @return LengthAwarePaginator
     */
    public function getCategories(array $filters = []): LengthAwarePaginator
    {
        return Category::query()
            ->with('merchantProfile:id,company_name')
            ->where('is_active', true)
            ->when(
                $filters['merchant_profile_id'] ?? null,
                fn (Builder $query, string $profileId) =>
                    $query->where('merchant_profile_id', $profileId)
            )
            ->when(
                $filters['search'] ?? null,
                fn (Builder $query, string $search) =>
                    $query->where('name', 'ilike', "%{$search}%")
            )
            ->orderBy('sort_order')
            ->latest()
            ->paginate($filters['per_page'] ?? 15);
    }

    /**
     * Find an active category by UUID.
     *
     * @param string $categoryId
     * @return Category
     */
    public function getCategory(string $categoryId): Category
    {
        return Category::query()
            ->with('merchantProfile:id,company_name')
            ->where('is_active', true)
            ->findOrFail($categoryId);
    }

    /**
     * Get categories owned by a merchant profile.
     *
     * @param Profile $profile
     * @return \Illuminate\Database\Eloquent\Collection
     */
    public function getMerchantCategories(Profile $profile)
    {
        return $profile->categories()
            ->withCount('menus')
            ->orderBy('sort_order')
            ->latest()
            ->get();
    }

    /**
     * Create a category for the authenticated merchant.
     *
     * @param Profile $profile
     * @param array $data
     * @return Category
     */
    public function createCategory(Profile $profile, array $data): Category
    {
        return DB::transaction(function () use ($profile, $data): Category {
            $data['slug'] = $this->generateSlug($data['name']);

            return $profile->categories()->create($data);
        });
    }

    /**
     * Update a category owned by the merchant.
     *
     * @param Category $category
     * @param array $data
     * @return Category
     */
    public function updateCategory(
        Category $category,
        array $data
    ): Category {
        return DB::transaction(function () use ($category, $data): Category {
            if (
                isset($data['name'])
                && $data['name'] !== $category->name
            ) {
                $data['slug'] = $this->generateSlug(
                    $data['name'],
                    $category->id
                );
            }

            $category->update($data);

            return $category->refresh();
        });
    }

    /**
     * Delete a category if it is not used by any menu.
     *
     * @param Category $category
     * @return bool
     */
    public function deleteCategory(Category $category): bool
    {
        return DB::transaction(function () use ($category): bool {
            if ($category->menus()->exists()) {
                return false;
            }

            return (bool) $category->delete();
        });
    }

    /**
     * Generate a globally unique category slug.
     *
     * @param string $name
     * @param string|null $ignoreCategoryId
     * @return string
     */
    private function generateSlug(
        string $name,
        ?string $ignoreCategoryId = null
    ): string {
        $baseSlug = Str::slug($name);
        $baseSlug = $baseSlug !== '' ? $baseSlug : 'category';

        $slug = $baseSlug;
        $counter = 1;

        while (
            Category::query()
                ->when(
                    $ignoreCategoryId,
                    fn (Builder $query) =>
                        $query->where('id', '!=', $ignoreCategoryId)
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
