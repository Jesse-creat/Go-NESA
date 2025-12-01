import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class GoFoodPage extends StatelessWidget {
  const GoFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-FOOD', style: TextStyle(color: Colors.white)),
        backgroundColor: GojekPalette.menuFood,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Halaman Fitur GO-FOOD'),
      ),
    );
  }
}
