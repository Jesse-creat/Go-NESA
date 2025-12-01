import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class GoCarPage extends StatelessWidget {
  const GoCarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-CAR', style: TextStyle(color: Colors.white)),
        backgroundColor: GojekPalette.menuCar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Halaman Fitur GO-CAR'),
      ),
    );
  }
}
