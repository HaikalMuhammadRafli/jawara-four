import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../../data/models/keluarga_model.dart';
import '../../../../../data/models/rumah_model.dart';
import '../../../../../data/models/warga_model.dart';
import '../../../../../data/repositories/keluarga_repository.dart';
import '../../../../../data/repositories/rumah_repository.dart';
import '../../../../../data/repositories/warga_repository.dart';

class KeluargaFormPage extends StatefulWidget {
  final Keluarga? keluarga;

  const KeluargaFormPage({super.key, this.keluarga});

  @override
  State<KeluargaFormPage> createState() => _KeluargaFormPageState();
}

class _KeluargaFormPageState extends State<KeluargaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final KeluargaRepository _keluargaRepository = KeluargaRepository();
  final WargaRepository _wargaRepository = WargaRepository();
  final RumahRepository _rumahRepository = RumahRepository();
  bool _isLoading = false;

  // Controllers
  final TextEditingController _nomorKKController = TextEditingController();

  // State
  String? _selectedKepalaKeluargaId;
  List<String> _selectedAnggotaIds = [];
  String? _selectedRumahId;

  List<Warga> _wargaList = [];
  List<Rumah> _rumahList = [];
  bool _isLoadingWarga = false;
  bool _isLoadingRumah = false;

  @override
  void initState() {
    super.initState();
    _loadWarga();
    _loadRumah();

    if (widget.keluarga != null) {
      _nomorKKController.text = widget.keluarga!.nomorKK;
      _selectedKepalaKeluargaId = widget.keluarga!.kepalaKeluargaId;
      _selectedAnggotaIds = List.from(widget.keluarga!.anggotaIds);
      _selectedRumahId = widget.keluarga!.rumahId;
    }
  }

  @override
  void dispose() {
    _nomorKKController.dispose();
    super.dispose();
  }

  Future<void> _loadWarga() async {
    setState(() => _isLoadingWarga = true);
    _wargaRepository.getWargaStream().listen((wargaList) {
      if (mounted) {
        setState(() {
          _wargaList = wargaList;
          _isLoadingWarga = false;
        });
      }
    });
  }

  Future<void> _loadRumah() async {
    setState(() => _isLoadingRumah = true);
    // Load only available (kosong) rumah for new keluarga, or all rumah for edit
    if (widget.keluarga == null) {
      _rumahRepository.getRumahKosong().listen((rumahList) {
        if (mounted) {
          setState(() {
            _rumahList = rumahList;
            _isLoadingRumah = false;
          });
        }
      });
    } else {
      _rumahRepository.getRumahStream().listen((rumahList) {
        if (mounted) {
          setState(() {
            _rumahList = rumahList;
            _isLoadingRumah = false;
          });
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedKepalaKeluargaId == null ||
          _selectedKepalaKeluargaId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kepala keluarga harus dipilih'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (_selectedAnggotaIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Minimal satu anggota keluarga harus dipilih'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (!_selectedAnggotaIds.contains(_selectedKepalaKeluargaId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Kepala keluarga harus termasuk dalam anggota keluarga',
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (_selectedRumahId == null || _selectedRumahId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rumah harus dipilih'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final keluarga = Keluarga(
          id: widget.keluarga?.id ?? '',
          nomorKK: _nomorKKController.text,
          kepalaKeluargaId: _selectedKepalaKeluargaId!,
          anggotaIds: _selectedAnggotaIds,
          rumahId: _selectedRumahId!,
          createdAt: widget.keluarga?.createdAt ?? DateTime.now(),
          updatedAt: widget.keluarga != null ? DateTime.now() : null,
        );

        if (widget.keluarga == null) {
          await _keluargaRepository.addKeluarga(keluarga);
        } else {
          await _keluargaRepository.updateKeluarga(keluarga);
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.keluarga == null
                  ? 'Data keluarga berhasil ditambahkan!'
                  : 'Data keluarga berhasil diupdate!',
            ),
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
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
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
                      Icons.family_restroom_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.keluarga == null
                              ? 'Tambah Keluarga'
                              : 'Edit Keluarga',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.keluarga == null
                              ? 'Lengkapi data keluarga baru'
                              : 'Update data keluarga',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Nomor KK Section
            _buildSectionTitle('Nomor Kartu Keluarga', Icons.badge_rounded),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Nomor KK'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nomorKKController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Masukkan 16 digit nomor KK',
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.divider.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor KK wajib diisi';
                      }
                      if (value.length != 16) {
                        return 'Nomor KK harus 16 digit';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Kepala Keluarga Section
            _buildSectionTitle('Kepala Keluarga', Icons.person_rounded),
            _buildCard(
              child: _isLoadingWarga
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildLabel('Pilih Kepala Keluarga'),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.refresh, size: 20),
                              color: AppColors.primary,
                              onPressed: _loadWarga,
                              tooltip: 'Refresh list warga',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedKepalaKeluargaId,
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'Pilih kepala keluarga',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.primary.withValues(alpha: 0.6),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundGray,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.divider.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.error,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          items: _wargaList.map((warga) {
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
                              _selectedKepalaKeluargaId = value;
                              // Auto-add kepala keluarga to anggota if not already added
                              if (value != null &&
                                  !_selectedAnggotaIds.contains(value)) {
                                _selectedAnggotaIds.add(value);
                              }
                            });
                          },
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),

            // Anggota Keluarga Section
            _buildSectionTitle('Anggota Keluarga', Icons.groups_rounded),
            _buildCard(
              child: _isLoadingWarga
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildLabel('Pilih Anggota Keluarga'),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_selectedAnggotaIds.length} anggota',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 300),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.divider.withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _wargaList.length,
                            itemBuilder: (context, index) {
                              final warga = _wargaList[index];
                              final isSelected = _selectedAnggotaIds.contains(
                                warga.id,
                              );
                              return CheckboxListTile(
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedAnggotaIds.add(warga.id);
                                    } else {
                                      _selectedAnggotaIds.remove(warga.id);
                                    }
                                  });
                                },
                                title: Text(warga.nama),
                                subtitle: Text('NIK: ${warga.nik}'),
                                activeColor: AppColors.primary,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),

            // Rumah Section
            _buildSectionTitle('Rumah', Icons.home_rounded),
            _buildCard(
              child: _isLoadingRumah
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildLabel('Pilih Rumah'),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.refresh, size: 20),
                              color: AppColors.primary,
                              onPressed: _loadRumah,
                              tooltip: 'Refresh list rumah',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedRumahId,
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'Pilih rumah yang ditinggali',
                            prefixIcon: Icon(
                              Icons.home_outlined,
                              color: AppColors.primary.withValues(alpha: 0.6),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundGray,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.divider.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.error,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          items: _rumahList.map((rumah) {
                            return DropdownMenuItem<String>(
                              value: rumah.id,
                              child: Text(
                                '${rumah.alamat} (RT ${rumah.rt} / RW ${rumah.rw})',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRumahId = value;
                            });
                          },
                        ),
                        if (_rumahList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              widget.keluarga == null
                                  ? 'Tidak ada rumah kosong yang tersedia. Buat rumah terlebih dahulu.'
                                  : 'Tidak ada rumah yang tersedia.',
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.save, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            widget.keluarga == null
                                ? 'Simpan Keluarga'
                                : 'Update Keluarga',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
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
      ),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
