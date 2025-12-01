import 'package:pemesanan_hotel/models/hotel_model.dart';

class Booking {
  final Hotel hotel;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final double totalPrice;
  final String status; // Menambahkan status pesanan

  Booking({
    required this.hotel,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.totalPrice,
    required this.status,
  });

  // Fungsi untuk membuat salinan booking dengan status baru
  Booking copyWith({String? status}) {
    return Booking(
      hotel: hotel,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      numberOfGuests: numberOfGuests,
      totalPrice: totalPrice,
      status: status ?? this.status,
    );
  }
}
