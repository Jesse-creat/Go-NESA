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
import 'package:gojek/gosend/gosend_view.dart';
import 'package:gojek/godeals/godeals_view.dart';
import 'package:gojek/gopulsa/gopulsa_view.dart';
import 'package:gojek/isi_saldo/isi_saldo_view.dart';
import 'package:gojek/lainnya/lainnya_view.dart';
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

  final List<Food> _goFoodFeaturedList = [
    Food(title: "Steak Andakar", image: "assets/images/food_1.jpg"),
    Food(title: "Mie Ayam Tumini", image: "assets/images/food_2.jpg"),
    Food(title: "Tengkleng Hohah", image: "assets/images/food_3.jpg"),
    Food(title: "Warung Steak", image: "assets/images/food_4.jpg"),
    Food(title: "Kindai Warung Banjar", image: "assets/images/food_5.jpg")
  ];

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

  void _openProfileSidebar(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'ProfileSidebar',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.78,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                ),
                child: const _ProfileSidebarContent(),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Kalau mau trigger sidebar dari AppBar:
        // appBar: GojekAppBar(onProfileTap: () => _openProfileSidebar(context)),
       appBar: GojekAppBar(onProfileTap: () => _openProfileSidebar(context)),
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
          SizedBox(
            height: 190.0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _goFoodFeaturedList.length,
              itemBuilder: (context, index) {
                return _rowGoFoodFeatured(_goFoodFeaturedList[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowGoFoodFeatured(Food food, int index) {
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
            onTap: () {},
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          food.image,
                          width: 140.0,
                          height: 120.0,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              size: 16.0,
                              color: Color(0xFFE74C3C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.title,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C3E50),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14.0,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 4.0),
                            const Text(
                              "4.8",
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7F8C8D),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            const Icon(
                              Icons.access_time,
                              size: 14.0,
                              color: Color(0xFF7F8C8D),
                            ),
                            const SizedBox(width: 4.0),
                            const Text(
                              "20 min",
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Color(0xFF7F8C8D),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _ProfileSidebarContent extends StatelessWidget {
  const _ProfileSidebarContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER PROFILE
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00AA13),
                Color(0xFF00C91D),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_rounded,
                  size: 30,
                  color: Color(0xFF00AA13),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hi, User GoNesa', // TODO: ganti dengan nama user
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Lihat dan kelola akun kamu',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // MENU LIST
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              _SidebarItem(
                icon: Icons.person_outline_rounded,
                title: 'Profil Saya',
                subtitle: 'Lihat dan edit data akun',
                onTap: () {
                  // TODO: Navigator.pushNamed(context, '/profile');
                },
              ),
              _SidebarItem(
                icon: Icons.receipt_long_rounded,
                title: 'Riwayat Pesanan',
                subtitle: 'Lihat transaksi dan pesanan kamu',
                onTap: () {
                  // TODO: buka halaman history / orders
                },
              ),
              _SidebarItem(
                icon: Icons.settings_outlined,
                title: 'Pengaturan',
                subtitle: 'Bahasa, notifikasi, keamanan',
                onTap: () {
                  // TODO: buka halaman settings
                },
              ),
              const Divider(height: 24),
              _SidebarItem(
                icon: Icons.logout_rounded,
                title: 'Keluar',
                subtitle: 'Logout dari akun ini',
                iconColor: Colors.red,
                titleColor: Colors.red,
                onTap: () {
                  // TODO: panggil fungsi logout
                  // lalu Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF00AA13).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor ?? const Color(0xFF00AA13),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: titleColor ?? const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
