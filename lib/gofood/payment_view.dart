import 'package:flutter/material.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class PaymentView extends StatefulWidget {
  const PaymentView({Key? key}) : super(key: key);

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String _selectedPayment = 'QRIS'; // Default payment method

  void _processOrder() {
    final total = OrderData.getCartTotal();
    if (_selectedPayment == 'QRIS' && OrderData.currentBalance < total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo tidak mencukupi!')),
      );
      return;
    }

    // Buat order baru
    final newOrder = Order(
      id: 'GOFOOD-${Random().nextInt(99999)}',
      serviceName: 'GO-FOOD',
      orderTime: DateTime.now(),
      totalPrice: total,
      paymentMethod: _selectedPayment,
      items: List.from(OrderData.shoppingCart),
    );

    // Tambahkan ke history
    OrderData.history.insert(0, newOrder);

    // Kurangi saldo jika pakai QRIS
    if (_selectedPayment == 'QRIS') {
      OrderData.currentBalance -= total;
      OrderData.saveBalance();
    }

    // Simpan history dan kosongkan keranjang
    OrderData.saveOrders();
    OrderData.clearCart();

    // Tampilkan konfirmasi dan kembali ke halaman utama
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Pesanan Berhasil'),
        content: const Text('Pesanan Anda telah diterima dan akan segera diproses.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    final total = OrderData.getCartTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Pilih Metode Pembayaran', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text('QRIS (Saldo GoNesa)'),
              subtitle: Text('Saldo: ${currencyFormatter.format(OrderData.currentBalance)}'),
              value: 'QRIS',
              groupValue: _selectedPayment,
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Bayar di Tempat'),
              subtitle: const Text('Siapkan uang tunai saat pesanan tiba'),
              value: 'Bayar di Tempat',
              groupValue: _selectedPayment,
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value!;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          child: Text('Pesan Sekarang (${currencyFormatter.format(total)})'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: _processOrder,
        ),
      ),
    );
  }
}
