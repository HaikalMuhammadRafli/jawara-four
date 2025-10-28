class Pengeluaran {
  final String nama;
  final String jenis;
  final String nominal;
  final String tanggal;

  const Pengeluaran({
    required this.nama,
    required this.jenis,
    required this.nominal,
    required this.tanggal,
  });

  factory Pengeluaran.fromMap(Map<String, String> m) => Pengeluaran(
    nama: m['nama'] ?? '',
    jenis: m['jenis'] ?? '',
    nominal: m['nominal'] ?? '',
    tanggal: m['tanggal'] ?? '',
  );
}

