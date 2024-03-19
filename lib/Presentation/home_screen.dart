import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/HomeScreenController/home_screen_controller.dart';
import 'package:image_converter_macos/Presentation/history.dart';
import 'package:image_converter_macos/Presentation/select_file_screen.dart';
import 'package:image_converter_macos/Screens/premium_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final homeScreenController = Get.put(HomeScreenController());

  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
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
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 65),
        child: homeScreenController.customAppBar(context),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Obx(
              () => Container(
                decoration: BoxDecoration(color: UiColors.whiteColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: isArabicOrPersianOrHebrew ? 0 : 20,
                        right: isArabicOrPersianOrHebrew ? 20 : 0,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          homeScreenController.sideBarItem(
                            "assets/Home.png",
                            "Home",
                            1,
                            context,
                          ),
                          homeScreenController.divider(),
                          homeScreenController.sideBarItem(
                            "assets/History.png",
                            "History",
                            2,
                            context,
                          ),
                          homeScreenController.divider(),
                          homeScreenController.sideBarItem(
                            "assets/Setting.png",
                            "Setting",
                            3,
                            context,
                          ),
                          homeScreenController.divider(),
                          homeScreenController.sideBarItem(
                            "assets/Star.png",
                            "Rate Us",
                            4,
                            context,
                          ),
                          homeScreenController.divider(),
                          homeScreenController.sideBarItem(
                            "assets/Feedback.png",
                            "Feedback",
                            5,
                            context,
                          ),
                          homeScreenController.divider(),
                          homeScreenController.sideBarItem(
                            "assets/Privacy Policy.png",
                            "Privacy Policy",
                            6,
                            context,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        PremiumPopUp().premiumScreenPopUp(context);
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            child: Expanded(
                              child: Container(
                                height: 170,
                                width: MediaQuery.of(context).size.width / 5.2,
                                decoration: BoxDecoration(
                                  color: UiColors.lightblueColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Positioned(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "IMAGE",
                                          style: GoogleFonts.poppins(
                                              color: UiColors.whiteColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "CONVERTER",
                                          style: GoogleFonts.poppins(
                                              color: UiColors.whiteColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: UiColors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text(
                                              "PRO",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.orange,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Container(
                                            width: 90,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: UiColors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              child: Center(
                                                child: Text(
                                                  "Upgrade",
                                                  // AppLocalizations.of(context)!
                                                  //     .upgrade,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: const Color(
                                                          0xFFC1041A),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // top: 5,
                            right: isArabicOrPersianOrHebrew ? null : 1,
                            left: isArabicOrPersianOrHebrew ? 1 : null,
                            bottom: 10,
                            child: Image.asset(
                              "assets/Pro-Banner-Image.png",
                              width: 200,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // ),
          Obx(
            () => Expanded(
              flex: 4,
              child: Scaffold(
                body: homeScreenController.sideBarSelectedIndex.value == 1
                    ? const SelectFileScreen()
                    : homeScreenController.sideBarSelectedIndex.value == 2
                        ? const HistoryScreen()
                        : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
