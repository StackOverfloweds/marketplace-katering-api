<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Menu extends Model
{
    use HasUuids, SoftDeletes;

    protected $fillable = [
        'merchant_profile_id',
        'category_id',
        'name',
        'slug',
        'description',
        'photo',
        'price',
        'is_available',
    ];

    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'is_available' => 'boolean',
        ];
    }

    /**
     * Get the merchant profile that owns this menu.
     *
     * @return BelongsTo
     */
    public function merchantProfile(): BelongsTo
    {
        return $this->belongsTo(
            Profile::class,
            'merchant_profile_id'
        );
    }

    /**
     * Get the category assigned to this menu.
     *
     * @return BelongsTo
     */
    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    /**
     * Get all order items associated with this menu.
     *
     * @return HasMany
     */
    public function orderItems(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }

    /**
     * Get all categories belonging to this merchant profile.
     *
     * @return HasMany
     */
    public function categories(): HasMany
    {
        return $this->hasMany(Category::class, 'merchant_profile_id');
    }

}
