import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart'; // ⬅️ penting! supaya bisa diarahkan ke LoginPage
import 'widgets/animated_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showCredit = false;
  @override
  void initState() {
    super.initState();

    // Setelah 4 detik pindah ke LoginPage
    // show credit after short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _showCredit = true);
    });

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/1213.png', // Logo (tidak berputar)
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Manajemen Stok Gudang",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(height: 12),
                  const SpinKitFadingCircle(color: Colors.white, size: 32.0),
                ],
              ),
            ),
            // small transparent credit at the bottom center
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  opacity: _showCredit ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    "APK by Dewa Nazwa Marna Putra",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withAlpha((0.6 * 255).round()),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
