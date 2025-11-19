import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/beranda/beranda_view.dart';
import 'package:gojek/pesanan/pesanan_view.dart';
import 'package:gojek/inbox/inbox_view.dart';
import 'package:gojek/akun/akun_view.dart';
import 'package:gojek/pesanan/pesanan_model.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _bottomNavCurrentIndex = 0;
  bool _isLoading = true;

  final List<Widget> _container = [
    BerandaPage(), // Dihapus const agar bisa rebuild dengan data baru
    PesananView(),
    const InboxPage(),
    const AkunPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await OrderData.loadOrders();
    await OrderData.loadBalance(); // Muat saldo
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: _container[_bottomNavCurrentIndex],
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  BottomNavigationBar _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _bottomNavCurrentIndex = index;
        });
      },
      currentIndex: _bottomNavCurrentIndex,
      items: [
        _buildBottomNavigationBarItem(Icons.home, 'Beranda'),
        _buildBottomNavigationBarItem(Icons.assignment, 'Pesanan'),
        _buildBottomNavigationBarItem(Icons.mail, 'Inbox'),
        _buildBottomNavigationBarItem(Icons.person, 'Akun'),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: Colors.grey),
      activeIcon: Icon(icon, color: GoNesaPalette.menuRide),
      label: label,
    );
  }
}
