<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CompanySetting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CompanySettingController extends Controller
{
    public function show(): JsonResponse
    {
        $settings = CompanySetting::getInstance();

        return response()->json(['status' => 'success', 'data' => $settings]);
    }

    public function update(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'clinic_name'            => 'sometimes|string|max:255',
            'address'                => 'nullable|string',
            'phone'                  => 'nullable|string|max:30',
            'email'                  => 'nullable|email',
            'tagline'                => 'nullable|string|max:255',
            'receipt_footer'         => 'nullable|string',
            'print_logo_on_receipt'  => 'nullable|boolean',
            'print_cashier_name'     => 'nullable|boolean',
            'print_doctor_name'      => 'nullable|boolean',
            'logo'                   => 'nullable|image|max:2048',
        ]);

        if ($request->hasFile('logo')) {
            $validated['logo'] = $request->file('logo')->store('settings', 'public');
        }

        $settings = CompanySetting::getInstance();
        $settings->update($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Pengaturan perusahaan berhasil diupdate',
            'data'    => $settings,
        ]);
    }
}
