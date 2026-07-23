<?php

namespace App\Exports;

use App\Models\Transaction;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class SalesExport implements FromCollection, WithHeadings, WithMapping, ShouldAutoSize, WithStyles
{
    public function __construct(
        private readonly string $from,
        private readonly string $to,
    ) {}

    public function collection(): Collection
    {
        return Transaction::where('status', 'paid')
            ->whereBetween(\DB::raw('DATE(paid_at)'), [$this->from, $this->to])
            ->with(['customer', 'cashier', 'payments.paymentMethod'])
            ->latest('paid_at')
            ->get();
    }

    public function headings(): array
    {
        return [
            'No. Transaksi',
            'Tanggal',
            'Customer',
            'Kasir',
            'Subtotal',
            'Diskon',
            'Total',
            'Metode Bayar',
            'Status',
        ];
    }

    public function map($row): array
    {
        $methods = $row->payments->map(fn($p) => $p->paymentMethod->name)->join(', ');

        return [
            $row->transaction_number,
            $row->paid_at?->format('d/m/Y H:i'),
            $row->customer?->name ?? 'Umum',
            $row->cashier?->name ?? '-',
            number_format($row->subtotal, 0, ',', '.'),
            number_format($row->discount_amount, 0, ',', '.'),
            number_format($row->total, 0, ',', '.'),
            $methods,
            $row->status,
        ];
    }

    public function styles(Worksheet $sheet): array
    {
        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}
