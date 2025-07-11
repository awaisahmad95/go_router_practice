import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/home');
          },
          child: Text('NEXT'),
        ),
      ),
    );
  }
}