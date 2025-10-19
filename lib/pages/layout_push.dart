import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/widgets/custom_push_appbar.dart';

class LayoutPush extends StatefulWidget {
  final GoRouterState state;
  final Widget child;
  const LayoutPush({super.key, required this.state, required this.child});

  @override
  State<LayoutPush> createState() => _LayoutPushState();
}

class _LayoutPushState extends State<LayoutPush> {
  // Map route names to titles and colors
  String _getTitle() {
    final routeName = widget.state.name;
    switch (routeName) {
      // Keuangan routes
      case 'keuangan-iuran-tagihan':
        return 'Iuran dan Tagihan';
      case 'keuangan-pemasukan-lain':
        return 'Pemasukan Lain';
      case 'keuangan-kategori-iuran':
        return 'Kategori Iuran';
      case 'keuangan-pengeluaran':
        return 'Pengeluaran';
      case 'keuangan-laporan':
        return 'Laporan Keuangan';

      // Kependudukan routes
      case 'kependudukan-warga':
        return 'Data Warga';
      case 'kependudukan-keluarga':
        return 'Data Keluarga';
      case 'kependudukan-rumah':
        return 'Data Rumah';
      case 'kependudukan-tambah':
        return 'Tambah Data';
      case 'informasi-aspirasi':
        return 'Informasi & Aspirasi';
      case 'penerimaan-warga':
        return 'Penerimaan Warga';
      case 'mutasi-keluarga':
        return 'Mutasi Keluarga';
      case 'mutasi-keluarga-tambah':
        return 'Tambah Mutasi Keluarga';

      // Kegiatan routes
      case 'broadcast':
        return 'Broadcast';

      // Lainnya routes
      case 'log-aktifitas':
        return 'Log Aktifitas';
      case 'daftar-pengguna':
        return 'Pengguna';

      default:
        return 'Detail';
    }
  }

  Color _getAccentColor() {
    final routeName = widget.state.name;
    if (routeName?.startsWith('keuangan') == true) {
      return Colors.green;
    } else if (routeName?.startsWith('kependudukan') == true ||
        routeName == 'informasi-aspirasi' ||
        routeName == 'penerimaan-warga' ||
        routeName == 'mutasi-keluarga' ||
        routeName == 'mutasi-keluarga-tambah') {
      return Colors.purple;
    } else if (routeName == 'broadcast') {
      return Colors.purple;
    } else {
      return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomPushAppbar(title: _getTitle(), accentColor: _getAccentColor()),
      body: widget.child,
    );
  }
}
