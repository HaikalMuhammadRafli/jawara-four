import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () => context.goNamed('register'),
              child: Text('Register Page'),
            ),
            ElevatedButton(
              onPressed: () => context.goNamed('dashboard'),
              child: Text('Dashboard Page'),
            ),
          ],
        ),
      ),
    );
  }
}
