import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/beranda/beranda_model.dart';
import 'package:gojek/goride/goride_view.dart';
import 'package:gojek/gocar/gocar_view.dart';
import 'package:gojek/gobluebird/gobluebird_view.dart';
import 'package:gojek/gofood/gofood_view.dart';
import 'package:gojek/gosend/gosend_view.dart';
import 'package:gojek/godeals/godeals_view.dart';
import 'package:gojek/gopulsa/gopulsa_view.dart';

class LainnyaView extends StatelessWidget {
  const LainnyaView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GojekService> allServices = [
      GojekService(image: Icons.directions_bike, color: GoNesaPalette.menuRide, title: "GO-RIDE"),
      GojekService(image: Icons.local_car_wash, color: GoNesaPalette.menuCar, title: "GO-CAR"),
      GojekService(image: Icons.directions_car, color: GoNesaPalette.menuBluebird, title: "GO-BLUEBIRD"),
      GojekService(image: Icons.restaurant, color: GoNesaPalette.menuFood, title: "GO-FOOD"),
      GojekService(image: Icons.next_week, color: GoNesaPalette.menuSend, title: "GO-SEND"),
      GojekService(image: Icons.local_offer, color: GoNesaPalette.menuDeals, title: "GO-DEALS"),
      GojekService(image: Icons.phonelink_ring, color: GoNesaPalette.menuPulsa, title: "GO-PULSA"),
      // Tambahkan layanan lain di sini jika ada
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Layanan'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15.0),
        itemCount: allServices.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final service = allServices[index];
          return InkWell(
            onTap: () => _navigateToService(context, service.title),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: service.color.withOpacity(0.1),
                  child: Icon(service.image, color: service.color, size: 30),
                ),
                const SizedBox(height: 8.0),
                Text(service.title, style: const TextStyle(fontSize: 12.0), textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToService(BuildContext context, String title) {
    Widget? destination;
    switch (title) {
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
    }
    if (destination != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination!),
      );
    }
  }
}
