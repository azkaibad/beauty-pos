<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MedicalPhoto;
use App\Models\MedicalRecord;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class MedicalPhotoController extends Controller
{
    /**
     * Upload foto ke rekam medis (max 5 per rekam medis).
     */
    public function store(Request $request, MedicalRecord $medicalRecord): JsonResponse
    {
        $request->validate([
            'photo'      => 'required|image|max:5120', // max 5MB
            'photo_type' => 'required|in:before,during,after',
            'caption'    => 'nullable|string|max:255',
        ]);

        // Batasi max 5 foto per rekam medis
        $count = $medicalRecord->photos()->count();
        if ($count >= 5) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Maksimal 5 foto per rekam medis',
            ], 422);
        }

        $path = $request->file('photo')->store('medical_photos', 'public');

        $photo = $medicalRecord->photos()->create([
            'file_path'  => $path,
            'photo_type' => $request->photo_type,
            'caption'    => $request->caption,
        ]);

        return response()->json([
            'status'  => 'success',
            'message' => 'Foto berhasil diupload',
            'data'    => [
                ...$photo->toArray(),
                'url' => asset('storage/' . $photo->file_path),
            ],
        ], 201);
    }

    /**
     * Hapus foto rekam medis.
     */
    public function destroy(MedicalRecord $medicalRecord, MedicalPhoto $photo): JsonResponse
    {
        // Pastikan foto milik rekam medis yang benar
        if ($photo->medical_record_id !== $medicalRecord->id) {
            return response()->json(['status' => 'error', 'message' => 'Foto tidak ditemukan'], 404);
        }

        Storage::disk('public')->delete($photo->file_path);
        $photo->delete();

        return response()->json(['status' => 'success', 'message' => 'Foto berhasil dihapus']);
    }
}
