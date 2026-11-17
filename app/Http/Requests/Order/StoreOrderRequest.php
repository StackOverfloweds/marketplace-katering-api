<?php

namespace App\Http\Requests\Order;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreOrderRequest extends FormRequest
{
    /**
     * Determine whether the customer is authorized to make this request.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules for creating an order.
     *
     * @return array
     */
    public function rules(): array
    {
        return [
            'merchant_profile_id' => [
                'required',
                'uuid',
                Rule::exists('profiles', 'id'),
            ],

            'delivery_date' => [
                'required',
                'date',
                'after_or_equal:today',
            ],

            'delivery_address' => [
                'required',
                'string',
                'max:1000',
            ],

            'notes' => [
                'nullable',
                'string',
                'max:2000',
            ],

            'items' => [
                'required',
                'array',
                'min:1',
            ],

            'items.*.menu_id' => [
                'required',
                'uuid',
                'distinct',
                Rule::exists('menus', 'id'),
            ],

            'items.*.quantity' => [
                'required',
                'integer',
                'min:1',
                'max:10000',
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
            'merchant_profile_id.required' => 'Merchant wajib dipilih.',
            'merchant_profile_id.exists' => 'Merchant tidak ditemukan.',
            'delivery_date.after_or_equal' => 'Tanggal pengiriman tidak boleh di masa lalu.',
            'items.required' => 'Minimal satu menu harus dipilih.',
            'items.min' => 'Minimal satu menu harus dipilih.',
            'items.*.menu_id.distinct' => 'Menu yang sama tidak boleh dimasukkan lebih dari satu kali.',
            'items.*.menu_id.exists' => 'Salah satu menu tidak ditemukan.',
            'items.*.quantity.min' => 'Jumlah porsi minimal satu.',
        ];
    }
}
