import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/PremiumPopUpController/premium_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PremiumPopUp {
  final payWallController = Get.put(PayWallController());

  premiumScreenPopUp(BuildContext context) {
    bool isArabicOrPersianOrHebrew = [
      'ar',
      'fa',
      'he',
    ].contains(Localizations.localeOf(Get.context!).languageCode);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: const DecorationImage(
                image: AssetImage(
                  'assets/Premium_MAc.png',
                ), // Replace with your image path
                fit: BoxFit.fill,
              ),
            ),
            child: FutureBuilder(
                future: payWallController.getProductsPrice(),
                builder: ((BuildContext buildContext, AsyncSnapshot snapshot) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text(
                              "${AppLocalizations.of(context)!.image} ${AppLocalizations.of(context)!.converter}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    UiColors.darkblueColor,
                                    UiColors.lightblueColor,
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    // "Pro",
                                    AppLocalizations.of(context)!.pro,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15.0, left: 15.0),
                              child: InkWell(
                                  onTap: () {
                                    Get.back();
                                    payWallController.selectPackage.value = 1;
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: UiColors.whiteColor,
                                    size: 30.0,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 45.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              customRow(
                                                context,
                                                AppLocalizations.of(context)!
                                                    .multiple_format_at_once,
                                                'assets/Multiple_images.png',
                                              ),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              customRow(
                                                context,
                                                AppLocalizations.of(context)!
                                                    .convert_to_any_format,
                                                'assets/any_format.png',
                                              ),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              customRow(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .unlimited_conversions,
                                                  'assets/Unlimited.png'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              customRow(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .support_upto_20mbs_files,
                                                  'assets/20mb.png'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              customRow(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .customer_support,
                                                  'assets/Customer_support.png'),
                                            ],
                                          ),
                                        ),
                                        // const Spacer(),
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: 60,
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .free,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 22.0,
                                            ),
                                            customLockColumn('tick'),
                                            const SizedBox(
                                              height: 22.0,
                                            ),
                                            customLockColumn('lock'),
                                            const SizedBox(
                                              height: 22.0,
                                            ),
                                            customLockColumn('lock'),
                                            const SizedBox(
                                              height: 22.0,
                                            ),
                                            customLockColumn('lock'),
                                            const SizedBox(
                                              height: 22.0,
                                            ),
                                            customLockColumn('lock'),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 18,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0,
                                                          right: 15.0,
                                                          top: 3.0,
                                                          bottom: 3.0),
                                                  decoration: BoxDecoration(
                                                    // border: Border.all(),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: <Color>[
                                                        UiColors.lightblueColor,
                                                        UiColors.darkblueColor
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    // "Pro",
                                                    AppLocalizations.of(
                                                            context)!
                                                        .pro,
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 18.0,
                                                ),
                                                customLockColumn('tick_Blue'),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                customLockColumn('tick_Blue'),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                customLockColumn('tick_Blue'),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                customLockColumn('tick_Blue'),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                customLockColumn('tick_Blue'),
                                                const SizedBox(
                                                  height: 30.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Center(
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                            "assets/rating_image.png",
                                            width: 220,
                                            height: 100,
                                          ),
                                          Positioned(
                                              top: 5,
                                              left: isArabicOrPersianOrHebrew
                                                  ? 0
                                                  : 5,
                                              right: isArabicOrPersianOrHebrew
                                                  ? 6
                                                  : 0,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .trusted_by,
                                                    // "Trusted By",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 18,
                                                        color:
                                                            UiColors.whiteColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .professionals,
                                                    // "Professionals",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 22,
                                                        color:
                                                            UiColors.whiteColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: VerticalDivider(
                                  thickness: 2.0,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40.0, right: 0),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            snapshot.data != null
                                                ? payWallController
                                                    .premiumContainer(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .most_flexible,
                                                        AppLocalizations.of(
                                                                context)!
                                                            .monthly,
                                                        0,
                                                        false,
                                                        context)
                                                : shimmerContainer(
                                                    context, 170, 170),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            snapshot.data != null
                                                ? payWallController
                                                    .premiumContainer(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .most_popular,
                                                        AppLocalizations.of(
                                                                context)!
                                                            .yearly,
                                                        1,
                                                        true,
                                                        context)
                                                : shimmerContainer(
                                                    context, 170, 170),
                                          ],
                                        ),
                                        const Spacer(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        payWallController
                                            .purchaseButton(context),
                                        const Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                payWallController
                                                    .hyperLinksOptionsText(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .terms_of_services,
                                                        () {
                                                  var urlTermsofServices =
                                                      Uri.parse(
                                                          "https://eclixtech.com/terms-service");
                                                  launchUrl(urlTermsofServices);
                                                }),
                                                VerticalDivider(
                                                  thickness: 2,
                                                  color: UiColors.whiteColor
                                                      .withOpacity(0.4),
                                                ),
                                                payWallController
                                                    .hyperLinksOptionsText(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .privacy_policy,
                                                        () {
                                                  var urlPrivacyPolicy = Uri.parse(
                                                      "https://eclixtech.com/privacy-policy");
                                                  launchUrl(urlPrivacyPolicy);
                                                }),
                                                VerticalDivider(
                                                  thickness: 2,
                                                  color: UiColors.whiteColor
                                                      .withOpacity(0.4),
                                                ),
                                                payWallController
                                                    .hyperLinksOptionsText(
                                                        // "Restore Purchase",
                                                        AppLocalizations.of(
                                                                context)!
                                                            .restore_purchase,
                                                        () {
                                                  payWallController
                                                      .restorePurchase(context);
                                                }),
                                              ],
                                            ),
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
                      )
                    ],
                  );
                })),
          ),
        );
      },
    );
  }

  Shimmer shimmerContainer(BuildContext context, double height, double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.4),
      highlightColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(32),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 12),
        width: width,
        height: height,
      ),
    );
  }

  Widget customLockColumn(String image) {
    return Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          // border: Border.all(),
          image: DecorationImage(
            image: AssetImage(
              "assets/$image.png",
            ),
          ),
        ));
  }

  Widget customRow(BuildContext context, String title, String image) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 25, 24, 24)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Image.asset(image),
        ),
        const SizedBox(
          width: 15,
        ),
        SizedBox(
          width: 260,
          child: Text(
            title,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                fontSize: 16,
                textStyle: TextStyle(
                  color: UiColors.whiteColor,
                )),
          ),
        ),
      ]),
    );
  }
}
