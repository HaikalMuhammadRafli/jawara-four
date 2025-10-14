class KategoriIuran {
  final String nama;
  final String deskripsi;
  final String nominal;
  final String periode;
  final String status;
  final String warna;

  const KategoriIuran({
    required this.nama,
    required this.deskripsi,
    required this.nominal,
    required this.periode,
    required this.status,
    required this.warna,
  });

  factory KategoriIuran.fromMap(Map<String, String> m) => KategoriIuran(
    nama: m['nama'] ?? '',
    deskripsi: m['deskripsi'] ?? '',
    nominal: m['nominal'] ?? '',
    periode: m['periode'] ?? '',
    status: m['status'] ?? '',
    warna: m['warna'] ?? 'blue',
  );
}
