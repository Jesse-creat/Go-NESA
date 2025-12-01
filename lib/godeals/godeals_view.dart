import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'dart:math';

class GodealsView extends StatelessWidget {
  const GodealsView({super.key});

  void _createDummyOrder(BuildContext context) {
    final random = Random();
    final dummyPrice = (50000 + random.nextInt(100001)).toDouble();

    final newOrder = Order(
      id: 'GODEALS-${random.nextInt(99999)}',
      serviceName: 'GO-DEALS',
      orderTime: DateTime.now(),
      totalPrice: dummyPrice,
      paymentMethod: 'GoNesa Saldo',
      from: 'Merchant A', // Contoh data
      to: 'Voucher Diskon', // Contoh data
    );

    OrderData.history.insert(0, newOrder);
    OrderData.saveOrders();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voucher Go-Deals berhasil diklaim!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-DEALS'),
        backgroundColor: GoNesaPalette.menuDeals,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _createDummyOrder(context),
          child: const Text('Klaim Voucher Dummy'),
        ),
      ),
    );
  }
}
