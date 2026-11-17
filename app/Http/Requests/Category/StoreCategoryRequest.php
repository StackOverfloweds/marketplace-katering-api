<?php

namespace App\Http\Requests\Category;

use App\Models\Category;
use Illuminate\Foundation\Http\FormRequest;

class StoreCategoryRequest extends FormRequest
{
    /**
     * Determine whether the authenticated user can create a category.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return $this->user('api')?->can('create', Category::class) ?? false;
    }

    /**
     * Get validation rules for creating a category.
     *
     * @return array
     */
    public function rules(): array
    {
        return [
            'name' => [
                'required',
                'string',
                'max:150',
            ],
            'description' => [
                'nullable',
                'string',
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
            'name.required' => 'Nama kategori wajib diisi.',
            'name.max' => 'Nama kategori maksimal 150 karakter.',
            'sort_order.integer' => 'Urutan kategori harus berupa angka.',
            'sort_order.min' => 'Urutan kategori tidak boleh kurang dari nol.',
        ];
    }
}
