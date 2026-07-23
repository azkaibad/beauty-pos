<?php

namespace App\Exports;

use App\Models\Product;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class StockExport implements FromCollection, WithHeadings, WithMapping, ShouldAutoSize, WithStyles
{
    public function collection(): Collection
    {
        return Product::with('category')
            ->where('is_active', true)
            ->orderBy('name')
            ->get();
    }

    public function headings(): array
    {
        return [
            'Kode',
            'Nama Produk',
            'Kategori',
            'Jenis',
            'Stok',
            'Stok Minimum',
            'Status',
            'Harga Jual',
        ];
    }

    public function map($row): array
    {
        return [
            $row->code ?? '-',
            $row->name,
            $row->category?->name ?? '-',
            ucfirst($row->type),
            $row->stock,
            $row->min_stock,
            $row->stock <= $row->min_stock ? '⚠ LOW STOCK' : 'OK',
            'Rp ' . number_format($row->selling_price, 0, ',', '.'),
        ];
    }

    public function styles(Worksheet $sheet): array
    {
        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}
