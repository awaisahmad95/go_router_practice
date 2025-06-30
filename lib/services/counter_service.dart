import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton // Only create this when needed
class CounterService {
  int _count = 0;

  void increment() {
    _count++;
    debugPrint("Count is now: $_count");
  }

  @disposeMethod
  void dispose(){
    // logic to dispose instance
  }
}