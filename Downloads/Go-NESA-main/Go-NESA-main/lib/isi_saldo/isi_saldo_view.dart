import 'package:flutter/material.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:gojek/pesanan/pesanan_view.dart';
import 'package:intl/intl.dart';

class IsiSaldoView extends StatefulWidget {
  @override
  _IsiSaldoViewState createState() => _IsiSaldoViewState();
}

class _IsiSaldoViewState extends State<IsiSaldoView> {
  final _formKey = GlobalKey<FormState>();
  final _nominalController = TextEditingController();

  void _processTopUp() {
    if (_formKey.currentState!.validate()) {
      final double amount = double.parse(_nominalController.text);
      final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
      final formattedAmount = currencyFormatter.format(amount);

      // 1. Perbarui saldo
      OrderData.currentBalance += amount;
      OrderData.saveBalance(); // Simpan saldo baru

      // 2. Buat entri pesanan
      final newOrder = Order(
        serviceIcon: Icons.account_balance_wallet,
        serviceName: 'ISI SALDO',
        from: 'Sumber Dana',
        to: 'Seabank',
        price: formattedAmount,
        orderTime: DateTime.now(),
      );

      // 3. Simpan ke riwayat
      OrderData.history.insert(0, newOrder);
      OrderData.saveOrders();

      // 4. Tampilkan notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Isi saldo sebesar $formattedAmount berhasil!"),
          backgroundColor: Colors.yellow,
        ),
      );

      // 5. Arahkan ke halaman riwayat
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PesananView()),
        (Route<dynamic> route) => route.isFirst,
      );
    }
  }

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Saldo'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Masukan Nominal Saldo',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Mohon masukan angka yang valid';
                  }
                  if (double.parse(value) < 10000) {
                    return 'Minimum isi saldo adalah Rp 10.000';
                  }
                  return null;
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _processTopUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size.fromHeight(50),
                ),
                child: Text('Konfirmasi', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
