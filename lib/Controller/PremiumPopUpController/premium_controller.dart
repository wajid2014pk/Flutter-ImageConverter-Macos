// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PayWallController extends GetxController {
  RxInt selectPackage = 1.obs;

  late Offerings offerings;
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
      if (offerings.current != null) {
        return true;
      }
    } on PlatformException catch (e) {
      log(e.message.toString());
    }
  }

  premiumContainer(String title, String subscriptionDuration, int index,
      bool showTrailText, BuildContext context) {
    return SizedBox(
      width: 160,
      child: Stack(
        children: [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () => {selectPackage.value = index},
                  child: Container(
                    // width: 190,
                    height: 165,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectPackage.value == index
                            ? UiColors.lightblueColor
                            : Colors.white,
                        style: BorderStyle.solid,
                        width: 2.2,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                color: selectPackage.value == index
                                    ? UiColors.lightblueColor
                                    : Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(8),
                                )),
                            child: SizedBox(
                              width: 10,
                              child: Center(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: selectPackage.value == index
                                        ? UiColors.whiteColor
                                        : UiColors.lightblueColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      width: 170,
                                      child: Text(
                                        subscriptionDuration,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    index == 0
                                        ? "${offerings.current!.availablePackages[4].storeProduct.currencyCode} ${getActualPrice(offerings.current!.availablePackages[3].storeProduct.price, 30)}"
                                        : "${offerings.current!.availablePackages[3].storeProduct.currencyCode} ${getActualPrice(offerings.current!.availablePackages[4].storeProduct.price, 60)}",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        color: Colors.black.withOpacity(0.5),
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  Text(
                                    index == 0
                                        ? "${offerings.current!.availablePackages[4].storeProduct.currencyCode} ${offerings.current!.availablePackages[4].storeProduct.price.toStringAsFixed(2)}"
                                        : "${offerings.current!.availablePackages[3].storeProduct.currencyCode} ${offerings.current!.availablePackages[3].storeProduct.price.toStringAsFixed(2)}",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      color: selectPackage.value == index
                                          ? UiColors.lightblueColor
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
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

  getActualPrice(double salePrice, double disRate) {
    disRate = disRate / 100;
    double disRatePer = 1 - disRate;
    double aPrice = salePrice / disRatePer;
    return aPrice.toStringAsFixed(1);
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

  makePurchase() async {
    try {
      showLoading(Get.context!);
      bool isPro = false;
      Package? monthlyPackage = offerings.current!.availablePackages[4];
      Package? yearlyPackage = offerings.current!.availablePackages[3];

      if (selectPackage.value == 0) {
        CustomerInfo purchaserInfo =
            await Purchases.purchasePackage(monthlyPackage);
        isPro = purchaserInfo.entitlements.all["monthlyPremium"]!.isActive;
      } else if (selectPackage.value == 1) {
        CustomerInfo purchaserInfo =
            await Purchases.purchasePackage(yearlyPackage);
        isPro = purchaserInfo.entitlements.all["yearlyPremium"]!.isActive;
      }
      if (isPro) {
        await initRevenuePlatform();

        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Text(AppLocalizations.of(Get.context!)!
                    .premium_purchased_successfully),
                const Expanded(
                  child: SizedBox(),
                ),
                const Icon(
                  Icons.done_outline_rounded,
                  color: Colors.green,
                ),
              ],
            )));

        Future.delayed(const Duration(milliseconds: 2500), () {
          Get.offAll(() => const HomeScreen());
        });
      } else {
        Get.back();
      }
    } on PlatformException catch (e) {
      Get.back();
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Text(
                '${AppLocalizations.of(Get.context!)!.premium_failed} ${AppLocalizations.of(Get.context!)!.please_try_again}',
              ),
              const Expanded(
                child: SizedBox(),
              ),
              const Icon(
                Icons.clear_outlined,
                color: Colors.red,
              ),
            ],
          )));
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        log(e.message.toString());
      }
    }
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
        makePurchase();
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
                style: GoogleFonts.poppins(
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
          style: GoogleFonts.poppins(
            fontSize: 12.0,
            color: UiColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
