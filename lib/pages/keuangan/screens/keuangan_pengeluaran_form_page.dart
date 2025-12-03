import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/pengeluaran_model.dart';
import 'package:jawara_four/data/repositories/pengeluaran_repository.dart';

class KeuanganPengeluaranFormPage extends StatefulWidget {
  final Pengeluaran? pengeluaran;
  
  const KeuanganPengeluaranFormPage({super.key, this.pengeluaran});

  @override
  State<KeuanganPengeluaranFormPage> createState() =>
      _KeuanganPengeluaranFormPageState();
}

class _KeuanganPengeluaranFormPageState
    extends State<KeuanganPengeluaranFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _nominalController = TextEditingController();
  final _penerimaPembayaranController = TextEditingController();
  final _keteranganController = TextEditingController();
  final _repository = PengeluaranRepository();

  String? _selectedKategori;
  DateTime? _selectedTanggal;
  String? _selectedMetodePembayaran;

  final List<String> _kategoriList = [
    'Operasional',
    'Pemeliharaan',
    'Listrik',
    'Air',
    'Kebersihan',
    'Keamanan',
    'Acara',
    'Renovasi',
    'Administrasi',
    'Lainnya',
  ];

  final List<String> _metodePembayaranList = [
    'Tunai',
    'Transfer Bank',
    'E-Wallet',
    'Cek',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.pengeluaran != null) {
      _judulController.text = widget.pengeluaran!.nama;
      _nominalController.text = widget.pengeluaran!.nominal.toString();
      _selectedKategori = widget.pengeluaran!.jenis;
      _selectedTanggal = widget.pengeluaran!.tanggal;
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _nominalController.dispose();
    _penerimaPembayaranController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.error,
              onPrimary: Colors.white,
              surface: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTanggal) {
      setState(() {
        _selectedTanggal = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTanggal == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Silakan pilih tanggal pengeluaran'),
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
                Text('Silakan pilih kategori pengeluaran'),
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

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        final pengeluaran = Pengeluaran(
          id: widget.pengeluaran?.id ?? '',
          nama: _judulController.text.trim(),
          jenis: _selectedKategori!,
          nominal: int.parse(_nominalController.text.trim()),
          tanggal: _selectedTanggal!,
          createdAt: widget.pengeluaran?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (widget.pengeluaran != null) {
          await _repository.updatePengeluaran(pengeluaran);
        } else {
          await _repository.addPengeluaran(pengeluaran);
        }

        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    widget.pengeluaran != null
                        ? 'Pengeluaran berhasil diperbarui!'
                        : 'Pengeluaran berhasil ditambahkan!',
                  ),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Gagal menyimpan: $e')),
                ],
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.error,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.pengeluaran != null ? 'Edit Pengeluaran' : 'Tambah Pengeluaran',
          style: const TextStyle(
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
                  colors: [AppColors.error, AppColors.error.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.3),
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
                      Icons.trending_down_rounded,
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
                          'Pengeluaran',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Catat semua pengeluaran kas RT',
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

            // Informasi Pengeluaran Section
            _buildSectionTitle(
              'Informasi Pengeluaran',
              Icons.info_outline_rounded,
            ),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _judulController,
                    label: 'Judul Pengeluaran',
                    hint: 'Contoh: Bayar Listrik Bulan Januari',
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
                    hint: 'Pilih kategori pengeluaran',
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
                    controller: _nominalController,
                    label: 'Nominal (Rp)',
                    hint: 'Contoh: 500000',
                    icon: Icons.attach_money_rounded,
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
                    label: 'Tanggal Pengeluaran',
                    icon: Icons.event_rounded,
                    value: _selectedTanggal != null
                        ? '${_selectedTanggal!.day}/${_selectedTanggal!.month}/${_selectedTanggal!.year}'
                        : null,
                    hint: 'Pilih tanggal pengeluaran',
                    onTap: () => _selectDate(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Detail Pembayaran Section
            _buildSectionTitle('Detail Pembayaran', Icons.payment_rounded),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                children: [
                  _buildDropdown(
                    value: _selectedMetodePembayaran,
                    label: 'Metode Pembayaran',
                    hint: 'Pilih metode pembayaran',
                    icon: Icons.account_balance_wallet_rounded,
                    items: _metodePembayaranList,
                    onChanged: (value) {
                      setState(() {
                        _selectedMetodePembayaran = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _penerimaPembayaranController,
                    label: 'Penerima Pembayaran',
                    hint: 'Contoh: PT. PLN atau Nama Vendor',
                    icon: Icons.business_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Penerima pembayaran harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _keteranganController,
                    label: 'Keterangan',
                    hint: 'Jelaskan detail pengeluaran...',
                    icon: Icons.description_outlined,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Keterangan harus diisi';
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
                gradient: LinearGradient(
                  colors: [AppColors.error, AppColors.error.withValues(alpha: 0.8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.3),
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
                          Icons.add_circle_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Tambah Pengeluaran',
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
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.error),
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
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.6), width: 1.5),
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
            color: AppColors.textPrimary,
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
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(icon, size: 20, color: AppColors.error),
            filled: true,
            fillColor: AppColors.divider.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
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
            prefixIcon: Icon(icon, size: 20, color: AppColors.error),
            filled: true,
            fillColor: AppColors.divider.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
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
          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.error),
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
                border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: AppColors.error),
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

