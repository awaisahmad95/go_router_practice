import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShopDetailPage extends StatelessWidget {
  const ShopDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Detail Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.pop();
          },
          child: Text('SHOP DETAIL'),
        ),
      ),
    );
  }
}