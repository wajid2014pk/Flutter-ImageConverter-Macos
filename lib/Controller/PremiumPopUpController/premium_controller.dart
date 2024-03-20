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
    print("Done");
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

  premiumContainer(String subscriptionDuration, int index, bool showTrailText,
      BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () => {selectPackage.value = index},
                    child: Container(
                      width: 190,
                      height: 155,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
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
                          14,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 12),
                              child: SizedBox(
                                width: 180,
                                child: Text(
                                  subscriptionDuration,
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            index == 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${offerings.current!.monthly!.storeProduct.currencyCode} ',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              ' ${offerings.current!.monthly!.storeProduct.price.toStringAsFixed(2)}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              // "/${AppLocalizations.of(context)!.month}",
                                              "/month",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${offerings.current!.annual!.storeProduct.currencyCode} ',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              ' ${offerings.current!.annual!.storeProduct.price.toStringAsFixed(2)}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              // "/${AppLocalizations.of(context)!.year}",
                                              "Year",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          index == 1
              ? Positioned(
                  bottom: 1.0,
                  right: 43,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffD00024),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SizedBox(
                      width: 100,
                      child: Center(
                        child: Text(
                          // AppLocalizations.of(context)!.most_popular,
                          "Most popular",

                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
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
      Package? monthlyPackage = offerings.current!.monthly;
      Package? yearlyPackage = offerings.current!.annual;

      if (selectPackage.value == 0) {
        CustomerInfo purchaserInfo =
            await Purchases.purchasePackage(monthlyPackage!);
        isPro = purchaserInfo
            .entitlements.all["text.scanner.pro.monthly"]!.isActive;
      } else if (selectPackage.value == 1) {
        CustomerInfo purchaserInfo =
            await Purchases.purchasePackage(yearlyPackage!);
        isPro =
            purchaserInfo.entitlements.all["text.scanner.pro.yearly"]!.isActive;
      }
      if (isPro) {
        await initRevenuePlatform();

        ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Text(
                  "Premium Successfully Purchased",
                  // AppLocalizations.of(Get.context!)!.premium_successfully
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Icon(
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
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Text(
                "Premium Failed. Try Again",

                // AppLocalizations.of(Get.context!)!.premium_cancel
              ),
              Expanded(
                child: SizedBox(),
              ),
              Icon(
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
            content: const Row(
              children: [
                Text("Premium Restore Successfully"
                    // AppLocalizations.of(Get.context!)!.restore_successfully
                    ),
                Expanded(
                  child: SizedBox(),
                ),
                Icon(Icons.done_outline_rounded, color: Colors.green),
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
            content: const Row(
              children: [
                Text(
                  "Restore Failed. Try Again",

                  // AppLocalizations.of(Get.context!)!.restore_failed
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Icon(Icons.remove_circle_outline, color: Colors.red),
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
          content: const Row(
            children: [
              Text(
                "Restore Failed. Try Again",

                // AppLocalizations.of(Get.context!)!.restore_failed
              ),
              Expanded(
                child: SizedBox(),
              ),
              Icon(Icons.remove_circle_outline, color: Colors.red),
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
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 280,
                child: Text(
                  selectPackage.value == 0 ? "Continue" : "Claim 3 Days Free ",
                  // ? AppLocalizations.of(Get.context!)!.cont
                  // : AppLocalizations.of(context)!.claim_3_days_free,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          color: UiColors.whiteColor,
        ),
      ),
    );
  }
}
