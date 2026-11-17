<?php

namespace App\Http\Requests\Menu;

use App\Models\Menu;
use Illuminate\Foundation\Http\FormRequest;

class StoreMenuRequest extends FormRequest
{
    /**
     * Determine whether the user is authorized to create a menu.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return $this->user('api')?->can('create', Menu::class) ?? false;
    }

    /**
     * Get the validation rules for creating a menu.
     *
     * @return array
     */
    public function rules(): array
    {
        return [
            'category_id' => [
                'required',
                'uuid',
                'exists:categories,id,is_active,1',
            ],
            'name' => [
                'required',
                'string',
                'max:150',
            ],
            'description' => [
                'nullable',
                'string',
            ],
            'price' => [
                'required',
                'numeric',
                'min:0',
            ],
            'is_available' => [
                'sometimes',
                'boolean',
            ],
            'photo' => [
            'nullable',
            'image',
            'mimes:jpeg,jpg,png,webp',
            'max:2048',
        ],
        ];
    }

    /**
     * Get custom validation messages.
     *
     * @return array
     */
    public function messages(): array
    {
        return [
            'category_id.required' => 'Kategori menu wajib dipilih.',
            'category_id.uuid' => 'Format kategori tidak valid.',
            'category_id.exists' => 'Kategori tidak ditemukan atau tidak aktif.',
            'name.required' => 'Nama menu wajib diisi.',
            'name.max' => 'Nama menu maksimal 150 karakter.',
            'price.required' => 'Harga menu wajib diisi.',
            'price.numeric' => 'Harga menu harus berupa angka.',
            'price.min' => 'Harga menu tidak boleh kurang dari nol.',
        ];
    }
}
