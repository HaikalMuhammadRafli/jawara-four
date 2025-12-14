import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../data/models/broadcast_model.dart';
import '../../../../data/repositories/broadcast_repository.dart';

class BroadcastFormPage extends StatefulWidget {
  const BroadcastFormPage({super.key});

  @override
  State<BroadcastFormPage> createState() => _BroadcastFormPageState();
}

class _BroadcastFormPageState extends State<BroadcastFormPage> {
  final BroadcastRepository _repository = BroadcastRepository();
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  final _pengirimController = TextEditingController();

  String? _selectedKategori;
  String _selectedPrioritas = 'Rendah';
  bool _isSubmitting = false;

  final List<String> _kategoriList = [
    'Pengumuman',
    'Informasi',
    'Keagamaan',
    'Kebersihan',
    'Keuangan',
    'Keamanan',
    'Lainnya',
  ];

  final List<String> _prioritasList = ['Rendah', 'Sedang', 'Tinggi'];

  @override
  void dispose() {
    _namaController.dispose();
    _judulController.dispose();
    _isiController.dispose();
    _pengirimController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedKategori == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white),
                SizedBox(width: 12),
                Text('Silakan pilih kategori broadcast'),
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
        final broadcast = Broadcast(
          id: '',
          nama: _namaController.text.trim(),
          pengirim: _pengirimController.text.trim(),
          judul: _judulController.text.trim(),
          isi: _isiController.text.trim(),
          kategori: _selectedKategori!,
          prioritas: _selectedPrioritas,
          status: 'Aktif',
          tanggal: now,
          createdAt: now,
        );

        await _repository.addBroadcast(broadcast.toMap());

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Broadcast berhasil dikirim!')),
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
                  child: Text('Gagal mengirim broadcast: ${e.toString()}'),
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
          'Kirim Broadcast',
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
                : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            label: Text(
              _isSubmitting ? 'Mengirim...' : 'Kirim',
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
                      Icons.campaign_rounded,
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
                          'Broadcast Pesan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kirim pesan ke seluruh warga RT',
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

            // Informasi Pesan Section
            _buildSectionTitle('Informasi Pesan', Icons.message_outlined),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _judulController,
                    label: 'Judul Broadcast',
                    hint: 'Contoh: Pengumuman Iuran Bulan Ini',
                    icon: Icons.title_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul harus diisi';
                      }
                      if (value.length < 5) {
                        return 'Judul minimal 5 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    value: _selectedKategori,
                    label: 'Kategori',
                    hint: 'Pilih kategori broadcast',
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
                    controller: _isiController,
                    label: 'Isi Pesan',
                    hint: 'Tulis isi pesan broadcast di sini...',
                    icon: Icons.description_outlined,
                    maxLines: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi pesan harus diisi';
                      }
                      if (value.length < 20) {
                        return 'Isi pesan minimal 20 karakter';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Prioritas Section
            _buildSectionTitle('Prioritas', Icons.flag_outlined),
            const SizedBox(height: 12),
            _buildCard(
              child: _buildDropdown(
                value: _selectedPrioritas,
                label: 'Tingkat Prioritas',
                hint: 'Pilih prioritas broadcast',
                icon: Icons.flag_rounded,
                items: _prioritasList,
                onChanged: (value) {
                  setState(() {
                    _selectedPrioritas = value!;
                  });
                },
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
                        Icon(Icons.send_rounded, color: Colors.white, size: 22),
                        SizedBox(width: 12),
                        Text(
                          'Kirim Broadcast',
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
              return 'Silakan pilih $label';
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
}
