import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Controller/PremiumPopUpController/premium_controller.dart';
import 'package:image_converter_macos/Controller/initialize-revenuecat-keys.dart';
import 'package:image_converter_macos/Screens/splash_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RevenuecatKey.initPlatformState();

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
  final payWallController = Get.put(PayWallController());

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    Purchases.addCustomerInfoUpdateListener((_) => updateCustomerStatus());
    updateCustomerStatus();
    super.initState();
  }

  Future updateCustomerStatus() async {
    final customerInfo = await Purchases.getCustomerInfo();

    final monthlyEntitalments = customerInfo.entitlements.active['monthlyPremium'];
    final yearlyEntitalments =
        customerInfo.entitlements.active['yearlyPremium'];

    if (monthlyEntitalments != null || yearlyEntitalments != null) {
      payWallController.isPro.value = true;
      print("####PRO VALUE ${payWallController.isPro.value}");
    } else {
      payWallController.isPro.value = false;
      print("####PRO VALUE ${payWallController.isPro.value}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SplashScreen(),
    );
  }
}
