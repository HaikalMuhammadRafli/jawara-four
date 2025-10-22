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

class KegiatanFormPage extends StatefulWidget {
  const KegiatanFormPage({super.key});

  @override
  State<KegiatanFormPage> createState() => _KegiatanFormPageState();
}

class _KegiatanFormPageState extends State<KegiatanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _penanggungJawabController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String? _selectedKategori;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedPrioritas = 'Sedang';

  final List<String> _kategoriList = [
    'Keamanan',
    'Kebersihan',
    'Sosial',
    'Kesehatan',
    'Olahraga',
    'Keagamaan',
    'Pendidikan',
    'Lainnya',
  ];

  final List<String> _prioritasList = ['Rendah', 'Sedang', 'Tinggi', 'Urgent'];

  @override
  void dispose() {
    _namaController.dispose();
    _penanggungJawabController.dispose();
    _deskripsiController.dispose();
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Silakan pilih tanggal kegiatan'),
              ],
            ),
            backgroundColor: errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }

      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Silakan pilih waktu kegiatan'),
              ],
            ),
            backgroundColor: errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }

      // TODO: Simpan data kegiatan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 12),
              Text('Kegiatan berhasil ditambahkan!'),
            ],
          ),
          backgroundColor: successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          'Tambah Kegiatan',
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
            icon: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
            label: const Text(
              'Simpan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
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
                  colors: [primaryBlue, primaryBlue.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.3),
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
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.event_note_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buat Kegiatan Baru',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Lengkapi informasi kegiatan di bawah ini',
                          style: TextStyle(fontSize: 13, color: Colors.white70, letterSpacing: 0.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Informasi Dasar Section
            _buildSectionTitle('Informasi Dasar', Icons.info_outline_rounded),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _namaController,
                    label: 'Nama Kegiatan',
                    hint: 'Contoh: Gotong Royong RT 01',
                    icon: Icons.title_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama kegiatan harus diisi';
                      }
                      if (value.length < 5) {
                        return 'Nama kegiatan minimal 5 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    value: _selectedKategori,
                    label: 'Kategori',
                    hint: 'Pilih kategori kegiatan',
                    icon: Icons.category_rounded,
                    items: _kategoriList,
                    onChanged: (value) {
                      setState(() {
                        _selectedKategori = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _deskripsiController,
                    label: 'Deskripsi',
                    hint: 'Jelaskan detail kegiatan...',
                    icon: Icons.description_outlined,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi harus diisi';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Penanggung Jawab Section
            _buildSectionTitle('Penanggung Jawab', Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _buildCard(
              child: _buildTextField(
                controller: _penanggungJawabController,
                label: 'Nama Penanggung Jawab',
                hint: 'Contoh: Bapak Ahmad',
                icon: Icons.person_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Penanggung jawab harus diisi';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),

            // Jadwal Section
            _buildSectionTitle('Jadwal Kegiatan', Icons.schedule_rounded),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                children: [
                  _buildDateTimePicker(
                    label: 'Tanggal',
                    icon: Icons.calendar_today_rounded,
                    value: _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : null,
                    hint: 'Pilih tanggal kegiatan',
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 16),
                  _buildDateTimePicker(
                    label: 'Waktu',
                    icon: Icons.access_time_rounded,
                    value: _selectedTime != null
                        ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                        : null,
                    hint: 'Pilih waktu kegiatan',
                    onTap: () => _selectTime(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Prioritas Section
            _buildSectionTitle('Prioritas', Icons.flag_outlined),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tingkat Prioritas',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _prioritasList.map((prioritas) {
                      final isSelected = _selectedPrioritas == prioritas;
                      Color chipColor;
                      switch (prioritas) {
                        case 'Rendah':
                          chipColor = const Color(0xFF4CAF50);
                          break;
                        case 'Sedang':
                          chipColor = const Color(0xFFFFA726);
                          break;
                        case 'Tinggi':
                          chipColor = const Color(0xFFFF7043);
                          break;
                        case 'Urgent':
                          chipColor = errorRed;
                          break;
                        default:
                          chipColor = textSecondary;
                      }
                      return FilterChip(
                        label: Text(prioritas),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedPrioritas = prioritas;
                          });
                        },
                        backgroundColor: chipColor.withOpacity(0.08),
                        selectedColor: chipColor.withOpacity(0.15),
                        checkmarkColor: chipColor,
                        labelStyle: TextStyle(
                          color: isSelected ? chipColor : textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13,
                        ),
                        side: BorderSide(
                          color: isSelected ? chipColor : dividerGray,
                          width: isSelected ? 2 : 1,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      );
                    }).toList(),
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
                    color: primaryBlue.withOpacity(0.3),
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
                        Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
                        SizedBox(width: 12),
                        Text(
                          'Simpan Kegiatan',
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
            color: primaryBlue.withOpacity(0.1),
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
        border: Border.all(color: dividerGray.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
          style: const TextStyle(fontSize: 14, color: textPrimary, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: textSecondary.withOpacity(0.6)),
            prefixIcon: Icon(icon, size: 20, color: primaryBlue),
            filled: true,
            fillColor: dividerGray.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dividerGray.withOpacity(0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dividerGray.withOpacity(0.6)),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: textSecondary.withOpacity(0.6)),
            prefixIcon: Icon(icon, size: 20, color: primaryBlue),
            filled: true,
            fillColor: dividerGray.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dividerGray.withOpacity(0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dividerGray.withOpacity(0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
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
              return 'Silakan pilih kategori';
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
          color: dividerGray.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: dividerGray.withOpacity(0.6)),
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
                        color: value != null ? textPrimary : textSecondary.withOpacity(0.6),
                        fontWeight: value != null ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: textSecondary.withOpacity(0.6),
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
