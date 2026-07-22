<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\CustomerController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\TreatmentController;
use App\Http\Controllers\Api\PaymentMethodController;
use App\Http\Controllers\Api\CompanySettingController;
use App\Http\Controllers\Api\ShiftSettingController;
use App\Http\Controllers\Api\StockMovementController;
use App\Http\Controllers\Api\MedicalRecordController;
use App\Http\Controllers\Api\MedicalPhotoController;
use App\Http\Controllers\Api\QueueController;
use App\Http\Controllers\Api\TransactionController;
use App\Http\Controllers\Api\ClosingController;
use App\Http\Controllers\Api\ExpenseController;
use App\Http\Controllers\Api\FollowUpController;
use App\Http\Controllers\Api\ReportController;

Route::prefix('v1')->group(function () {

    // ── Auth (public) ──────────────────────────────────────────────
    Route::post('/login', [AuthController::class, 'login']);

    // ── Authenticated routes ───────────────────────────────────────
    Route::middleware('auth:sanctum')->group(function () {

        // Auth
        Route::post('/logout',          [AuthController::class, 'logout']);
        Route::get('/me',               [AuthController::class, 'me']);
        Route::post('/change-password', [AuthController::class, 'changePassword']);

        // Users (Owner only)
        Route::get('/users', [UserController::class, 'index'])
            ->middleware('permission:manage_users');

        // ── Master Data ────────────────────────────────────────────

        Route::apiResource('customers', CustomerController::class);
        Route::apiResource('categories', CategoryController::class);
        Route::get('/products/low-stock', [ProductController::class, 'lowStock']);
        Route::apiResource('products', ProductController::class);
        Route::apiResource('treatments', TreatmentController::class);
        Route::apiResource('payment-methods', PaymentMethodController::class);

        Route::get('/company-settings',     [CompanySettingController::class, 'show']);
        Route::put('/company-settings',     [CompanySettingController::class, 'update']);
        Route::get('/shift-settings',       [ShiftSettingController::class, 'index']);
        Route::put('/shift-settings/{shiftSetting}', [ShiftSettingController::class, 'update']);
        Route::get('/stock-movements',      [StockMovementController::class, 'index']);
        Route::post('/stock-movements',     [StockMovementController::class, 'store']);

        // ── Antrian (Queues) ──────────────────────────────────────
        Route::prefix('queues')->group(function () {
            Route::get('/active',            [QueueController::class, 'active']);
            Route::get('/history',           [QueueController::class, 'history']);
            Route::post('/{queue}/call',     [QueueController::class, 'call']);
            Route::put('/{queue}/status',    [QueueController::class, 'updateStatus']);
        });
        Route::apiResource('queues', QueueController::class);

        // ── POS / Transaksi (manage_pos) ──────────────────────────
        Route::middleware('permission:manage_pos')->group(function () {
            Route::get('/transactions/{transaction}/receipt',
                [TransactionController::class, 'receipt']);
            Route::put('/transactions/{transaction}/pay',
                [TransactionController::class, 'pay']);
            Route::apiResource('transactions', TransactionController::class);
        });

        // ── Closing Shift (manage_pos) ────────────────────────────
        Route::middleware('permission:manage_pos')->group(function () {
            Route::get('/closings/summary',             [ClosingController::class, 'summary']);
            Route::put('/closings/{closing}/approve',   [ClosingController::class, 'approve']);
            Route::apiResource('closings', ClosingController::class);
        });

        // ── Pengeluaran (manage_expenses) ─────────────────────────
        Route::middleware('permission:manage_expenses')->group(function () {
            Route::put('/expenses/{expense}/approve',  [ExpenseController::class, 'approve']);
            Route::put('/expenses/{expense}/reject',   [ExpenseController::class, 'reject']);
            Route::post('/expenses/{expense}/upload',  [ExpenseController::class, 'uploadBukti']);
            Route::apiResource('expenses', ExpenseController::class);
        });

        // ── Follow-Up (manage_followup) ───────────────────────────
        Route::middleware('permission:manage_followup')->group(function () {
            Route::get('/follow-ups/today',            [FollowUpController::class, 'today']);
            Route::put('/follow-ups/{followUp}/contact', [FollowUpController::class, 'contact']);
            Route::apiResource('follow-ups', FollowUpController::class);
        });

        // ── Medical Records (manage_medical_records) ──────────────
        Route::middleware('permission:manage_medical_records')->group(function () {
            Route::apiResource('medical-records', MedicalRecordController::class);
            Route::post('/medical-records/{medicalRecord}/photos',
                [MedicalPhotoController::class, 'store']);
            Route::delete('/medical-records/{medicalRecord}/photos/{photo}',
                [MedicalPhotoController::class, 'destroy']);
        });

        // ── Laporan (view_reports) ─────────────────────────────────
        Route::middleware('permission:view_reports')->prefix('reports')->group(function () {
            Route::get('/sales/daily',       [ReportController::class, 'salesDaily']);
            Route::get('/sales/monthly',     [ReportController::class, 'salesMonthly']);
            Route::get('/sales/by-payment',  [ReportController::class, 'salesByPayment']);
            Route::get('/stock/movements',   [ReportController::class, 'stockMovements']);
            Route::get('/stock/current',     [ReportController::class, 'stockCurrent']);
            Route::get('/medical-records',   [ReportController::class, 'medicalRecords']);
            Route::get('/treatments',        [ReportController::class, 'treatments']);
            Route::get('/practitioners',     [ReportController::class, 'practitioners']);
            Route::get('/expenses',          [ReportController::class, 'expenses']);
            Route::get('/balance',           [ReportController::class, 'balance']);
            Route::get('/revenue',           [ReportController::class, 'revenue']);
            Route::get('/closings',          [ReportController::class, 'closings']);
            Route::get('/export/{type}',     [ReportController::class, 'export']);
        });
    });
});


