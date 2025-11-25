class Tagihan {
  final String id;
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
    this.id = '',
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

  factory Tagihan.fromMap(Map<String, dynamic> m, String id) => Tagihan(
    id: id,
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

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'kategori': kategori,
      'total': total,
      'status': status,
      'tanggal': tanggal,
      'warga': warga,
      'kodeTagihan': kodeTagihan,
      'namaKeluarga': namaKeluarga,
      'statusKeluarga': statusKeluarga,
      'periode': periode,
      'alamat': alamat,
      'metodePembayaran': metodePembayaran,
      'bukti': bukti,
    };
  }
}

