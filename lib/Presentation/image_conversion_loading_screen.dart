import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_converter_macos/Constant/color.dart';

import 'package:image_converter_macos/Controller/convert_images_controller.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constant/global.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as im;

class ImageConversionLoadingScreen extends StatefulWidget {
  final List<String>? imagePath;
  const ImageConversionLoadingScreen({super.key, this.imagePath});

  @override
  State<ImageConversionLoadingScreen> createState() =>
      _ImageConversionLoadingScreenState();
}

class _ImageConversionLoadingScreenState
    extends State<ImageConversionLoadingScreen>
    with SingleTickerProviderStateMixin {
  final conversionController = Get.put(ConvertImagesController());

  AnimationController? controller;
  Animation<double>? progressAnimation;
  RxDouble infiniteProgress = 0.0.obs;

  List<String> shortenedFileNameMulti = [];
  RxDouble withoutApiProgressValue = 0.0.obs;
  RxBool isTimerComplete = false.obs;
  @override
  void initState() {
    super.initState();

    print("778899 ${conversionController.selectedIndex.value}");

    controller = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 10), // Adjust the speed of progress animation
    );
    progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(controller!)
      ..addListener(() {
        infiniteProgress.value = progressAnimation!.value;
        setState(() {});
      });

    controller!.repeat(reverse: false);
    Timer(const Duration(seconds: 9), () {
      isTimerComplete.value = true;
    });
    Future.delayed(const Duration(milliseconds: 1000), () async {
     
      await conversionMethod();
    });
  }

  // Future incrementValue() async {
  //   withoutApiProgressValue.value = 0.0;
  //   await Future.delayed(Duration(milliseconds: 100), () async {
  //     for (int i = 0; i < 10; i++) {
  //       if (conversionController.showLoader.value == false) {
  //         print("Condition met, breaking the loop");
  //         break;
  //       }
  //       await Future.delayed(Duration(milliseconds: 100), () {
  //         withoutApiProgressValue.value = (withoutApiProgressValue.value + 0.1)
  //             .clamp(0.0, 0.9); // Ensuring it doesn't exceed 0.9

  //         print("value.value ${withoutApiProgressValue.value}");
  //       });
  //     }
  //   });
  // }

  openDropDownAutomatically() async {
    Future.delayed(const Duration(milliseconds: 1), () {
      conversionController.conversionOptionList(
          Get.context!, widget.imagePath!);
    });
  }

  @override
  Widget build(BuildContext context) {
    // String fileName = widget.imagePath != null
    //     ? File(widget.imagePath![0]).uri.pathSegments.last
    //     : "File Name";

    // String shortenedFileName = fileName.length <= 15
    //     ? fileName
    //     : '${fileName.substring(0, 13)}...${fileName.substring(fileName.length - 10)}';
    for (int i = 0; i < widget.imagePath!.length; i++) {
      String fileNameMultiImage = widget.imagePath != null
          ? File(widget.imagePath![i]).uri.pathSegments.last
          : "File Name";
      // AppLocalizations.of(Get.context!)!.file_name;

      shortenedFileNameMulti.add(fileNameMultiImage.length <= 15
          ? fileNameMultiImage
          : '${fileNameMultiImage.substring(0, 13)}...${fileNameMultiImage.substring(fileNameMultiImage.length - 10)}');
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Obx(
            () => Column(
              children: [
                // if (!isPremium.value) const SafeArea(child: ICBannerAd()),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          (isTimerComplete.value)
                              ? InkWell(
                                  onTap: () {
                                    conversionController.isError.value = true;
                                    Get.offAll(() => const HomeScreen(
                                          index: 1,
                                        ));
                                    // if (isTapOnCamera.value == true) {
                                    //   conversionController.isError.value = true;
                                    //   Get.offAll(() => const BottomNavBar());
                                    // } else {
                                    //   conversionController.isError.value = true;
                                    //   Get.offAll(() => const BottomNavBar());
                                    // }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: UiColors.greyColor
                                            .withOpacity(0.5)),
                                    padding: EdgeInsets.all(8),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(left: 12, top: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: Colors.transparent,
                                      )
                                    ],
                                  ),
                                ),
                          sizedBoxWidth,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  infiniteProgress.value >= 0.96
                                      ? "Completed"
                                      // AppLocalizations.of(Get.context!)!
                                      //     .completed
                                      : "In Progress",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 26),
                                ),
                              ),
                              Obx(
                                () => Text(
                                  infiniteProgress.value >= 0.96
                                      ?
                                      // AppLocalizations.of(Get.context!)!
                                      //     .your_file_is_converted
                                      "Your file is converted"
                                      : AppLocalizations.of(Get.context!)!
                                          .your_file_is_converting,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 32,
                ),
                conversionController.loadingState.value == false ||
                        svgAndBmpApi.value
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Center(
                              child: Obx(
                                () => Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularPercentIndicator(
                                      backgroundColor:
                                          Colors.black.withOpacity(0.1),
                                      radius: 120.0,
                                      lineWidth: 8.0,
                                      percent: infiniteProgress.value,
                                      progressColor: UiColors.blueColorNew,
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
                                                  color: UiColors.blueColorNew
                                                      .withOpacity(0.1),
                                                  spreadRadius: 4,
                                                  blurRadius: 7,
                                                  offset: const Offset(0,
                                                      1.5), // changes position of shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(256),
                                            ),
                                          ),
                                          Obx(
                                            () => (conversionController
                                                            .selectedIndex
                                                            .value ==
                                                        9 ||
                                                    conversionController
                                                            .selectedIndex
                                                            .value ==
                                                        8 ||
                                                    conversionController
                                                            .selectedIndex
                                                            .value ==
                                                        11)
                                                ? Image.asset(
                                                    "assets/Processing.png",
                                                    height: 70,
                                                  )
                                                : Positioned(
                                                    child: Obx(
                                                      () => Image.asset(
                                                        infiniteProgress
                                                                    .value >=
                                                                0.96
                                                            ? "assets/Complete.png"
                                                            : "assets/Processing.png",
                                                        height: 70,
                                                      ),
                                                    ),
                                                  ),
                                          )
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
                            Text(
                              // AppLocalizations.of(context)!.converting,

                              "Converting",
                              // (conversionController.selectedIndex.value ==
                              //             9 ||
                              //         conversionController
                              //                 .selectedIndex.value ==
                              //             8 ||
                              //         conversionController
                              //                 .selectedIndex.value ==
                              //             11)
                              //     ? ''
                              //     : infiniteProgress.value >= 0.96
                              //         ? AppLocalizations.of(Get.context!)!
                              //             .your_file_is_converted
                              //         : AppLocalizations.of(context)!
                              //             .your_file_is_converting,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              // AppLocalizations.of(context)!
                              //     .your_file_will_be_ready_shortly,
                              "Your File will be ready shortly",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Center(
                              child: Obx(
                                () => Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularPercentIndicator(
                                      backgroundColor:
                                          Colors.black.withOpacity(0.1),
                                      radius: 120.0,
                                      lineWidth: 8.0,
                                      percent: infiniteProgress.value,
                                      progressColor: UiColors.blueColorNew,
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
                                                  color: UiColors.blueColorNew
                                                      .withOpacity(0.1),
                                                  spreadRadius: 4,
                                                  blurRadius: 7,
                                                  offset: const Offset(0,
                                                      1.5), // changes position of shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(256),
                                            ),
                                          ),
                                          Obx(
                                            () => (conversionController
                                                            .selectedIndex
                                                            .value ==
                                                        9 ||
                                                    conversionController
                                                            .selectedIndex
                                                            .value ==
                                                        8 ||
                                                    conversionController
                                                            .selectedIndex
                                                            .value ==
                                                        11)
                                                ? Image.asset(
                                                    "assets/Processing.png",
                                                    height: 70,
                                                  )
                                                : Positioned(
                                                    child: Obx(
                                                      () => Image.asset(
                                                        infiniteProgress
                                                                    .value >=
                                                                0.96
                                                            ? "assets/Complete.png"
                                                            : "assets/Processing.png",
                                                        height: 70,
                                                      ),
                                                    ),
                                                  ),
                                          )
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
                            Text(
                              // AppLocalizations.of(context)!.converting,
                              "Converting",
                              // (conversionController.selectedIndex.value ==
                              //             9 ||
                              //         conversionController
                              //                 .selectedIndex.value ==
                              //             8 ||
                              //         conversionController
                              //                 .selectedIndex.value ==
                              //             11)
                              //     ? ''
                              //     : infiniteProgress.value >= 0.96
                              //         ? AppLocalizations.of(Get.context!)!
                              //             .your_file_is_converted
                              //         : AppLocalizations.of(context)!
                              //             .your_file_is_converting,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              // AppLocalizations.of(context)!
                              //     .your_file_will_be_ready_shortly,
                              "Your File will be ready shortly",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Obx(
                            //   () => (conversionController
                            //                   .selectedIndex.value ==
                            //               9 ||
                            //           conversionController
                            //                   .selectedIndex.value ==
                            //               8 ||
                            //           conversionController
                            //                   .selectedIndex.value ==
                            //               11)
                            //       ? const SizedBox()
                            //       : Obx(
                            //           () => Text(
                            //             infiniteProgress.value >= 0.88 &&
                            //                     infiniteProgress.value <= 0.9
                            //                 ? AppLocalizations.of(Get.context!)!
                            //                     .your_file_is_converting
                            //                 : AppLocalizations.of(context)!
                            //                     .your_file_is_converting,
                            //             style: GoogleFonts.poppins(
                            //               fontSize: 18,
                            //               fontWeight: FontWeight.w500,
                            //             ),
                            //           ),
                            //         ),
                            // ),
                            const Spacer(),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  conversionMethod() async {
    // int toolValue = await SharedPref().getToolValue();

    // int webpValue = await SharedPref().getWEBPValue();
    // int svgValue = await SharedPref().getSVGValue();
    // CustomEvent.firebaseCustom('OUTPUT_FORMAT_SCREEN_CONVERT_FILES_BTN');
    print("RERETTTTT ${conversionController.selectedIndex.value}");
    if (conversionController.selectedIndex.value == 10) {
      // ++toolValue;
      // await SharedPref().setToolValue(toolValue);
      // if (pdfValue <= 10 || isPremium.value) {
      try {
        if (conversionController.selectedIndex.value == 0) {
          Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            // AppLocalizations.of(Get.context!)!
            //     .please_select_an_option_in_which_you_want_to_convert,
            "Please select an option",
          );
          conversionController.conversionOptionList(
              Get.context!, widget.imagePath!);
        }

        // await loopFunction();
        if (widget.imagePath![0].toLowerCase().endsWith('.jpg') ||
            widget.imagePath![0].toLowerCase().endsWith('.jpeg')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertJpgToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertJpgToPdfMulti(
                      Get.context!, widget.imagePath)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertJpgToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertJpgToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertJpgToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertJpgToBMPMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.png')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertPngToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertPngToPdfMulti(
                      Get.context!, widget.imagePath)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertPngToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertPngToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertPngToJPEGMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertPngToBMPMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.gif')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertGifToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertGifToPdfMulti(
                      Get.context!, widget.imagePath!)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertGifToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertGifToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertGifToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertGifToBmpMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.bmp')) {
          print("@@@@BMP");
          conversionController.selectedIndex.value == 1
              ? conversionController.convertBmpToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertBmpToPdfMulti(
                      Get.context!, widget.imagePath!)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertBmpToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertBmpToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertBmpToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertBmpToBmpMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.tiff') ||
            widget.imagePath![0].toLowerCase().endsWith('.tif')) {
          print("@@@@tif");
          conversionController.selectedIndex.value == 1
              ? conversionController.convertTifToJpg(
                  Get.context!, widget.imagePath![0])
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertTifToPdf(
                      Get.context!, widget.imagePath![0])
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertTifToPng(
                          Get.context!, widget.imagePath![0])
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertTiffToGif(
                                  Get.context!, widget.imagePath![0])
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertTiffToJpeg(
                                      Get.context!, widget.imagePath![0])
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController.convertTiffToBmp(
                                          Get.context!, widget.imagePath![0])
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.heic')) {
          print("@@@@heic");

          conversionController.convertingIntoDiffFormatsMulti(
            Get.context!,
            widget.imagePath!,
            widget.imagePath!
                .map((filePath) =>
                    path.extension(filePath).replaceFirst('.', ''))
                .toList(),
            conversionController.selectedIndex.value == 1
                ? 'jpg'
                : conversionController.selectedIndex.value == 2
                    ? 'gif'
                    : conversionController.selectedIndex.value == 3
                        ? 'jpeg'
                        : conversionController.selectedIndex.value == 4
                            ? 'png'
                            : conversionController.selectedIndex.value == 5
                                ? 'svg'
                                : conversionController.selectedIndex.value == 6
                                    ? 'webp'
                                    : conversionController
                                                .selectedIndex.value ==
                                            7
                                        ? 'bmp'
                                        : conversionController
                                                    .selectedIndex.value ==
                                                8
                                            ? 'doc'
                                            : conversionController
                                                        .selectedIndex.value ==
                                                    9
                                                ? 'txt'
                                                : conversionController
                                                            .selectedIndex
                                                            .value ==
                                                        10
                                                    ? 'pdf'
                                                    : conversionController
                                                                .selectedIndex
                                                                .value ==
                                                            11
                                                        ? 'xls'
                                                        : 'heic',
          );
        }
      } catch (e) {
        Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            // AppLocalizations.of(Get.context!)!
            //     .please_try_again_after_some_time
            "Please try again after some time");
      }
      // }
      // else {
      //   Get.to(() => const PremiumPage());
      // }
    } else if (conversionController.selectedIndex.value == 6) {
      // int webp = await SharedPref().getWEBPValue();

      // ++webp;
      // await SharedPref().setWEBPValue(webp);
      // await SharedPref().setToolValue(toolValue);
      // if (webpValue <= 10 || isPremium.value) {
      try {
        if (conversionController.selectedIndex.value == 0) {
          Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            // AppLocalizations.of(Get.context!)!
            //     .please_select_an_option_in_which_you_want_to_convert,
            "Please select an option in which you want to convert",
          );
          conversionController.conversionOptionList(
              Get.context!, widget.imagePath!);
        }

        // await loopFunction();
        if (widget.imagePath![0].toLowerCase().endsWith('.jpg') ||
            widget.imagePath![0].toLowerCase().endsWith('.jpeg')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertJpgToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertJpgToPdfMulti(
                      Get.context!, widget.imagePath)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertJpgToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertJpgToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertJpgToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertJpgToBMPMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.png')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertPngToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertPngToPdfMulti(
                      Get.context!, widget.imagePath)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertPngToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertPngToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertPngToJPEGMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertPngToBMPMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.gif')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertGifToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertGifToPdfMulti(
                      Get.context!, widget.imagePath!)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertGifToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertGifToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertGifToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertGifToBmpMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.bmp')) {
          print("@@@@BMP");
          conversionController.selectedIndex.value == 1
              ? conversionController.convertBmpToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertBmpToPdfMulti(
                      Get.context!, widget.imagePath!)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertBmpToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertBmpToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertBmpToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertBmpToBmpMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.tiff') ||
            widget.imagePath![0].toLowerCase().endsWith('.tif')) {
          print("@@@@tif");
          conversionController.selectedIndex.value == 1
              ? conversionController.convertTifToJpg(
                  Get.context!, widget.imagePath![0])
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertTifToPdf(
                      Get.context!, widget.imagePath![0])
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertTifToPng(
                          Get.context!, widget.imagePath![0])
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertTiffToGif(
                                  Get.context!, widget.imagePath![0])
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertTiffToJpeg(
                                      Get.context!, widget.imagePath![0])
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController.convertTiffToBmp(
                                          Get.context!, widget.imagePath![0])
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.heic')) {
          print("@@@@heic");

          conversionController.convertingIntoDiffFormatsMulti(
            Get.context!,
            widget.imagePath!,
            widget.imagePath!
                .map((filePath) =>
                    path.extension(filePath).replaceFirst('.', ''))
                .toList(),
            conversionController.selectedIndex.value == 1
                ? 'jpg'
                : conversionController.selectedIndex.value == 2
                    ? 'gif'
                    : conversionController.selectedIndex.value == 3
                        ? 'jpeg'
                        : conversionController.selectedIndex.value == 4
                            ? 'png'
                            : conversionController.selectedIndex.value == 5
                                ? 'svg'
                                : conversionController.selectedIndex.value == 6
                                    ? 'webp'
                                    : conversionController
                                                .selectedIndex.value ==
                                            7
                                        ? 'bmp'
                                        : conversionController
                                                    .selectedIndex.value ==
                                                8
                                            ? 'doc'
                                            : conversionController
                                                        .selectedIndex.value ==
                                                    9
                                                ? 'txt'
                                                : conversionController
                                                            .selectedIndex
                                                            .value ==
                                                        10
                                                    ? 'pdf'
                                                    : conversionController
                                                                .selectedIndex
                                                                .value ==
                                                            11
                                                        ? 'xls'
                                                        : 'heic',
          );
        }
      } catch (e) {
        Get.snackbar(
          backgroundColor: UiColors.whiteColor,
          duration: const Duration(seconds: 4),
          AppLocalizations.of(Get.context!)!.attention,
          // AppLocalizations.of(Get.context!)!
          //     .please_try_again_after_some_time
          "Please try again after some time",
        );
      }
      // } else {
      //   Get.to(() => const PremiumPage());
      // }
    } else if (conversionController.selectedIndex.value == 5) {
      // ++toolValue;
      // await SharedPref().setToolValue(toolValue);
      // int svgLimit = await SharedPref().getSVGValue();

      // ++svgLimit;
      // await SharedPref().setSVGValue(svgLimit);
      // if (svgValue <= 10 || isPremium.value) {
      try {
        if (conversionController.selectedIndex.value == 0) {
          Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            // AppLocalizations.of(Get.context!)!
            //     .please_select_an_option_in_which_you_want_to_convert,
            "Please select an option",
          );
          conversionController.conversionOptionList(
              Get.context!, widget.imagePath!);
        }

        // await loopFunction();
        if (widget.imagePath![0].toLowerCase().endsWith('.jpg') ||
            widget.imagePath![0].toLowerCase().endsWith('.jpeg')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertJpgToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertJpgToPdfMulti(
                      Get.context!, widget.imagePath)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertJpgToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertJpgToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertJpgToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertJpgToBMPMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.png')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertPngToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertPngToPdfMulti(
                      Get.context!, widget.imagePath)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertPngToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertPngToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertPngToJPEGMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertPngToBMPMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.gif')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertGifToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertGifToPdfMulti(
                      Get.context!, widget.imagePath!)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertGifToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertGifToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertGifToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertGifToBmpMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.bmp')) {
          print("@@@@BMP");
          conversionController.selectedIndex.value == 1
              ? conversionController.convertBmpToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertBmpToPdfMulti(
                      Get.context!, widget.imagePath!)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertBmpToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertBmpToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertBmpToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertBmpToBmpMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.tiff') ||
            widget.imagePath![0].toLowerCase().endsWith('.tif')) {
          print("@@@@tif");
          conversionController.selectedIndex.value == 1
              ? conversionController.convertTifToJpg(
                  Get.context!, widget.imagePath![0])
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertTifToPdf(
                      Get.context!, widget.imagePath![0])
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertTifToPng(
                          Get.context!, widget.imagePath![0])
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertTiffToGif(
                                  Get.context!, widget.imagePath![0])
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertTiffToJpeg(
                                      Get.context!, widget.imagePath![0])
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController.convertTiffToBmp(
                                          Get.context!, widget.imagePath![0])
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.heic')) {
          print("@@@@heic");

          conversionController.convertingIntoDiffFormatsMulti(
            Get.context!,
            widget.imagePath!,
            widget.imagePath!
                .map((filePath) =>
                    path.extension(filePath).replaceFirst('.', ''))
                .toList(),
            conversionController.selectedIndex.value == 1
                ? 'jpg'
                : conversionController.selectedIndex.value == 2
                    ? 'gif'
                    : conversionController.selectedIndex.value == 3
                        ? 'jpeg'
                        : conversionController.selectedIndex.value == 4
                            ? 'png'
                            : conversionController.selectedIndex.value == 5
                                ? 'svg'
                                : conversionController.selectedIndex.value == 6
                                    ? 'webp'
                                    : conversionController
                                                .selectedIndex.value ==
                                            7
                                        ? 'bmp'
                                        : conversionController
                                                    .selectedIndex.value ==
                                                8
                                            ? 'doc'
                                            : conversionController
                                                        .selectedIndex.value ==
                                                    9
                                                ? 'txt'
                                                : conversionController
                                                            .selectedIndex
                                                            .value ==
                                                        10
                                                    ? 'pdf'
                                                    : conversionController
                                                                .selectedIndex
                                                                .value ==
                                                            11
                                                        ? 'xls'
                                                        : 'heic',
          );
        }
      } catch (e) {
        Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            // AppLocalizations.of(Get.context!)!
            //     .please_try_again_after_some_time

            "Please try again after some time");
      }
      // } else {
      //   Get.to(() => const PremiumPage());
      // }
    } else if (conversionController.selectedIndex.value == 1 ||
        conversionController.selectedIndex.value == 4 ||
        conversionController.selectedIndex.value == 2 ||
        conversionController.selectedIndex.value == 3 ||
        conversionController.selectedIndex.value == 7) {
      try {
        if (conversionController.selectedIndex.value == 0) {
          Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            // AppLocalizations.of(Get.context!)!
            //     .please_select_an_option_in_which_you_want_to_convert,
            "Please select an option",
          );
          conversionController.conversionOptionList(
              Get.context!, widget.imagePath!);
        }

        // await loopFunction();
        if (widget.imagePath![0].toLowerCase().endsWith('.jpg') ||
            widget.imagePath![0].toLowerCase().endsWith('.jpeg')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertJpgToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertJpgToPdfMulti(
                      Get.context!, widget.imagePath)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertJpgToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertJpgToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertJpgToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertJpgToBMPMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.png')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertPngToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertPngToPdfMulti(
                      Get.context!, widget.imagePath)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertPngToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertPngToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertPngToJPEGMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertPngToBMPMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.gif')) {
          conversionController.selectedIndex.value == 1
              ? conversionController.convertGifToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertGifToPdfMulti(
                      Get.context!, widget.imagePath!)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertGifToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertGifToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertGifToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertGifToBmpMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.bmp')) {
          print("@@@@BMP");
          conversionController.selectedIndex.value == 1
              ? conversionController.convertBmpToJpgMulti(
                  Get.context!, widget.imagePath)
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertBmpToPdfMulti(
                      Get.context!, widget.imagePath!)
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertBmpToPngMulti(
                          Get.context!, widget.imagePath)
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertBmpToGifMulti(
                                  Get.context!, widget.imagePath)
                              : conversionController.selectedIndex.value == 3
                                  ? conversionController.convertBmpToJpegMulti(
                                      Get.context!, widget.imagePath)
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController
                                          .convertBmpToBmpMulti(
                                              Get.context!, widget.imagePath)
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.tiff') ||
            widget.imagePath![0].toLowerCase().endsWith('.tif')) {
          print("@@@@tif");
          conversionController.selectedIndex.value == 1
              ? conversionController.convertTifToJpg(
                  Get.context!, widget.imagePath![0])
              : conversionController.selectedIndex.value == 10
                  ? conversionController.convertTifToPdf(
                      Get.context!, widget.imagePath![0])
                  : conversionController.selectedIndex.value == 4
                      ? conversionController.convertTifToPng(
                          Get.context!, widget.imagePath![0])
                      : conversionController.selectedIndex.value == 6
                          ? conversionController.convertingIntoDiffFormatsMulti(
                              Get.context!,
                              widget.imagePath!,
                              widget.imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : conversionController.selectedIndex.value == 2
                              ? conversionController.convertTiffToGif(
                                  Get.context!, widget.imagePath![0])
                              : conversionController.selectedIndex.value == 2
                                  ? conversionController.convertTiffToJpeg(
                                      Get.context!, widget.imagePath![0])
                                  : conversionController.selectedIndex.value ==
                                          7
                                      ? conversionController.convertTiffToBmp(
                                          Get.context!, widget.imagePath![0])
                                      : conversionController
                                                  .selectedIndex.value ==
                                              5
                                          ? conversionController
                                              .convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              widget.imagePath!,
                                              widget.imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (widget.imagePath![0].toLowerCase().endsWith('.heic')) {
          print("@@@@heic");

          conversionController.convertingIntoDiffFormatsMulti(
            Get.context!,
            widget.imagePath!,
            widget.imagePath!
                .map((filePath) =>
                    path.extension(filePath).replaceFirst('.', ''))
                .toList(),
            conversionController.selectedIndex.value == 1
                ? 'jpg'
                : conversionController.selectedIndex.value == 2
                    ? 'gif'
                    : conversionController.selectedIndex.value == 3
                        ? 'jpeg'
                        : conversionController.selectedIndex.value == 4
                            ? 'png'
                            : conversionController.selectedIndex.value == 5
                                ? 'svg'
                                : conversionController.selectedIndex.value == 6
                                    ? 'webp'
                                    : conversionController
                                                .selectedIndex.value ==
                                            7
                                        ? 'bmp'
                                        : conversionController
                                                    .selectedIndex.value ==
                                                8
                                            ? 'doc'
                                            : conversionController
                                                        .selectedIndex.value ==
                                                    9
                                                ? 'txt'
                                                : conversionController
                                                            .selectedIndex
                                                            .value ==
                                                        10
                                                    ? 'pdf'
                                                    : conversionController
                                                                .selectedIndex
                                                                .value ==
                                                            11
                                                        ? 'xls'
                                                        : 'heic',
          );
        }
      } catch (e) {
        Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            // AppLocalizations.of(Get.context!)!
            //     .please_try_again_after_some_time
            "Please try again after some time");
        Get.back();
      }
    } else if (conversionController.selectedIndex.value == 9) {
      // ++toolValue;
      // await SharedPref().setToolValue(toolValue);
      print("Image to Text New Tool");
      conversionController.imageToTextTool(
        Get.context!,
        widget.imagePath!,
        widget.imagePath!
            .map((filePath) => path.extension(filePath).replaceFirst('.', ''))
            .toList(),
        'txt',
      );
    } else if (conversionController.selectedIndex.value == 8) {
      // ++toolValue;
      // await SharedPref().setToolValue(toolValue);
      await conversionController.imageToDocTool(
          Get.context!, widget.imagePath!, 'doc');
    } else if (conversionController.selectedIndex.value == 11) {
      if (widget.imagePath!.first.contains('.BMP') ||
          widget.imagePath!.first.contains('.bmp')) {
        log("I am triggered");
        List<String> tempList = [];
        Directory? dir = await getTemporaryDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/Img_${DateTime.now().microsecondsSinceEpoch}.png';
        // print("%%%%path  $path");

        im.Image? bmpImage =
            im.decodeImage(await File(widget.imagePath!.first).readAsBytes());

        File file = File(path);
        file.writeAsBytesSync(
          im.encodeJpg(
            bmpImage!,
          ),
        );
        tempList.add(file.path);
        await conversionController.imageToExcelTool(
            Get.context!, tempList, 'xlsx');
      } else {
        await conversionController.imageToExcelTool(
            Get.context!, widget.imagePath!, 'xlsx');
      }
    } else if (conversionController.selectedIndex.value == 12 ||
        conversionController.selectedIndex.value == 13 ||
        conversionController.selectedIndex.value == 14 ||
        conversionController.selectedIndex.value == 15 ||
        conversionController.selectedIndex.value == 16 ||
        conversionController.selectedIndex.value == 17 ||
        conversionController.selectedIndex.value == 18) {
      print("NEW TOOLS CONVERSIONS");
      // ++toolValue;
      // await SharedPref().setToolValue(toolValue);
      // setToolsValue();
      if (widget.imagePath!.first.contains('.png') ||
          widget.imagePath!.first.contains('.jpg') ||
          widget.imagePath!.first.contains('.jpeg')) {
        print("CORRECT");
        conversionController.selectedIndex.value == 12 ||
                conversionController.selectedIndex.value == 13 ||
                conversionController.selectedIndex.value == 14 ||
                conversionController.selectedIndex.value == 15 ||
                conversionController.selectedIndex.value == 16 ||
                conversionController.selectedIndex.value == 17 ||
                conversionController.selectedIndex.value == 18
            ? conversionController.convertingIntoDiffFormatsMulti(
                Get.context!,
                widget.imagePath!,
                widget.imagePath!
                    .map((filePath) =>
                        path.extension(filePath).replaceFirst('.', ''))
                    .toList(),
                conversionController.selectedIndex.value == 12
                    ? 'tiff'
                    : conversionController.selectedIndex.value == 13
                        ? 'raw'
                        : conversionController.selectedIndex.value == 14
                            ? 'psd'
                            : conversionController.selectedIndex.value == 15
                                ? 'dds'
                                : conversionController.selectedIndex.value == 16
                                    ? 'heic'
                                    : conversionController
                                                .selectedIndex.value ==
                                            17
                                        ? 'ppm'
                                        : conversionController
                                                    .selectedIndex.value ==
                                                18
                                            ? 'tga'
                                            : 'tiff',
              )
            : const SizedBox();
      } else {
        print("Wrong");
      }
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  launchURLFunction(String url) async {
    final Uri params = Uri(
      scheme: 'https',
      path: url,
    );
    launchUrl(params);
  }
}
