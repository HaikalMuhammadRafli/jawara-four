import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/aspirasi_model.dart';
import 'package:jawara_four/data/repositories/aspirasi_repository.dart';

class AspirasiEditPage extends StatefulWidget {
  final Aspirasi aspirasi;

  const AspirasiEditPage({super.key, required this.aspirasi});

  @override
  State<AspirasiEditPage> createState() => _AspirasiEditPageState();
}

class _AspirasiEditPageState extends State<AspirasiEditPage> {
  final _formKey = GlobalKey<FormState>();
  final AspirasiRepository _repository = AspirasiRepository();

  late TextEditingController _judulController;
  late TextEditingController _pengirimController;
  late TextEditingController _isiController;
  late TextEditingController _kontakController;

  late String _selectedKategori;
  late StatusAspirasi _selectedStatus;
  late bool _isAnonim;

  bool _isUpdating = false;

  final List<String> _kategoriOptions = [
    'Aspirasi',
    'Keluhan',
    'Saran',
    'Pengaduan',
    'Informasi',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.aspirasi.judul);
    _pengirimController = TextEditingController(text: widget.aspirasi.pengirim);
    _isiController = TextEditingController(text: widget.aspirasi.isi);
    _kontakController = TextEditingController(text: widget.aspirasi.kontak);
    _selectedKategori = widget.aspirasi.kategori;
    _selectedStatus = widget.aspirasi.status;
    _isAnonim = widget.aspirasi.isAnonim;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _pengirimController.dispose();
    _isiController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  Future<void> _updateAspirasi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdating = true);

    try {
      final updatedData = {
        'judul': _judulController.text.trim(),
        'pengirim': _pengirimController.text.trim(),
        'isi': _isiController.text.trim(),
        'kontak': _kontakController.text.trim(),
        'kategori': _selectedKategori,
        'status': _selectedStatus.value,
        'isAnonim': _isAnonim,
      };

      await _repository.updateAspirasi(widget.aspirasi.id, updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Text('Aspirasi berhasil diperbarui'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Gagal memperbarui aspirasi: $e')),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_rounded, color: AppColors.primary, size: 20),
          ),
        ),
        title: const Text(
          'Edit Aspirasi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Informasi Dasar', Icons.info_outline_rounded),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _judulController,
                    label: 'Judul',
                    hint: 'Masukkan judul aspirasi',
                    icon: Icons.title_rounded,
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Judul harus diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _pengirimController,
                    label: 'Pengirim',
                    hint: 'Masukkan nama pengirim',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Pengirim harus diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _kontakController,
                    label: 'Kontak',
                    hint: 'Masukkan nomor kontak',
                    icon: Icons.phone_outlined,
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Kontak harus diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Kategori',
                    value: _selectedKategori,
                    items: _kategoriOptions,
                    icon: Icons.category_outlined,
                    onChanged: (v) => setState(() => _selectedKategori = v!),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Status',
                    value: _selectedStatus.value,
                    items: StatusAspirasi.values.map((e) => e.value).toList(),
                    icon: Icons.flag_outlined,
                    onChanged: (v) =>
                        setState(() => _selectedStatus = StatusAspirasi.fromString(v!)),
                  ),
                  const SizedBox(height: 16),
                  _buildAnonimSwitch(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Isi Aspirasi', Icons.article_outlined),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _isiController,
                    label: 'Isi',
                    hint: 'Tulis isi aspirasi...',
                    icon: Icons.description_outlined,
                    maxLines: 6,
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Isi harus diisi' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isUpdating ? null : _updateAspirasi,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _isUpdating
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_rounded, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.6), width: 1.5),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.primary.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            filled: true,
            fillColor: AppColors.divider.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.error, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            filled: true,
            fillColor: AppColors.divider.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          dropdownColor: AppColors.background,
        ),
      ],
    );
  }

  Widget _buildAnonimSwitch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.divider.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.softPurple.withValues(alpha: 0.15),
                  AppColors.softPurple.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.visibility_off_outlined, color: AppColors.softPurple, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anonim',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Sembunyikan identitas pengirim',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: _isAnonim,
            onChanged: (v) => setState(() => _isAnonim = v),
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
