import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/shop/shopDetail/10/gh6fft6c');
          },
          child: Text('SHOP'),
        ),
      ),
    );
  }
}