import 'package:flutter/material.dart';

class CustomPushAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? accentColor;

  const CustomPushAppbar({super.key, required this.title, this.accentColor});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 3);

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Colors.purple;

    return AppBar(
      title: Text(title),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: Container(height: 3, color: color),
      ),
    );
  }
}
