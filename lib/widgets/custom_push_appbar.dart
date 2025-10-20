import 'package:flutter/material.dart';

class CustomPushAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomPushAppbar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(title),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
    );
  }
}
