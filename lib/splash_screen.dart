import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gojek/auth/auth_service.dart';
import 'package:gojek/auth/auth_view.dart';
import 'package:gojek/landingpage/landingpage_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Tunggu 4 detik
    await Future.delayed(const Duration(seconds: 4));

    // Cek status login
    bool isLoggedIn = await AuthService.isLoggedIn();

    // Arahkan ke halaman yang sesuai
    if (mounted) { // Pastikan widget masih ada di tree
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? LandingPage() : AuthView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Go.png',
              width: screenWidth * 0.7,
            ),
            const SizedBox(height: 20),
            LoadingAnimationWidget.hexagonDots(
              color: const Color(0xFFFFF400),
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
