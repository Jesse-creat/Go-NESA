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

class GocarView extends StatefulWidget {
  const GocarView({super.key});

  @override
  State<GocarView> createState() => _GocarViewState();
}

class _GocarViewState extends State<GocarView> {
  String? _selectedFrom;
  String? _selectedTo;

  double _rawPrice = 0.0;
  String _formattedPrice = "Rp 0";
  bool _isPriceCalculated = false;

  final List<String> _magetanStreets = [
    'Alun-Alun Magetan', 'Pasar Baru Magetan', 'Jalan Raya Maospati-Magetan',
    'Jalan Gubernur Suryo', 'Jalan Pahlawan', 'Jalan Jendral Sudirman',
    'Jalan Ahmad Yani', 'Jalan Diponegoro', 'Jalan MT Haryono', 'Jalan Tripandita',
    'Jalan Manggis', 'Jalan Yosonegoro', 'Jalan Bangka', 'Jalan S. Parman',
    'Jalan Kunti', 'Jalan Jaksa Agung Suprapto', 'Jalan Basuki Rahmat Timur',
    'Jalan Basuki Rahmat Utara', 'Jalan Hasanuddin', 'Jalan Kharya Darma', 'Jalan Mayjend',
  ];

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

  void _calculateDummyPrice() {
    if (_selectedFrom != null && _selectedTo != null) {
      if (_selectedFrom == _selectedTo) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lokasi penjemputan dan tujuan tidak boleh sama!"), backgroundColor: Colors.red),
        );
        setState(() => _isPriceCalculated = false);
        return;
      }
      final random = Random();
      final randomPrice = (25000 + random.nextInt(35001)).toDouble();
      setState(() {
        _rawPrice = randomPrice;
        _formatPrice(_rawPrice);
        _isPriceCalculated = true;
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
      id: 'GOCAR-${Random().nextInt(99999)}',
      serviceName: 'GO-CAR',
      orderTime: DateTime.now(),
      totalPrice: _rawPrice,
      paymentMethod: 'GoNesa Saldo',
      from: _selectedFrom!,
      to: _selectedTo!,
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
              MaterialPageRoute(builder: (context) => const BerandaPage()),
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
                  "Pemesanan berhasil! Driver sedang menuju lokasi.",
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
        backgroundColor: GoNesaPalette.menuCar,
        title: Text(AppLocale.pesanGoCar.getString(context)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Image.asset(
                'assets/images/map_magetan.png',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Center(child: Text('Gagal memuat peta')),
              ),
            ),
          ),
          _buildOrderCard(),
        ],
      ),
    );
  }

  Widget _buildOrderCard() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Pilih Lokasi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildLocationDropdown(
              hint: AppLocale.lokasiJemput.getString(context),
              icon: Icons.my_location,
              value: _selectedFrom,
              onChanged: (value) {
                setState(() {
                  _selectedFrom = value;
                  _calculateDummyPrice();
                });
              },
            ),
            const SizedBox(height: 10),
            _buildLocationDropdown(
              hint: AppLocale.tujuanAnda.getString(context),
              icon: Icons.location_on,
              value: _selectedTo,
              onChanged: (value) {
                setState(() {
                  _selectedTo = value;
                  _calculateDummyPrice();
                });
              },
            ),
            const SizedBox(height: 20),
            _buildPriceAndOrderSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDropdown({
    required String hint,
    required IconData icon,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: GoNesaPalette.menuCar),
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      items: _magetanStreets.map((String street) {
        return DropdownMenuItem<String>(
          value: street,
          child: Text(street, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildPriceAndOrderSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocale.estimasiHarga.getString(context), style: const TextStyle(fontSize: 16)),
            Text(
              _formattedPrice,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: _isPriceCalculated ? _createOrder : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: GoNesaPalette.menuCar,
            disabledBackgroundColor: Colors.grey[300],
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            AppLocale.pesanGoCar.getString(context),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
