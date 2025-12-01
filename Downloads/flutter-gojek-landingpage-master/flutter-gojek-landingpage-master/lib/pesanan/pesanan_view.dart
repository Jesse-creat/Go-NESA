import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class PesananPage extends StatelessWidget {
  const PesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: GojekPalette.green,
          title: const Text('Pesanan', style: TextStyle(color: Colors.white)),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Dalam Proses'),
              Tab(text: 'Riwayat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDalamProses(),
            _buildRiwayat(),
          ],
        ),
      ),
    );
  }

  Widget _buildDalamProses() {
    // Placeholder for active orders
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('Tidak ada pesanan aktif', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRiwayat() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildRiwayatItem(
          icon: Icons.restaurant,
          service: 'GO-FOOD',
          title: 'Geprek Bensu',
          date: '17 Agu 2024, 12:30',
          status: 'Selesai',
          statusColor: GojekPalette.green,
        ),
        _buildRiwayatItem(
          icon: Icons.directions_bike,
          service: 'GO-RIDE',
          title: 'Jl. Sudirman -> Jl. Thamrin',
          date: '16 Agu 2024, 08:00',
          status: 'Selesai',
          statusColor: GojekPalette.green,
        ),
        _buildRiwayatItem(
          icon: Icons.local_car_wash,
          service: 'GO-CAR',
          title: 'Blok M -> Pondok Indah Mall',
          date: '15 Agu 2024, 19:15',
          status: 'Dibatalkan',
          statusColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildRiwayatItem({
    required IconData icon,
    required String service,
    required String title,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: GojekPalette.green, size: 20),
                const SizedBox(width: 8),
                Text(service, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: GojekPalette.green),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Beri Penilaian', style: TextStyle(color: GojekPalette.green)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GojekPalette.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Pesan Lagi', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
