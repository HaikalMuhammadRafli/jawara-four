import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomScaffold extends StatefulWidget {
  final GoRouterState state;
  final Widget child;
  final PreferredSizeWidget appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  const CustomScaffold({
    super.key,
    required this.state,
    required this.child,
    required this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.appBar,
      body: widget.child,
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
