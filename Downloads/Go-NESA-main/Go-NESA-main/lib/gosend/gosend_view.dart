import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:gojek/pesanan/pesanan_view.dart';
import 'package:intl/intl.dart';

class GosendView extends StatefulWidget {
  const GosendView({super.key});

  @override
  State<GosendView> createState() => _GosendViewState();
}

class _GosendViewState extends State<GosendView> {
  final _formKey = GlobalKey<FormState>();
  final _senderController = TextEditingController();
  final _recipientController = TextEditingController();
  final _itemController = TextEditingController();

  double _rawPrice = 0.0;
  String _formattedPrice = "Rp 0";
  bool _isFormFilled = false;

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
    if (_formKey.currentState!.validate()) {
      final deliveryFee = (10000 + Random().nextInt(15001)).toDouble();
      setState(() {
        _rawPrice = deliveryFee;
        _formatPrice(_rawPrice);
        _isFormFilled = true;
      });
    } else {
      setState(() {
        _isFormFilled = false;
      });
    }
  }

  void _createOrder() {
    final newOrder = Order(
      serviceIcon: Icons.next_week,
      serviceName: 'GO-SEND',
      from: _senderController.text,
      to: _recipientController.text,
      price: _formattedPrice,
      orderTime: DateTime.now(),
    );

    OrderData.history.insert(0, newOrder);
    OrderData.saveOrders();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pesanan Go-Send berhasil dibuat!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
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
        backgroundColor: GoNesaPalette.menuSend,
        title: const Text('Kirim Barang (Go-Send)'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        onChanged: _calculatePrice,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const Text("Detail Pengiriman", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _senderController,
              label: 'Alamat Pengirim',
              icon: Icons.person_pin_circle,
            ),
            const SizedBox(height: 15),
            _buildTextFormField(
              controller: _recipientController,
              label: 'Alamat Penerima',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 15),
            _buildTextFormField(
              controller: _itemController,
              label: 'Deskripsi Barang',
              icon: Icons.inventory_2,
            ),
            const SizedBox(height: 30),
            _buildPriceAndOrderSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: GoNesaPalette.menuSend),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildPriceAndOrderSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Ongkos Kirim:", style: TextStyle(fontSize: 16)),
            Text(
              _formattedPrice,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: _isFormFilled ? _createOrder : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: GoNesaPalette.menuSend,
            disabledBackgroundColor: Colors.grey[300],
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Pesan Go-Send',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
