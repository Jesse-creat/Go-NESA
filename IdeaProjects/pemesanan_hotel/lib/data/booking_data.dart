import 'package:pemesanan_hotel/models/booking_model.dart';
import 'package:pemesanan_hotel/data/hotel_data.dart';

// Kelas untuk mengelola data pemesanan secara terpusat
class BookingData {
  // Daftar statis untuk menyimpan data pemesanan.
  // Dikosongkan agar riwayat hanya berisi pesanan yang dibuat oleh pengguna.
  static final List<Booking> _bookingList = [];

  // Getter untuk mendapatkan daftar pemesanan
  static List<Booking> get bookingList => _bookingList;

  // Metode untuk menambahkan pemesanan baru
  static void addBooking(Booking booking) {
    _bookingList.insert(0, booking); // Menambahkan ke awal daftar agar muncul paling atas
  }
}
