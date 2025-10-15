class InformasiAspirasi {
  final String pengirim;
  final String judul;
  final String tanggalDibuat;
  final String status;

  const InformasiAspirasi({
    required this.pengirim,
    required this.judul,
    required this.tanggalDibuat,
    required this.status,
  });

  factory InformasiAspirasi.fromMap(Map<String, String> m) => InformasiAspirasi(
    pengirim: m['pengirim'] ?? '',
    judul: m['judul'] ?? '',
    tanggalDibuat: m['tanggalDibuat'] ?? '',
    status: m['status'] ?? '',
  );
}