import 'package:flutter/material.dart';
import 'package:gojek/akun/voucher_data.dart';
import 'package:gojek/akun/voucher_model.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'dart:math';

class GodealsView extends StatelessWidget {
  const GodealsView({super.key});

  void _claimDummyVoucher(BuildContext context) {
    final random = Random();
    final newVoucher = Voucher(
      title: 'Voucher Spesial Go-Deals',
      description: 'Diskon ${random.nextInt(50) + 10}% untuk semua merchant Go-Deals. Maksimal diskon Rp ${random.nextInt(20000) + 10000}.',
      expiryDate: DateTime.now().add(Duration(days: random.nextInt(30) + 7)),
      code: 'GODEALS-${random.nextInt(99999)}',
      imageUrl: 'assets/gofood/gofood.png',
    );

    VoucherData.addVoucher(newVoucher);
    OrderData.addPoints(70);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voucher Go-Deals berhasil diklaim! Anda mendapatkan 70 poin.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-DEALS'),
        backgroundColor: GoNesaPalette.menuDeals,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _claimDummyVoucher(context),
          child: const Text('Klaim Voucher Dummy'),
        ),
      ),
    );
  }
}
