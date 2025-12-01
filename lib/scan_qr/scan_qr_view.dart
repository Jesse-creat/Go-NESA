import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class ScanQrView extends StatelessWidget {
  const ScanQrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const Expanded(
            flex: 5,
            child: Center(
              child: Text(
                'Arahkan kamera ke kode QR',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          // Placeholder for the camera view with an overlay
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Expanded(
            flex: 4,
            child: Center(
              child: Text(
                'Memindai...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.black.withOpacity(0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(Icons.flash_on, 'Flash'),
                _buildIconButton(Icons.image, 'Galeri'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
