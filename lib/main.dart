import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:gojek/akun/about_us_view.dart';
import 'package:gojek/app_locale.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/firebase_options.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:gojek/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _loadData();
    localization.init(
      mapLocales: LOCALES,
      initLanguageCode: 'id',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;

    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/about-us',
          builder: (context, state) => const AboutUsView(),
        ),
      ],
    );
  }

  Future<void> _loadData() async {
    await OrderData.loadBalance();
    await OrderData.loadOrders();
    setState(() {}); // Memperbarui UI jika diperlukan setelah data dimuat
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'GoNesa',
      theme: ThemeData(
        fontFamily: 'NeoSans',
        primaryColor: GoNesaPalette.menuRide,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: GoNesaPalette.menuRide),
      ),
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      routerConfig: _router,
    );
  }
}
