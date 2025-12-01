import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class TransferView extends StatefulWidget {
  const TransferView({super.key});

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showConfirmation() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konfirmasi Transfer'),
          content: Text('Anda akan mentransfer Rp${_amountController.text} ke nomor ${_phoneController.text}. Lanjutkan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transfer berhasil!'),
                    backgroundColor: Colors.green,
                  ),
                );
                _phoneController.clear();
                _amountController.clear();
              },
              child: const Text('Ya, Lanjutkan'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Saldo'),
        backgroundColor: GoNesaPalette.menuBluebird,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const Text(
              'Kirim Saldo ke Teman',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon Tujuan',
                prefixIcon: const Icon(Icons.person_search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) => (value == null || value.isEmpty) ? 'Nomor tidak boleh kosong' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah Transfer',
                prefixText: 'Rp ',
                prefixIcon: const Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah tidak boleh kosong';
                }
                if (int.tryParse(value) == null || int.parse(value) < 1000) {
                  return 'Minimum transfer Rp 1.000';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _showConfirmation,
              style: ElevatedButton.styleFrom(
                backgroundColor: GoNesaPalette.menuBluebird,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Kirim Sekarang',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
