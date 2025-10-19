class LogEntry {
  final String deskripsi;
  final String aktor;
  final String tanggal;

  const LogEntry({required this.deskripsi, required this.aktor, required this.tanggal});

  factory LogEntry.fromMap(Map<String, String> m) => LogEntry(
    deskripsi: m['deskripsi'] ?? '',
    aktor: m['aktor'] ?? '',
    tanggal: m['tanggal'] ?? '',
  );
}
