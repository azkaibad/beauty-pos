// lib/features/customers/screens/customer_form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/customer_model.dart';
import '../data/customer_service.dart';

class CustomerFormScreen extends ConsumerStatefulWidget {
  final CustomerModel? customer;

  const CustomerFormScreen({super.key, this.customer});

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDob;
  bool _isLoading = false;
  String? _error;

  bool get isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    if (c != null) {
      _nameCtrl.text = c.name;
      _phoneCtrl.text = c.phone ?? '';
      _emailCtrl.text = c.email ?? '';
      _addressCtrl.text = c.address ?? '';
      _notesCtrl.text = c.notes ?? '';
      _selectedGender = c.gender;
      if (c.dateOfBirth != null) {
        _selectedDob = DateTime.tryParse(c.dateOfBirth!);
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final data = {
      'name': _nameCtrl.text.trim(),
      if (_phoneCtrl.text.isNotEmpty) 'phone': _phoneCtrl.text.trim(),
      if (_emailCtrl.text.isNotEmpty) 'email': _emailCtrl.text.trim(),
      if (_selectedGender != null) 'gender': _selectedGender,
      if (_selectedDob != null)
        'date_of_birth': _selectedDob!.toIso8601String().split('T')[0],
      if (_addressCtrl.text.isNotEmpty) 'address': _addressCtrl.text.trim(),
      if (_notesCtrl.text.isNotEmpty) 'notes': _notesCtrl.text.trim(),
    };

    try {
      final service = ref.read(customerServiceProvider);
      if (isEditing) {
        await service.updateCustomer(widget.customer!.id, data);
      } else {
        await service.createCustomer(data);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _error = _parseError(e.toString());
        _isLoading = false;
      });
    }
  }

  String _parseError(String raw) {
    if (raw.contains('422')) return 'Data tidak valid. Periksa kembali inputan.';
    if (raw.contains('network')) return 'Gagal terhubung ke server.';
    return 'Terjadi kesalahan. Coba lagi.';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFD4838F),
            surface: Color(0xFF2A1F26),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.97,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1218),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF3D2D35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  Text(
                    isEditing ? 'Edit Customer' : 'Tambah Customer',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded,
                        color: Color(0xFF7A6470)),
                  ),
                ],
              ),
            ),

            // Error banner
            if (_error != null)
              Container(
                margin: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A1B1B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE57373)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Color(0xFFE57373), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_error!,
                          style: const TextStyle(
                              color: Color(0xFFE57373), fontSize: 13)),
                    ),
                  ],
                ),
              ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama
                      _label('Nama Lengkap *'),
                      _field(
                        controller: _nameCtrl,
                        hint: 'Masukkan nama lengkap',
                        icon: Icons.person_outline_rounded,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Nama wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Telepon
                      _label('Nomor Telepon'),
                      _field(
                        controller: _phoneCtrl,
                        hint: '08xxxxxxxxxx',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      _label('Email'),
                      _field(
                        controller: _emailCtrl,
                        hint: 'email@contoh.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Jenis Kelamin
                      _label('Jenis Kelamin'),
                      _genderSelector(),
                      const SizedBox(height: 16),

                      // Tanggal lahir
                      _label('Tanggal Lahir'),
                      _dobPicker(),
                      const SizedBox(height: 16),

                      // Alamat
                      _label('Alamat'),
                      _field(
                        controller: _addressCtrl,
                        hint: 'Alamat lengkap...',
                        icon: Icons.location_on_outlined,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Catatan
                      _label('Catatan / Alergi'),
                      _field(
                        controller: _notesCtrl,
                        hint: 'Catatan khusus, alergi, preferensi...',
                        icon: Icons.note_outlined,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4838F),
                            disabledBackgroundColor:
                                const Color(0xFFD4838F).withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  isEditing ? 'Simpan Perubahan' : 'Tambah Customer',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFB0A0A8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF4D3D45), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF7A6470), size: 20),
          filled: true,
          fillColor: const Color(0xFF221820),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3D2D35)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3D2D35)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD4838F)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE57373)),
          ),
        ),
      );

  Widget _genderSelector() => Row(
        children: [
          _genderChip('female', 'Perempuan', Icons.female_rounded,
              const Color(0xFFF48FB1)),
          const SizedBox(width: 10),
          _genderChip(
              'male', 'Laki-laki', Icons.male_rounded, const Color(0xFF4FC3F7)),
        ],
      );

  Widget _genderChip(
      String value, String label, IconData icon, Color color) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(
          () => _selectedGender = isSelected ? null : value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.18) : const Color(0xFF221820),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : const Color(0xFF3D2D35),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? color : const Color(0xFF7A6470)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : const Color(0xFF7A6470),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dobPicker() => GestureDetector(
        onTap: _pickDate,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF221820),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3D2D35)),
          ),
          child: Row(
            children: [
              const Icon(Icons.cake_outlined,
                  color: Color(0xFF7A6470), size: 20),
              const SizedBox(width: 12),
              Text(
                _selectedDob != null
                    ? '${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}'
                    : 'Pilih tanggal lahir',
                style: TextStyle(
                  color: _selectedDob != null
                      ? Colors.white
                      : const Color(0xFF4D3D45),
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (_selectedDob != null)
                GestureDetector(
                  onTap: () => setState(() => _selectedDob = null),
                  child: const Icon(Icons.clear_rounded,
                      size: 16, color: Color(0xFF7A6470)),
                ),
            ],
          ),
        ),
      );
}
