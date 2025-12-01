import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class GoDealsPage extends StatelessWidget {
  const GoDealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-DEALS', style: TextStyle(color: Colors.white)),
        backgroundColor: GojekPalette.menuDeals,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Halaman Fitur GO-DEALS'),
      ),
    );
  }
}
