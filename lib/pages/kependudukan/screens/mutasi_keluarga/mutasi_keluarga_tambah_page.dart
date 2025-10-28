import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

class MutasiKeluargaTambahPage extends StatefulWidget {
  const MutasiKeluargaTambahPage({super.key});

  @override
  State<MutasiKeluargaTambahPage> createState() => _MutasiKeluargaTambahPageState();
}

class _MutasiKeluargaTambahPageState extends State<MutasiKeluargaTambahPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers untuk input fields
  final TextEditingController _noKKController = TextEditingController();
  final TextEditingController _kepalaKeluargaController = TextEditingController();
  final TextEditingController _namaWargaController = TextEditingController();
  final TextEditingController _alamatAsalController = TextEditingController();
  final TextEditingController _alamatTujuanController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  String? _selectedJenisMutasi;
  DateTime? _selectedTanggalMutasi;

  @override
  void dispose() {
    _noKKController.dispose();
    _kepalaKeluargaController.dispose();
    _namaWargaController.dispose();
    _alamatAsalController.dispose();
    _alamatTujuanController.dispose();
    _alasanController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectTanggalMutasi() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTanggalMutasi ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)),
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
    if (picked != null && picked != _selectedTanggalMutasi) {
      setState(() {
        _selectedTanggalMutasi = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTanggalMutasi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tanggal mutasi harus dipilih'), backgroundColor: AppColors.error),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulasi submit ke backend
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mutasi keluarga berhasil ditambahkan!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Kembali ke halaman sebelumnya
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.move_to_inbox_rounded, color: Colors.white, size: 32),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tambah Mutasi Keluarga',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Catat perpindahan keluarga',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Section: Data Keluarga
            _buildSectionTitle(Icons.family_restroom_rounded, 'Data Keluarga'),
            _buildCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _noKKController,
                    label: 'Nomor Kartu Keluarga (KK)',
                    hint: 'Masukkan 16 digit nomor KK',
                    icon: Icons.badge_rounded,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor KK harus diisi';
                      }
                      if (value.length != 16) {
                        return 'Nomor KK harus 16 digit';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _kepalaKeluargaController,
                    label: 'Nama Kepala Keluarga',
                    hint: 'Masukkan nama kepala keluarga',
                    icon: Icons.person_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama kepala keluarga harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _namaWargaController,
                    label: 'Nama Warga yang Pindah',
                    hint: 'Masukkan nama warga',
                    icon: Icons.person_outline_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama warga harus diisi';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Section: Detail Mutasi
            _buildSectionTitle(Icons.info_rounded, 'Detail Mutasi'),
            _buildCard(
              child: Column(
                children: [
                  _buildDropdown(
                    value: _selectedJenisMutasi,
                    label: 'Jenis Mutasi',
                    hint: 'Pilih jenis mutasi',
                    icon: Icons.swap_horiz_rounded,
                    items: ['Pindah Masuk', 'Pindah Keluar', 'Pindah Antar RT/RW'],
                    onChanged: (value) {
                      setState(() {
                        _selectedJenisMutasi = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis mutasi harus dipilih';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildDateTimePicker(
                    label: 'Tanggal Mutasi',
                    hint: 'Pilih tanggal mutasi',
                    icon: Icons.calendar_today_rounded,
                    selectedDate: _selectedTanggalMutasi,
                    onTap: _selectTanggalMutasi,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _alamatAsalController,
                    label: 'Alamat Asal',
                    hint: 'Masukkan alamat asal',
                    icon: Icons.location_on_outlined,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat asal harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _alamatTujuanController,
                    label: 'Alamat Tujuan',
                    hint: 'Masukkan alamat tujuan',
                    icon: Icons.location_on_rounded,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat tujuan harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _alasanController,
                    label: 'Alasan Mutasi',
                    hint: 'Masukkan alasan mutasi',
                    icon: Icons.description_rounded,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alasan mutasi harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _keteranganController,
                    label: 'Keterangan Tambahan (Opsional)',
                    hint: 'Masukkan keterangan tambahan',
                    icon: Icons.note_rounded,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Submit Button
            Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Simpan Mutasi Keluarga',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper Widgets

  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: child,
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
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.backgroundGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.backgroundGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required String hint,
    required IconData icon,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primary),
          filled: true,
          fillColor: AppColors.backgroundGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
              : hint,
          style: TextStyle(
            color: selectedDate != null ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

