<?php

namespace App\Http\Requests\Order;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateOrderStatusRequest extends FormRequest
{
    /**
     * Determine whether the merchant is authorized to update the order.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get validation rules.
     *
     * @return array
     */
    public function rules(): array
    {
        return [
            'status' => [
                'required',
                'string',
                Rule::in([
                    'confirmed',
                    'preparing',
                    'ready',
                    'completed',
                ]),
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
            'status.required' => 'Status pesanan wajib diisi.',
            'status.in' => 'Status pesanan tidak valid.',
        ];
    }
}
