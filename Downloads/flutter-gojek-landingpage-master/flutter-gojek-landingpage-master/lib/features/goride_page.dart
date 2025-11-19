import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class GoRidePage extends StatelessWidget {
  const GoRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-RIDE', style: TextStyle(color: Colors.white)),
        backgroundColor: GojekPalette.menuRide,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Halaman Fitur GO-RIDE'),
      ),
    );
  }
}
