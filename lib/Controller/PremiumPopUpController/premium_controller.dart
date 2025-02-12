// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:image_converter_macos/Screens/premium_popup.dart';
import 'package:image_converter_macos/main.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PayWallController extends GetxController {
  RxInt selectPackage = 1.obs;

  Offerings? offerings;
  final _revenueCatKey =
      PurchasesConfiguration("appl_oVHFcWVOWeYVrUfYgjXDEoNsGQG");
  RxBool isPro = false.obs;

  @override
  void onInit() {
    initRevenuePlatform();
    super.onInit();
  }

  Future<void> initRevenuePlatform() async {
    await Purchases.configure(_revenueCatKey);
  }

  getProductsPrice() async {
    try {
      offerings = await Purchases.getOfferings();
      print("offerings $offerings");
      if (offerings!.current != null) {
        return true;
      }
    } on PlatformException catch (e) {
      log(e.message.toString());
    }
  }

  // premiumContainer(String subscriptionDuration, int index, bool showTrailText,
  //     BuildContext context) {
  //   return SizedBox(
  //     width: 150,
  //     child: Stack(
  //       children: [
  //         Obx(
  //           () => Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               InkWell(
  //                 hoverColor: Colors.transparent,
  //                 onTap: () => {selectPackage.value = index},
  //                 child: Container(
  //                   height: 150,
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                         color: selectPackage.value == index
  //                             ? UiColors.lightblueColor
  //                             : Colors.white,
  //                         style: BorderStyle.solid,
  //                         width: 1.5),
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(
  //                       10,
  //                     ),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(top: 0, bottom: 0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Container(
  //                           width: double.infinity,
  //                           height: 30,
  //                           decoration: BoxDecoration(
  //                               color: selectPackage.value == index
  //                                   ? UiColors.lightblueColor
  //                                   : Colors.white,
  //                               borderRadius: const BorderRadius.only(
  //                                 topRight: Radius.circular(8),
  //                                 topLeft: Radius.circular(8),
  //                               )),
  //                           child: SizedBox(
  //                             width: 10,
  //                             child: Center(
  //                               child: Text(
  //                                 subscriptionDuration,
  //                                 maxLines: 1,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: TextStyle(
  //                                   color: selectPackage.value == index
  //                                       ? UiColors.whiteColor
  //                                       : UiColors.blackColor,
  //                                   fontSize: 18,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Expanded(
  //                           child: Container(
  //                             width: MediaQuery.sizeOf(context).width,
  //                             decoration: const BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.only(
  //                                 bottomLeft: Radius.circular(12),
  //                                 bottomRight: Radius.circular(12),
  //                               ),
  //                             ),
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 Text(
  //                                   index == 0
  //                                       ? "${offerings!.current!.availablePackages[4].storeProduct.currencyCode} ${getActualPrice(offerings!.current!.availablePackages[4].storeProduct.price, 30)}"
  //                                       : "${offerings!.current!.availablePackages[3].storeProduct.currencyCode} ${getActualPrice(offerings!.current!.availablePackages[3].storeProduct.price, 60)}",
  //                                   style: TextStyle(
  //                                       fontWeight: FontWeight.w400,
  //                                       fontSize: 18,
  //                                       color: Colors.black.withOpacity(0.5),
  //                                       decoration: TextDecoration.lineThrough),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 2.0,
  //                                 ),
  //                                 Text(
  //                                   index == 0 ? "30% OFF" : "60% OFF",
  //                                   style: TextStyle(
  //                                     fontWeight: FontWeight.w500,
  //                                     fontSize: 16,
  //                                     color: Colors.red,
  //                                   ),
  //                                 ),
  //                                 const Padding(
  //                                   padding: EdgeInsets.only(
  //                                       left: 10.0, right: 10.0),
  //                                   child: Divider(),
  //                                 ),
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       index == 0
  //                                           ? "${offerings!.current!.availablePackages[4].storeProduct.currencyCode} "
  //                                           : "${offerings!.current!.availablePackages[3].storeProduct.currencyCode} ",
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.w600,
  //                                         fontSize: 16,
  //                                         color: selectPackage.value == index
  //                                             ? UiColors.lightblueColor
  //                                             : Colors.black,
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       index == 0
  //                                           ? offerings!
  //                                               .current!
  //                                               .availablePackages[4]
  //                                               .storeProduct
  //                                               .price
  //                                               .toStringAsFixed(2)
  //                                           : offerings!
  //                                               .current!
  //                                               .availablePackages[3]
  //                                               .storeProduct
  //                                               .price
  //                                               .toStringAsFixed(2),
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.w600,
  //                                         fontSize: 22,
  //                                         color: selectPackage.value == index
  //                                             ? UiColors.lightblueColor
  //                                             : Colors.black,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // getActualPrice(double salePrice, double disRate) {
  //   disRate = disRate / 100;
  //   double disRatePer = 1 - disRate;
  //   double aPrice = salePrice / disRatePer;
  //   return aPrice.toStringAsFixed(1);
  // }
  getActualPrice(double salePrice, double disRate) {
    if (salePrice != null) {
      disRate = disRate / 100;
      double disRatePer = 1 - disRate;
      double aPrice = salePrice / disRatePer;
      return formatPrice(aPrice);
    } else {
      return formatPrice(12.00);
    }
  }

  String formatPrice(double price) {
    // Check if the number is whole
    if (price == price.toInt()) {
      return price.toInt().toString(); // Return as an integer
    } else {
      return price.toStringAsFixed(2); // Return with two decimal places
    }
  }

  showLoading(context) {
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6),
      barrierDismissible: false,
      barrierLabel: "Dialog",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: SizedBox.expand(
                    child: Center(
                        child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(UiColors.lightblueColor),
                ))),
              ),
            ],
          ),
        );
      },
    );
  }

  // makePurchase() async {
  //   try {
  //     // showLoading(Get.context!);
  //     // CustomerInfo? purchaserInfo;

  //     if (selectPackage.value == 0) {
  //       print(
  //           "CHECK monthly 4:  ${offerings!.current!.availablePackages[4].storeProduct.identifier}");
  //     } else if (selectPackage.value == 1) {
  //       print(
  //           "CHECK Yearly 3: ${offerings!.current!.availablePackages[3].storeProduct.identifier}");
  //     } else if (selectPackage.value == 2) {
  //       print(
  //           "CHECK Lifetime 5: ${offerings!.current!.availablePackages[5].storeProduct.identifier}");
  //       // purchaserInfo = await Purchases.purchasePackage(
  //       //     offerings!.current!.availablePackages[5]);
  //     }
  //   } on PlatformException catch (e) {
  //     print("@@@ exception $e");
  //     Get.back();

  //     Navigator.pop(Get.context!);

  //     ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
  //         content: Center(
  //             child: Text(
  //       "Purchased failed!",
  //     ))));

  //     var errorCode = PurchasesErrorHelper.getErrorCode(e);
  //     if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
  //       debugPrint(e.message);
  //     }
  //   }
  // }

  makePurchase() async {
    try {
      showLoading(Get.context!);
      CustomerInfo? purchaserInfo;
      // bool isPro = false;
      // Package? monthlyPackage = offerings!.current!.monthly!;
      // Package? yearlyPackage = offerings!.current!.annual!;
      // Package? lifetimePackage = offerings!.current!.lifetime!;

      if (selectPackage.value == 0) {
        purchaserInfo = await Purchases.purchasePackage(
            offerings!.current!.availablePackages[4]);
        // isPro = offerings!.current!.availablePackages[4].storeProduct.
        // purchaserInfo.entitlements.all["monthlyPremium"]!.isActive;
      } else if (selectPackage.value == 1) {
        purchaserInfo = await Purchases.purchasePackage(
            offerings!.current!.availablePackages[3]);
        // isPro = purchaserInfo.entitlements.all["yearlyPremium"]!.isActive;
      } else if (selectPackage.value == 2) {
        purchaserInfo = await Purchases.purchasePackage(
            offerings!.current!.availablePackages[5]);
        // isPro = purchaserInfo.entitlements.all["lifetime_purchase"]!.isActive;
      }
      if (purchaserInfo!.entitlements.active.isNotEmpty) {
        // print("@@@isPremium222${isPremium.value}");
        // isPremium.value = true;
        payWallController.isPro.value = true;
        // context.read<MainCubit>().setPro(true);
        //snackMessage(context, AppLocalizations.of(context)!.subscribe_successfully);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Center(
                child: Text(
          AppLocalizations.of(Get.context!)!.premium_purchased_successfully,
        ))));

        Get.offAll(() => const HomeScreen(
                  index: 1,
                )
            // BottomTab()
            );
      } else {
        Navigator.pop(Get.context!);
      }
    } on PlatformException catch (e) {
      print("@@@ exception $e");
      Get.back();
      // if (isTriggerPremium) {
      // Get.to(const PremiumPage());
      // PremiumPopUp().premiumScreenPopUp(Get.context!);
      // }
      // else {
      Navigator.pop(Get.context!);
      // }
      //snackMessage(Get.context!, AppLocalizations.of(Get.context!)!.purchased_cancel);
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Center(
              child: Text(
        // AppLocalizations.of(Get.context!)!.purchased_failed,
        "Purchased failed!",
      ))));
      // showToast(context, "Purchased Successfull");
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint(e.message);
      }
    }
    //   if (isPro) {
    //     await initRevenuePlatform();

    //     ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    //         duration: const Duration(seconds: 2),
    //         behavior: SnackBarBehavior.floating,
    //         content: Row(
    //           children: [
    //             Text(AppLocalizations.of(Get.context!)!
    //                 .premium_purchased_successfully),
    //             const Expanded(
    //               child: SizedBox(),
    //             ),
    //             const Icon(
    //               Icons.done_outline_rounded,
    //               color: Colors.green,
    //             ),
    //           ],
    //         )));

    //     Future.delayed(const Duration(milliseconds: 2500), () {
    //       Get.offAll(() => const HomeScreen());
    //     });
    //   } else {
    //     Get.back();
    //   }
    // } on PlatformException catch (e) {
    //   // Get.back();
    //   Get.offAll(() => const HomeScreen(index: -1));
    //   ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    //       duration: const Duration(seconds: 2),
    //       behavior: SnackBarBehavior.floating,
    //       content: Row(
    //         children: [
    //           Text(
    //             '${AppLocalizations.of(Get.context!)!.premium_failed} ${AppLocalizations.of(Get.context!)!.please_try_again}',
    //           ),
    //           const Expanded(
    //             child: SizedBox(),
    //           ),
    //           const Icon(
    //             Icons.clear_outlined,
    //             color: Colors.red,
    //           ),
    //         ],
    //       )));
    //   var errorCode = PurchasesErrorHelper.getErrorCode(e);
    //   if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
    //     log(e.message.toString());
    //   }
    // }
  }

  restorePurchase(BuildContext context) async {
    try {
      showLoading(context);
      CustomerInfo restoredInfo = await Purchases.restorePurchases();

      if (restoredInfo.entitlements.active.isNotEmpty) {
        initRevenuePlatform();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).unselectedWidgetColor,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.premium_restore_successfully,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                const Icon(Icons.done_outline_rounded, color: Colors.green),
              ],
            )));
        Future.delayed(const Duration(milliseconds: 2500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        });
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).unselectedWidgetColor,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Text(
                  '${AppLocalizations.of(context)!.restore_failed} ${AppLocalizations.of(context)!.please_try_again}',
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                const Icon(Icons.remove_circle_outline, color: Colors.red),
              ],
            )));
      }
    } on PlatformException catch (e) {
      Navigator.pop(context);
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).unselectedWidgetColor,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Text(
                '${AppLocalizations.of(context)!.restore_failed} ${AppLocalizations.of(context)!.please_try_again}',
              ),
              const Expanded(
                child: SizedBox(),
              ),
              const Icon(Icons.remove_circle_outline, color: Colors.red),
            ],
          )));
    }
  }

  purchaseButton(BuildContext context) {
    return InkWell(
      onTap: () {
        payWallController.offerings == null
            ? Get.snackbar(
                backgroundColor: Colors.white,
                "Failed",
                "No Internet Connecion")
            : payWallController.makePurchase();
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          // color: textScannerColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              UiColors.darkblueColor,
              UiColors.lightblueColor
              // AppConstants.darkBlueColor,
            ],
          ),
          border: Border.all(color: UiColors.whiteColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 280,
              child: Text(
                AppLocalizations.of(Get.context!)!.continuee,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  discPriceRates(double salePrice, double disRate) {
    disRate = disRate / 100;
    double disRatePer = 1 - disRate;
    double aPrice = salePrice / disRatePer;
    return aPrice.toStringAsFixed(2);
  }

  hyperLinksOptionsText(String text, GestureTapCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.0,
            color: UiColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
