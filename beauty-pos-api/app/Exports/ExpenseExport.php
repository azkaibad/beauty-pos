<?php

namespace App\Exports;

use App\Models\ExpenseRequest;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class ExpenseExport implements FromCollection, WithHeadings, WithMapping, ShouldAutoSize, WithStyles
{
    public function __construct(
        private readonly ?string $from = null,
        private readonly ?string $to = null,
    ) {}

    public function collection(): Collection
    {
        $query = ExpenseRequest::where('status', 'approved')
            ->with(['requestedBy', 'approvedBy']);

        if ($this->from) $query->whereDate('approved_at', '>=', $this->from);
        if ($this->to)   $query->whereDate('approved_at', '<=', $this->to);

        return $query->latest()->get();
    }

    public function headings(): array
    {
        return ['Judul', 'Kategori', 'Jumlah', 'Diajukan Oleh', 'Disetujui Oleh', 'Tanggal Approved'];
    }

    public function map($row): array
    {
        return [
            $row->title,
            ucfirst($row->category),
            'Rp ' . number_format($row->amount, 0, ',', '.'),
            $row->requestedBy?->name,
            $row->approvedBy?->name,
            $row->approved_at?->format('d/m/Y'),
        ];
    }

    public function styles(Worksheet $sheet): array
    {
        return [1 => ['font' => ['bold' => true]]];
    }
}
