import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ==================== DEFINISI WARNA ====================
const Color primaryBlue = Color(0xFF1E88E5);
const Color backgroundWhite = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);
const Color dividerGray = Color(0xFFE0E0E0);
const Color successGreen = Color(0xFF43A047);
const Color errorRed = Color(0xFFE53935);

class IuranTagihanFormPage extends StatefulWidget {
  const IuranTagihanFormPage({super.key});

  @override
  State<IuranTagihanFormPage> createState() => _IuranTagihanFormPageState();
}

class _IuranTagihanFormPageState extends State<IuranTagihanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaWargaController = TextEditingController();
  final _noRumahController = TextEditingController();
  final _nominalController = TextEditingController();
  final _keteranganController = TextEditingController();

  String? _selectedJenisIuran;
  String? _selectedBulan;
  String? _selectedTahun;
  DateTime? _selectedJatuhTempo;

  final List<String> _jenisIuranList = [
    'Iuran Keamanan',
    'Iuran Kebersihan',
    'Iuran Sampah',
    'Iuran Listrik Umum',
    'Iuran Air',
    'Iuran Sosial',
    'Lainnya',
  ];

  final List<String> _bulanList = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final List<String> _tahunList = List.generate(
    5,
    (index) => (DateTime.now().year + index).toString(),
  );

  @override
  void dispose() {
    _namaWargaController.dispose();
    _noRumahController.dispose();
    _nominalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              surface: backgroundWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedJatuhTempo) {
      setState(() {
        _selectedJatuhTempo = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedJatuhTempo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Silakan pilih tanggal jatuh tempo'),
              ],
            ),
            backgroundColor: errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      // TODO: Simpan data iuran
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 12),
              Text('Data iuran berhasil ditambahkan!'),
            ],
          ),
          backgroundColor: successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Tambah Iuran / Tagihan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _submitForm,
            icon: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Simpan',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBlue, primaryBlue.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Iuran & Tagihan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Catat iuran atau tagihan warga',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
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

            // Data Warga Section
            _buildSectionTitle('Data Warga', Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _namaWargaController,
                    label: 'Nama Warga',
                    hint: 'Masukkan nama warga',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama warga harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _noRumahController,
                    label: 'No. Rumah',
                    hint: 'Contoh: 01',
                    icon: Icons.home_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'No. rumah harus diisi';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Detail Iuran Section
            _buildSectionTitle('Detail Iuran', Icons.payment_outlined),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                children: [
                  _buildDropdown(
                    value: _selectedJenisIuran,
                    label: 'Jenis Iuran',
                    hint: 'Pilih jenis iuran',
                    icon: Icons.category_rounded,
                    items: _jenisIuranList,
                    onChanged: (value) {
                      setState(() {
                        _selectedJenisIuran = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          value: _selectedBulan,
                          label: 'Bulan',
                          hint: 'Pilih bulan',
                          icon: Icons.calendar_month_rounded,
                          items: _bulanList,
                          onChanged: (value) {
                            setState(() {
                              _selectedBulan = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          value: _selectedTahun,
                          label: 'Tahun',
                          hint: 'Pilih tahun',
                          icon: Icons.event_rounded,
                          items: _tahunList,
                          onChanged: (value) {
                            setState(() {
                              _selectedTahun = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _nominalController,
                    label: 'Nominal (Rp)',
                    hint: 'Contoh: 50000',
                    icon: Icons.money_rounded,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nominal harus diisi';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Nominal harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDateTimePicker(
                    label: 'Jatuh Tempo',
                    icon: Icons.event_available_rounded,
                    value: _selectedJatuhTempo != null
                        ? '${_selectedJatuhTempo!.day}/${_selectedJatuhTempo!.month}/${_selectedJatuhTempo!.year}'
                        : null,
                    hint: 'Pilih tanggal jatuh tempo',
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _keteranganController,
                    label: 'Keterangan (Opsional)',
                    hint: 'Tambahkan keterangan jika perlu',
                    icon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [primaryBlue, Color(0xFF1976D2)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _submitForm,
                  borderRadius: BorderRadius.circular(12),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Simpan Data Iuran',
                          style: TextStyle(
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
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: primaryBlue),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerGray.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
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
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 14,
            color: textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: textSecondary.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(icon, size: 20, color: primaryBlue),
            filled: true,
            fillColor: dividerGray.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dividerGray.withValues(alpha: 0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dividerGray.withValues(alpha: 0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorRed, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorRed, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: textSecondary.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(icon, size: 20, color: primaryBlue),
            filled: true,
            fillColor: dividerGray.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dividerGray.withValues(alpha: 0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dividerGray.withValues(alpha: 0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  color: textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Silakan pilih $label';
            }
            return null;
          },
          icon: const Icon(Icons.arrow_drop_down_rounded, color: primaryBlue),
          dropdownColor: backgroundWhite,
        ),
      ],
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required IconData icon,
    required String? value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: dividerGray.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: dividerGray.withValues(alpha: 0.6)),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: primaryBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value ?? hint,
                      style: TextStyle(
                        fontSize: 14,
                        color: value != null
                            ? textPrimary
                            : textSecondary.withValues(alpha: 0.6),
                        fontWeight: value != null
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: textSecondary.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

