import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class GoPulsaPage extends StatelessWidget {
  const GoPulsaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-PULSA', style: TextStyle(color: Colors.white)),
        backgroundColor: GojekPalette.menuPulsa,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Halaman Fitur GO-PULSA'),
      ),
    );
  }
}
