class Pemasukan {
  final String judul;
  final String kategori;
  final String jumlah;
  final String tanggal;
  final String keterangan;

  const Pemasukan({
    required this.judul,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    required this.keterangan,
  });

  factory Pemasukan.fromMap(Map<String, String> m) => Pemasukan(
    judul: m['judul'] ?? '',
    kategori: m['kategori'] ?? '',
    jumlah: m['jumlah'] ?? '',
    tanggal: m['tanggal'] ?? '',
    keterangan: m['keterangan'] ?? '',
  );
}
