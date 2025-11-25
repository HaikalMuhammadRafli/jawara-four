class KategoriIuran {
  final String id;
  final String nama;
  final String deskripsi;
  final String nominal;
  final String periode;
  final String status;
  final String warna;

  const KategoriIuran({
    this.id = '',
    required this.nama,
    required this.deskripsi,
    required this.nominal,
    required this.periode,
    required this.status,
    required this.warna,
  });

  factory KategoriIuran.fromMap(Map<String, dynamic> m, String id) =>
      KategoriIuran(
        id: id,
        nama: m['nama'] ?? '',
        deskripsi: m['deskripsi'] ?? '',
        nominal: m['nominal'] ?? '',
        periode: m['periode'] ?? '',
        status: m['status'] ?? '',
        warna: m['warna'] ?? 'blue',
      );

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'nominal': nominal,
      'periode': periode,
      'status': status,
      'warna': warna,
    };
  }
}
