<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\LoginRequest;
use App\Http\Requests\Api\ChangePasswordRequest;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(LoginRequest $request)
    {
        $user = \App\Models\User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Email atau password salah.'
            ], 401);
        }

        if (!$user->is_active) {
            return response()->json([
                'status' => 'error',
                'message' => 'Akun tidak aktif.'
            ], 403);
        }

        // Update last login
        $user->update([
            'last_login_at' => now(),
            'last_login_ip' => $request->ip(),
        ]);

        // Audit log
        AuditLog::create([
            'user_id' => $user->id,
            'branch_id' => $user->branch_id,
            'action' => 'LOGIN',
            'module' => 'auth',
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        $user->load('roles', 'branch');

        return response()->json([
            'status' => 'success',
            'message' => 'Login berhasil',
            'data' => [
                'user' => array_merge($user->toArray(), [
                    'permissions' => $user->getAllPermissions()->map(fn($p) => [
                        'id' => $p->id,
                        'name' => $p->name,
                    ])->values(),
                ]),
                'token' => $token,
            ]
        ]);
    }

    public function logout(Request $request)
    {
        $user = $request->user();

        // Audit log
        AuditLog::create([
            'user_id' => $user->id,
            'branch_id' => $user->branch_id,
            'action' => 'LOGOUT',
            'module' => 'auth',
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        $user->currentAccessToken()->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Logout berhasil'
        ]);
    }

    public function me(Request $request)
    {
        $user = $request->user()->load('roles', 'branch');

        return response()->json([
            'status' => 'success',
            'data' => array_merge($user->toArray(), [
                'permissions' => $user->getAllPermissions()->map(fn($p) => [
                    'id' => $p->id,
                    'name' => $p->name,
                ])->values(),
            ])
        ]);
    }

    public function changePassword(ChangePasswordRequest $request)
    {
        $user = $request->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Password saat ini salah.'
            ], 400);
        }

        $user->update([
            'password' => Hash::make($request->new_password)
        ]);

        // Audit log
        AuditLog::create([
            'user_id' => $user->id,
            'branch_id' => $user->branch_id,
            'action' => 'CHANGE_PASSWORD',
            'module' => 'auth',
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Password berhasil diubah'
        ]);
    }
}
