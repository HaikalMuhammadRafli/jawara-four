import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../../data/models/warga_model.dart';
import '../../../../../data/repositories/warga_repository.dart';

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

  // Controllers
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Alamat removed - will be assigned from Keluarga/Rumah

  // State
  JenisKelamin _selectedJenisKelamin = JenisKelamin.lakiLaki;
  StatusPerkawinan _selectedStatusPerkawinan = StatusPerkawinan.belumKawin;
  Pendidikan? _selectedPendidikan;
  DateTime? _selectedTanggalLahir;

  @override
  void initState() {
    super.initState();
    if (widget.warga != null) {
      _nikController.text = widget.warga!.nik;
      _namaController.text = widget.warga!.nama;
      _emailController.text = widget.warga!.email;
      _noTeleponController.text = widget.warga!.noTelepon;
      _tempatLahirController.text = widget.warga!.tempatLahir ?? '';
      _pekerjaanController.text = widget.warga!.pekerjaan ?? '';
      // Alamat not loaded - will come from Keluarga
      _selectedJenisKelamin = widget.warga!.jenisKelamin;
      _selectedStatusPerkawinan = widget.warga!.statusPerkawinan;
      _selectedPendidikan = widget.warga!.pendidikan;
      _selectedTanggalLahir = widget.warga!.tanggalLahir;
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _noTeleponController.dispose();
    _tempatLahirController.dispose();
    _pekerjaanController.dispose();
    _passwordController.dispose();
    // Alamat controller removed
    super.dispose();
  }

  Future<void> _selectTanggalLahir() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTanggalLahir ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTanggalLahir) {
      setState(() {
        _selectedTanggalLahir = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTanggalLahir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tanggal lahir harus dipilih'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final warga = Warga(
          id: widget.warga?.id ?? '',
          nik: _nikController.text,
          nama: _namaController.text,
          jenisKelamin: _selectedJenisKelamin,
          email: _emailController.text,
          noTelepon: _noTeleponController.text,
          tanggalLahir: _selectedTanggalLahir!,
          tempatLahir: _tempatLahirController.text.isEmpty
              ? null
              : _tempatLahirController.text,
          statusPerkawinan: _selectedStatusPerkawinan,
          pekerjaan: _pekerjaanController.text.isEmpty
              ? null
              : _pekerjaanController.text,
          pendidikan: _selectedPendidikan,
          alamat: null, // Will be assigned from Keluarga/Rumah
          createdAt: widget.warga?.createdAt ?? DateTime.now(),
          updatedAt: widget.warga != null ? DateTime.now() : null,
        );

        if (widget.warga == null) {
          // Create warga with account using password or NIK as default
          final password = _passwordController.text.trim().isEmpty
              ? _nikController.text
              : _passwordController.text.trim();
          await _repository.createWargaWithAccount(warga, password);
        } else {
          // Update warga and optionally update user profile
          await _repository.updateWargaWithAccount(
            warga,
            updateUserProfile: true,
          );
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.warga == null
                  ? 'Warga dan akun berhasil dibuat!'
                  : 'Data warga berhasil diupdate!',
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
                    Icons.person_add_rounded,
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
                        widget.warga == null ? 'Tambah Warga' : 'Edit Warga',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.warga == null
                            ? 'Lengkapi data warga dan buat akun'
                            : 'Perbarui data warga',
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

          // Info Card - Account Creation
          if (widget.warga == null)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Password default: NIK. Anda bisa mengisi password manual di bawah (opsional)',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Data Pribadi Section
          _buildSectionTitle('Data Pribadi', Icons.person_rounded),
          _buildCard(
            child: Column(
              children: [
                _buildTextField(
                  controller: _namaController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _nikController,
                  label: 'NIK',
                  hint: 'Masukkan 16 digit NIK',
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
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
                const SizedBox(height: 16),
                _buildLabel('Jenis Kelamin'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildGenderOption(
                        JenisKelamin.lakiLaki,
                        'Laki-laki',
                        Icons.male,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGenderOption(
                        JenisKelamin.perempuan,
                        'Perempuan',
                        Icons.female,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _tempatLahirController,
                  label: 'Tempat Lahir (Opsional)',
                  hint: 'Masukkan tempat lahir',
                  icon: Icons.location_city,
                ),
                const SizedBox(height: 16),
                _buildDatePicker(
                  label: 'Tanggal Lahir',
                  hint: 'Pilih tanggal lahir',
                  icon: Icons.calendar_today,
                  selectedDate: _selectedTanggalLahir,
                  onTap: _selectTanggalLahir,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Data Kontak Section
          _buildSectionTitle('Data Kontak & Akun', Icons.contact_phone_rounded),
          _buildCard(
            child: Column(
              children: [
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: widget.warga != null, // Read-only saat edit
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email harus diisi';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                // Info jika mode edit
                if (widget.warga != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Email tidak dapat diubah (memerlukan Admin SDK)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // Password field - only for new warga
                if (widget.warga == null)
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password (Opsional)',
                    hint: 'Kosongkan untuk menggunakan NIK sebagai password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                if (widget.warga == null) const SizedBox(height: 16),
                _buildTextField(
                  controller: _noTeleponController,
                  label: 'No Telepon',
                  hint: 'Masukkan nomor telepon',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No telepon wajib diisi';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Data Tambahan Section
          _buildSectionTitle('Data Tambahan', Icons.work_outline_rounded),
          _buildCard(
            child: Column(
              children: [
                _buildDropdown<StatusPerkawinan>(
                  value: _selectedStatusPerkawinan.value,
                  label: 'Status Perkawinan',
                  hint: 'Pilih status perkawinan',
                  icon: Icons.family_restroom,
                  items: StatusPerkawinan.values.map((e) => e.value).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusPerkawinan = StatusPerkawinan.values
                          .firstWhere((e) => e.value == value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown<Pendidikan>(
                  value: _selectedPendidikan?.value,
                  label: 'Pendidikan (Opsional)',
                  hint: 'Pilih pendidikan terakhir',
                  icon: Icons.school_outlined,
                  items: Pendidikan.values.map((e) => e.value).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPendidikan = value != null
                          ? Pendidikan.values.firstWhere(
                              (e) => e.value == value,
                            )
                          : null;
                    });
                  },
                  required: false,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _pekerjaanController,
                  label: 'Pekerjaan (Opsional)',
                  hint: 'Masukkan pekerjaan',
                  icon: Icons.work_outline,
                ),
                // Alamat field removed - will be assigned from Keluarga/Rumah
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          widget.warga == null
                              ? 'Simpan & Buat Akun'
                              : 'Update Warga',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
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
    bool obscureText = false,
    bool readOnly = false, // Added for disabling email edit
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
          obscureText: obscureText,
          readOnly: readOnly, // Disable editing when true
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
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

  Widget _buildDropdown<T>({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: onChanged,
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label wajib dipilih';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required String hint,
    required IconData icon,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(
                icon,
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            child: Text(
              selectedDate != null
                  ? DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate)
                  : hint,
              style: TextStyle(
                color: selectedDate != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(JenisKelamin value, String label, IconData icon) {
    final isSelected = _selectedJenisKelamin == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedJenisKelamin = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.backgroundGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.divider.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
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
