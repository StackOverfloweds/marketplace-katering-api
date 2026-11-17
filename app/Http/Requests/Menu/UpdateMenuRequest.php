<?php

namespace App\Http\Requests\Menu;

use App\Models\Menu;
use Illuminate\Foundation\Http\FormRequest;

class UpdateMenuRequest extends FormRequest
{
    /**
     * Determine whether the user is authorized to update the menu.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        $user = $this->user('api');
        $menu = $this->route('menu');

        return $user !== null
            && $menu instanceof Menu
            && $user->can('update', $menu);
    }

    /**
     * Get the validation rules for updating a menu.
     *
     * @return array
     */
    public function rules(): array
    {
        return [
            'category_id' => [
                'sometimes',
                'required',
                'uuid',
                'exists:categories,id,is_active,1',
            ],
            'name' => [
                'sometimes',
                'required',
                'string',
                'max:150',
            ],
            'description' => [
                'sometimes',
                'nullable',
                'string',
            ],
            'price' => [
                'sometimes',
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
            'category_id.exists' => 'Kategori tidak ditemukan atau tidak aktif.',
            'name.required' => 'Nama menu tidak boleh kosong.',
            'name.max' => 'Nama menu maksimal 150 karakter.',
            'price.numeric' => 'Harga menu harus berupa angka.',
            'price.min' => 'Harga menu tidak boleh kurang dari nol.',
        ];
    }
}
