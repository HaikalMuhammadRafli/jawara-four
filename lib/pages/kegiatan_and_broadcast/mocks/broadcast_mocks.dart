import 'package:flutter/material.dart';

import '../models/broadcast_model.dart';

const List<BroadcastItem> broadcastMock = [
  BroadcastItem(
    no: 1,
    nama: 'Pengumuman Kebersihan',
    pengirim: 'Admin RW 05',
    judul: 'Kerja Bakti Minggu Depan',
    tanggal: '11 Okt 2025',
    icon: Icons.cleaning_services,
    color: Colors.green,
  ),
  BroadcastItem(
    no: 2,
    nama: 'Peringatan Hari Santri',
    pengirim: 'Pak RT 02',
    judul: 'Akan diadakan doa bersama',
    tanggal: '14 Okt 2025',
    icon: Icons.mosque,
    color: Colors.purple,
  ),
  BroadcastItem(
    no: 3,
    nama: 'Tagihan Iuran',
    pengirim: 'Admin Keuangan',
    judul: 'Pembayaran Iuran Bulan Oktober',
    tanggal: '15 Okt 2025',
    icon: Icons.payment,
    color: Colors.orange,
  ),
];
