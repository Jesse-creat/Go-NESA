import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemesanan_hotel/data/booking_data.dart';
import 'package:pemesanan_hotel/models/booking_model.dart';
import 'package:pemesanan_hotel/utillity/booking_list_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;

  const PaymentScreen({super.key, required this.booking});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulasi proses pembayaran selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    // 1. Ubah status pesanan menjadi "Lunas"
    final paidBooking = widget.booking.copyWith(status: 'Lunas');

    // 2. Simpan pesanan yang sudah lunas ke data terpusat
    BookingData.addBooking(paidBooking);

    if (mounted) {
      // 3. Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pembayaran berhasil dan pesanan dikonfirmasi!'),
          backgroundColor: Colors.green,
        ),
      );

      // 4. Kembali ke halaman paling awal (Dashboard) lalu buka Riwayat Pesanan
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookingListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: const Color(0xFFFF0C0C),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Total Tagihan Anda',
                style: TextStyle(fontSize: 22, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                formatCurrency.format(widget.booking.totalPrice),
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(
                    0xFFFF0C0C)),
              ),
              const SizedBox(height: 40),
              const Text(
                'Silakan selesaikan pembayaran untuk mengonfirmasi pesanan Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isProcessing
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton.icon(
                onPressed: _processPayment,
                icon: const Icon(Icons.security),
                label: const Text('Bayar Sekarang', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFFF0C0C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
      ),
    );
  }
}
