import '../models/broadcast_model.dart';

final List<Broadcast> broadcastMock = [
  Broadcast(
    id: '1',
    nama: 'Pengumuman Kebersihan',
    pengirim: 'Admin RW 05',
    judul: 'Kerja Bakti Minggu Depan',
    isi: 'Kepada seluruh warga, dihimbau untuk mengikuti kegiatan kerja bakti yang akan dilaksanakan hari Minggu depan pukul 07.00 WIB. Mohon membawa peralatan kebersihan masing-masing. Terima kasih atas partisipasinya.',
    kategori: 'Kebersihan',
    prioritas: 'Tinggi',
    tanggal: DateTime(2025, 10, 11),
    createdAt: DateTime(2025, 10, 11),
  ),
  Broadcast(
    id: '2',
    nama: 'Peringatan Hari Santri',
    pengirim: 'Pak RT 02',
    judul: 'Akan diadakan doa bersama',
    isi: 'Dalam rangka memperingati Hari Santri Nasional, akan diadakan doa bersama dan tahlilan di musholla lingkungan. Acara dimulai pukul 19.30 WIB. Warga diharapkan dapat hadir.',
    kategori: 'Keagamaan',
    prioritas: 'Normal',
    tanggal: DateTime(2025, 10, 14),
    createdAt: DateTime(2025, 10, 14),
  ),
  Broadcast(
    id: '3',
    nama: 'Tagihan Iuran',
    pengirim: 'Admin Keuangan',
    judul: 'Pembayaran Iuran Bulan Oktober',
    isi: 'Pengingat kepada seluruh warga untuk segera melakukan pembayaran iuran bulanan. Pembayaran dapat dilakukan melalui bendahara RT atau transfer ke rekening yang telah ditentukan. Batas pembayaran tanggal 20 Oktober.',
    kategori: 'Keuangan',
    prioritas: 'Tinggi',
    tanggal: DateTime(2025, 10, 15),
    createdAt: DateTime(2025, 10, 15),
  ),
];
