import 'package:flutter/material.dart';
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
  BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  String _formattedBalance = "";

  final List<GojekService> _gojekServiceList = [
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
        image: Icons.apps, color: GoNesaPalette.menuOther, title: "LAINNYA"),
  ];

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
  }

  void _updateBalanceDisplay() {
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    setState(() {
      _formattedBalance = currencyFormatter.format(OrderData.currentBalance);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GojekAppBar(),
        backgroundColor: GoNesaPalette.grey,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  children: [
                    _buildGopayMenu(),
                    const SizedBox(height: 16.0),
                    _buildGojekServicesMenu(),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 16.0),
                child: _buildGoFoodFeatured(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGopayMenu() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffff6a00), Color(0xffff6a00)],
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Seabank",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontFamily: "NeoSansBold",
                  ),
                ),
                Text(
                  _formattedBalance, // Tampilkan saldo dinamis
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontFamily: "NeoSansBold",
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 12.0, 32.0, 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGopayMenuItem(
                    asset: "assets/icons/icon_transfer.png",
                    text: "Transfer",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferView()))),
                _buildGopayMenuItem(
                    asset: "assets/icons/icon_scan.png",
                    text: "Scan QR",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanQrView()))),
                _buildGopayMenuItem(
                    asset: "assets/icons/icon_saldo.png",
                    text: "Isi Saldo",
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => IsiSaldoView()));
                      _updateBalanceDisplay();
                    }),
                _buildGopayMenuItem(
                    asset: "assets/icons/icon_menu.png",
                    text: "Lainnya",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LainnyaView()))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGopayMenuItem({required String asset, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(asset, width: 32.0, height: 32.0),
          const SizedBox(height: 10.0),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12.0)),
        ],
      ),
    );
  }

  Widget _buildGojekServicesMenu() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _gojekServiceList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        return _rowGojekService(_gojekServiceList[index]);
      },
    );
  }

  Widget _rowGojekService(GojekService gojekService) {
    return InkWell(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: GoNesaPalette.grey200, width: 1.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              gojekService.image,
              color: gojekService.color,
              size: 32.0,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(gojekService.title, style: const TextStyle(fontSize: 10.0)),
        ],
      ),
    );
  }

  Widget _buildGoFoodFeatured() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("GO-FOOD", style: TextStyle(fontFamily: "NeoSansBold")),
          const SizedBox(height: 8.0),
          const Text("Pilihan Terlaris", style: TextStyle(fontFamily: "NeoSansBold")),
          SizedBox(
            height: 172.0,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12.0),
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _goFoodFeaturedList.length,
              itemBuilder: (context, index) {
                return _rowGoFoodFeatured(_goFoodFeaturedList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowGoFoodFeatured(Food food) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              food.image,
              width: 132.0,
              height: 132.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(food.title),
        ],
      ),
    );
  }
}
