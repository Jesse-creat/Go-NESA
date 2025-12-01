import 'package:gojek/akun/voucher_model.dart';

class VoucherData {
  // Daftar voucher yang diklaim oleh pengguna (dummy data)
  static final List<Voucher> claimedVouchers = [
    Voucher(
      title: 'Diskon 50% untuk GO-RIDE',
      description: 'Nikmati diskon 50% untuk perjalanan GO-RIDE Anda berikutnya. Berlaku untuk 1 kali perjalanan.',
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      code: 'GORIDE50',
      imageUrl: 'assets/gofood/gofood.png',
    ),
  ];

  // Fungsi untuk menambahkan voucher baru ke daftar
  static void addVoucher(Voucher voucher) {
    claimedVouchers.add(voucher);
  }
}
