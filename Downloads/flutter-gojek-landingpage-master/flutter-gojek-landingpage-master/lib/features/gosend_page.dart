import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class GoSendPage extends StatelessWidget {
  const GoSendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-SEND', style: TextStyle(color: Colors.white)),
        backgroundColor: GojekPalette.menuSend,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Halaman Fitur GO-SEND'),
      ),
    );
  }
}
