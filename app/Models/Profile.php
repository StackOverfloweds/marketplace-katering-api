<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Profile extends Model
{
    use HasUuids;

    protected $fillable = [
        'user_id',
        'full_name',
        'email',
        'phone',
        'company_name',
        'contact_person',
        'address',
        'city',
        'description',
        'logo',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get all menus belonging to this profile.
     *
     * @return HasMany
     */
    public function menus() : HasMany 
    {
        return $this->hasMany(Menu::class, "merchant_profile_id");
    }
}