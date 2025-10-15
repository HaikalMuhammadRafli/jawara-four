class Keluarga {
  final String kepalaKeluarga;
  final String alamat;
  final String jumlahAnggota;

  const Keluarga({required this.kepalaKeluarga, required this.alamat, required this.jumlahAnggota});

  factory Keluarga.fromMap(Map<String, String> m) => Keluarga(
    kepalaKeluarga: m['kepalaKeluarga'] ?? '',
    alamat: m['alamat'] ?? '',
    jumlahAnggota: m['jumlahAnggota'] ?? '0',
  );
}
