import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class GopulsaView extends StatefulWidget {
  const GopulsaView({super.key});

  @override
  State<GopulsaView> createState() => _GopulsaViewState();
}

class _GopulsaViewState extends State<GopulsaView> {
  final TextEditingController _phoneController = TextEditingController();
  double? _selectedAmount;

  final List<double> _pulsaAmounts = [10000, 20000, 50000, 100000, 150000, 200000];

  void _buyPulsa() {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor telepon tidak valid!')),
      );
      return;
    }
    if (_selectedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus memilih nominal pulsa!')),
      );
      return;
    }

    if (OrderData.currentBalance < _selectedAmount!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo tidak mencukupi!')),
      );
      return;
    }

    OrderData.currentBalance -= _selectedAmount!;
    OrderData.saveBalance();

    final newOrder = Order(
      id: 'GOPULSA-${Random().nextInt(99999)}',
      serviceName: 'GO-PULSA',
      orderTime: DateTime.now(),
      totalPrice: _selectedAmount!,
      paymentMethod: 'GoNesa Saldo',
      to: _phoneController.text, // Nomor tujuan
    );

    OrderData.history.insert(0, newOrder);
    OrderData.saveOrders();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pembelian pulsa untuk ${_phoneController.text} berhasil!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-PULSA'),
        backgroundColor: GoNesaPalette.menuPulsa,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Pilih Nominal Pulsa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
              ),
              itemCount: _pulsaAmounts.length,
              itemBuilder: (context, index) {
                final amount = _pulsaAmounts[index];
                final isSelected = _selectedAmount == amount;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAmount = amount;
                    });
                  },
                  child: Card(
                    elevation: isSelected ? 6 : 2,
                    color: isSelected ? GoNesaPalette.menuPulsa.withOpacity(0.1) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? GoNesaPalette.menuPulsa : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        currencyFormatter.format(amount),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? GoNesaPalette.menuPulsa : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _buyPulsa,
          style: ElevatedButton.styleFrom(
            backgroundColor: GoNesaPalette.menuPulsa,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: const Text('Beli Sekarang'),
        ),
      ),
    );
  }
}
