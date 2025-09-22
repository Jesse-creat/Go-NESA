import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemesanan_hotel/models/hotel_model.dart';
import 'package:pemesanan_hotel/models/booking_model.dart';
import 'package:pemesanan_hotel/utillity/confirmation_screen.dart';

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _numberOfGuests = 1;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final now = DateTime.now();
    final firstDate = isCheckIn ? now : (_checkInDate ?? now).add(const Duration(days: 1));
    final initialDate = isCheckIn ? (_checkInDate ?? now) : (_checkOutDate ?? firstDate);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = pickedDate;
          if (_checkOutDate != null && !_checkOutDate!.isAfter(_checkInDate!)) {
            _checkOutDate = null;
          }
        } else {
          _checkOutDate = pickedDate;
        }
      });
    }
  }

  void _proceedToConfirmation() {
    if (_checkInDate == null || _checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tanggal check-in dan check-out.'), backgroundColor: Colors.red),
      );
      return;
    }

    final duration = _checkOutDate!.difference(_checkInDate!).inDays;
    if (duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal check-out harus setelah tanggal check-in.'), backgroundColor: Colors.red),
      );
      return;
    }

    final totalPrice = duration * widget.hotel.pricePerNight;

    // Membuat objek Booking dengan status awal
    final newBooking = Booking(
      hotel: widget.hotel,
      checkInDate: _checkInDate!,
      checkOutDate: _checkOutDate!,
      numberOfGuests: _numberOfGuests,
      totalPrice: totalPrice,
      status: 'Menunggu Pembayaran', // Menambahkan status awal
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(booking: newBooking),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotel.name),
        backgroundColor: const Color(0xFFFF0C0C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.hotel.imageUrl,
              child: Image.network(widget.hotel.imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.hotel.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(
                      0xFFFF0C0C))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey), const SizedBox(width: 4),
                      Expanded(child: Text(widget.hotel.location, style: const TextStyle(fontSize: 16, color: Colors.grey))),
                      const Icon(Icons.star, color: Colors.amber, size: 20), const SizedBox(width: 4),
                      Text(widget.hotel.rating.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 32),
                  Text('Buat Pesanan Anda', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildDatePickerTile(context, title: 'Check-in', date: _checkInDate, onTap: () => _selectDate(context, true))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDatePickerTile(context, title: 'Check-out', date: _checkOutDate, onTap: () => _selectDate(context, false))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildGuestCounter(),
                  const Divider(height: 32),
                  const Text('Fasilitas', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8.0, runSpacing: 4.0, children: widget.hotel.facilities.map((f) => Chip(label: Text(f))).toList()),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _proceedToConfirmation,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xFF6A1B9A), foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Lanjutkan ke Konfirmasi', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildDatePickerTile(BuildContext context, {required String title, DateTime? date, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          const Icon(Icons.calendar_today, color: Color(0xFFFF0C0C), size: 20),
          const SizedBox(width: 8),
          Text(date != null ? DateFormat('d MMM').format(date) : title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
      ),
    );
  }

  Widget _buildGuestCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Jumlah Tamu', style: TextStyle(fontSize: 16)),
        Row(children: [
          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => setState(() => _numberOfGuests > 1 ? _numberOfGuests-- : null)),
          Text('$_numberOfGuests', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => _numberOfGuests++)),
        ]),
      ]),
    );
  }
}
