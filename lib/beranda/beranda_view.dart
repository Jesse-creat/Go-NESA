import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gojek/app_locale.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/beranda/beranda_model.dart';
import 'package:gojek/beranda/beranda_gojek_appbar.dart';
import 'package:gojek/goride/goride_view.dart';
import 'package:gojek/gocar/gocar_view.dart';
import 'package:gojek/gobluebird/gobluebird_view.dart';
import 'package:gojek/gofood/gofood_view.dart';
import 'package:gojek/gofood/meal_model.dart';
import 'package:gojek/gofood/themealdb_api.dart';
import 'package:gojek/gosend/gosend_view.dart';
import 'package:gojek/godeals/godeals_view.dart';
import 'package:gojek/gopulsa/gopulsa_view.dart';
import 'package:gojek/isi_saldo/isi_saldo_view.dart';
import 'package:gojek/lainnya/lainnya_view.dart';
import 'package:gojek/pencarian/pencarian_view.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:gojek/scan_qr/scan_qr_view.dart';
import 'package:gojek/transfer/transfer_view.dart';
import 'package:intl/intl.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage>
    with SingleTickerProviderStateMixin {
  String _formattedBalance = "";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // === TheMealDB ===
  late Future<List<Meal>> _goFoodFeaturedFuture;
  final ThemealdbApi _mealApi = ThemealdbApi();

  List<GojekService> _getGojekServices(BuildContext context) {
    return [
      GojekService(
          image: Icons.directions_bike,
          color: GoNesaPalette.menuRide,
          title: "GO-RIDE"),
      GojekService(
          image: Icons.local_car_wash,
          color: GoNesaPalette.menuCar,
          title: "GO-CAR"),
      GojekService(
          image: Icons.directions_car,
          color: GoNesaPalette.menuBluebird,
          title: "GO-BLUEBIRD"),
      GojekService(
          image: Icons.restaurant,
          color: GoNesaPalette.menuFood,
          title: "GO-FOOD"),
      GojekService(
          image: Icons.next_week,
          color: GoNesaPalette.menuSend,
          title: "GO-SEND"),
      GojekService(
          image: Icons.local_offer,
          color: GoNesaPalette.menuDeals,
          title: "GO-DEALS"),
      GojekService(
          image: Icons.phonelink_ring,
          color: GoNesaPalette.menuPulsa,
          title: "GO-PULSA"),
      GojekService(
        image: Icons.apps,
        color: GoNesaPalette.menuOther,
        title: AppLocale.lainnya.getString(context),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _updateBalanceDisplay();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();

    // === Inisialisasi data GO-FOOD dari TheMealDB ===
    _goFoodFeaturedFuture = _mealApi.getMealsByCategory('Seafood');
    // bisa ganti kategori: 'Beef', 'Chicken', 'Dessert', dll
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateBalanceDisplay() {
    final currencyFormatter =
    NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    setState(() {
      _formattedBalance = currencyFormatter.format(OrderData.currentBalance);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GojekAppBar(
          onSearchTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PencarianView()),
            );
          },
        ),
        backgroundColor: const Color(0xFFF5F7FA),
        body: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildGopayMenu(),
                        const SizedBox(height: 20.0),
                        _buildGojekServicesMenu(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _buildGoFoodFeatured(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGopayMenu() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B35),
            Color(0xFFFF8A50),
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    const Text(
                      "Seabank",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: "NeoSansBold",
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    _formattedBalance,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontFamily: "NeoSansBold",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGopayMenuItem(
                  icon: Icons.send_rounded,
                  text: "Transfer",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransferView(),
                    ),
                  ),
                ),
                _buildGopayMenuItem(
                  icon: Icons.qr_code_scanner_rounded,
                  text: "Scan QR",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScanQrView(),
                    ),
                  ),
                ),
                _buildGopayMenuItem(
                  icon: Icons.add_card_rounded,
                  text: "Isi Saldo",
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IsiSaldoView(),
                      ),
                    );
                    _updateBalanceDisplay();
                  },
                ),
                _buildGopayMenuItem(
                  icon: Icons.more_horiz_rounded,
                  text: AppLocale.lainnya.getString(context),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LainnyaView(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGopayMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(icon, color: Colors.white, size: 24.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGojekServicesMenu() {
    final services = _getGojekServices(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        return _rowGojekService(services[index], index);
      },
    );
  }

  Widget _rowGojekService(GojekService gojekService, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          Widget? destination;
          switch (gojekService.title) {
            case "GO-RIDE":
              destination = const GoRideView();
              break;
            case "GO-CAR":
              destination = const GocarView();
              break;
            case "GO-BLUEBIRD":
              destination = const GoBluebirdView();
              break;
            case "GO-FOOD":
              destination = const GofoodView();
              break;
            case "GO-SEND":
              destination = const GosendView();
              break;
            case "GO-DEALS":
              destination = const GodealsView();
              break;
            case "GO-PULSA":
              destination = const GopulsaView();
              break;
            case "LAINNYA":
            case "MORE":
              destination = const LainnyaView();
              break;
          }
          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination!),
            );
          }
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: gojekService.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: gojekService.color.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  gojekService.image,
                  color: gojekService.color,
                  size: 28.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                gojekService.title,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== GO-FOOD (TheMealDB) =====================

  Widget _buildGoFoodFeatured() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: GoNesaPalette.menuFood.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  color: GoNesaPalette.menuFood,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 12.0),
              const Text(
                "GO-FOOD",
                style: TextStyle(
                  fontFamily: "NeoSansBold",
                  fontSize: 18.0,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pilihan Terlaris",
                style: TextStyle(
                  fontFamily: "NeoSansBold",
                  fontSize: 16.0,
                  color: Color(0xFF34495E),
                ),
              ),
              Text(
                "Lihat Semua",
                style: TextStyle(
                  fontSize: 13.0,
                  color: GoNesaPalette.menuFood,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Perbaikan: Menambah tinggi SizedBox untuk memberi ruang lebih
          SizedBox(
            height: 210.0,
            child: FutureBuilder<List<Meal>>(
              future: _goFoodFeaturedFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading: skeleton sederhana
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, index) {
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );
                    },
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Gagal memuat rekomendasi makanan',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 12,
                      ),
                    ),
                  );
                }

                final meals = snapshot.data ?? [];

                if (meals.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada rekomendasi makanan',
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    return _rowGoFoodFeaturedFromApi(meals[index], index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowGoFoodFeaturedFromApi(Meal meal, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              // Contoh: kalau mau ambil detail resep
              // final detail = await _mealApi.getMealDetail(meal.id);
              // TODO: push ke halaman detail GoFood
            },
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              width: 140.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              // Perbaikan: Menggunakan Column sederhana tanpa Expanded
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    child: meal.thumbnail.trim().isNotEmpty
                        ? Image.network(
                            meal.thumbnail,
                            width: 140.0,
                            height: 120.0,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 140,
                              height: 120,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, size: 28),
                            ),
                          )
                        : Container(
                            width: 140,
                            height: 120,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.fastfood, size: 32),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      meal.name,
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.star,
                          size: 14.0,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          "4.8", // dummy rating
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
