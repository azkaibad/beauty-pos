<?php

namespace App\Observers;

use App\Models\AuditLog;
use Illuminate\Database\Eloquent\Model;

class AuditLogObserver
{
    // Flag untuk mencegah infinite loop ketika AuditLog::create() dipanggil
    protected static bool $logging = false;

    public function created(Model $model): void
    {
        $this->log($model, 'CREATE');
    }

    public function updated(Model $model): void
    {
        $this->log($model, 'UPDATE');
    }

    public function deleted(Model $model): void
    {
        $this->log($model, 'DELETE');
    }

    protected function log(Model $model, string $action): void
    {
        // Hindari infinite loop: jangan log AuditLog itu sendiri
        if ($model instanceof AuditLog) return;

        // Hindari re-entrant logging
        if (static::$logging) return;

        $user = auth()->user();
        if (!$user) return; // Skip jika tidak ada user (seeder/console)

        $oldValues = [];
        $newValues = [];

        if ($action === 'UPDATE') {
            $dirty = $model->getDirty();
            // Skip jika hanya update last_login (sudah dicatat manual di AuthController)
            $skipOnly = ['last_login_at', 'last_login_ip', 'updated_at', 'remember_token'];
            $realDirty = array_diff_key($dirty, array_flip($skipOnly));
            if (empty($realDirty)) return;

            $oldValues = array_intersect_key($model->getOriginal(), $realDirty);
            $newValues = $realDirty;
        } elseif ($action === 'CREATE') {
            $newValues = $model->getAttributes();
        } elseif ($action === 'DELETE') {
            $oldValues = $model->getAttributes();
        }

        static::$logging = true;

        try {
            AuditLog::create([
                'user_id'    => $user->id,
                'branch_id'  => $user->branch_id,
                'action'     => $action,
                'module'     => $model->getTable(),
                'target_id'  => $model->id,
                'old_values' => empty($oldValues) ? null : $oldValues,
                'new_values' => empty($newValues) ? null : $newValues,
                'ip_address' => request()->ip(),
                'user_agent' => request()->userAgent(),
            ]);
        } finally {
            static::$logging = false;
        }
    }
}
