import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../../data/models/rumah_model.dart';
// warga_model and warga_repository imports removed - pemilik auto-assigned
import '../../../../../data/repositories/rumah_repository.dart';

class RumahFormPage extends StatefulWidget {
  final Rumah? rumah;

  const RumahFormPage({super.key, this.rumah});

  @override
  State<RumahFormPage> createState() => _RumahFormPageState();
}

class _RumahFormPageState extends State<RumahFormPage> {
  final _formKey = GlobalKey<FormState>();
  final RumahRepository _rumahRepository = RumahRepository();
  // WargaRepository removed - pemilik will be auto-assigned from Keluarga
  bool _isLoading = false;

  // Controllers
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _nomorRumahController = TextEditingController();
  final TextEditingController _luasTanahController = TextEditingController();
  final TextEditingController _luasBangunanController = TextEditingController();

  // State
  StatusRumah _selectedStatus = StatusRumah.kosong;
  @override
  void initState() {
    super.initState();
    // Pemilik loading removed - will be auto-assigned

    if (widget.rumah != null) {
      _alamatController.text = widget.rumah!.alamat;
      _rtController.text = widget.rumah!.rt;
      _rwController.text = widget.rumah!.rw;
      _nomorRumahController.text = widget.rumah!.nomorRumah ?? '';
      _luasTanahController.text = widget.rumah!.luasTanah?.toString() ?? '';
      _luasBangunanController.text =
          widget.rumah!.luasBangunan?.toString() ?? '';
      _selectedStatus = widget.rumah!.status;
      // pemilikId not loaded - will be set by Keluarga
    }
  }

  @override
  void dispose() {
    _alamatController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _nomorRumahController.dispose();
    _luasTanahController.dispose();
    _luasBangunanController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Pemilik validation removed - will be set by Keluarga

      setState(() => _isLoading = true);

      try {
        final rumah = Rumah(
          id: widget.rumah?.id ?? '',
          alamat: _alamatController.text,
          rt: _rtController.text,
          rw: _rwController.text,
          nomorRumah: _nomorRumahController.text.isEmpty
              ? null
              : _nomorRumahController.text,
          status: _selectedStatus,
          pemilikId: null, // Will be auto-assigned from Keluarga
          luasTanah: _luasTanahController.text.isEmpty
              ? null
              : double.tryParse(_luasTanahController.text),
          luasBangunan: _luasBangunanController.text.isEmpty
              ? null
              : double.tryParse(_luasBangunanController.text),
          createdAt: widget.rumah?.createdAt ?? DateTime.now(),
          updatedAt: widget.rumah != null ? DateTime.now() : null,
        );

        if (widget.rumah == null) {
          await _rumahRepository.addRumah(rumah);
        } else {
          await _rumahRepository.updateRumah(rumah);
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.rumah == null
                  ? 'Data rumah berhasil ditambahkan!'
                  : 'Data rumah berhasil diupdate!',
            ),
            backgroundColor: AppColors.success,
          ),
        );

        context.pop();
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan data: $e'),
            backgroundColor: AppColors.error,
          ),
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
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.rumah == null ? 'Tambah Rumah' : 'Edit Rumah',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.rumah == null
                            ? 'Lengkapi semua informasi rumah'
                            : 'Perbarui informasi rumah',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Lokasi Section
          _buildSectionTitle('Lokasi Rumah', Icons.location_on_rounded),
          const SizedBox(height: 12),
          _buildCard(
            child: Column(
              children: [
                _buildTextField(
                  controller: _alamatController,
                  label: 'Alamat Lengkap',
                  hint: 'Masukkan alamat lengkap',
                  icon: Icons.location_on_outlined,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _rtController,
                        label: 'RT',
                        hint: 'Masukkan RT',
                        icon: Icons.home_work,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'RT wajib diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _rwController,
                        label: 'RW',
                        hint: 'Masukkan RW',
                        icon: Icons.apartment,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'RW wajib diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _nomorRumahController,
                  label: 'Nomor Rumah (Opsional)',
                  hint: 'Masukkan nomor rumah',
                  icon: Icons.numbers,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pemilik section removed - will be auto-assigned from Keluarga
          // Status Section
          _buildSectionTitle('Status Rumah', Icons.info_outline_rounded),
          _buildCard(child: Column(children: [_buildStatusDropdown()])),
          const SizedBox(height: 20),

          // Detail Bangunan Section
          _buildSectionTitle(
            'Detail Bangunan (Opsional)',
            Icons.straighten_rounded,
          ),
          _buildCard(
            child: Column(
              children: [
                _buildTextField(
                  controller: _luasTanahController,
                  label: 'Luas Tanah (m²)',
                  hint: 'Masukkan luas tanah',
                  icon: Icons.landscape,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _luasBangunanController,
                  label: 'Luas Bangunan (m²)',
                  hint: 'Masukkan luas bangunan',
                  icon: Icons.home_outlined,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isLoading ? null : _submitForm,
                borderRadius: BorderRadius.circular(12),
                child: _isLoading
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.save_rounded,
                              size: 22,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              widget.rumah == null
                                  ? 'Simpan Rumah'
                                  : 'Update Rumah',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: child,
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: AppColors.divider.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.divider.withValues(alpha: 0.6),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Status Rumah'),
        const SizedBox(height: 8),
        DropdownButtonFormField<StatusRumah>(
          initialValue: _selectedStatus,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: 'Pilih status rumah',
            prefixIcon: Icon(
              Icons.home_outlined,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: AppColors.backgroundGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.divider.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: StatusRumah.values.map((status) {
            return DropdownMenuItem<StatusRumah>(
              value: status,
              child: Text(status.value),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedStatus = value;
              });
            }
          },
        ),
      ],
    );
  }
}
