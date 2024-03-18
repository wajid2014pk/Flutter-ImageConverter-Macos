
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/convert_images_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class ConvertFile extends StatefulWidget {
  final String? imagePath;
  const ConvertFile({super.key, this.imagePath});

  @override
  State<ConvertFile> createState() => _ConvertFileState();
}

class _ConvertFileState extends State<ConvertFile> {
  final conversionController = Get.put(ConvertImagesController());

  @override
  void initState() {
    super.initState();
    conversionController.selectedIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    String fileName = widget.imagePath != null
        ? File(widget.imagePath!).uri.pathSegments.last
        : "File Name";

    // String shortenedFileName =
    //     '${fileName.substring(0, 13)}...${fileName.substring(fileName.length - 10)}';
    String shortenedFileName = fileName.length <= 15
        ? fileName
        : '${fileName.substring(0, 13)}...${fileName.substring(fileName.length - 10)}';

    return Scaffold(
      body: Container(
        width: double.infinity,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topRight,
        //     end: Alignment.center,
        //     colors: [
        //       UiColors.darkblueColor,
        //       UiColors.lightblueColor,
        //     ],
        //   ),
        // ),
        child: Obx(
              () => Column(
            children: [

              Container(

                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.only(
                  //   topRight: Radius.circular(50),
                  //   topLeft: Radius.circular(50),
                  // ),
                ),
                child: conversionController.loadingState.value == false
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 60, bottom: 15),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: UiColors.buttonColor),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Image.file(
                              File(widget.imagePath!),
                              height: 35,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              shortenedFileName,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/Convert.png",
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 15),
                      child: InkWell(
                        onTap: () {
                          conversionController
                              .conversionOptionList(context);
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: UiColors.buttonColor,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                conversionController
                                    .selectedIndex.value ==
                                    1
                                    ? "assets/JPG.png"
                                    : conversionController
                                    .selectedIndex.value ==
                                    2
                                    ? "assets/PDF.png"
                                    : conversionController
                                    .selectedIndex
                                    .value ==
                                    3
                                    ? "assets/PNG.png"
                                    : conversionController
                                    .selectedIndex
                                    .value ==
                                    4
                                    ? "assets/WEBP.png"
                                    : conversionController
                                    .selectedIndex
                                    .value ==
                                    5
                                    ? "assets/GIF.png"
                                    : conversionController
                                    .selectedIndex
                                    .value ==
                                    6
                                    ? "assets/JPEG.png"
                                    : conversionController
                                    .selectedIndex
                                    .value ==
                                    7
                                    ? "assets/BMP.png"
                                    : conversionController
                                    .selectedIndex
                                    .value ==
                                    8
                                    ? "assets/SVG.png"
                                    : "assets/JPG.png",
                                height: 35,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${
                                    // AppLocalizations.of(context)!.convert_in_to
                                "Convert Into"
                                } ${conversionController.selectedIndex.value == 1 ? "jpg" : conversionController.selectedIndex.value == 2 ? "pdf" : conversionController.selectedIndex.value == 3 ? "png" : conversionController.selectedIndex.value == 4 ? "webp" : conversionController.selectedIndex.value == 5 ? "gif" : conversionController.selectedIndex.value == 6 ? "jpeg" : conversionController.selectedIndex.value == 7 ? "bmp" : conversionController.selectedIndex.value == 8 ? "svg" : ""}",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Image.asset(
                                "assets/down.png",
                                height: 15,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 22, right: 22, top: 30),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         AppLocalizations.of(context)!.quality,
                    //         style: GoogleFonts.poppins(
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w500),
                    //       ),
                    //       const Spacer(),
                    //       Container(
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(8),
                    //           color: UiColors.buttonColor,
                    //         ),
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //               horizontal: 10, vertical: 5),
                    //           child: Text(
                    //             "${(conversionController.sliderValue * 100).round()}%",
                    //             style: GoogleFonts.poppins(
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.w500),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SliderTheme(
                    //   data: SliderThemeData(
                    //     trackHeight: 8,
                    //     thumbColor: Colors.white,
                    //     activeTrackColor: UiColors.lightblueColor,
                    //     inactiveTrackColor: UiColors.buttonColor,
                    //     overlayColor: Colors.transparent,
                    //   ),
                    //   child: Slider(
                    //     onChanged: (double value) {
                    //       setState(() {
                    //         conversionController.sliderValue = value;
                    //       });
                    //     },
                    //     divisions: 100,
                    //     value: conversionController.sliderValue,
                    //     min: 0.0,
                    //     max: 1.0,
                    //   ),
                    // ),

                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: InkWell(
                        onTap: () async {
                          if (conversionController.selectedIndex.value ==
                              0) {
                            Get.snackbar(
                              backgroundColor: UiColors.whiteColor,
                              duration: const Duration(seconds: 4),
                              // ",
                              "attention",
                              // AppLocalizations.of(context)!..please_select_an_option_in_which_you_want_to_convert,
                                  ".please_select_an_option_in_which_you_want_to_convert,",
                            );
                            conversionController
                                .conversionOptionList(context);
                          }

                          // await loopFunction();
                          if (widget.imagePath!
                              .toLowerCase()
                              .endsWith('.jpg') ||
                              widget.imagePath!
                                  .toLowerCase()
                                  .endsWith('.jpeg')) {
                            conversionController.selectedIndex.value == 1
                                ? conversionController.convertJpgToJpg(
                                context, widget.imagePath)
                                : conversionController.selectedIndex.value ==
                                2
                                ? conversionController
                                .convertJpgToPdf(
                              context,
                              widget.imagePath,
                            )
                                : conversionController.selectedIndex.value ==
                                3
                                ? conversionController
                                .convertJpgToPng(
                              context,
                              widget.imagePath,
                            )
                                : conversionController
                                .selectedIndex
                                .value ==
                                4
                                ? conversionController
                                .convertingIntoDiffFormats(
                              context,
                              widget.imagePath,
                              'jpg',
                              'webp',
                            )
                                : conversionController
                                .selectedIndex
                                .value ==
                                5
                                ? conversionController
                                .convertJpgToGif(
                                context,
                                widget.imagePath)
                                : conversionController
                                .selectedIndex
                                .value ==
                                6
                                ? conversionController
                                .convertJpgToJpeg(
                                context,
                                widget
                                    .imagePath)
                                : conversionController
                                .selectedIndex
                                .value ==
                                7
                                ? conversionController.convertJpgToBMP(
                                context, widget.imagePath)
                                : conversionController.selectedIndex.value == 8
                                ? conversionController.convertingIntoDiffFormats(
                              context,
                              widget
                                  .imagePath,
                              'jpg',
                              'svg',
                            )
                                : const SizedBox();
                          } else if (widget.imagePath!
                              .toLowerCase()
                              .endsWith('.png')) {
                            print("HDHHDHDHHD");
                            conversionController.selectedIndex.value == 1
                                ? conversionController.convertPngToJpg(
                              context,
                              widget.imagePath,
                            )
                                : conversionController
                                .selectedIndex.value ==
                                2
                                ? conversionController
                                .convertPngToPdf(
                              context,
                              widget.imagePath,
                            )
                                : conversionController
                                .selectedIndex.value ==
                                3
                                ? conversionController
                                .convertPngToPng(
                              context,
                              widget.imagePath,
                            )
                                : conversionController
                                .selectedIndex
                                .value ==
                                4
                                ? conversionController
                                .convertingIntoDiffFormats(
                              context,
                              widget.imagePath,
                              'png',
                              'webp',
                            )
                                : conversionController
                                .selectedIndex
                                .value ==
                                5
                                ? conversionController
                                .convertPngToGif(
                                context,
                                widget.imagePath)
                                : conversionController
                                .selectedIndex
                                .value ==
                                6
                                ? conversionController
                                .convertPngToJPEG(
                              context,
                              widget.imagePath,
                            )
                                : conversionController
                                .selectedIndex
                                .value ==
                                7
                                ? conversionController
                                .convertPngToBMP(
                                context,
                                widget
                                    .imagePath)
                                : conversionController
                                .selectedIndex
                                .value ==
                                8
                                ? conversionController
                                .convertingIntoDiffFormats(
                              context,
                              widget
                                  .imagePath,
                              'png',
                              'svg',
                            )
                                : const SizedBox();
                          } else if (widget.imagePath!
                              .toLowerCase()
                              .endsWith('.gif')) {
                            conversionController.selectedIndex.value == 1
                                ? conversionController.convertGifToJpg(
                                context, widget.imagePath)
                                : conversionController.selectedIndex.value ==
                                2
                                ? conversionController.convertGifToPdf(
                                context, widget.imagePath)
                                : conversionController.selectedIndex.value ==
                                3
                                ? conversionController.convertGifToPng(
                                context, widget.imagePath)
                                : conversionController
                                .selectedIndex
                                .value ==
                                4
                                ? conversionController
                                .convertingIntoDiffFormats(
                              context,
                              widget.imagePath,
                              'gif',
                              'webp',
                            )
                                : conversionController
                                .selectedIndex
                                .value ==
                                5
                                ? conversionController
                                .convertGifToGif(
                                context,
                                widget.imagePath)
                                : conversionController
                                .selectedIndex
                                .value ==
                                6
                                ? conversionController
                                .convertGifToJpeg(
                                context,
                                widget.imagePath)
                                : conversionController.selectedIndex.value == 7
                                ? conversionController.convertGifToBmp(context, widget.imagePath)
                                : conversionController.selectedIndex.value == 8
                                ? conversionController.convertingIntoDiffFormats(
                              context,
                              widget
                                  .imagePath,
                              'gif',
                              'svg',
                            )
                                : const SizedBox();
                          } else if (widget.imagePath!
                              .toLowerCase()
                              .endsWith('.bmp')) {
                            print("@@@@BMP");
                            conversionController.selectedIndex.value == 1
                                ? conversionController.convertBmpToJpg(
                                context, widget.imagePath)
                                : conversionController.selectedIndex.value ==
                                2
                                ? conversionController.convertBmpToPdf(
                                context, widget.imagePath)
                                : conversionController.selectedIndex.value ==
                                3
                                ? conversionController.convertBmpToPng(
                                context, widget.imagePath)
                                : conversionController
                                .selectedIndex
                                .value ==
                                4
                                ? conversionController
                                .convertingIntoDiffFormats(
                              context,
                              widget.imagePath,
                              'bmp',
                              'webp',
                            )
                                : conversionController
                                .selectedIndex
                                .value ==
                                5
                                ? conversionController
                                .convertBmpToGif(
                                context,
                                widget.imagePath)
                                : conversionController
                                .selectedIndex
                                .value ==
                                6
                                ? conversionController
                                .convertBmpToJpeg(
                                context,
                                widget.imagePath)
                                : conversionController.selectedIndex.value == 7
                                ? conversionController.convertBmpToBmp(context, widget.imagePath)
                                : conversionController.selectedIndex.value == 8
                                ? conversionController.convertingIntoDiffFormats(
                              context,
                              widget
                                  .imagePath,
                              'bmp',
                              'svg',
                            )
                                : const SizedBox();
                          } else if (widget.imagePath!
                              .toLowerCase()
                              .endsWith('.tiff') ||
                              widget.imagePath!
                                  .toLowerCase()
                                  .endsWith('.tif')) {
                            print("@@@@tif");
                            conversionController.selectedIndex.value == 1
                                ? conversionController.convertTifToJpg(
                                context, widget.imagePath)
                                : conversionController.selectedIndex.value ==
                                2
                                ? conversionController.convertTifToPdf(
                                context, widget.imagePath)
                                : conversionController.selectedIndex.value ==
                                3
                                ? conversionController.convertTifToPng(
                                context, widget.imagePath)
                                : conversionController
                                .selectedIndex
                                .value ==
                                4
                                ? conversionController
                                .convertingIntoDiffFormats(
                              context,
                              widget.imagePath,
                              'tif',
                              'webp',
                            )
                                : conversionController
                                .selectedIndex
                                .value ==
                                5
                                ? conversionController
                                .convertTiffToGif(
                                context,
                                widget.imagePath)
                                : conversionController
                                .selectedIndex
                                .value ==
                                6
                                ? conversionController
                                .convertTiffToJpeg(
                                context,
                                widget.imagePath)
                                : conversionController.selectedIndex.value == 7
                                ? conversionController.convertTiffToBmp(context, widget.imagePath)
                                : conversionController.selectedIndex.value == 8
                                ? conversionController.convertingIntoDiffFormats(
                              context,
                              widget
                                  .imagePath,
                              'tif',
                              'svg',
                            )
                                : const SizedBox();
                          } else if (widget.imagePath!
                              .toLowerCase()
                              .endsWith('.heic')) {
                            print("@@@@heic");
                            conversionController
                                .convertingIntoDiffFormats(
                              context,
                              widget.imagePath,
                              'heic',
                              conversionController.selectedIndex.value ==
                                  1
                                  ? 'jpg'
                                  : conversionController
                                  .selectedIndex.value ==
                                  2
                                  ? 'pdf'
                                  : conversionController
                                  .selectedIndex.value ==
                                  3
                                  ? 'png'
                                  : conversionController
                                  .selectedIndex
                                  .value ==
                                  4
                                  ? 'webp'
                                  : conversionController
                                  .selectedIndex
                                  .value ==
                                  5
                                  ? 'gif'
                                  : conversionController
                                  .selectedIndex
                                  .value ==
                                  6
                                  ? 'jpeg'
                                  : conversionController
                                  .selectedIndex
                                  .value ==
                                  7
                                  ? 'bmp'
                                  : conversionController
                                  .selectedIndex
                                  .value ==
                                  8
                                  ? 'svg'
                                  : 'heic',
                            );
                          }
                        },
                        child: Obx(
                              () => Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: UiColors.lightblueColor),
                            child: conversionController
                                .showLoader.value ==
                                false
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        2.8,
                                    child: Text(
                                      // AppLocalizations.of(context)!.convert_file,
                                      "Convert File ",
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: UiColors.whiteColor,
                                      ),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  "assets/Convert.png",
                                  color: UiColors.whiteColor,
                                  height: 20,
                                ),
                              ],
                            )
                                : const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    : Column(
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
                              percent:
                              conversionController.percentage.value /
                                  100,
                              progressColor: UiColors.lightblueColor,
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
                                          color: UiColors.lightblueColor
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
                                  Positioned(
                                    child: Image.asset(
                                      conversionController
                                          .isDownloading.value ==
                                          false
                                          ? "assets/Processing.png"
                                          : "assets/Complete.png",
                                      height: 70,
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
                      ".your_file_is_converting,",
                      // AppLocalizations.of(context)!.your_file_is_converting,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color:
                          Colors.black, // Set the default text color
                        ),
                        children: [
                          const TextSpan(
                            text:"files_are_uploaded_over_an_encrypted_connection",
                            // AppLocalizations.of(context)!.files_are_uploaded_over_an_encrypted_connection,
                          ),
                          TextSpan(
                            // text: AppLocalizations.of(context)!.privacy_policy,
                            text: "privacy_policy",

                          style: GoogleFonts.poppins(
                                color: UiColors.lightblueColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchURLFunction(
                                  "www.eclixtech.com/privacy-policy",
                                ); // Define this function to open your Privacy Policy link
                              },
                          ),
                        ],
                      ),
                    ),
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
    );
  }

  launchURLFunction(String url) async {
    final Uri params = Uri(
      scheme: 'https',
      path: url,
    );
    launchUrl(params);
  }
}