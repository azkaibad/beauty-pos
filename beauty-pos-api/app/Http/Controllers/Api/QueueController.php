<?php

namespace App\Http\Controllers\Api;

use App\Events\QueueCalled;
use App\Http\Controllers\Controller;
use App\Models\Queue;
use App\Models\QueueType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class QueueController extends Controller
{
    // GET /api/v1/queues — list antrian dengan filter
    public function index(Request $request): JsonResponse
    {
        $query = Queue::with(['customer', 'queueType', 'doctor']);

        // Filter hari ini jika tidak ada tanggal
        $date = $request->get('date', today()->toDateString());
        $query->whereDate('queue_date', $date);

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('queue_type_id')) {
            $query->where('queue_type_id', $request->queue_type_id);
        }

        if ($request->filled('doctor_id')) {
            $query->where('doctor_id', $request->doctor_id);
        }

        $queues = $query->orderBy('queue_number')->get();

        // Summary hitung per status
        $summary = [
            'total'     => $queues->count(),
            'waiting'   => $queues->where('status', 'waiting')->count(),
            'called'    => $queues->where('status', 'called')->count(),
            'serving'   => $queues->where('status', 'serving')->count(),
            'completed' => $queues->where('status', 'completed')->count(),
        ];

        return response()->json([
            'status'  => 'success',
            'summary' => $summary,
            'data'    => $queues,
        ]);
    }

    // GET /api/v1/queues/active — hanya antrian aktif hari ini
    public function active(): JsonResponse
    {
        $queues = Queue::with(['customer', 'queueType', 'doctor'])
            ->whereDate('queue_date', today())
            ->whereIn('status', ['waiting', 'called', 'serving'])
            ->orderBy('queue_number')
            ->get();

        return response()->json(['status' => 'success', 'data' => $queues]);
    }

    // GET /api/v1/queues/history — riwayat antrian
    public function history(Request $request): JsonResponse
    {
        $query = Queue::with(['customer', 'queueType', 'doctor'])
            ->whereIn('status', ['completed', 'skipped']);

        if ($request->filled('from')) {
            $query->whereDate('queue_date', '>=', $request->from);
        }

        if ($request->filled('to')) {
            $query->whereDate('queue_date', '<=', $request->to);
        }

        $queues = $query->latest()->paginate($request->get('per_page', 20));

        return response()->json(['status' => 'success', 'data' => $queues]);
    }

    // POST /api/v1/queues — daftarkan antrian baru
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'customer_id'   => 'required|exists:customers,id',
            'queue_type_id' => 'required|exists:queue_types,id',
            'doctor_id'     => 'nullable|exists:users,id',
            'branch_id'     => 'nullable|exists:branches,id',
            'queue_date'    => 'nullable|date',
            'notes'         => 'nullable|string',
        ]);

        $queueType = QueueType::findOrFail($validated['queue_type_id']);
        $date      = $validated['queue_date'] ?? today();

        $queue = Queue::create([
            ...$validated,
            'queue_number' => Queue::generateNumber($queueType, $date),
            'queue_date'   => $date,
        ]);

        return response()->json([
            'status'  => 'success',
            'message' => "Antrian {$queue->queue_number} berhasil didaftarkan",
            'data'    => $queue->load(['customer', 'queueType', 'doctor']),
        ], 201);
    }

    // GET /api/v1/queues/{id}
    public function show(Queue $queue): JsonResponse
    {
        return response()->json([
            'status' => 'success',
            'data'   => $queue->load(['customer', 'queueType', 'doctor']),
        ]);
    }

    // PUT /api/v1/queues/{id}/status — update status antrian
    public function updateStatus(Request $request, Queue $queue): JsonResponse
    {
        $validated = $request->validate([
            'status' => 'required|in:waiting,called,serving,completed,skipped',
        ]);

        $now = now();

        // Set timestamp sesuai status
        $timestamps = match ($validated['status']) {
            'called'    => ['called_at'    => $now],
            'serving'   => ['served_at'    => $now],
            'completed' => ['completed_at' => $now],
            default     => [],
        };

        $queue->update([...$validated, ...$timestamps]);

        // Broadcast via WebSocket saat dipanggil
        if ($validated['status'] === 'called') {
            broadcast(new QueueCalled($queue->load(['customer', 'queueType', 'doctor'])));
        }

        return response()->json([
            'status'  => 'success',
            'message' => "Status antrian {$queue->queue_number} diupdate ke {$validated['status']}",
            'data'    => $queue->load(['customer', 'queueType', 'doctor']),
        ]);
    }

    // POST /api/v1/queues/{id}/call — shortcut panggil antrian + broadcast
    public function call(Queue $queue): JsonResponse
    {
        $queue->update([
            'status'    => 'called',
            'called_at' => now(),
        ]);

        broadcast(new QueueCalled($queue->load(['customer', 'queueType', 'doctor'])));

        return response()->json([
            'status'  => 'success',
            'message' => "Antrian {$queue->queue_number} dipanggil",
            'data'    => $queue,
        ]);
    }

    // DELETE /api/v1/queues/{id}
    public function destroy(Queue $queue): JsonResponse
    {
        $queue->delete();

        return response()->json(['status' => 'success', 'message' => 'Antrian berhasil dihapus']);
    }
}
