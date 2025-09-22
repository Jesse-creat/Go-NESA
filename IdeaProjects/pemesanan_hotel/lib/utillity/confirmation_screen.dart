import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemesanan_hotel/models/booking_model.dart';
import 'package:pemesanan_hotel/utillity/payment_screen.dart'; // Import halaman pembayaran

class ConfirmationScreen extends StatelessWidget {
  final Booking booking;

  const ConfirmationScreen({super.key, required this.booking});

  // Mengubah fungsi untuk melanjutkan ke pembayaran
  void _proceedToPayment(BuildContext context) {
    // Mengarahkan ke halaman pembayaran sambil membawa data pesanan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(booking: booking),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hotel = booking.hotel;
    final duration = booking.checkOutDate.difference(booking.checkInDate).inDays;
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formatDate = DateFormat('d MMMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pesanan'),
        backgroundColor: const Color(0xFFFF0C0C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mohon periksa kembali pesanan Anda:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotel.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(
                        0xFFFF0C0C))),
                    const SizedBox(height: 8),
                    Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(hotel.location)]),
                    const Divider(height: 24),
                    _buildSummaryRow('Check-in', formatDate.format(booking.checkInDate)),
                    _buildSummaryRow('Check-out', formatDate.format(booking.checkOutDate)),
                    _buildSummaryRow('Jumlah Tamu', '${booking.numberOfGuests} orang'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Rincian Harga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPriceRow('${formatCurrency.format(hotel.pricePerNight)} x $duration malam', formatCurrency.format(booking.totalPrice)),
                    const Divider(height: 20, thickness: 1.5),
                    _buildPriceRow('Total Pembayaran', formatCurrency.format(booking.totalPrice), isTotal: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _proceedToPayment(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xFFFF0C0C), foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          // Mengubah teks tombol
          child: const Text('Lanjut ke Pembayaran', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: isTotal ? 18 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: isTotal ? 18 : 16, fontWeight: FontWeight.bold, color: isTotal ? const Color(
              0xFFFF0C0C) : Colors.black)),
        ],
      ),
    );
  }
}
