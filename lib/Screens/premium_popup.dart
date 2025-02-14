import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
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
          surfaceTintColor: UiColors.whiteColor,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Container(
            width: Get.width / 1.4,
            height: Get.height / 1.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: const DecorationImage(
                image: AssetImage(
                  'assets/paywall_background.png',
                ), // Replace with your image path
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.close))
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 52),
                    child: Row(
                      children: [
                        Expanded(
                          // flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: SizedBox(
                                        width: 190,
                                        child: Text(
                                          AppLocalizations.of(Get.context!)!
                                              .image_converter,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 22,
                                              fontFamily: 'Manrope-Medium',
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 4,
                                          bottom: 4),
                                      decoration: BoxDecoration(
                                        gradient:
                                            UiColors().linearGradientBlueColor,
                                        borderRadius: BorderRadius.circular(30),
                                        // color: UiColors.blueColorNew,
                                      ),
                                      child: Row(
                                        children: [
                                          // SvgPicture.asset(AppAssets.diamond),
                                          Center(
                                            child: SizedBox(
                                              width: 36,
                                              child: Text(
                                                // "PRO",
                                                AppLocalizations.of(
                                                        Get.context!)!
                                                    .pro,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 50.0),
                                  child: CarouselWidget(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  payWallController.selectPackage.value = 0;
                                },
                                child: premiumWidget(
                                    // "Monthly",
                                    AppLocalizations.of(Get.context!)!.monthly,
                                    payWallController
                                        .offerings!
                                        .current!
                                        .availablePackages[4]
                                        .storeProduct
                                        .currencyCode,
                                    payWallController.getActualPrice(
                                        payWallController
                                            .offerings!
                                            .current!
                                            .availablePackages[4]
                                            .storeProduct
                                            .price,
                                        30),
                                    payWallController.formatPrice(
                                      payWallController
                                          .offerings!
                                          .current!
                                          .availablePackages[4]
                                          .storeProduct
                                          .price,
                                    ),
                                    "30 %",
                                    0,
                                    // 'OFF'
                                    AppLocalizations.of(Get.context!)!.off),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  payWallController.selectPackage.value = 1;
                                },
                                child: premiumWidget(
                                    // "Yearly",
                                    AppLocalizations.of(Get.context!)!.yearly,
                                    payWallController
                                        .offerings!
                                        .current!
                                        .availablePackages[3]
                                        .storeProduct
                                        .currencyCode,
                                    payWallController.getActualPrice(
                                        payWallController
                                            .offerings!
                                            .current!
                                            .availablePackages[3]
                                            .storeProduct
                                            .price,
                                        66),
                                    payWallController.formatPrice(
                                      payWallController
                                          .offerings!
                                          .current!
                                          .availablePackages[3]
                                          .storeProduct
                                          .price,
                                    ),
                                    "66 %",
                                    1,
                                    // 'OFF'
                                    AppLocalizations.of(Get.context!)!.off),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  payWallController.selectPackage.value = 2;
                                },
                                child: premiumWidget(
                                    // "LifeTime",
                                    AppLocalizations.of(Get.context!)!.lifetime,
                                    payWallController
                                        .offerings!
                                        .current!
                                        .availablePackages[5]
                                        .storeProduct
                                        .currencyCode,
                                    payWallController.getActualPrice(
                                        payWallController
                                            .offerings!
                                            .current!
                                            .availablePackages[5]
                                            .storeProduct
                                            .price,
                                        58),
                                    payWallController.formatPrice(
                                      payWallController
                                          .offerings!
                                          .current!
                                          .availablePackages[5]
                                          .storeProduct
                                          .price,
                                    ),
                                    "58 %",
                                    2,
                                    // 'OFF'
                                    AppLocalizations.of(Get.context!)!.off
                                    //  "USD", "12",
                                    //     "9.99", "50 %", 2, 'OFF'

                                    ),
                              ),
                              SizedBox(
                                height: 42,
                              ),
                              Obx(
                                () => payWallController.selectPackage.value == 2
                                    ? SizedBox()
                                    : Text(
                                        // "No Commitment, Cancel Anytime",
                                        AppLocalizations.of(Get.context!)!
                                            .no_commitment_cancel_anytime,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800),
                                      ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  payWallController.makePurchase();
                                },
                                child: Container(
                                  height: 42,
                                  width: 200,
                                  padding: EdgeInsets.symmetric(horizontal: 22),
                                  decoration: BoxDecoration(
                                      gradient:
                                          UiColors().linearGradientBlueColor,
                                      // border: Border.all(color: Colors.green),
                                      color: UiColors.blueColorNew,
                                      borderRadius: BorderRadius.circular(32)),
                                  child: Center(
                                    child: Text(
                                      // "Subscribe",
                                      AppLocalizations.of(Get.context!)!
                                          .subscribe,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Manrope-Medium',
                                          color: UiColors.whiteColor),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        launchURLFunction(
                                            "www.eclixtech.com/privacy-policy");
                                      });
                                    },
                                    child: Text(
                                      // "Privacy Policy",
                                      AppLocalizations.of(Get.context!)!
                                          .privacy_policy,
                                      style: TextStyle(
                                        color: UiColors.newGreyColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  sizedBoxWidth,
                                  Container(
                                    height: 18,
                                    width: 1,
                                    decoration: BoxDecoration(
                                        color: UiColors.newGreyColor),
                                  ),
                                  sizedBoxWidth,
                                  GestureDetector(
                                    onTap: () async {
                                      await payWallController
                                          .restorePurchase(Get.context!);
                                    },
                                    child: Text(
                                      // "Restore",
                                      AppLocalizations.of(Get.context!)!
                                          .restore,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: UiColors.newGreyColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Obx premiumWidget(String text, String currency, String cutPrice,
      String actualPrice, String offText, int index, String off) {
    return Obx(
      () => Container(
        width: Get.width * 0.27,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
            border: payWallController.selectPackage.value == index
                ? Border.all(color: UiColors.blueColorNew, width: 2)
                : null,
            color: UiColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  blurRadius: 12,
                  color: payWallController.selectPackage.value != index
                      ? Colors.black.withOpacity(0.2)
                      : UiColors.blueColorNew.withOpacity(0.2))
            ],
            // border: Border.all(),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    // fontFamily: 'Manrope-Medium',
                    fontWeight: payWallController.selectPackage.value == index
                        ? FontWeight.bold
                        : FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "$currency $cutPrice",
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: UiColors.newGreyColor),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "$currency $actualPrice",
                  style: TextStyle(
                      color: payWallController.selectPackage.value == index
                          ? UiColors.blueColorNew
                          : UiColors.blackColor,
                      fontFamily:
                          // 'Manrope-Bold',
                          payWallController.selectPackage.value == index
                              ? 'Manrope-Bold'
                              : 'Manrope-Medium',
                      fontWeight: payWallController.selectPackage.value == index
                          ? FontWeight.w800
                          : FontWeight.w800,
                      fontSize: 16),
                ),
                sizedBoxWidth,
                Container(
                  height: 52,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: payWallController.selectPackage.value == index
                          ? UiColors.blueColorNew.withOpacity(0.2)
                          : UiColors.newGreyColor.withOpacity(0.2)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          offText,
                          // "Basic",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Text(
                          off,
                          // "Basic",
                          style: TextStyle(
                              fontWeight:
                                  payWallController.selectPackage.value == index
                                      ? FontWeight.w400
                                      : FontWeight.w500,
                              fontSize: 14),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  launchURLFunction(String url) async {
    final Uri params = Uri(
      scheme: 'https',
      path: url,
    );
    launchUrl(params);
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
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          // border: Border.all(),
          image: DecorationImage(
            image: AssetImage(
              "assets/$image.png",
            ),
          ),
        ));
  }
}

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  // ignore:
  CarouselWidgetState createState() => CarouselWidgetState();
}

class CarouselWidgetState extends State<CarouselWidget> {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  final List<String> _images = [
    'assets/premium_1.png',
    'assets/premium_2.png',
    'assets/premium_3.png',
    'assets/premium_4.png',
    'assets/premium_5.png',
    'assets/premium_6.png',
    'assets/premium_7.png',
    'assets/premium_8.png',
    'assets/premium_9.png',
  ];

  final List<String> _texts = [
    AppLocalizations.of(Get.context!)!.unlimited_conversions,
    '',
    AppLocalizations.of(Get.context!)!.access_to_all_formats,
    AppLocalizations.of(Get.context!)!.batch_conversion,
    '',
    AppLocalizations.of(Get.context!)!.ad_free_experience,
    '',
    AppLocalizations.of(Get.context!)!.priority_customer_support,
    AppLocalizations.of(Get.context!)!.regular_updates,
  ];
  final List<String> subText = [
    // 'Convert images without any restrictions on the number of conversions you can perform.',
    AppLocalizations.of(Get.context!)!
        .convert_images_without_any_restrictions_on,
    '',
    // 'Convert to and from a wide variety of formats including PDF, DOC, EXCEL, WEBP, and more.',
    AppLocalizations.of(Get.context!)!.convert_to_and_from_a_wide_variety_of,
    // 'Convert multiple images at once to save time and increase productivity.',
    AppLocalizations.of(Get.context!)!.convert_multiple_images_at_once_to,
    '',
    // 'Enjoy a seamless and distraction-free experience without any advertisements.',
    AppLocalizations.of(Get.context!)!
        .enjoy_a_seamless_and_distraction_free_experience,
    '',
    // 'Receive top-priority support from our dedicated team to resolve any issues quickly.',
    AppLocalizations.of(Get.context!)!
        .receive_top_priority_support_from_our_dedicated_team,
    // 'Stay updated with the latest features, improvements, and new formats with regular updates.',
    AppLocalizations.of(Get.context!)!.stay_updated_with_the_latest_features,

    // AppLocalizations.of(Get.context!)!.detailed_explanations_for_solving,
    // AppLocalizations.of(Get.context!)!.lightning_fast_solutions_for_multiple,
    // AppLocalizations.of(Get.context!)!
    //     .support_for_higher_level_math_like_calculas,
    // AppLocalizations.of(Get.context!)!.faster_customer_support_for_premium,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            carouselController: carouselController,
            itemCount: _images.length,
            itemBuilder: (context, index, realIndex) {
              return (index == 1 || index == 4 || index == 6)
                  ? Image.asset(
                      _images[index],
                      // "assets/images/123.png",
                      fit: BoxFit.contain,
                      // color: Colors.red,
                      // height: 100,
                    )
                  : Column(
                      children: [
                        Image.asset(
                          _images[index],
                          // "assets/images/123.png",
                          fit: BoxFit.cover,
                          // color: Colors.red,
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 230,
                          child: Center(
                            child: Text(
                              _texts[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  // color: Colors.red,
                                  fontSize: 18,
                                  fontFamily: 'Manrope-Medium',
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Center(
                            child: Text(
                              subText[index],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF757575),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            },
            options: CarouselOptions(
              height: 200,
              viewportFraction: 1,

              // enlargeCenterPage: true,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: 12,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(22),
                    color: _currentIndex == entry.key
                        ? UiColors.blueColorNew
                        : Colors.grey,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
