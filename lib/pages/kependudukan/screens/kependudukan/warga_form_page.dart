import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../data/models/warga_model.dart';
import '../../../../data/repositories/warga_repository.dart';

class WargaFormPage extends StatefulWidget {
  final Warga? warga;

  const WargaFormPage({super.key, this.warga});

  @override
  State<WargaFormPage> createState() => _WargaFormPageState();
}

class _WargaFormPageState extends State<WargaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final WargaRepository _repository = WargaRepository();
  bool _isLoading = false;

  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  JenisKelamin _selectedJenisKelamin = JenisKelamin.lakiLaki;

  @override
  void initState() {
    super.initState();
    if (widget.warga != null) {
      _nikController.text = widget.warga!.nik;
      _namaController.text = widget.warga!.nama;
      _selectedJenisKelamin = widget.warga!.jenisKelamin;
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final warga = Warga(
          id: widget.warga?.id ?? '',
          nik: _nikController.text,
          nama: _namaController.text,
          jenisKelamin: _selectedJenisKelamin,
          createdAt: widget.warga?.createdAt ?? DateTime.now(),
          updatedAt: widget.warga != null ? DateTime.now() : null,
        );

        if (widget.warga == null) {
          await _repository.addWarga(warga);
        } else {
          await _repository.updateWarga(warga);
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.warga == null
                  ? 'Data warga berhasil ditambahkan!'
                  : 'Data warga berhasil diupdate!',
            ),
            backgroundColor: AppColors.success,
          ),
        );

        context.pop();
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e'), backgroundColor: AppColors.error),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.warga == null ? 'Tambah Warga' : 'Edit Warga',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.warga == null ? 'Lengkapi data warga baru' : 'Update data warga',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // NIK
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('NIK'),
                TextFormField(
                  controller: _nikController,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration(
                    hint: 'Masukkan NIK',
                    icon: Icons.badge_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIK wajib diisi';
                    }
                    if (value.length != 16) {
                      return 'NIK harus 16 digit';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Nama
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Nama Lengkap'),
                TextFormField(
                  controller: _namaController,
                  decoration: _buildInputDecoration(
                    hint: 'Masukkan nama lengkap',
                    icon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Jenis Kelamin
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Jenis Kelamin'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildGenderOption(JenisKelamin.lakiLaki, 'Laki-laki', Icons.male),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGenderOption(JenisKelamin.perempuan, 'Perempuan', Icons.female),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      widget.warga == null ? 'Tambah Warga' : 'Update Warga',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.6), width: 1.5),
      ),
      child: child,
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary.withValues(alpha: 0.6)),
      filled: true,
      fillColor: AppColors.backgroundGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildGenderOption(JenisKelamin value, String label, IconData icon) {
    final isSelected = _selectedJenisKelamin == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedJenisKelamin = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.backgroundGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
