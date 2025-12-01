import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class GoBluebirdPage extends StatelessWidget {
  const GoBluebirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-BLUEBIRD', style: TextStyle(color: Colors.white)),
        backgroundColor: GojekPalette.menuBluebird,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Halaman Fitur GO-BLUEBIRD'),
      ),
    );
  }
}
