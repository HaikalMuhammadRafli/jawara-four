import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

class RumahFormPage extends StatefulWidget {
  const RumahFormPage({super.key});

  @override
  State<RumahFormPage> createState() => _RumahFormPageState();
}

class _RumahFormPageState extends State<RumahFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers untuk input fields
  final TextEditingController _noRumahController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _luasTanahController = TextEditingController();
  final TextEditingController _luasBangunanController = TextEditingController();
  final TextEditingController _jumlahPenghuniController = TextEditingController();
  final TextEditingController _jumlahKamarTidurController = TextEditingController();
  final TextEditingController _jumlahKamarMandiController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  String? _selectedStatusKepemilikan;
  String? _selectedJenisRumah;
  String? _selectedKondisiRumah;
  String? _selectedSumberAir;
  String? _selectedDayaListrik;

  @override
  void dispose() {
    _noRumahController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _alamatController.dispose();
    _luasTanahController.dispose();
    _luasBangunanController.dispose();
    _jumlahPenghuniController.dispose();
    _jumlahKamarTidurController.dispose();
    _jumlahKamarMandiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
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
          content: Text('Data rumah berhasil ditambahkan!'),
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
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
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
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.home_rounded, color: Colors.white, size: 32),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tambah Rumah Baru',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Masukkan data rumah baru',
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Section: Identitas Rumah
            _buildSectionTitle(Icons.home_work_rounded, 'Identitas Rumah'),
            _buildCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _noRumahController,
                    label: 'Nomor Rumah',
                    hint: 'Contoh: 001, A-12, dll',
                    icon: Icons.numbers_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor rumah harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _rtController,
                          label: 'RT',
                          hint: 'RT',
                          icon: Icons.home_work_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'RT harus diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _rwController,
                          label: 'RW',
                          hint: 'RW',
                          icon: Icons.location_city_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'RW harus diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _alamatController,
                    label: 'Alamat Lengkap',
                    hint: 'Masukkan alamat lengkap rumah',
                    icon: Icons.map_rounded,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat harus diisi';
                      }
                      if (value.length < 10) {
                        return 'Alamat harus minimal 10 karakter';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Section: Detail Rumah
            _buildSectionTitle(Icons.house_rounded, 'Detail Rumah'),
            _buildCard(
              child: Column(
                children: [
                  _buildDropdown(
                    value: _selectedStatusKepemilikan,
                    label: 'Status Kepemilikan',
                    hint: 'Pilih status kepemilikan',
                    icon: Icons.key_rounded,
                    items: ['Milik Sendiri', 'Kontrak', 'Sewa', 'Menumpang', 'Dinas'],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatusKepemilikan = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Status kepemilikan harus dipilih';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    value: _selectedJenisRumah,
                    label: 'Jenis Rumah',
                    hint: 'Pilih jenis rumah',
                    icon: Icons.apartment_rounded,
                    items: [
                      'Rumah Permanen',
                      'Rumah Semi Permanen',
                      'Rumah Non Permanen',
                      'Rumah Susun',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedJenisRumah = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis rumah harus dipilih';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    value: _selectedKondisiRumah,
                    label: 'Kondisi Rumah',
                    hint: 'Pilih kondisi rumah',
                    icon: Icons.build_circle_rounded,
                    items: ['Baik', 'Sedang', 'Rusak Ringan', 'Rusak Berat'],
                    onChanged: (value) {
                      setState(() {
                        _selectedKondisiRumah = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kondisi rumah harus dipilih';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Section: Ukuran dan Fasilitas
            _buildSectionTitle(Icons.square_foot_rounded, 'Ukuran dan Fasilitas'),
            _buildCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _luasTanahController,
                          label: 'Luas Tanah (m²)',
                          hint: 'Luas tanah',
                          icon: Icons.landscape_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Luas tanah harus diisi';
                            }
                            final doubleValue = double.tryParse(value);
                            if (doubleValue == null || doubleValue <= 0) {
                              return 'Luas harus lebih dari 0';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _luasBangunanController,
                          label: 'Luas Bangunan (m²)',
                          hint: 'Luas bangunan',
                          icon: Icons.home_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Luas bangunan harus diisi';
                            }
                            final doubleValue = double.tryParse(value);
                            if (doubleValue == null || doubleValue <= 0) {
                              return 'Luas harus lebih dari 0';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _jumlahKamarTidurController,
                          label: 'Jumlah Kamar Tidur',
                          hint: 'Jumlah',
                          icon: Icons.bed_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jumlah kamar tidur harus diisi';
                            }
                            final intValue = int.tryParse(value);
                            if (intValue == null || intValue < 0) {
                              return 'Jumlah tidak valid';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _jumlahKamarMandiController,
                          label: 'Jumlah Kamar Mandi',
                          hint: 'Jumlah',
                          icon: Icons.bathtub_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jumlah kamar mandi harus diisi';
                            }
                            final intValue = int.tryParse(value);
                            if (intValue == null || intValue < 0) {
                              return 'Jumlah tidak valid';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Section: Utilitas
            _buildSectionTitle(Icons.electrical_services_rounded, 'Utilitas'),
            _buildCard(
              child: Column(
                children: [
                  _buildDropdown(
                    value: _selectedSumberAir,
                    label: 'Sumber Air',
                    hint: 'Pilih sumber air',
                    icon: Icons.water_drop_rounded,
                    items: ['PDAM', 'Sumur Bor', 'Sumur Gali', 'Air Hujan', 'Lainnya'],
                    onChanged: (value) {
                      setState(() {
                        _selectedSumberAir = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Sumber air harus dipilih';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    value: _selectedDayaListrik,
                    label: 'Daya Listrik',
                    hint: 'Pilih daya listrik',
                    icon: Icons.power_rounded,
                    items: [
                      '450 VA',
                      '900 VA',
                      '1300 VA',
                      '2200 VA',
                      '3500 VA',
                      'Lebih dari 3500 VA',
                      'Tidak Ada',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDayaListrik = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Daya listrik harus dipilih';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Section: Informasi Tambahan
            _buildSectionTitle(Icons.info_rounded, 'Informasi Tambahan'),
            _buildCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _jumlahPenghuniController,
                    label: 'Jumlah Penghuni',
                    hint: 'Masukkan jumlah penghuni rumah',
                    icon: Icons.people_rounded,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah penghuni harus diisi';
                      }
                      final intValue = int.tryParse(value);
                      if (intValue == null || intValue < 0) {
                        return 'Jumlah tidak valid';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _catatanController,
                    label: 'Catatan (Opsional)',
                    hint: 'Masukkan catatan tambahan jika ada',
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
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
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
                            'Simpan Data Rumah',
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: Offset(0, 2)),
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
}
