import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Controller/PremiumPopUpController/premium_controller.dart';
import 'package:image_converter_macos/Controller/initialize-revenuecat-keys.dart';
import 'package:image_converter_macos/Screens/splash_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:window_manager/window_manager.dart';

String key = 'appl_oVHFcWVOWeYVrUfYgjXDEoNsGQG';
final payWallController = Get.put(PayWallController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // Initialize the window
  doWhenWindowReady(() {
    final initialSize = Size(1300, 720);
    final minSize = Size(1300, 720);
    appWindow.minSize = minSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });

  RevenuecatKey.initPlatformState();

  var connectivityResult = await (Connectivity().checkConnectivity());
  print("connectivityResult $connectivityResult");

  // Check if internet connection is available
  if (connectivityResult[0] != ConnectivityResult.none) {
    // Internet connection available, get offerings and run the app
    await getOfferingsAndRunApp();
  } else {
    // No internet connection, simply run the app
    runAppApp();
  }
}

Future<void> getOfferingsAndRunApp() async {
  // Completer to handle the timeout logic
  Completer<void> offeringsCompleter = Completer<void>();

  // Set up a timer to resolve the completer after 5 seconds
  Timer timeoutTimer = Timer(const Duration(seconds: 5), () {
    print("Timer");
    if (!offeringsCompleter.isCompleted) {
      offeringsCompleter.complete();
      print(
          "Offerings request timed out, proceeding with app initialization...");
      runAppApp();
    }
  });

  // Get offerings and wait for completion or timeout
  await Future.wait([
    Purchases.configure(PurchasesConfiguration(key)),
    Purchases.getOfferings().then((offerings) {
      payWallController.offerings = offerings;

      print("###offerings $offerings");
      // Complete the completer when offerings are received
      if (!offeringsCompleter.isCompleted) {
        offeringsCompleter.complete();
        // Cancel the timeout timer since offerings were received
        timeoutTimer.cancel();
        runAppApp();
      }
    }),
  ]);
}

void runAppApp() {
  runApp(const MyApp());
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

    final monthlyEntitalments =
        customerInfo.entitlements.active['monthlyPremium'];
    final yearlyEntitalments =
        customerInfo.entitlements.active['yearlyPremium'];
    final lifeTimeEntitalments =
        customerInfo.entitlements.active['lifetime_purchase'];

    if (monthlyEntitalments != null ||
        yearlyEntitalments != null ||
        lifeTimeEntitalments != null) {
      payWallController.isPro.value = true;
      print("####PRO VALUE ${payWallController.isPro.value}");
    } else {
      payWallController.isPro.value = true;
      print("####PRO VALUE ${payWallController.isPro.value}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: "Manrope"),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SplashScreen(),
    );
  }
}
