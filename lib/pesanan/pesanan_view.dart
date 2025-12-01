import 'package:flutter/material.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:intl/intl.dart';

class PesananView extends StatelessWidget {
  const PesananView({super.key});

  // Helper untuk mendapatkan ikon berdasarkan nama layanan
  IconData _getIconForService(String serviceName) {
    switch (serviceName) {
      case 'GO-FOOD':
        return Icons.restaurant;
      case 'GO-RIDE':
        return Icons.directions_bike;
      case 'GO-CAR':
        return Icons.local_car_wash;
      case 'ISI SALDO':
        return Icons.account_balance_wallet;
      default:
        return Icons.receipt_long;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: OrderData.history.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat pesanan.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: OrderData.history.length,
              itemBuilder: (context, index) {
                final order = OrderData.history[index];

                Widget subtitleWidget;
                // Tentukan subtitle berdasarkan jenis pesanan
                if (order.serviceName == 'GO-FOOD') {
                  subtitleWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Tampilkan item pertama sebagai ringkasan
                        order.items?.isNotEmpty ?? false
                            ? '${order.items!.first.meal.name}${order.items!.length > 1 ? ' dan lainnya' : ''}'
                            : 'Pesanan makanan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dibayar dengan ${order.paymentMethod}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  );
                } else {
                  // Untuk GO-RIDE, GO-CAR, dll.
                  subtitleWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dari: ${order.from ?? '-'}'),
                      Text('Ke: ${order.to ?? '-'}'),
                    ],
                  );
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      _getIconForService(order.serviceName),
                      color: Colors.green,
                      size: 40,
                    ),
                    title: Text(
                      order.serviceName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subtitleWidget,
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(order.orderTime),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Text(
                      currencyFormatter.format(order.totalPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
