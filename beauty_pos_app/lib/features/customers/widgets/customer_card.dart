// lib/features/customers/widgets/customer_card.dart

import 'package:flutter/material.dart';
import '../../../core/models/customer_model.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF221820),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3D2D35)),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF5C2D3A),
                backgroundImage: customer.photo != null
                    ? NetworkImage(customer.photo!)
                    : null,
                child: customer.photo == null
                    ? Text(
                        customer.initials,
                        style: const TextStyle(
                          color: Color(0xFFD4838F),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (customer.phone != null || customer.email != null)
                      Text(
                        customer.phone ?? customer.email ?? '',
                        style: const TextStyle(
                          color: Color(0xFF7A6470),
                          fontSize: 13,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Gender chip
                        if (customer.gender != null)
                          _chip(
                            icon: customer.gender == 'female'
                                ? Icons.female_rounded
                                : Icons.male_rounded,
                            label: customer.genderLabel,
                            color: customer.gender == 'female'
                                ? const Color(0xFFF48FB1)
                                : const Color(0xFF4FC3F7),
                          ),
                        const SizedBox(width: 6),
                        // Status chip
                        _chip(
                          icon: customer.isActive
                              ? Icons.check_circle_outline_rounded
                              : Icons.cancel_outlined,
                          label: customer.isActive ? 'Aktif' : 'Nonaktif',
                          color: customer.isActive
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFE57373),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              Column(
                children: [
                  _iconBtn(
                    icon: Icons.edit_rounded,
                    color: const Color(0xFF4FC3F7),
                    onTap: onEdit,
                  ),
                  const SizedBox(height: 4),
                  _iconBtn(
                    icon: Icons.delete_outline_rounded,
                    color: const Color(0xFFE57373),
                    onTap: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required Color color,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Widget _iconBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      );
}
