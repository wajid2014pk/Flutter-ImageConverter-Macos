import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    Timer(const Duration(milliseconds: 3000), () {
      Get.to(() => const HomeScreen(
            index: -1,
          ));
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: UiColors.whiteColor,
          image: const DecorationImage(
            image: AssetImage(
              'assets/splash_background_screen.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (BuildContext context, Widget? child) {
                return Opacity(
                  opacity: _logoAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/logo_icon.png',
                fit: BoxFit.fill,
                height: 100.0,
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(Get.context!)!.image,
                  // "Image Converter",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Manrope-Medium'),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  AppLocalizations.of(Get.context!)!.converter,
                  // "Image Converter",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Manrope-Medium'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
