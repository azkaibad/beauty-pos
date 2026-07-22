<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Relations\Pivot;

/**
 * @property int $id
 * @property int $user_id
 * @property int $branch_id
 * @property bool $is_primary
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @method static \Illuminate\Database\Eloquent\Builder<static>|BranchUser newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|BranchUser newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|BranchUser query()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|BranchUser whereBranchId($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|BranchUser whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|BranchUser whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|BranchUser whereIsPrimary($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|BranchUser whereUpdatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|BranchUser whereUserId($value)
 * @mixin \Eloquent
 */
class BranchUser extends Pivot
{
    protected $table = 'branch_users';

    protected $fillable = [
        'user_id',
        'branch_id',
        'is_primary',
    ];

    protected $casts = [
        'is_primary' => 'boolean',
    ];
}
