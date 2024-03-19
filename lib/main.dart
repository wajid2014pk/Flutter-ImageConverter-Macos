import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Controller/initialize-revenuecat-keys.dart';
import 'package:image_converter_macos/Screens/splash_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // RevenuecatKey.initPlatformState();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
  doWhenWindowReady(() {
    final initialSize = Size(1100, 700);
    final minSize = Size(1100, 700);
    appWindow.minSize = minSize;
    appWindow.size = initialSize;
    appWindow.show();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // Purchases.addCustomerInfoUpdateListener((_) => updateCustomerStatus());
    // updateCustomerStatus();
    super.initState();
  }

  // Future updateCustomerStatus() async {
  //   final customerInfo = await Purchases.getCustomerInfo();

  //   final monthlyEntitalments =
  //       customerInfo.entitlements.active['pdf.converter.pro.monthly'];
  //   final yearlyEntitalments =
  //       customerInfo.entitlements.active['pdf.converter.mac'];

  //   if (monthlyEntitalments != null || yearlyEntitalments != null) {
  //     // setState(() {
  //     // isPremium.isPro.value = true;
  //     // print("####PRO VALUE ${isPremium.isPro.value}");
  //     // });
  //   } else {
  //     // setState(() {
  //     // isPremium.isPro.value = false;
  //     // print("####PRO VALUE ${isPremium.isPro.value}");
  //     // });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      home: SplashScreen(),
    );
  }
}
