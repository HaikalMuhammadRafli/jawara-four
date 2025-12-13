import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/keluarga_model.dart';
import 'package:jawara_four/data/models/mutasi_keluarga_model.dart';
import 'package:jawara_four/data/models/warga_model.dart';
import 'package:jawara_four/data/repositories/keluarga_repository.dart';
import 'package:jawara_four/data/repositories/mutasi_keluarga_repository.dart';

class MutasiKeluargaTambahPage extends StatefulWidget {
  const MutasiKeluargaTambahPage({super.key});

  @override
  State<MutasiKeluargaTambahPage> createState() =>
      _MutasiKeluargaTambahPageState();
}

class _MutasiKeluargaTambahPageState extends State<MutasiKeluargaTambahPage> {
  final _formKey = GlobalKey<FormState>();
  final MutasiKeluargaRepository _mutasiRepository = MutasiKeluargaRepository();
  final KeluargaRepository _keluargaRepository = KeluargaRepository();
  bool _isLoading = false;

  // Controllers
  final TextEditingController _alamatTujuanController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  // State
  String? _selectedKeluargaId;
  String? _selectedWargaId;
  JenisMutasi? _selectedJenisMutasi;
  DateTime? _selectedTanggalMutasi;

  // Auto-filled data
  String _nomorKK = '';
  String _namaKepalaKeluarga = '';
  String _alamatAsal = '';
  List<Warga> _anggotaKeluarga = [];

  // Lists
  List<Keluarga> _keluargaList = [];
  bool _isLoadingKeluarga = false;

  @override
  void initState() {
    super.initState();
    _loadKeluarga();
  }

  @override
  void dispose() {
    _alamatTujuanController.dispose();
    _alasanController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _loadKeluarga() async {
    setState(() => _isLoadingKeluarga = true);
    _keluargaRepository.getKeluargaStream().listen((keluargaList) {
      if (mounted) {
        setState(() {
          _keluargaList = keluargaList;
          _isLoadingKeluarga = false;
        });
      }
    });
  }

  Future<void> _onKeluargaSelected(String? keluargaId) async {
    if (keluargaId == null) return;

    setState(() {
      _selectedKeluargaId = keluargaId;
      _selectedWargaId = null; // Reset selected warga
    });

    // Fetch keluarga details
    final keluargaDetails = await _keluargaRepository.getKeluargaWithDetails(
      keluargaId,
    );
    if (keluargaDetails != null && mounted) {
      final keluarga = keluargaDetails['keluarga'] as Keluarga;
      final kepalaKeluarga = keluargaDetails['kepalaKeluarga'] as Warga?;
      final anggota = keluargaDetails['anggota'] as List<Warga>;
      final rumah = keluargaDetails['rumah'];

      setState(() {
        _nomorKK = keluarga.nomorKK;
        _namaKepalaKeluarga = kepalaKeluarga?.nama ?? '';
        _anggotaKeluarga = anggota;
        if (rumah != null) {
          _alamatAsal = '${rumah.alamat} (RT ${rumah.rt} / RW ${rumah.rw})';
        }
      });
    }
  }

  Future<void> _selectTanggalMutasi() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTanggalMutasi ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
      if (_selectedKeluargaId == null || _selectedKeluargaId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Keluarga harus dipilih'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (_selectedWargaId == null || _selectedWargaId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Warga yang pindah harus dipilih'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (_selectedJenisMutasi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jenis mutasi harus dipilih'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (_selectedTanggalMutasi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tanggal mutasi harus dipilih'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        // Get nama warga
        final selectedWarga = _anggotaKeluarga.firstWhere(
          (w) => w.id == _selectedWargaId,
        );

        final mutasi = MutasiKeluarga(
          id: '',
          keluargaId: _selectedKeluargaId!,
          nomorKK: _nomorKK,
          namaKepalaKeluarga: _namaKepalaKeluarga,
          namaWarga: selectedWarga.nama,
          tanggal: _selectedTanggalMutasi!,
          jenisMutasi: _selectedJenisMutasi!,
          alamatAsal: _alamatAsal,
          alamatTujuan: _alamatTujuanController.text,
          alasan: _alasanController.text,
          keterangan: _keteranganController.text.isEmpty
              ? null
              : _keteranganController.text,
          createdAt: DateTime.now(),
        );

        await _mutasiRepository.create(mutasi);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mutasi keluarga berhasil ditambahkan!'),
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
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.move_to_inbox_rounded,
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
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section: Pilih Keluarga
            _buildSectionTitle(Icons.family_restroom_rounded, 'Pilih Keluarga'),
            _buildCard(
              child: _isLoadingKeluarga
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        _buildLabel('Keluarga'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedKeluargaId,
                          isExpanded: true,
                          decoration: _buildInputDecoration(
                            hint: 'Pilih keluarga',
                            icon: Icons.family_restroom_rounded,
                          ),
                          items: _keluargaList.map((keluarga) {
                            return DropdownMenuItem<String>(
                              value: keluarga.id,
                              child: Text(
                                'KK: ${keluarga.nomorKK}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: _onKeluargaSelected,
                        ),
                        if (_selectedKeluargaId != null) ...[
                          const SizedBox(height: 16),
                          _buildInfoRow('Nomor KK', _nomorKK),
                          const SizedBox(height: 8),
                          _buildInfoRow('Kepala Keluarga', _namaKepalaKeluarga),
                          const SizedBox(height: 8),
                          _buildInfoRow('Alamat Asal', _alamatAsal),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 20),

            // Section: Warga yang Pindah
            if (_selectedKeluargaId != null && _anggotaKeluarga.isNotEmpty) ...[
              _buildSectionTitle(
                Icons.person_outline_rounded,
                'Warga yang Pindah',
              ),
              _buildCard(
                child: Column(
                  children: [
                    _buildLabel('Pilih Warga'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedWargaId,
                      isExpanded: true,
                      decoration: _buildInputDecoration(
                        hint: 'Pilih warga yang pindah',
                        icon: Icons.person_outline_rounded,
                      ),
                      items: _anggotaKeluarga.map((warga) {
                        return DropdownMenuItem<String>(
                          value: warga.id,
                          child: Text(
                            '${warga.nama} - ${warga.nik}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedWargaId = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Section: Detail Mutasi
            _buildSectionTitle(Icons.info_rounded, 'Detail Mutasi'),
            _buildCard(
              child: Column(
                children: [
                  _buildLabel('Jenis Mutasi'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<JenisMutasi>(
                    initialValue: _selectedJenisMutasi,
                    isExpanded: true,
                    decoration: _buildInputDecoration(
                      hint: 'Pilih jenis mutasi',
                      icon: Icons.swap_horiz_rounded,
                    ),
                    items: JenisMutasi.values.map((jenis) {
                      return DropdownMenuItem<JenisMutasi>(
                        value: jenis,
                        child: Text(
                          jenis.value,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedJenisMutasi = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDateTimePicker(
                    label: 'Tanggal Mutasi',
                    hint: 'Pilih tanggal mutasi',
                    icon: Icons.calendar_today_rounded,
                    selectedDate: _selectedTanggalMutasi,
                    onTap: _selectTanggalMutasi,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
            const SizedBox(height: 32),

            // Submit Button
            Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Row(
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
            const SizedBox(height: 16),
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
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
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
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
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
          decoration: _buildInputDecoration(hint: hint, icon: icon),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDateTimePicker({
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
            decoration: _buildInputDecoration(hint: hint, icon: icon),
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

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
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
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
