import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/splash_screen.dart';

void main() {
  // Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoNesa',
      theme: ThemeData(
        fontFamily: 'NeoSans',
        primaryColor: GoNesaPalette.menuRide,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: GoNesaPalette.menuRide),
      ),
      home: const SplashScreen(), // Mulai dari SplashScreen
    );
  }
}
