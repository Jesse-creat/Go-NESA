import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gojek/app_locale.dart';
import 'package:gojek/beranda/beranda_view.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

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

    if (OrderData.currentBalance < _selectedNominal!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saldo tidak mencukupi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    OrderData.currentBalance -= _selectedNominal!;
    OrderData.saveBalance();

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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => BerandaPage()),
              (Route<dynamic> route) => false,
            );
          }
        });

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/icons/succes.json', width: 150, height: 150),
                const SizedBox(height: 16),
                Text(
                  "Pembelian pulsa untuk ${_phoneController.text} berhasil!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GoNesaPalette.menuPulsa,
        title: Text(AppLocale.beliPulsa.getString(context)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(AppLocale.isiUlangPulsa.getString(context), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: AppLocale.nomorTelepon.getString(context),
              prefixIcon: Icon(Icons.phone_android, color: GoNesaPalette.menuPulsa),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          Text(AppLocale.pilihNominal.getString(context), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            Text(AppLocale.totalPembayaran.getString(context), style: const TextStyle(fontSize: 16)),
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
          child: Text(
            AppLocale.beliPulsa.getString(context),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
