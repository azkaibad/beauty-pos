<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class QueueType extends Model
{
    protected $fillable = ['name', 'code', 'color', 'is_active', 'sort_order'];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function queues()
    {
        return $this->hasMany(Queue::class);
    }
}
