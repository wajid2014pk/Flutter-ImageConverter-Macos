import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/HomeScreenController/home_screen_controller.dart';
import 'package:image_converter_macos/Presentation/history.dart';
import 'package:image_converter_macos/Presentation/select_file_screen.dart';

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
                child: Padding(
                  padding: EdgeInsets.only(
                    left: isArabicOrPersianOrHebrew ? 0 : 20,
                    right: isArabicOrPersianOrHebrew ? 20 : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
