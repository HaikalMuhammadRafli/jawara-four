import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../data/models/kegiatan_model.dart';
import '../../../../data/repositories/kegiatan_repository.dart';
import '../../../../data/repositories/broadcast_repository.dart';

class KegiatanFormPage extends StatefulWidget {
  const KegiatanFormPage({super.key});

  @override
  State<KegiatanFormPage> createState() => _KegiatanFormPageState();
}

class _KegiatanFormPageState extends State<KegiatanFormPage> {
  final KegiatanRepository _repository = KegiatanRepository();
  final BroadcastRepository _broadcastRepository = BroadcastRepository();
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _penanggungJawabController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _pesertaController = TextEditingController();

  String? _selectedKategori;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSubmitting = false;

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

  @override
  void dispose() {
    _namaController.dispose();
    _penanggungJawabController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    _pesertaController.dispose();
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
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.background,
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
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.background,
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

  void _submitForm() async {
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
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      if (_selectedKategori == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Silakan pilih kategori kegiatan'),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      try {
        final now = DateTime.now();
        final kegiatanDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        final kegiatan = Kegiatan(
          id: '',
          nama: _namaController.text.trim(),
          deskripsi: _deskripsiController.text.trim(),
          kategori: _selectedKategori!,
          penanggungJawab: _penanggungJawabController.text.trim(),
          lokasi: _lokasiController.text.trim(),
          peserta: int.tryParse(_pesertaController.text.trim()) ?? 0,
          tanggal: kegiatanDateTime,
          createdAt: now,
        );

        await _repository.addKegiatan(kegiatan.toMap());

        // Auto-create Broadcast
        await _broadcastRepository.addBroadcast({
          'judul': 'Kegiatan Baru: ${_namaController.text}',
          'isi':
              '${_deskripsiController.text}\n\n📍 Lokasi: ${_lokasiController.text}\n📅 Tanggal: ${kegiatanDateTime.day}/${kegiatanDateTime.month}/${kegiatanDateTime.year}\n⏰ Waktu: ${kegiatanDateTime.hour}:${kegiatanDateTime.minute.toString().padLeft(2, '0')}',
          'kategori': 'Kegiatan',
          'prioritas': 'Info',
          'pengirim': 'Admin Kegiatan',
          'tanggal': DateTime.now().toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Kegiatan berhasil ditambahkan!')),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        context.pop();
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Gagal menambahkan kegiatan: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
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
            onPressed: _isSubmitting ? null : _submitForm,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
            label: Text(
              _isSubmitting ? 'Menyimpan...' : 'Simpan',
              style: const TextStyle(
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
                      Icons.event_note_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
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
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Lengkapi informasi kegiatan di bawah ini',
                          style: TextStyle(
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
            _buildSectionTitle(
              'Penanggung Jawab',
              Icons.person_outline_rounded,
            ),
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

            // Lokasi & Peserta Section
            _buildSectionTitle('Lokasi & Peserta', Icons.location_on_outlined),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _lokasiController,
                    label: 'Lokasi',
                    hint: 'Contoh: Balai RT 01',
                    icon: Icons.place_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lokasi harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _pesertaController,
                    label: 'Jumlah Peserta',
                    hint: 'Contoh: 50',
                    icon: Icons.people_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah peserta harus diisi';
                      }
                      final peserta = int.tryParse(value);
                      if (peserta == null || peserta <= 0) {
                        return 'Jumlah peserta harus angka positif';
                      }
                      return null;
                    },
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
                color: AppColors.primary,
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
            color: AppColors.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.divider.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.divider.withValues(alpha: 0.6),
              ),
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
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
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
            color: AppColors.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.divider.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.divider.withValues(alpha: 0.6),
              ),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
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
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: AppColors.primary,
          ),
          dropdownColor: AppColors.background,
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
            color: AppColors.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: AppColors.divider.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.divider.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value ?? hint,
                      style: TextStyle(
                        fontSize: 14,
                        color: value != null
                            ? AppColors.textPrimary
                            : AppColors.textSecondary.withValues(alpha: 0.6),
                        fontWeight: value != null
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
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
