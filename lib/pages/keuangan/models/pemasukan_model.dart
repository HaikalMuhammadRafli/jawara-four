class Pemasukan {
  final String id;
  final String judul;
  final String kategori;
  final String jumlah;
  final String tanggal;
  final String keterangan;
  final String nama;
  final String jenisPemasukan;

  const Pemasukan({
    this.id = '',
    required this.judul,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    required this.keterangan,
    required this.nama,
    required this.jenisPemasukan,
  });

  factory Pemasukan.fromMap(Map<String, dynamic> m, String id) => Pemasukan(
    id: id,
    judul: m['judul'] ?? '',
    kategori: m['kategori'] ?? '',
    jumlah: m['jumlah'] ?? '',
    tanggal: m['tanggal'] ?? '',
    keterangan: m['keterangan'] ?? '',
    nama: m['nama'] ?? '',
    jenisPemasukan: m['jenisPemasukan'] ?? '',
  );

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'kategori': kategori,
      'jumlah': jumlah,
      'tanggal': tanggal,
      'keterangan': keterangan,
      'nama': nama,
      'jenisPemasukan': jenisPemasukan,
    };
  }
}
