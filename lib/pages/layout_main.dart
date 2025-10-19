import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/widgets/custom_bottom_navigationbar.dart';
import 'package:jawara_four/widgets/custom_main_appbar.dart';

class LayoutMain extends StatefulWidget {
  final GoRouterState state;
  final Widget child;
  const LayoutMain({super.key, required this.state, required this.child});

  @override
  State<LayoutMain> createState() => _LayoutMainState();
}

class _LayoutMainState extends State<LayoutMain> {
  String _getTitle() {
    final routeName = widget.state.name;
    switch (routeName) {
      case 'dashboard':
        return 'Dashboard';
      case 'keuangan':
        return 'Keuangan';
      case 'kependudukan':
        return 'Kependudukan';
      case 'kegiatan':
        return 'Kegiatan';
      default:
        return 'Jawara';
    }
  }

  Color _getAccentColor() {
    final routeName = widget.state.name;
    switch (routeName) {
      case 'dashboard':
        return Colors.purple;
      case 'keuangan':
        return Colors.green;
      case 'kependudukan':
        return Colors.purple;
      case 'kegiatan':
        return Colors.purple;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomMainAppbar(title: _getTitle(), accentColor: _getAccentColor()),
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigationbar(),
    );
  }
}
