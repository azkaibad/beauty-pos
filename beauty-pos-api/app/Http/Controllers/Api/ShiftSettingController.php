<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ShiftSetting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ShiftSettingController extends Controller
{
    public function index(): JsonResponse
    {
        $shifts = ShiftSetting::orderBy('start_time')->get();

        return response()->json(['status' => 'success', 'data' => $shifts]);
    }

    public function update(Request $request, ShiftSetting $shiftSetting): JsonResponse
    {
        $validated = $request->validate([
            'label'      => 'sometimes|string|max:100',
            'start_time' => 'sometimes|date_format:H:i',
            'end_time'   => 'sometimes|date_format:H:i|after:start_time',
            'is_active'  => 'nullable|boolean',
        ]);

        $shiftSetting->update($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Pengaturan shift berhasil diupdate',
            'data'    => $shiftSetting,
        ]);
    }
}
