import 'package:flutter/material.dart';

import 'splash.dart'; // ⬅️ ambil SplashScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manajemen Stok Gudang',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // ⬅️ mulai dari Splash
    );
  }
}
