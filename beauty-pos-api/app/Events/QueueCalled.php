<?php

namespace App\Events;

use App\Models\Queue;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class QueueCalled implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(public readonly Queue $queue)
    {
        //
    }

    public function broadcastOn(): array
    {
        return [
            new Channel('queues'),
        ];
    }

    public function broadcastWith(): array
    {
        return [
            'id'           => $this->queue->id,
            'queue_number' => $this->queue->queue_number,
            'status'       => $this->queue->status,
            'customer'     => [
                'id'   => $this->queue->customer->id,
                'name' => $this->queue->customer->name,
            ],
            'queue_type'   => [
                'id'   => $this->queue->queueType->id,
                'name' => $this->queue->queueType->name,
                'code' => $this->queue->queueType->code,
            ],
            'doctor'       => $this->queue->doctor ? [
                'id'   => $this->queue->doctor->id,
                'name' => $this->queue->doctor->name,
            ] : null,
            'called_at'    => $this->queue->called_at?->toISOString(),
        ];
    }

    public function broadcastAs(): string
    {
        return 'queue.called';
    }
}
