class Warga {
  final String nama;
  final String nik;
  final String jenisKelamin;

  const Warga({
    required this.nama,
    required this.nik,
    required this.jenisKelamin,
  });

  factory Warga.fromMap(Map<String, String> m) => Warga(
    nama: m['nama'] ?? '',
    nik: m['nik'] ?? '',
    jenisKelamin: m['jenisKelamin'] ?? '',
  );
}
