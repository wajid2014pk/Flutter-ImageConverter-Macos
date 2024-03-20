// ignore_for_file: file_names
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenuecatKey {
  static String key = 'appl_oVHFcWVOWeYVrUfYgjXDEoNsGQG';

  static Future<void> initPlatformState() async {
    await Purchases.configure(PurchasesConfiguration(key));
    print("key $key is initialise.");
  }
}
