import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class FeaturePlaceholderPage extends StatelessWidget {
  final String featureName;

  const FeaturePlaceholderPage({
    super.key,
    required this.featureName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(featureName, style: const TextStyle(color: Colors.white)),
        backgroundColor: GojekPalette.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Halaman $featureName',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fitur ini akan segera hadir!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
