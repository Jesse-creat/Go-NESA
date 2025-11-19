import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:gojek/pesanan/pesanan_view.dart';

class GodealsView extends StatefulWidget {
  const GodealsView({super.key});

  @override
  State<GodealsView> createState() => _GodealsViewState();
}

class _GodealsViewState extends State<GodealsView> {
  final List<Map<String, dynamic>> _deals = [
    {'title': 'Diskon 50% Kopi Kenangan', 'subtitle': 'Min. pembelian Rp 50.000', 'icon': Icons.local_cafe},
    {'title': 'Cashback 20% di XXI', 'subtitle': 'Maks. cashback Rp 20.000', 'icon': Icons.theaters},
    {'title': 'Beli 1 Gratis 1 Chatime', 'subtitle': 'Hanya untuk ukuran reguler', 'icon': Icons.local_drink},
  ];

  void _claimDeal(String title) {
    final newOrder = Order(
      serviceIcon: Icons.local_offer,
      serviceName: 'GO-DEALS',
      from: 'Klaim Voucher',
      to: title,
      price: 'GRATIS',
      orderTime: DateTime.now(),
    );

    OrderData.history.insert(0, newOrder);
    OrderData.saveOrders();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Voucher '$title' berhasil diklaim!"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PesananView()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GoNesaPalette.menuDeals,
        title: const Text('Go-Deals'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15.0),
        itemCount: _deals.length,
        itemBuilder: (context, index) {
          final deal = _deals[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              leading: CircleAvatar(
                backgroundColor: GoNesaPalette.menuDeals.withOpacity(0.1),
                child: Icon(deal['icon'], color: GoNesaPalette.menuDeals),
              ),
              title: Text(deal['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(deal['subtitle']),
              trailing: ElevatedButton(
                onPressed: () => _claimDeal(deal['title']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GoNesaPalette.menuDeals,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Klaim', style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}
