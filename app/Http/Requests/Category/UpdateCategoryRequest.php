<?php

namespace App\Http\Requests\Category;

use App\Models\Category;
use Illuminate\Foundation\Http\FormRequest;

class UpdateCategoryRequest extends FormRequest
{
    /**
     * Determine whether the authenticated user can update this category.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        $user = $this->user('api');
        $category = $this->route('category');

        return $user !== null
            && $category instanceof Category
            && $user->can('update', $category);
    }

    /**
     * Get validation rules for updating a category.
     *
     * @return array
     */
    public function rules(): array
    {
        return [
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
            'is_active' => [
                'sometimes',
                'boolean',
            ],
            'sort_order' => [
                'sometimes',
                'integer',
                'min:0',
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
            'name.required' => 'Nama kategori tidak boleh kosong.',
            'name.max' => 'Nama kategori maksimal 150 karakter.',
            'is_active.boolean' => 'Status kategori harus berupa boolean.',
            'sort_order.integer' => 'Urutan kategori harus berupa angka.',
            'sort_order.min' => 'Urutan kategori tidak boleh kurang dari nol.',
        ];
    }
}
