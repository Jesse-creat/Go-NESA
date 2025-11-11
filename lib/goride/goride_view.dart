import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:gojek/pesanan/pesanan_view.dart';
import 'package:intl/intl.dart'; // Import untuk NumberFormat

class GoRideView extends StatefulWidget {
  @override
  _GoRideViewState createState() => _GoRideViewState();
}

class _GoRideViewState extends State<GoRideView> {
  String? _selectedFrom;
  String? _selectedTo;

  double _rawPrice = 0.0; // Menyimpan harga dalam bentuk double
  String _formattedPrice = "Rp 0"; // Menyimpan harga dalam format String
  bool _isPriceCalculated = false;

  final List<String> _magetanStreets = [
    'Alun-Alun Magetan',
    'Pasar Baru Magetan',
    'Jalan Raya Maospati-Magetan',
    'Jalan Gubernur Suryo',
    'Jalan Pahlawan',
    'Jalan Jendral Sudirman',
    'Jalan Ahmad Yani',
    'Jalan Diponegoro',
    'Jalan MT Haryono',
    'Jalan Tripandita',
    'Jalan Manggis',
    'Jalan Yosonegoro',
    'Jalan Bangka',
    'Jalan S. Parman',
    'Jalan Kunti',
    'Jalan Jaksa Agung Suprapto',
    'Jalan Basuki Rahmat Timur',
    'Jalan Basuki Rahmat Utara',
    'Jalan Hasanuddin',
    'Jalan Kharya Darma',
    'Jalan Mayjend',
  ];

  @override
  void initState() {
    super.initState();
    _formatPrice(0.0); // Inisialisasi harga awal
  }

  void _formatPrice(double price) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    setState(() {
      _formattedPrice = currencyFormatter.format(price);
    });
  }

  void _resetState() {
    setState(() {
      _isPriceCalculated = false;
      _rawPrice = 0.0;
      _formatPrice(_rawPrice);
      _selectedFrom = null;
      _selectedTo = null;
    });
  }

  void _createOrder() {
    final newOrder = Order(
      serviceIcon: Icons.directions_bike,
      serviceName: 'GO-RIDE',
      from: _selectedFrom!,
      to: _selectedTo!,
      price: _formattedPrice, // Gunakan harga yang sudah diformat
      orderTime: DateTime.now(),
    );

    OrderData.history.insert(0, newOrder);
    OrderData.saveOrders();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Pemesanan berhasil!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PesananView()),
        );
      }
    });
  }

  void _calculateDummyPrice() {
    if (_selectedFrom == null || _selectedTo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lokasi penjemputan dan tujuan harus dipilih!")),
      );
      return;
    }
    if (_selectedFrom == _selectedTo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lokasi penjemputan dan tujuan tidak boleh sama!")),
      );
      return;
    }

    final random = Random();
    final randomPrice = (15000 + random.nextInt(25001)).toDouble(); // Menghasilkan angka antara 15000 dan 40000
    
    setState(() {
      _rawPrice = randomPrice;
      _formatPrice(_rawPrice); // Format harga
      _isPriceCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Go-Ride'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetState,
            tooltip: 'Pesan Lagi',
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[300],
              child: Image.asset(
                'assets/images/map_magetan.png', // Menampilkan gambar peta dari assets
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 50),
                        Text('Gagal memuat peta. Pastikan map_magetan.png ada di assets/images/'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedFrom,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: 'Dari', border: OutlineInputBorder()),
                      items: _magetanStreets.map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (newValue) => setState(() => _selectedFrom = newValue),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedTo,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: 'Ke', border: OutlineInputBorder()),
                      items: _magetanStreets.map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (newValue) => setState(() => _selectedTo = newValue),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _isPriceCalculated ? _createOrder : _calculateDummyPrice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPriceCalculated ? Colors.blue : Colors.green,
                        minimumSize: Size.fromHeight(50),
                      ),
                      child: Text(
                        _isPriceCalculated ? 'Konfirmasi Pesanan' : 'Hitung Harga',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Estimasi Harga: $_formattedPrice', // Tampilkan harga yang sudah diformat
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
