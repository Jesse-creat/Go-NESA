import 'package:flutter/material.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:intl/intl.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  void _updateCart() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    final cartItems = OrderData.shoppingCart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Pesanan'),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Keranjang Anda masih kosong.'),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(item.meal.thumbnail, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item.meal.name),
                  subtitle: Text('${currencyFormatter.format(15000)} x ${item.quantity}'),
                  trailing: Text(currencyFormatter.format(15000 * item.quantity)),
                  onTap: () {
                    // Mungkin bisa tambahkan aksi edit atau hapus di sini
                  },
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        currencyFormatter.format(OrderData.getCartTotal()),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text('Lanjut ke Pembayaran'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      // TODO: Navigasi ke halaman pembayaran
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigasi ke halaman pembayaran...')),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
