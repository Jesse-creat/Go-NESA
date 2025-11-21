import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gojek/app_locale.dart';
import 'package:gojek/beranda/beranda_view.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class GofoodView extends StatefulWidget {
  const GofoodView({super.key});

  @override
  State<GofoodView> createState() => _GofoodViewState();
}

class _GofoodViewState extends State<GofoodView> {
  String? _selectedFood;
  double _rawPrice = 0.0;
  String _formattedPrice = "Rp 0";
  bool _isFoodSelected = false;

  final Map<String, double> _foodOptions = {
    'Nasi Goreng Spesial': 25000,
    'Ayam Bakar Madu': 35000,
    'Sate Ayam 10 Tusuk': 22000,
    'Mie Ayam Komplit': 20000,
    'Jus Alpukat': 15000,
  };

  @override
  void initState() {
    super.initState();
    _formatPrice(0.0);
  }

  void _formatPrice(double price) {
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    setState(() {
      _formattedPrice = currencyFormatter.format(price);
    });
  }

  void _calculatePrice() {
    if (_selectedFood != null) {
      final price = _foodOptions[_selectedFood]!;
      final deliveryFee = (5000 + Random().nextInt(10001)).toDouble();
      setState(() {
        _rawPrice = price + deliveryFee;
        _formatPrice(_rawPrice);
        _isFoodSelected = true;
      });
    }
  }

  void _createOrder() {
    if (OrderData.currentBalance < _rawPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saldo tidak mencukupi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    OrderData.currentBalance -= _rawPrice;
    OrderData.saveBalance();

    final newOrder = Order(
      serviceIcon: Icons.restaurant,
      serviceName: 'GO-FOOD',
      from: 'Restoran Pilihan',
      to: _selectedFood!,
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
                const Text(
                  "Pesanan makananmu sedang disiapkan!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        backgroundColor: GoNesaPalette.menuFood,
        title: Text(AppLocale.pesanMakanan.getString(context)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocale.mauMakanApa.getString(context), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedFood,
              isExpanded: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.fastfood, color: GoNesaPalette.menuFood),
                labelText: AppLocale.pilihMakananFavorit.getString(context),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              items: _foodOptions.keys.map((String food) {
                return DropdownMenuItem<String>(
                  value: food,
                  child: Text(food, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFood = value;
                  _calculatePrice();
                });
              },
            ),
            const Spacer(),
            _buildPriceAndOrderSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAndOrderSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocale.totalHarga.getString(context), style: const TextStyle(fontSize: 16)),
            Text(
              _formattedPrice,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: _isFoodSelected ? _createOrder : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: GoNesaPalette.menuFood,
            disabledBackgroundColor: Colors.grey[300],
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            AppLocale.pesanMakanan.getString(context),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
