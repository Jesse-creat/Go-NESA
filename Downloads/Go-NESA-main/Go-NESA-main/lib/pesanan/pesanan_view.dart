import 'package:flutter/material.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:intl/intl.dart';

class PesananView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pesanan'),
        backgroundColor: Colors.yellow,
      ),
      body: OrderData.history.isEmpty
          ? Center(
              child: Text(
                'Belum ada pesanan.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: OrderData.history.length,
              itemBuilder: (context, index) {
                final order = OrderData.history[index];
                
                // Widget khusus untuk subtitle berdasarkan jenis pesanan
                Widget subtitle;
                if (order.serviceName == 'ISI SALDO') {
                  subtitle = Text(
                    'Top up ke ${order.to}',
                    style: TextStyle(color: Colors.grey[600]),
                  );
                } else {
                  subtitle = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dari: ${order.from}'),
                      Text('Ke: ${order.to}'),
                    ],
                  );
                }

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(order.serviceIcon, color: Colors.green, size: 40),
                    title: Text(
                      order.serviceName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subtitle,
                        SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(order.orderTime),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Text(
                      order.price,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 16,
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
