import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // context.go('/shop/shopDetail/10/gh6fft6c');
          },
          child: Text('Change Password Page'),
        ),
      ),
    );
  }
}