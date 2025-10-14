class Tagihan {
  final String judul;
  final String kategori;
  final String total;
  final String status;
  final String tanggal;
  final String warga;

  const Tagihan({
    required this.judul,
    required this.kategori,
    required this.total,
    required this.status,
    required this.tanggal,
    required this.warga,
  });

  factory Tagihan.fromMap(Map<String, String> m) => Tagihan(
    judul: m['judul'] ?? '',
    kategori: m['kategori'] ?? '',
    total: m['total'] ?? '',
    status: m['status'] ?? '',
    tanggal: m['tanggal'] ?? '',
    warga: m['warga'] ?? '0',
  );
}
