<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RolePermissionSeeder extends Seeder
{
    public function run(): void
    {
        // Reset cached roles and permissions
        app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

        $roles = ['owner', 'manajer', 'admin', 'dokter'];
        foreach ($roles as $role) {
            Role::firstOrCreate(['name' => $role]);
        }

        // Create basic permissions
        $permissions = [
            'manage_users',
            'manage_branches',
            'manage_roles',
            'manage_expenses', // pengajuan pengeluaran
            'manage_pos',      // system pelayan kasir
            'view_reports',    // omset saldo, closingan
            'manage_followup', // data followup
            'manage_medical_records', // rekam medis
            'manage_customers', // pelanggan
            'manage_products',
            'manage_treatments',
        ];

        foreach ($permissions as $permission) {
            Permission::firstOrCreate(['name' => $permission]);
        }

        // Assign permissions to roles
        $admin = Role::findByName('admin');
        $admin->syncPermissions([
            'manage_expenses',
            'manage_pos',
            'view_reports',
            'manage_followup',
            'manage_customers',
            'manage_products',
            'manage_treatments'
        ]);

        $dokter = Role::findByName('dokter');
        $dokter->syncPermissions([
            'manage_medical_records'
        ]);

        // Owner and Manager get all permissions for now
        $owner = Role::findByName('owner');
        $owner->syncPermissions(Permission::all());

        $manager = Role::findByName('manajer');
        $manager->syncPermissions(Permission::all());
    }
}
