class Rumah {
  final String alamat;
  final String status;
  final String pemilik;

  const Rumah({
    required this.alamat,
    required this.status,
    required this.pemilik,
  });

  factory Rumah.fromMap(Map<String, String> m) => Rumah(
    alamat: m['alamat'] ?? '',
    status: m['status'] ?? '',
    pemilik: m['pemilik'] ?? '-',
  );
}

