<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Order extends Model
{
    use HasUuids;

    protected $fillable = [
        'order_number',
        'customer_profile_id',
        'merchant_profile_id',
        'delivery_date',
        'delivery_address',
        'subtotal',
        'total',
        'status',
        'notes',
    ];

    protected function casts(): array
    {
        return [
            'delivery_date' => 'date',
            'subtotal' => 'decimal:2',
            'total' => 'decimal:2',
        ];
    }

    public function customerProfile(): BelongsTo
    {
        return $this->belongsTo(
            Profile::class,
            'customer_profile_id'
        );
    }

    public function merchantProfile(): BelongsTo
    {
        return $this->belongsTo(
            Profile::class,
            'merchant_profile_id'
        );
    }

    public function orderItems(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }

    public function invoice(): HasOne
    {
        return $this->hasOne(Invoice::class);
    }
}
