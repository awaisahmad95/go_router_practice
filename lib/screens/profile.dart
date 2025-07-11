import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // context.go('/shop/shopDetail/10/gh6fft6c');
            context.push('/home/profile/changePassword');
          },
          child: Text('Go to Change Password Page'),
        ),
      ),
    );
  }
}