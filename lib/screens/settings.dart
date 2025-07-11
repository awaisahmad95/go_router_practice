import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // context.go('/shop/shopDetail/10/gh6fft6c');
          },
          child: Text('Go to ---'),
        ),
      ),
    );
  }
}