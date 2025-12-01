import 'package:flutter/material.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class IsiSaldoView extends StatefulWidget {
  const IsiSaldoView({super.key});

  @override
  _IsiSaldoViewState createState() => _IsiSaldoViewState();
}

class _IsiSaldoViewState extends State<IsiSaldoView> {
  final _nominalController = TextEditingController();
  final List<double> _predefinedAmounts = [20000, 50000, 100000, 200000];

  void _processTopUp() {
    final amountString = _nominalController.text.replaceAll('.', '');
    if (amountString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal tidak boleh kosong')),
      );
      return;
    }

    final double amount = double.tryParse(amountString) ?? 0;
    if (amount < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimum isi saldo adalah Rp 10.000')),
      );
      return;
    }

    // 1. Perbarui saldo
    OrderData.currentBalance += amount;
    OrderData.saveBalance();

    // 2. Buat entri pesanan
    final newOrder = Order(
      id: 'TOPUP-${Random().nextInt(99999)}',
      serviceName: 'ISI SALDO',
      orderTime: DateTime.now(),
      totalPrice: amount,
      paymentMethod: 'Transfer Bank', // Contoh
      to: 'GoNesa Saldo',
    );

    // 3. Simpan ke riwayat
    OrderData.history.insert(0, newOrder);
    OrderData.saveOrders();

    // 4. Tampilkan notifikasi dan tutup halaman
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Isi saldo sebesar ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(amount)} berhasil!"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Isi Saldo'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pilih Nominal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: _predefinedAmounts.length,
              itemBuilder: (context, index) {
                final amount = _predefinedAmounts[index];
                return GestureDetector(
                  onTap: () {
                    _nominalController.text = currencyFormatter.format(amount);
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Rp ${currencyFormatter.format(amount)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Atau Masukkan Nominal Lain',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minimal Rp 10.000',
                prefixText: 'Rp ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // Auto-format input
                String newValue = value.replaceAll('.', '');
                if (newValue.isNotEmpty) {
                  final number = int.parse(newValue);
                  final formattedValue = currencyFormatter.format(number);
                  _nominalController.value = TextEditingValue(
                    text: formattedValue,
                    selection: TextSelection.collapsed(offset: formattedValue.length),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check_circle),
          label: const Text('Konfirmasi'),
          onPressed: _processTopUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
