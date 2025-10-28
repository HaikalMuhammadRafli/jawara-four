class Tagihan {
  final String judul;
  final String kategori;
  final String total;
  final String status;
  final String tanggal;
  final String warga;
  final String kodeTagihan;
  final String namaKeluarga;
  final String statusKeluarga;
  final String periode;
  final String alamat;
  final String metodePembayaran;
  final String bukti;

  const Tagihan({
    required this.judul,
    required this.kategori,
    required this.total,
    required this.status,
    required this.tanggal,
    required this.warga,
    required this.kodeTagihan,
    required this.namaKeluarga,
    required this.statusKeluarga,
    required this.periode,
    required this.alamat,
    required this.metodePembayaran,
    required this.bukti,
  });

  factory Tagihan.fromMap(Map<String, String> m) => Tagihan(
    judul: m['judul'] ?? '',
    kategori: m['kategori'] ?? '',
    total: m['total'] ?? '',
    status: m['status'] ?? '',
    tanggal: m['tanggal'] ?? '',
    warga: m['warga'] ?? '0',
    kodeTagihan: m['kodeTagihan'] ?? '',
    namaKeluarga: m['namaKeluarga'] ?? '',
    statusKeluarga: m['statusKeluarga'] ?? '',
    periode: m['periode'] ?? '',
    alamat: m['alamat'] ?? '',
    metodePembayaran: m['metodePembayaran'] ?? '',
    bukti: m['bukti'] ?? '',
  );
}

