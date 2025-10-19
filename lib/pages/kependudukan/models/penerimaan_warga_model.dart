class PenerimaanWarga {
  final String fotoIdentitas;
  final String nama;
  final String nik;
  final String email;
  final String jenisKelamin;
  final String statusRegistrasi;

  const PenerimaanWarga({
    required this.fotoIdentitas,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    required this.statusRegistrasi,
  });

  factory PenerimaanWarga.fromMap(Map<String, String> m) => PenerimaanWarga(
    fotoIdentitas: m['fotoIdentitas'] ?? '',
    nama: m['nama'] ?? '',
    nik: m['nik'] ?? '',
    email: m['email'] ?? '',
    jenisKelamin: m['jenisKelamin'] ?? '',
    statusRegistrasi: m['statusRegistrasi'] ?? '',
  );
}
