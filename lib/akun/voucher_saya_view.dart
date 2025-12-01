import 'package:flutter/material.dart';
import 'package:gojek/akun/voucher_data.dart';
import 'package:gojek/akun/voucher_model.dart';
import 'package:intl/intl.dart';

class VoucherSayaView extends StatelessWidget {
  const VoucherSayaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher Saya'),
      ),
      body: ListView.builder(
        itemCount: VoucherData.claimedVouchers.length,
        itemBuilder: (context, index) {
          final voucher = VoucherData.claimedVouchers[index];
          return _buildVoucherCard(context, voucher);
        },
      ),
    );
  }

  Widget _buildVoucherCard(BuildContext context, Voucher voucher) {
    final bool isExpired = voucher.expiryDate.isBefore(DateTime.now());
    final String formattedDate = DateFormat('d MMMM yyyy').format(voucher.expiryDate);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: isExpired
                ? [Colors.grey.shade300, Colors.grey.shade400]
                : [const Color(0xFFE0F7FA), const Color(0xFFB2EBF2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                voucher.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isExpired ? Colors.grey.shade700 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                voucher.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isExpired ? Colors.grey.shade600 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Berlaku hingga: $formattedDate',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isExpired ? Colors.red.shade700 : Colors.green.shade800,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isExpired ? null : () {
                      // Logika untuk menggunakan voucher
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isExpired ? Colors.grey : Theme.of(context).primaryColor,
                    ),
                    child: const Text('Gunakan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
