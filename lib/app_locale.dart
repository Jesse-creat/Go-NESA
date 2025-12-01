import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale('id', AppLocale.ID),
  MapLocale('en', AppLocale.EN),
];

mixin AppLocale {
  // Common
  static const String title = 'title';
  static const String lainnya = 'lainnya';

  // Akun Page
  static const String profileSaya = 'profileSaya';
  static const String pengaturanAkun = 'pengaturanAkun';
  static const String keamananAkun = 'keamananAkun';
  static const String kelolaPassword = 'kelolaPassword';
  static const String bahasa = 'bahasa';
  static const String pilihBahasa = 'pilihBahasa';
  static const String keluar = 'keluar';
  static const String yakinKeluar = 'yakinKeluar';
  static const String batal = 'batal';
  static const String voucherSaya = 'voucherSaya';
  static const String poin = 'poin';
  static const String pesanan = 'pesanan';
  static const String metodePembayaran = 'metodePembayaran';
  static const String kelolaKartu = 'kelolaKartu';
  static const String pusatBantuan = 'pusatBantuan';
  static const String faq = 'faq';

  // Service Pages (Go-Ride, Go-Car, etc.)
  static const String pesanSekarang = 'pesanSekarang';
  static const String pesanGoRide = 'pesanGoRide';
  static const String pesanGoCar = 'pesanGoCar';
  static const String pesanMakanan = 'pesanMakanan';
  static const String pesanGoSend = 'pesanGoSend';
  static const String beliPulsa = 'beliPulsa';
  static const String lokasiJemput = 'lokasiJemput';
  static const String tujuanAnda = 'tujuanAnda';
  static const String estimasiHarga = 'estimasiHarga';
  static const String totalHarga = 'totalHarga';
  static const String totalPembayaran = 'totalPembayaran';
  static const String mauMakanApa = 'mauMakanApa';
  static const String pilihMakananFavorit = 'pilihMakananFavorit';
  static const String isiUlangPulsa = 'isiUlangPulsa';
  static const String nomorTelepon = 'nomorTelepon';
  static const String pilihNominal = 'pilihNominal';
  static const String detailPengiriman = 'detailPengiriman';
  static const String alamatPengirim = 'alamatPengirim';
  static const String alamatPenerima = 'alamatPenerima';
  static const String deskripsiBarang = 'deskripsiBarang';
  static const String ongkosKirim = 'ongkosKirim';


  static const Map<String, dynamic> ID = {
    title: 'GoNesa',
    lainnya: 'LAINNYA',
    profileSaya: 'Profil Saya',
    pengaturanAkun: 'Pengaturan Akun',
    keamananAkun: 'Keamanan Akun',
    kelolaPassword: 'Kelola password & verifikasi',
    bahasa: 'Bahasa',
    pilihBahasa: 'Pilih Bahasa',
    keluar: 'Keluar',
    yakinKeluar: 'Apakah Anda yakin ingin keluar dari akun?',
    batal: 'Batal',
    voucherSaya: 'Voucher Saya',
    poin: 'Poin',
    pesanan: 'Pesanan',
    metodePembayaran: 'Metode Pembayaran',
    kelolaKartu: 'Kelola kartu & rekening',
    pusatBantuan: 'Pusat Bantuan',
    faq: 'FAQ & dukungan pelanggan',
    pesanSekarang: 'Pesan Sekarang',
    pesanGoRide: 'Pesan Go-Ride',
    pesanGoCar: 'Pesan Go-Car',
    pesanMakanan: 'Pesan Makanan',
    pesanGoSend: 'Pesan Go-Send',
    beliPulsa: 'Beli Pulsa',
    lokasiJemput: 'Lokasi Penjemputan',
    tujuanAnda: 'Tujuan Anda',
    estimasiHarga: 'Estimasi Harga',
    totalHarga: 'Total Harga',
    totalPembayaran: 'Total Pembayaran',
    mauMakanApa: 'Mau makan apa hari ini?',
    pilihMakananFavorit: 'Pilih Makanan Favoritmu',
    isiUlangPulsa: 'Isi Ulang Pulsa',
    nomorTelepon: 'Nomor Telepon',
    pilihNominal: 'Pilih Nominal',
    detailPengiriman: 'Detail Pengiriman',
    alamatPengirim: 'Alamat Pengirim',
    alamatPenerima: 'Alamat Penerima',
    deskripsiBarang: 'Deskripsi Barang',
    ongkosKirim: 'Ongkos Kirim',
  };

  static const Map<String, dynamic> EN = {
    title: 'GoNesa',
    lainnya: 'MORE',
    profileSaya: 'My Profile',
    pengaturanAkun: 'Account Settings',
    keamananAkun: 'Account Security',
    kelolaPassword: 'Manage password & verification',
    bahasa: 'Language',
    pilihBahasa: 'Select Language',
    keluar: 'Logout',
    yakinKeluar: 'Are you sure you want to log out?',
    batal: 'Cancel',
    voucherSaya: 'My Vouchers',
    poin: 'Points',
    pesanan: 'Orders',
    metodePembayaran: 'Payment Methods',
    kelolaKartu: 'Manage cards & accounts',
    pusatBantuan: 'Help Center',
    faq: 'FAQ & customer support',
    pesanSekarang: 'Order Now',
    pesanGoRide: 'Order Go-Ride',
    pesanGoCar: 'Order Go-Car',
    pesanMakanan: 'Order Food',
    pesanGoSend: 'Order Go-Send',
    beliPulsa: 'Buy Credit',
    lokasiJemput: 'Pickup Location',
    tujuanAnda: 'Your Destination',
    estimasiHarga: 'Estimated Price',
    totalHarga: 'Total Price',
    totalPembayaran: 'Total Payment',
    mauMakanApa: 'What to eat today?',
    pilihMakananFavorit: 'Choose Your Favorite Food',
    isiUlangPulsa: 'Top Up Credit',
    nomorTelepon: 'Phone Number',
    pilihNominal: 'Select Nominal',
    detailPengiriman: 'Shipment Details',
    alamatPengirim: "Sender's Address",
    alamatPenerima: "Recipient's Address",
    deskripsiBarang: 'Item Description',
    ongkosKirim: 'Shipping Cost',
  };
}
