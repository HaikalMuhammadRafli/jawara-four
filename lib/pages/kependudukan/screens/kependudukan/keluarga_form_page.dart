import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../data/models/keluarga_model.dart';
import '../../../../data/repositories/keluarga_repository.dart';

class KeluargaFormPage extends StatefulWidget {
  final Keluarga? keluarga;

  const KeluargaFormPage({super.key, this.keluarga});

  @override
  State<KeluargaFormPage> createState() => _KeluargaFormPageState();
}

class _KeluargaFormPageState extends State<KeluargaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final KeluargaRepository _repository = KeluargaRepository();
  bool _isLoading = false;

  // Controllers untuk input fields
  final TextEditingController _kepalaKeluargaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _jumlahAnggotaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.keluarga != null) {
      _kepalaKeluargaController.text = widget.keluarga!.kepalaKeluarga;
      _alamatController.text = widget.keluarga!.alamat;
      _jumlahAnggotaController.text = widget.keluarga!.jumlahAnggota.toString();
    }
  }

  @override
  void dispose() {
    _kepalaKeluargaController.dispose();
    _alamatController.dispose();
    _jumlahAnggotaController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final keluarga = Keluarga(
          id: widget.keluarga?.id ?? '',
          kepalaKeluarga: _kepalaKeluargaController.text,
          alamat: _alamatController.text,
          jumlahAnggota: int.parse(_jumlahAnggotaController.text),
          createdAt: widget.keluarga?.createdAt ?? DateTime.now(),
          updatedAt: widget.keluarga != null ? DateTime.now() : null,
        );

        if (widget.keluarga == null) {
          await _repository.addKeluarga(keluarga);
        } else {
          await _repository.updateKeluarga(keluarga);
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.keluarga == null
                  ? 'Data keluarga berhasil ditambahkan!'
                  : 'Data keluarga berhasil diupdate!',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    child: const Icon(Icons.family_restroom_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.keluarga == null ? 'Tambah Keluarga' : 'Edit Keluarga',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.keluarga == null
                              ? 'Lengkapi data keluarga baru'
                              : 'Update data keluarga',
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

            // Kepala Keluarga
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Nama Kepala Keluarga'),
                  TextFormField(
                    controller: _kepalaKeluargaController,
                    decoration: _buildInputDecoration(
                      hint: 'Masukkan nama kepala keluarga',
                      icon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama kepala keluarga wajib diisi';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Alamat
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Alamat Lengkap'),
                  TextFormField(
                    controller: _alamatController,
                    maxLines: 3,
                    decoration: _buildInputDecoration(
                      hint: 'Masukkan alamat lengkap',
                      icon: Icons.location_on,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat wajib diisi';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Jumlah Anggota
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Jumlah Anggota Keluarga'),
                  TextFormField(
                    controller: _jumlahAnggotaController,
                    keyboardType: TextInputType.number,
                    decoration: _buildInputDecoration(
                      hint: 'Masukkan jumlah anggota',
                      icon: Icons.people_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah anggota wajib diisi';
                      }
                      final intValue = int.tryParse(value);
                      if (intValue == null || intValue < 1) {
                        return 'Jumlah harus minimal 1';
                      }
                      return null;
                    },
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
                        widget.keluarga == null ? 'Tambah Keluarga' : 'Update Keluarga',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
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
}
