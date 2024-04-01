import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/convert_images_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as path;

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

    String shortenedFileName = fileName.length <= 15
        ? fileName
        : '${fileName.substring(0, 10)}...${fileName.substring(fileName.length - 10)}';

    String fileExtension = path.extension(fileName);
    print("fileExtension $fileExtension");

    return Scaffold(
      backgroundColor: UiColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 65),
        child: AppBar(
          backgroundColor: UiColors.whiteColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Transform.flip(
                  flipX: true,
                  child: Image.asset(
                    'assets/Right.png',
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Obx(
                () => GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    conversionController.loadingState.value == false ||
                            conversionController.isDownloading.value == false
                        ? AppLocalizations.of(context)!.select_files
                        : AppLocalizations.of(context)!.converted,
                    style: GoogleFonts.poppins(
                      color: UiColors.blueColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            conversionController.loadingState.value == false
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20,
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: UiColors.whiteColor),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          fileExtension == '.jpg'
                                              ? "assets/JPG.png"
                                              : fileExtension == '.pdf'
                                                  ? "assets/PDF.png"
                                                  : fileExtension == '.png'
                                                      ? "assets/PNG.png"
                                                      : fileExtension == '.webp'
                                                          ? "assets/WEBP.png"
                                                          : fileExtension ==
                                                                  '.gif'
                                                              ? "assets/GIF.png"
                                                              : fileExtension ==
                                                                      '.jpeg'
                                                                  ? "assets/JPEG.png"
                                                                  : fileExtension ==
                                                                          '.bmp'
                                                                      ? "assets/BMP.png"
                                                                      : fileExtension ==
                                                                              '.svg'
                                                                          ? "assets/SVG.png"
                                                                          : "assets/JPG.png",
                                          height: 50,
                                          width: 50,
                                        ),
                                        // Image.file(
                                        //   File(widget.imagePath!),
                                        // height: 50,
                                        // width: 50,
                                        //   fit: BoxFit.cover,
                                        // ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          shortenedFileName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            // fontWeight: FontWeight.w500
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 40),
                                  child: Image.asset(
                                    "assets/Convert.png",
                                    height: 40,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    conversionController
                                        .conversionOptionList(context);
                                  },
                                  child: Container(
                                    height: 70,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: UiColors.whiteColor,
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Image.asset(
                                          conversionController
                                                      .selectedIndex.value ==
                                                  1
                                              ? "assets/JPG.png"
                                              : conversionController
                                                          .selectedIndex
                                                          .value ==
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
                                                                      : conversionController.selectedIndex.value ==
                                                                              8
                                                                          ? "assets/SVG.png"
                                                                          : "assets/JPG.png",
                                          height: 45,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.convert_into} ${conversionController.selectedIndex.value == 1 ? "jpg" : conversionController.selectedIndex.value == 2 ? "pdf" : conversionController.selectedIndex.value == 3 ? "png" : conversionController.selectedIndex.value == 4 ? "webp" : conversionController.selectedIndex.value == 5 ? "gif" : conversionController.selectedIndex.value == 6 ? "jpeg" : conversionController.selectedIndex.value == 7 ? "bmp" : conversionController.selectedIndex.value == 8 ? "svg" : " "}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            // fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.arrow_right_rounded,
                                          size: 50,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.black.withOpacity(0.5)),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.5),
                                //     spreadRadius: 5,
                                //     blurRadius: 7,
                                //     offset: Offset(
                                //         0, 3), // changes position of shadow
                                //   ),
                                // ],
                              ),
                              height: MediaQuery.of(context).size.height / 2.5,
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Image.file(File(widget.imagePath!)),
                            ),
                            // conversionController.conversionOptionList(context),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: InkWell(
                          onTap: () async {
                            if (conversionController.selectedIndex.value == 0) {
                              Get.snackbar(
                                backgroundColor: UiColors.whiteColor,
                                duration: const Duration(seconds: 4),
                                AppLocalizations.of(context)!.attention,
                                AppLocalizations.of(context)!
                                    .please_select_an_option,
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
                                      ? conversionController.convertJpgToPdf(
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
                                          : conversionController.selectedIndex.value ==
                                                  4
                                              ? conversionController
                                                  .convertingIntoDiffFormats(
                                                  context,
                                                  widget.imagePath,
                                                  'jpg',
                                                  'webp',
                                                )
                                              : conversionController.selectedIndex.value ==
                                                      5
                                                  ? conversionController.convertJpgToGif(
                                                      context, widget.imagePath)
                                                  : conversionController
                                                              .selectedIndex
                                                              .value ==
                                                          6
                                                      ? conversionController
                                                          .convertJpgToJpeg(
                                                              context,
                                                              widget.imagePath)
                                                      : conversionController
                                                                  .selectedIndex
                                                                  .value ==
                                                              7
                                                          ? conversionController
                                                              .convertJpgToBMP(
                                                                  context,
                                                                  widget
                                                                      .imagePath)
                                                          : conversionController
                                                                      .selectedIndex
                                                                      .value ==
                                                                  8
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
                                  : conversionController.selectedIndex.value ==
                                          2
                                      ? conversionController.convertPngToPdf(
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
                                                      .selectedIndex.value ==
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
                                                      .convertPngToGif(context,
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
                                          : conversionController.selectedIndex.value ==
                                                  4
                                              ? conversionController
                                                  .convertingIntoDiffFormats(
                                                  context,
                                                  widget.imagePath,
                                                  'gif',
                                                  'webp',
                                                )
                                              : conversionController.selectedIndex.value ==
                                                      5
                                                  ? conversionController.convertGifToGif(
                                                      context, widget.imagePath)
                                                  : conversionController
                                                              .selectedIndex
                                                              .value ==
                                                          6
                                                      ? conversionController
                                                          .convertGifToJpeg(
                                                              context,
                                                              widget.imagePath)
                                                      : conversionController
                                                                  .selectedIndex
                                                                  .value ==
                                                              7
                                                          ? conversionController
                                                              .convertGifToBmp(
                                                                  context, widget.imagePath)
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
                                          : conversionController.selectedIndex.value ==
                                                  4
                                              ? conversionController
                                                  .convertingIntoDiffFormats(
                                                  context,
                                                  widget.imagePath,
                                                  'bmp',
                                                  'webp',
                                                )
                                              : conversionController.selectedIndex.value ==
                                                      5
                                                  ? conversionController.convertBmpToGif(
                                                      context, widget.imagePath)
                                                  : conversionController
                                                              .selectedIndex
                                                              .value ==
                                                          6
                                                      ? conversionController
                                                          .convertBmpToJpeg(
                                                              context,
                                                              widget.imagePath)
                                                      : conversionController
                                                                  .selectedIndex
                                                                  .value ==
                                                              7
                                                          ? conversionController
                                                              .convertBmpToBmp(
                                                                  context, widget.imagePath)
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
                                          : conversionController.selectedIndex.value ==
                                                  4
                                              ? conversionController
                                                  .convertingIntoDiffFormats(
                                                  context,
                                                  widget.imagePath,
                                                  'tif',
                                                  'webp',
                                                )
                                              : conversionController.selectedIndex.value ==
                                                      5
                                                  ? conversionController.convertTiffToGif(
                                                      context, widget.imagePath)
                                                  : conversionController
                                                              .selectedIndex
                                                              .value ==
                                                          6
                                                      ? conversionController
                                                          .convertTiffToJpeg(
                                                              context,
                                                              widget.imagePath)
                                                      : conversionController
                                                                  .selectedIndex
                                                                  .value ==
                                                              7
                                                          ? conversionController
                                                              .convertTiffToBmp(
                                                                  context, widget.imagePath)
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
                              conversionController.convertingIntoDiffFormats(
                                context,
                                widget.imagePath,
                                'heic',
                                conversionController.selectedIndex.value == 1
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
                                                        .selectedIndex.value ==
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
                              width: MediaQuery.of(context).size.width / 5.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: UiColors.lightblueColor,
                              ),
                              child: conversionController.showLoader.value ==
                                      false
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .convert_file,
                                              // "Convert File ",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Center(
                        child: Obx(
                          () => Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularPercentIndicator(
                                backgroundColor: Colors.black.withOpacity(0.1),
                                radius: 120.0,
                                lineWidth: 8.0,
                                percent:
                                    conversionController.percentage.value / 100,
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
                        conversionController.isDownloading.value == false
                            ? AppLocalizations.of(context)!
                                .your_file_is_converting
                            : AppLocalizations.of(context)!.converted,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // const Spacer(),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              // fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .files_are_uploaded_over_an_encrypted,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .privacy_policy,
                                style: GoogleFonts.poppins(
                                    color: UiColors.lightblueColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchURLFunction(
                                      "www.eclixtech.com/privacy-policy",
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
}
