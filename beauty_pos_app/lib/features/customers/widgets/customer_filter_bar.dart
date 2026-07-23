// lib/features/customers/widgets/customer_filter_bar.dart

import 'package:flutter/material.dart';

class CustomerFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const CustomerFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          // Search bar
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF221820),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF3D2D35)),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Cari nama, telepon, email...',
                  hintStyle: TextStyle(color: Color(0xFF7A6470), fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: Color(0xFF7A6470), size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Gender filter
          _GenderFilterButton(
            selected: selectedGender,
            onChanged: onGenderChanged,
          ),
        ],
      ),
    );
  }
}

class _GenderFilterButton extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _GenderFilterButton({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final hasFilter = selected != null;

    return PopupMenuButton<String?>(
      color: const Color(0xFF2A1F26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 48),
      onSelected: (val) => onChanged(val == 'all' ? null : val),
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'all',
          child: _MenuItem(icon: Icons.people_outline_rounded, label: 'Semua'),
        ),
        const PopupMenuItem(
          value: 'female',
          child: _MenuItem(
              icon: Icons.female_rounded,
              label: 'Perempuan',
              color: Color(0xFFF48FB1)),
        ),
        const PopupMenuItem(
          value: 'male',
          child: _MenuItem(
              icon: Icons.male_rounded,
              label: 'Laki-laki',
              color: Color(0xFF4FC3F7)),
        ),
      ],
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: hasFilter
              ? const Color(0xFFD4838F).withOpacity(0.15)
              : const Color(0xFF221820),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasFilter
                ? const Color(0xFFD4838F)
                : const Color(0xFF3D2D35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list_rounded,
              size: 18,
              color: hasFilter
                  ? const Color(0xFFD4838F)
                  : const Color(0xFF7A6470),
            ),
            const SizedBox(width: 6),
            Text(
              selected == 'female'
                  ? 'Perempuan'
                  : selected == 'male'
                      ? 'Laki-laki'
                      : 'Filter',
              style: TextStyle(
                color: hasFilter
                    ? const Color(0xFFD4838F)
                    : const Color(0xFF7A6470),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.color = const Color(0xFFB0A0A8),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }
}
