import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:gojek/pesanan/pesanan_view.dart';
import 'package:intl/intl.dart';

class GopulsaView extends StatefulWidget {
  const GopulsaView({super.key});

  @override
  State<GopulsaView> createState() => _GopulsaViewState();
}

class _GopulsaViewState extends State<GopulsaView> {
  final _phoneController = TextEditingController();
  int? _selectedNominal;

  final List<int> _nominalOptions = [10000, 25000, 50000, 100000, 200000];

  String get _formattedPrice {
    if (_selectedNominal == null) return "Rp 0";
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    return currencyFormatter.format(_selectedNominal);
  }

  void _createOrder() {
    if (_phoneController.text.isEmpty || _selectedNominal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor telepon dan nominal harus diisi!"), backgroundColor: Colors.red),
      );
      return;
    }

    final newOrder = Order(
      serviceIcon: Icons.phonelink_ring,
      serviceName: 'GO-PULSA',
      from: _phoneController.text,
      to: 'Pulsa $_selectedNominal',
      price: _formattedPrice,
      orderTime: DateTime.now(),
    );

    OrderData.history.insert(0, newOrder);
    OrderData.saveOrders();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Pembelian pulsa untuk ${_phoneController.text} berhasil!"),
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
        backgroundColor: GoNesaPalette.menuPulsa,
        title: const Text('Beli Pulsa'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text("Isi Ulang Pulsa", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Nomor Telepon',
              prefixIcon: Icon(Icons.phone_android, color: GoNesaPalette.menuPulsa),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Pilih Nominal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: _nominalOptions.length,
            itemBuilder: (context, index) {
              final nominal = _nominalOptions[index];
              final isSelected = _selectedNominal == nominal;
              return GestureDetector(
                onTap: () => setState(() => _selectedNominal = nominal),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? GoNesaPalette.menuPulsa.withOpacity(0.1) : Colors.grey[200],
                    border: Border.all(
                      color: isSelected ? GoNesaPalette.menuPulsa : Colors.grey,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(nominal),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? GoNesaPalette.menuPulsa : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          _buildPriceAndOrderSection(),
        ],
      ),
    );
  }

  Widget _buildPriceAndOrderSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total Pembayaran:", style: TextStyle(fontSize: 16)),
            Text(
              _formattedPrice,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: _createOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: GoNesaPalette.menuPulsa,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Beli Pulsa',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
