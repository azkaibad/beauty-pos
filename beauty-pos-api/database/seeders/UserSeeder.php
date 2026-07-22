<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Branch;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        $branch = Branch::where('name', 'Cabang Pusat')->first();

        // Owner
        $owner = User::firstOrCreate(
            ['email' => 'owner@beautypos.com'],
            [
                'name' => 'Owner',
                'password' => Hash::make('password'),
                'branch_id' => null, // Owner has access to all, can be null
            ]
        );
        $owner->assignRole('owner');

        // Manager
        $manager = User::firstOrCreate(
            ['email' => 'manager@beautypos.com'],
            [
                'name' => 'Manager',
                'password' => Hash::make('password'),
                'branch_id' => $branch->id,
            ]
        );
        $manager->assignRole('manajer');
        $manager->branches()->syncWithoutDetaching([$branch->id => ['is_primary' => true]]);

        // Admin (Kasir)
        $admin = User::firstOrCreate(
            ['email' => 'admin@beautypos.com'],
            [
                'name' => 'Admin Kasir',
                'password' => Hash::make('password'),
                'branch_id' => $branch->id,
            ]
        );
        $admin->assignRole('admin');
        $admin->branches()->syncWithoutDetaching([$branch->id => ['is_primary' => true]]);

        // Dokter
        $dokter = User::firstOrCreate(
            ['email' => 'dokter@beautypos.com'],
            [
                'name' => 'Dokter',
                'password' => Hash::make('password'),
                'branch_id' => $branch->id,
            ]
        );
        $dokter->assignRole('dokter');
        $dokter->branches()->syncWithoutDetaching([$branch->id => ['is_primary' => true]]);
    }
}
