import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';
import '../../../../../data/models/tagihan_model.dart';
import '../../../../../data/repositories/tagihan_repository.dart';
import '../../../../../data/repositories/keluarga_repository.dart';
import '../../../../../data/repositories/broadcast_repository.dart';
import '../../../../../utils/number_helpers.dart';
import 'package:uuid/uuid.dart';

class IuranTagihanFormPage extends StatefulWidget {
  final Tagihan? tagihan;

  const IuranTagihanFormPage({super.key, this.tagihan});

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

  // Logic fields
  final KeluargaRepository _keluargaRepository = KeluargaRepository();
  final BroadcastRepository _broadcastRepository = BroadcastRepository();
  int _keluargaCount = 0;
  bool _useTargetCalculator = false;
  bool _isBroadcast = false;
  int _calculatedPerPerson = 0;

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
  void initState() {
    super.initState();
    _fetchKeluargaCount();

    if (widget.tagihan != null) {
      final tagihan = widget.tagihan!;
      _namaWargaController.text = tagihan.namaKeluarga;
      _noRumahController.text = tagihan.alamat;
      _nominalController.text = tagihan.total.toString();
      _selectedJenisIuran = tagihan.kategori;

      // Parse periode to get bulan and tahun
      final periodeParts = tagihan.periode.split(' ');
      if (periodeParts.length >= 2) {
        _selectedBulan = periodeParts[0];
        _selectedTahun = periodeParts[1];
      }

      _selectedJatuhTempo = tagihan.tanggal;
    }
  }

  Future<void> _fetchKeluargaCount() async {
    try {
      final snapshot = await _keluargaRepository.getKeluargaStream().first;
      if (mounted) {
        setState(() {
          _keluargaCount = snapshot.length;
        });
      }
    } catch (e) {
      debugPrint('Error fetching keluarga count: $e');
    }
  }

  void _calculateNominal() {
    if (_useTargetCalculator && _keluargaCount > 0) {
      final total = int.tryParse(_nominalController.text) ?? 0;
      setState(() {
        _calculatedPerPerson = (total / _keluargaCount).ceil();
      });
    }
  }

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
      initialDate: _selectedJatuhTempo ?? DateTime.now(),
      firstDate: DateTime(2020),
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
    if (picked != null && picked != _selectedJatuhTempo) {
      setState(() {
        _selectedJatuhTempo = picked;
      });
    }
  }

  final _repository = TagihanRepository();

  void _submitForm() async {
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
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        int finalTotal = int.tryParse(_nominalController.text) ?? 0;
        if (_useTargetCalculator) {
          finalTotal = _calculatedPerPerson;
        }

        final isEditing = widget.tagihan != null;
        final tagihan = Tagihan(
          id: isEditing ? widget.tagihan!.id : '',
          judul: _selectedJenisIuran ?? 'Iuran',
          kategori: _selectedJenisIuran ?? 'Lainnya',
          total: finalTotal,
          status: isEditing ? widget.tagihan!.status : StatusTagihan.pending,
          tanggal: _selectedJatuhTempo!,
          warga: isEditing
              ? widget.tagihan!.warga
              : (_isBroadcast ? 'broadcast' : '0'),
          kodeTagihan: isEditing
              ? widget.tagihan!.kodeTagihan
              : const Uuid().v4(),
          namaKeluarga: _isBroadcast
              ? 'Semua Warga'
              : _namaWargaController.text,
          statusKeluarga: _isBroadcast ? 'Broadcast' : 'Warga',
          periode: '$_selectedBulan $_selectedTahun',
          alamat: _isBroadcast ? '-' : _noRumahController.text,
          metodePembayaran: '-',
          bukti: '-',
          createdAt: isEditing ? widget.tagihan!.createdAt : DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (isEditing) {
          await _repository.updateTagihan(tagihan);
        } else {
          await _repository.addTagihan(tagihan);
        }

        if (_isBroadcast && !isEditing) {
          await _broadcastRepository.addBroadcast({
            'judul': 'Tagihan ${_selectedJenisIuran ?? "Iuran"}',
            'isi':
                'Mohon segera lunasi tagihan sebesar Rp ${NumberHelpers.formatCurrency(finalTotal)}',
            'kategori': 'Keuangan',
            'prioritas': 'Penting',
            'pengirim': 'Admin Keuangan',
            'tanggal': DateTime.now().toIso8601String(),
            'createdAt': DateTime.now().toIso8601String(),
          });
        }

        if (mounted) {
          // Hide loading indicator
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    isEditing
                        ? 'Data iuran berhasil diperbarui!'
                        : 'Data iuran berhasil ditambahkan!',
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

          context.pop();
        }
      } catch (e) {
        if (mounted) {
          // Hide loading indicator
          Navigator.of(context).pop();

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
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
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
                      Icons.receipt_long_rounded,
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
                          'Iuran & Tagihan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Catat iuran atau tagihan warga',
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

            // Data Warga Section
            _buildSectionTitle('Data Warga', Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                children: [
                  _buildSwitchBroadcast(),
                  if (!_isBroadcast) ...[
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _namaWargaController,
                      label: 'Nama Warga',
                      hint: 'Masukkan nama warga',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (!_isBroadcast && (value == null || value.isEmpty)) {
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
                        if (!_isBroadcast && (value == null || value.isEmpty)) {
                          return 'No. rumah harus diisi';
                        }
                        return null;
                      },
                    ),
                  ],
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
                  _buildSwitchCalculator(),
                  const SizedBox(height: 16),
                  if (_useTargetCalculator) _buildCalculationResult(),
                  _buildTextField(
                    controller: _nominalController,
                    label: _useTargetCalculator
                        ? 'Target Total (Rp)'
                        : 'Nominal (Rp)',
                    hint: _useTargetCalculator
                        ? 'Contoh: 1000000'
                        : 'Contoh: 50000',
                    icon: Icons.money_rounded,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _calculateNominal(),
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
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
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

  Widget _buildSwitchBroadcast() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buat Sebagai Pengumuman?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Iuran akan muncul di semua warga & buat broadcast',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isBroadcast,
            activeThumbColor: AppColors.info,
            onChanged: (value) {
              setState(() {
                _isBroadcast = value;
                if (_isBroadcast) {
                  _namaWargaController.text = 'Semua Warga';
                  _noRumahController.text = '-';
                } else {
                  _namaWargaController.clear();
                  _noRumahController.clear();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCalculator() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hitung dari Total Target?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Hitung iuran per keluarga otomatis',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _useTargetCalculator,
            activeThumbColor: AppColors.primary,
            onChanged: (value) {
              setState(() {
                _useTargetCalculator = value;
                _calculateNominal();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationResult() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 20, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hasil Perhitungan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${NumberHelpers.formatCurrency(_calculatedPerPerson)} / keluarga',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Dari $_keluargaCount keluarga',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
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
    TextInputType? keyboardType,
    void Function(String)? onChanged,
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
          onChanged: onChanged,
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
          isExpanded: true,
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
