<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

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
}