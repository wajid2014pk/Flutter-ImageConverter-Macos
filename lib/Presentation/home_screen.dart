import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Controller/HomeScreenController/home_screen_controller.dart';
import 'package:image_converter_macos/Controller/PremiumPopUpController/premium_controller.dart';
import 'package:image_converter_macos/Presentation/history.dart';
import 'package:image_converter_macos/Presentation/select_file_screen.dart';
import 'package:image_converter_macos/Screens/feedback_screen.dart';
import 'package:image_converter_macos/Screens/premium_popup.dart';
import 'package:image_converter_macos/Screens/privacy_policy.dart';
import 'package:image_converter_macos/Screens/rate_us_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final int? index;
  const HomeScreen({super.key, this.index});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final homeScreenController = Get.put(HomeScreenController());
  final payWallController = Get.put(PayWallController());

  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    payWallController.offerings == null
        ? payWallController.getProductsPrice()
        : null;
    widget.index == -1 ? homeScreenController.showPremium() : null;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Adjust the duration as needed
    );

    animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabicOrPersianOrHebrew = [
      'ar',
      'fa',
      'he',
    ].contains(Localizations.localeOf(context).languageCode);
    return Scaffold(
      backgroundColor: UiColors.backgroundColor,
      // appBar: PreferredSize(
      //   preferredSize: const Size(double.infinity, 65),
      //   child: homeScreenController.customAppBar(context),
      // ),
      body: Row(
        children: [
          Obx(
            () => Container(
              width: 290,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
                color: UiColors.whiteColor,
                // border: Border.all()
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/logo_icon.png',
                              height: 32,
                              width: 32,
                            ),
                            sizedBoxWidth,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Image Converter",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Manrope-Bold',
                                      fontSize: 18),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    PremiumPopUp()
                                        .premiumScreenPopUp(Get.context!);
                                  },
                                  child: Text(
                                    "Version 11111",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        homeScreenController.divider(),
                        SizedBox(
                          height: 18,
                        ),
                        homeScreenController.sideBarItem(
                          "assets/home_new_icon.png",
                          AppLocalizations.of(Get.context!)!.home,
                          1,
                          context,
                        ),
                        // homeScreenController.divider(),
                        homeScreenController.sideBarItem(
                          "assets/recent_file_new_icon.png",
                          AppLocalizations.of(Get.context!)!.history,
                          2,
                          context,
                        ),
                        // homeScreenController.divider(),
                        homeScreenController.sideBarItem(
                          "assets/share_us_new_icon.png",
                          AppLocalizations.of(Get.context!)!.rate_us,
                          3,
                          context,
                        ),
                        // homeScreenController.divider(),
                        homeScreenController.sideBarItem(
                          "assets/rate_us_new_icon.png",
                          AppLocalizations.of(Get.context!)!.feedback,
                          4,
                          context,
                        ),
                        // homeScreenController.divider(),
                        homeScreenController.sideBarItem(
                          "assets/privacy_policy_new_icon.png",
                          AppLocalizations.of(Get.context!)!.privacy_policy,
                          5,
                          context,
                        ),
                        homeScreenController.sideBarItem(
                          "assets/about_image_new_icon.png",
                          AppLocalizations.of(Get.context!)!.privacy_policy,
                          5,
                          context,
                        ),
                        homeScreenController.sideBarItem(
                          "assets/feedback_new_icon.png",
                          AppLocalizations.of(Get.context!)!.privacy_policy,
                          5,
                          context,
                        ),
                        homeScreenController.sideBarItem(
                          "assets/more_apps_new_icon.png",
                          AppLocalizations.of(Get.context!)!.privacy_policy,
                          5,
                          context,
                        ),
                      ],
                    ),
                  ),
                  // const Spacer(),
                  // payWallController.isPro.value == false
                  //     ? GestureDetector(
                  //         onTap: () {
                  //           payWallController.offerings == null
                  //               ? payWallController.getProductsPrice()
                  //               : null;
                  //           payWallController.selectPackage.value = 1;
                  //           payWallController.offerings == null
                  //               ? Get.snackbar(
                  //                   backgroundColor: Colors.white,
                  //                   "Failed",
                  //                   "No Internet Connecion")
                  //               : payWallController.makePurchase();
                  //           // payWallController.makePurchase();
                  //           // PremiumPopUp().premiumScreenPopUp(context);
                  //         },
                  //         child: SizedBox(
                  //           height: 180,
                  //           child: Stack(
                  //             clipBehavior: Clip.none,
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.all(10),
                  //                 // Use Positioned.fill instead of Padding
                  //                 child: Container(
                  //                   width: 280,
                  //                   decoration: BoxDecoration(
                  //                     color: UiColors.lightblueColor,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                   ),
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.only(
                  //                         left: 12, right: 12, top: 10),
                  //                     child: Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.start,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           AppLocalizations.of(Get.context!)!
                  //                               .imagee,
                  //                           style: GoogleFonts.poppins(
                  //                               color: UiColors.whiteColor,
                  //                               fontSize: 18,
                  //                               fontWeight: FontWeight.w600),
                  //                         ),
                  //                         Text(
                  //                           AppLocalizations.of(Get.context!)!
                  //                               .converterr,
                  //                           style: GoogleFonts.poppins(
                  //                               color: UiColors.whiteColor,
                  //                               fontSize: 18,
                  //                               fontWeight: FontWeight.w600),
                  //                         ),
                  //                         Padding(
                  //                           padding:
                  //                               const EdgeInsets.only(top: 4.0),
                  //                           child: Container(
                  //                             decoration: BoxDecoration(
                  //                                 color: UiColors.whiteColor,
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(4)),
                  //                             child: Padding(
                  //                               padding: const EdgeInsets.only(
                  //                                   left: 7,
                  //                                   right: 7,
                  //                                   top: 2,
                  //                                   bottom: 2),
                  //                               child: Text(
                  //                                 AppLocalizations.of(
                  //                                         Get.context!)!
                  //                                     .proo,
                  //                                 style: GoogleFonts.poppins(
                  //                                     color:
                  //                                         UiColors.yellowColor,
                  //                                     fontSize: 14,
                  //                                     fontWeight:
                  //                                         FontWeight.w600),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         const Spacer(),
                  //                         Padding(
                  //                           padding: const EdgeInsets.only(
                  //                               bottom: 10),
                  //                           child: Container(
                  //                             width: 90,
                  //                             height: 28,
                  //                             decoration: BoxDecoration(
                  //                               color: UiColors.yellowColor,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(6),
                  //                             ),
                  //                             child: SizedBox(
                  //                               width: MediaQuery.of(context)
                  //                                       .size
                  //                                       .width /
                  //                                   1.2,
                  //                               child: Center(
                  //                                 child: Text(
                  //                                   AppLocalizations.of(
                  //                                           Get.context!)!
                  //                                       .upgrade,
                  //                                   maxLines: 1,
                  //                                   overflow:
                  //                                       TextOverflow.ellipsis,
                  //                                   style: GoogleFonts.poppins(
                  //                                       fontSize: 14,
                  //                                       color:
                  //                                           UiColors.whiteColor,
                  //                                       fontWeight:
                  //                                           FontWeight.w600),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                 right: isArabicOrPersianOrHebrew ? null : 1,
                  //                 left: isArabicOrPersianOrHebrew ? 1 : null,
                  //                 bottom: 10,
                  //                 child: Image.asset(
                  //                   "assets/Pro-Banner-Image.png",
                  //                   width: 185,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ))
                  //     : const SizedBox(),
                ],
              ),
            ),
          ),
          Obx(
            () => Expanded(
              flex: 4,
              child: Scaffold(
                body: homeScreenController.sideBarSelectedIndex.value == 1
                    ? const SelectFileScreen()
                    : homeScreenController.sideBarSelectedIndex.value == 2
                        ? const HistoryScreen()
                        : homeScreenController.sideBarSelectedIndex.value == 3
                            ? const RateUs()
                            : homeScreenController.sideBarSelectedIndex.value ==
                                    4
                                ? const FeedBack()
                                : homeScreenController
                                            .sideBarSelectedIndex.value ==
                                        5
                                    ? const PrivacyPolicy()
                                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
