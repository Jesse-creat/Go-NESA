import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:gojek/akun/about_us_view.dart';
import 'package:gojek/app_locale.dart';
import 'package:gojek/auth/login_screen.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/firebase_options.dart';
import 'package:gojek/landingpage/landingpage_view.dart';
import 'package:gojek/pesanan/pesanan_model.dart';
import 'package:gojek/splash_screen.dart';

// Konfigurasi GoRouter
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const LandingPage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/about',
      builder: (BuildContext context, GoRouterState state) {
        return const AboutUsView();
      },
    ),
  ],
);

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

  @override
  void initState() {
    super.initState();
    _loadData();
    localization.init(
      mapLocales: LOCALES,
      initLanguageCode: 'id',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
  }

  Future<void> _loadData() async {
    await OrderData.loadBalance();
    await OrderData.loadOrders();
    await OrderData.loadPoints(); // Muat poin saat aplikasi dimulai
    setState(() {});
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'GoNesa',
      theme: ThemeData(
        fontFamily: 'NeoSans',
        primaryColor: GoNesaPalette.menuRide,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: GoNesaPalette.menuRide),
      ),
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
    );
  }
}
