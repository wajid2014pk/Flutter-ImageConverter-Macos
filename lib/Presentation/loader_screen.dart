import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/resize_image_controller/resize_image_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen>
    with SingleTickerProviderStateMixin {
  final resizedController = Get.put(ResizeImageController());

  @override
  void initState() {
    resizedController.loadingState.value = true;
    print(
        "resizedController.loadingState.value ${resizedController.loadingState.value}");
    resizedController.controller = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 10), // Adjust the speed of progress animation
    );
    resizedController.progressAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(resizedController.controller!)
      ..addListener(() {
        resizedController.infiniteProgress.value =
            resizedController.progressAnimation!.value;
        setState(() {});
      });

    resizedController.controller!.repeat(reverse: false);

    Future.delayed(const Duration(seconds: 2), () async {
      resizeImage();
      print(
          "resizedController.resizeOption.value ${resizedController.resizeOption.value}");
      print(
          "resizedController.selectedResizeType.value ${resizedController.selectedResizeType.value}");
    });
    super.initState();
  }

  @override
  void dispose() {
    resizedController.controller!.dispose();
    super.dispose();
  }

  resizeImage() {
    if (resizedController.resizeOption.value == 'Quality') {
      if (resizedController.selectedResizeType.value == 'Custom') {
        if (resizedController.widthController.text.isNotEmpty &&
            resizedController.heightController.text.isNotEmpty) {
          resizedController.loadingState.value = true;
          resizedController.resizeByDimensions();
        } else {
          Get.snackbar(AppLocalizations.of(context)!.attention,
              "Please enter a valid URL!");
        }
      } else if (resizedController.selectedResizeType.value ==
          'Reduce By Quality') {
        resizedController.loadingState.value = true;
        resizedController.resizeByDimensions();
      }
    } else if (resizedController.resizeOption.value == 'Percentage') {
      print(
          "resizedController.selectedPercentageDimensions ${resizedController.selectedPercentageDimensions}");
      if (resizedController.selectedPercentageDimensions!.isNotEmpty) {
        resizedController.loadingState.value = true;
        resizedController.resizeByDimensions();
      } else {
        print("Select a valid percentage!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: Obx(
              () => Stack(
                alignment: Alignment.center,
                children: [
                  CircularPercentIndicator(
                    backgroundColor: Colors.black.withOpacity(0.1),
                    radius: 120.0,
                    lineWidth: 8.0,
                    percent: resizedController.infiniteProgress.value,
                    progressColor: UiColors.blueColor,
                  ),
                  Positioned(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: UiColors.blueColor.withOpacity(0.1),
                                spreadRadius: 4,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 1.5), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(256),
                          ),
                        ),
                        Positioned(
                          child: Obx(
                            () => Image.asset(
                              resizedController.infiniteProgress.value >= 0.96
                                  ? "assets/Complete.png"
                                  : "assets/Processing.png",
                              height: 70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Obx(
            () => Text(
              resizedController.infiniteProgress.value >= 0.88 &&
                      resizedController.infiniteProgress.value <= 0.9
                  ? AppLocalizations.of(context)!.your_file_is_converting
                  : AppLocalizations.of(context)!.your_file_is_converting,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
