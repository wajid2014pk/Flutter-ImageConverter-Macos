import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Controller/PremiumPopUpController/premium_controller.dart';
import 'package:image_converter_macos/Controller/convert_images_controller.dart';
import 'package:image_converter_macos/utils/shared_pref.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as im;

class ConvertFile extends StatefulWidget {
  List<String> imagePath;
  ConvertFile({super.key, required this.imagePath});

  @override
  State<ConvertFile> createState() => _ConvertFileState();
}

class _ConvertFileState extends State<ConvertFile> {
  final conversionController = Get.put(ConvertImagesController());
  final payWallController = Get.put(PayWallController());
  RxList<String> getFileNames = <String>[].obs;
  RxList<double> getFileSize = <double>[].obs;
  @override
  void initState() {
    super.initState();
    payWallController.offerings == null
        ? payWallController.getProductsPrice()
        : null;
    conversionController.selectedIndex.value = 0;
    for (int i = 0; i < widget.imagePath.length; i++) {
      print("widget.imagePath ${widget.imagePath[i]}");
      getFileNames.add(getName(widget.imagePath[i]));
    }

    for (int i = 0; i < widget.imagePath.length; i++) {
      print("widget.imagePath${path.basename(widget.imagePath[i])}");
      getFileSize.add(getFileSizeInKB(File(widget.imagePath[i])));
    }

    Future.delayed(const Duration(milliseconds: 50), () async {
      await Future.delayed(const Duration(milliseconds: 50), () {
        conversionController.conversionOptionList(context, widget.imagePath);
      });
    });
    Future.delayed(const Duration(milliseconds: 100), () async {
      await getAllLimitValue();
    });
  }

  getAllLimitValue() async {
    webpLimit.value = await SharedPref().getWEBPValue();
    svgLimit.value = await SharedPref().getSVGValue();
    bmpLimit.value = await SharedPref().getBmpLimit();
    tiffLimit.value = await SharedPref().getTiffLimit();
    rawLimit.value = await SharedPref().getRawLimit();
    psdLimit.value = await SharedPref().getPsdLimit();
    ddsLimit.value = await SharedPref().getDdsLimit();
    heicLimit.value = await SharedPref().getHeicLimit();
    ppmLimit.value = await SharedPref().getPpmLimit();
    tgaLimit.value = await SharedPref().getTgaLimit();
  }

  double getFileSizeInKB(File file) {
    final bytes = file.lengthSync();
    print("file $file");
    double size = bytes / 1024;
    return size;
  }

  String getName(String value) {
    String fileName = value.split('/').last;
    List<String> parts = fileName.split(' - ');
    String datePart = parts.last.split(' at ').first;
    // String extension = fileName.split('.').last;
    String result = '$datePart';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(
                    'assets/back_arrow.png',
                    height: 22,
                    width: 22,
                  ),
                ),
                sizedBoxWidth,
                sizedBoxWidth,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // "Output Format",
                      AppLocalizations.of(context)!.output_format,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          fontFamily: 'Manrope-Bold'),
                    ),
                    Text(
                      // "Choose file output format",
                      AppLocalizations.of(context)!.choose_file_format,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 22,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.1, vertical: Get.width * 0.01),
                decoration: BoxDecoration(
                    // border: Border.all(),
                    boxShadow: [
                      BoxShadow(
                        color: UiColors.blackColor.withOpacity(0.1),
                        blurRadius: 4,
                      )
                    ],
                    borderRadius: BorderRadius.circular(22),
                    color: UiColors.whiteColor),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 22),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, // Number of columns
                              crossAxisSpacing: 22, // Spacing between columns
                              mainAxisSpacing: 22, // Spacing between rows
                              mainAxisExtent: 80,
                              // childAspectRatio: 1
                            ),
                            itemCount: widget
                                .imagePath.length, // Total number of items
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  conversionController.conversionOptionList(
                                      context, widget.imagePath);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: UiColors.greyColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 70,
                                          width: 70,
                                          margin: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              File(widget.imagePath[index]),
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      sizedBoxWidth,
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 110,
                                            child: TextScroll(
                                              getFileNames[index],
                                              mode: TextScrollMode.endless,
                                              velocity: const Velocity(
                                                  pixelsPerSecond:
                                                      Offset(20, 0)),
                                              delayBefore: const Duration(
                                                  milliseconds: 500),
                                              numberOfReps: 1111,
                                              pauseBetween: const Duration(
                                                  milliseconds: 500),
                                              textAlign: TextAlign.right,
                                              selectable: true,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                              "${getFileSize[index].toInt()} KB"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // Scaffold(
    //   backgroundColor: UiColors.whiteColor,
    //   appBar: PreferredSize(
    //     preferredSize: const Size(double.infinity, 65),
    //     child: AppBar(
    //       backgroundColor: UiColors.whiteColor,
    //       elevation: 0.0,
    //       automaticallyImplyLeading: false,
    //       title: Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           GestureDetector(
    //             onTap: () => Get.back(),
    //             child: Transform.flip(
    //               flipX: true,
    //               child: Image.asset(
    //                 'assets/Right.png',
    //                 height: 20,
    //                 width: 20,
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             width: 10,
    //           ),
    //           Obx(
    //             () => GestureDetector(
    //               onTap: () => Get.back(),
    //               child: Text(
    //                 conversionController.loadingState.value == false ||
    //                         conversionController.isDownloading.value == false
    //                     ? AppLocalizations.of(context)!.select_files
    //                     : AppLocalizations.of(context)!.converted,
    //                 style: TextStyle(
    //                   color: UiColors.blueColor,
    //                   fontSize: 20.0,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   body: Obx(
    //     () => Column(
    //       children: [
    //         conversionController.loadingState.value == false
    //             ? Column(
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.only(top: 60.0),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Column(
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           children: [
    //                             Padding(
    //                               padding: const EdgeInsets.only(
    //                                 left: 20.0,
    //                                 right: 20,
    //                               ),
    //                               child: Container(
    //                                 width:
    //                                     MediaQuery.of(context).size.width / 3,
    //                                 height: 70,
    //                                 decoration: BoxDecoration(
    //                                     borderRadius: BorderRadius.circular(8),
    //                                     color: UiColors.whiteColor),
    //                                 child: Row(
    //                                   children: [
    //                                     const SizedBox(
    //                                       width: 10,
    //                                     ),
    //                                     Image.asset(
    //                                       fileExtension == '.jpg'
    //                                           ? "assets/JPG.png"
    //                                           : fileExtension == '.pdf'
    //                                               ? "assets/PDF.png"
    //                                               : fileExtension == '.png'
    //                                                   ? "assets/PNG.png"
    //                                                   : fileExtension == '.webp'
    //                                                       ? "assets/WEBP.png"
    //                                                       : fileExtension ==
    //                                                               '.gif'
    //                                                           ? "assets/GIF.png"
    //                                                           : fileExtension ==
    //                                                                   '.jpeg'
    //                                                               ? "assets/JPEG.png"
    //                                                               : fileExtension ==
    //                                                                       '.bmp'
    //                                                                   ? "assets/BMP.png"
    //                                                                   : fileExtension ==
    //                                                                           '.svg'
    //                                                                       ? "assets/SVG.png"
    //                                                                       : "assets/JPG.png",
    //                                       height: 45,
    //                                     ),
    //                                     const SizedBox(
    //                                       width: 15,
    //                                     ),
    //                                     Text(
    //                                       shortenedFileName,
    //                                       style: TextStyle(
    //                                         fontSize: 16,
    //                                         // fontWeight: FontWeight.w500
    //                                       ),
    //                                     )
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.only(
    //                                   top: 40, bottom: 40),
    //                               child: Image.asset(
    //                                 "assets/Convert.png",
    //                                 height: 40,
    //                               ),
    //                             ),
    //                             GestureDetector(
    //                               onTap: () {
    //                                 conversionController
    //                                     .conversionOptionList(context);
    //                               },
    //                               child: Container(
    //                                 height: 70,
    //                                 width:
    //                                     MediaQuery.of(context).size.width / 3,
    //                                 decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(12),
    //                                   color: UiColors.whiteColor,
    //                                 ),
    //                                 child: Row(
    //                                   children: [
    //                                     const SizedBox(
    //                                       width: 20,
    //                                     ),
    //                                     Image.asset(
    //                                       conversionController
    //                                                   .selectedIndex.value ==
    //                                               1
    //                                           ? "assets/JPG.png"
    //                                           : conversionController
    //                                                       .selectedIndex
    //                                                       .value ==
    //                                                   2
    //                                               ? "assets/PDF.png"
    //                                               : conversionController
    //                                                           .selectedIndex
    //                                                           .value ==
    //                                                       3
    //                                                   ? "assets/PNG.png"
    //                                                   : conversionController
    //                                                               .selectedIndex
    //                                                               .value ==
    //                                                           4
    //                                                       ? "assets/WEBP.png"
    //                                                       : conversionController
    //                                                                   .selectedIndex
    //                                                                   .value ==
    //                                                               5
    //                                                           ? "assets/GIF.png"
    //                                                           : conversionController
    //                                                                       .selectedIndex
    //                                                                       .value ==
    //                                                                   6
    //                                                               ? "assets/JPEG.png"
    //                                                               : conversionController
    //                                                                           .selectedIndex
    //                                                                           .value ==
    //                                                                       7
    //                                                                   ? "assets/BMP.png"
    //                                                                   : conversionController.selectedIndex.value ==
    //                                                                           8
    //                                                                       ? "assets/SVG.png"
    //                                                                       : "assets/JPG.png",
    //                                       height: 45,
    //                                     ),
    //                                     const SizedBox(
    //                                       width: 10,
    //                                     ),
    //                                     Text(
    //                                       "${AppLocalizations.of(context)!.convert_into} ${conversionController.selectedIndex.value == 1 ? "jpg" : conversionController.selectedIndex.value == 2 ? "pdf" : conversionController.selectedIndex.value == 3 ? "png" : conversionController.selectedIndex.value == 4 ? "webp" : conversionController.selectedIndex.value == 5 ? "gif" : conversionController.selectedIndex.value == 6 ? "jpeg" : conversionController.selectedIndex.value == 7 ? "bmp" : conversionController.selectedIndex.value == 8 ? "svg" : " "}",
    //                                       style: TextStyle(
    //                                         fontSize: 16,
    //                                         // fontWeight: FontWeight.w500
    //                                       ),
    //                                     ),
    //                                     const Spacer(),
    //                                     const Icon(
    //                                       Icons.arrow_right_rounded,
    //                                       size: 50,
    //                                     ),
    //                                     const SizedBox(
    //                                       width: 15,
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         const SizedBox(
    //                           width: 30,
    //                         ),
    //                         Container(
    //                           decoration: BoxDecoration(
    //                             border: Border.all(
    //                               width: 0.5,
    //                               color: Colors.black.withOpacity(0.5),
    //                             ),
    //                           ),
    //                           height: MediaQuery.of(context).size.height / 2.5,
    //                           width: MediaQuery.of(context).size.width / 2.5,
    //                           child: Image.file(File(widget.imagePath!)),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.only(top: 100.0),
    //                     child: InkWell(
    //                       onTap: () async {
    //                         if (conversionController.selectedIndex.value == 0) {
    //                           Get.snackbar(
    //                             backgroundColor: UiColors.whiteColor,
    //                             duration: const Duration(seconds: 4),
    //                             AppLocalizations.of(context)!.attention,
    //                             AppLocalizations.of(context)!
    //                                 .please_select_an_option,
    //                           );
    //                           conversionController
    //                               .conversionOptionList(context);
    //                         }

    //                         // await loopFunction();
    //                         if (widget.imagePath!
    //                                 .toLowerCase()
    //                                 .endsWith('.jpg') ||
    //                             widget.imagePath!
    //                                 .toLowerCase()
    //                                 .endsWith('.jpeg')) {
    //                           conversionController.selectedIndex.value == 1
    //                               ? conversionController.convertJpgToJpg(
    //                                   context, widget.imagePath)
    //                               : conversionController.selectedIndex.value ==
    //                                       2
    //                                   ? conversionController.convertJpgToPdf(
    //                                       context,
    //                                       widget.imagePath,
    //                                     )
    //                                   : conversionController.selectedIndex.value ==
    //                                           3
    //                                       ? conversionController
    //                                           .convertJpgToPng(
    //                                           context,
    //                                           widget.imagePath,
    //                                         )
    //                                       : conversionController.selectedIndex.value ==
    //                                               4
    //                                           ? conversionController
    //                                               .convertingIntoDiffFormats(
    //                                               context,
    //                                               widget.imagePath,
    //                                               'jpg',
    //                                               'webp',
    //                                             )
    //                                           : conversionController.selectedIndex.value ==
    //                                                   5
    //                                               ? conversionController.convertJpgToGif(
    //                                                   context, widget.imagePath)
    //                                               : conversionController
    //                                                           .selectedIndex
    //                                                           .value ==
    //                                                       6
    //                                                   ? conversionController
    //                                                       .convertJpgToJpeg(
    //                                                           context,
    //                                                           widget.imagePath)
    //                                                   : conversionController
    //                                                               .selectedIndex
    //                                                               .value ==
    //                                                           7
    //                                                       ? conversionController
    //                                                           .convertJpgToBMP(
    //                                                               context,
    //                                                               widget
    //                                                                   .imagePath)
    //                                                       : conversionController
    //                                                                   .selectedIndex
    //                                                                   .value ==
    //                                                               8
    //                                                           ? conversionController.convertingIntoDiffFormats(
    //                                                               context,
    //                                                               widget
    //                                                                   .imagePath,
    //                                                               'jpg',
    //                                                               'svg',
    //                                                             )
    //                                                           : const SizedBox();
    //                         } else if (widget.imagePath!
    //                             .toLowerCase()
    //                             .endsWith('.png')) {
    //                           print("HDHHDHDHHD");
    //                           conversionController.selectedIndex.value == 1
    //                               ? conversionController.convertPngToJpg(
    //                                   context,
    //                                   widget.imagePath,
    //                                 )
    //                               : conversionController.selectedIndex.value ==
    //                                       2
    //                                   ? conversionController.convertPngToPdf(
    //                                       context,
    //                                       widget.imagePath,
    //                                     )
    //                                   : conversionController
    //                                               .selectedIndex.value ==
    //                                           3
    //                                       ? conversionController
    //                                           .convertPngToPng(
    //                                           context,
    //                                           widget.imagePath,
    //                                         )
    //                                       : conversionController
    //                                                   .selectedIndex.value ==
    //                                               4
    //                                           ? conversionController
    //                                               .convertingIntoDiffFormats(
    //                                               context,
    //                                               widget.imagePath,
    //                                               'png',
    //                                               'webp',
    //                                             )
    //                                           : conversionController
    //                                                       .selectedIndex
    //                                                       .value ==
    //                                                   5
    //                                               ? conversionController
    //                                                   .convertPngToGif(context,
    //                                                       widget.imagePath)
    //                                               : conversionController
    //                                                           .selectedIndex
    //                                                           .value ==
    //                                                       6
    //                                                   ? conversionController
    //                                                       .convertPngToJPEG(
    //                                                       context,
    //                                                       widget.imagePath,
    //                                                     )
    //                                                   : conversionController
    //                                                               .selectedIndex
    //                                                               .value ==
    //                                                           7
    //                                                       ? conversionController
    //                                                           .convertPngToBMP(
    //                                                               context,
    //                                                               widget
    //                                                                   .imagePath)
    //                                                       : conversionController
    //                                                                   .selectedIndex
    //                                                                   .value ==
    //                                                               8
    //                                                           ? conversionController
    //                                                               .convertingIntoDiffFormats(
    //                                                               context,
    //                                                               widget
    //                                                                   .imagePath,
    //                                                               'png',
    //                                                               'svg',
    //                                                             )
    //                                                           : const SizedBox();
    //                         } else if (widget.imagePath!
    //                             .toLowerCase()
    //                             .endsWith('.gif')) {
    //                           conversionController.selectedIndex.value == 1
    //                               ? conversionController.convertGifToJpg(
    //                                   context, widget.imagePath)
    //                               : conversionController.selectedIndex.value ==
    //                                       2
    //                                   ? conversionController.convertGifToPdf(
    //                                       context, widget.imagePath)
    //                                   : conversionController.selectedIndex.value ==
    //                                           3
    //                                       ? conversionController.convertGifToPng(
    //                                           context, widget.imagePath)
    //                                       : conversionController.selectedIndex.value ==
    //                                               4
    //                                           ? conversionController
    //                                               .convertingIntoDiffFormats(
    //                                               context,
    //                                               widget.imagePath,
    //                                               'gif',
    //                                               'webp',
    //                                             )
    //                                           : conversionController.selectedIndex.value ==
    //                                                   5
    //                                               ? conversionController.convertGifToGif(
    //                                                   context, widget.imagePath)
    //                                               : conversionController
    //                                                           .selectedIndex
    //                                                           .value ==
    //                                                       6
    //                                                   ? conversionController
    //                                                       .convertGifToJpeg(
    //                                                           context,
    //                                                           widget.imagePath)
    //                                                   : conversionController
    //                                                               .selectedIndex
    //                                                               .value ==
    //                                                           7
    //                                                       ? conversionController
    //                                                           .convertGifToBmp(
    //                                                               context, widget.imagePath)
    //                                                       : conversionController.selectedIndex.value == 8
    //                                                           ? conversionController.convertingIntoDiffFormats(
    //                                                               context,
    //                                                               widget
    //                                                                   .imagePath,
    //                                                               'gif',
    //                                                               'svg',
    //                                                             )
    //                                                           : const SizedBox();
    //                         } else if (widget.imagePath!
    //                             .toLowerCase()
    //                             .endsWith('.bmp')) {
    //                           print("@@@@BMP");
    //                           conversionController.selectedIndex.value == 1
    //                               ? conversionController.convertBmpToJpg(
    //                                   context, widget.imagePath)
    //                               : conversionController.selectedIndex.value ==
    //                                       2
    //                                   ? conversionController.convertBmpToPdf(
    //                                       context, widget.imagePath)
    //                                   : conversionController.selectedIndex.value ==
    //                                           3
    //                                       ? conversionController.convertBmpToPng(
    //                                           context, widget.imagePath)
    //                                       : conversionController.selectedIndex.value ==
    //                                               4
    //                                           ? conversionController
    //                                               .convertingIntoDiffFormats(
    //                                               context,
    //                                               widget.imagePath,
    //                                               'bmp',
    //                                               'webp',
    //                                             )
    //                                           : conversionController.selectedIndex.value ==
    //                                                   5
    //                                               ? conversionController.convertBmpToGif(
    //                                                   context, widget.imagePath)
    //                                               : conversionController
    //                                                           .selectedIndex
    //                                                           .value ==
    //                                                       6
    //                                                   ? conversionController
    //                                                       .convertBmpToJpeg(
    //                                                           context,
    //                                                           widget.imagePath)
    //                                                   : conversionController
    //                                                               .selectedIndex
    //                                                               .value ==
    //                                                           7
    //                                                       ? conversionController
    //                                                           .convertBmpToBmp(
    //                                                               context, widget.imagePath)
    //                                                       : conversionController.selectedIndex.value == 8
    //                                                           ? conversionController.convertingIntoDiffFormats(
    //                                                               context,
    //                                                               widget
    //                                                                   .imagePath,
    //                                                               'bmp',
    //                                                               'svg',
    //                                                             )
    //                                                           : const SizedBox();
    //                         } else if (widget.imagePath!
    //                                 .toLowerCase()
    //                                 .endsWith('.tiff') ||
    //                             widget.imagePath!
    //                                 .toLowerCase()
    //                                 .endsWith('.tif')) {
    //                           print("@@@@tif");
    //                           conversionController.selectedIndex.value == 1
    //                               ? conversionController.convertTifToJpg(
    //                                   context, widget.imagePath)
    //                               : conversionController.selectedIndex.value ==
    //                                       2
    //                                   ? conversionController.convertTifToPdf(
    //                                       context, widget.imagePath)
    //                                   : conversionController.selectedIndex.value ==
    //                                           3
    //                                       ? conversionController.convertTifToPng(
    //                                           context, widget.imagePath)
    //                                       : conversionController.selectedIndex.value ==
    //                                               4
    //                                           ? conversionController
    //                                               .convertingIntoDiffFormats(
    //                                               context,
    //                                               widget.imagePath,
    //                                               'tif',
    //                                               'webp',
    //                                             )
    //                                           : conversionController.selectedIndex.value ==
    //                                                   5
    //                                               ? conversionController.convertTiffToGif(
    //                                                   context, widget.imagePath)
    //                                               : conversionController
    //                                                           .selectedIndex
    //                                                           .value ==
    //                                                       6
    //                                                   ? conversionController
    //                                                       .convertTiffToJpeg(
    //                                                           context,
    //                                                           widget.imagePath)
    //                                                   : conversionController
    //                                                               .selectedIndex
    //                                                               .value ==
    //                                                           7
    //                                                       ? conversionController
    //                                                           .convertTiffToBmp(
    //                                                               context, widget.imagePath)
    //                                                       : conversionController.selectedIndex.value == 8
    //                                                           ? conversionController.convertingIntoDiffFormats(
    //                                                               context,
    //                                                               widget
    //                                                                   .imagePath,
    //                                                               'tif',
    //                                                               'svg',
    //                                                             )
    //                                                           : const SizedBox();
    //                         } else if (widget.imagePath!
    //                             .toLowerCase()
    //                             .endsWith('.heic')) {
    //                           print("@@@@heic");

    //                           conversionController.selectedIndex.value == 1
    //                               ? conversionController
    //                                   .convertingIntoDiffFormats(
    //                                   context,
    //                                   widget.imagePath,
    //                                   'heic',
    //                                   'jpg',
    //                                 )
    //                               : conversionController.selectedIndex.value ==
    //                                       2
    //                                   ? conversionController
    //                                       .convertingIntoDiffFormats(
    //                                       context,
    //                                       widget.imagePath,
    //                                       'heic',
    //                                       'pdf',
    //                                     )
    //                                   : conversionController
    //                                               .selectedIndex.value ==
    //                                           3
    //                                       ? conversionController
    //                                           .convertingIntoDiffFormats(
    //                                           context,
    //                                           widget.imagePath,
    //                                           'heic',
    //                                           'png',
    //                                         )
    //                                       : conversionController
    //                                                   .selectedIndex.value ==
    //                                               4
    //                                           ? conversionController
    //                                               .convertingIntoDiffFormats(
    //                                               context,
    //                                               widget.imagePath,
    //                                               'heic',
    //                                               'webp',
    //                                             )
    //                                           : conversionController
    //                                                       .selectedIndex
    //                                                       .value ==
    //                                                   5
    //                                               ? conversionController
    //                                                   .convertingIntoDiffFormats(
    //                                                   context,
    //                                                   widget.imagePath,
    //                                                   'heic',
    //                                                   'gif',
    //                                                 )
    //                                               : conversionController
    //                                                           .selectedIndex
    //                                                           .value ==
    //                                                       6
    //                                                   ? conversionController
    //                                                       .convertingIntoDiffFormats(
    //                                                       context,
    //                                                       widget.imagePath,
    //                                                       'heic',
    //                                                       'jpeg',
    //                                                     )
    //                                                   : conversionController
    //                                                               .selectedIndex
    //                                                               .value ==
    //                                                           7
    //                                                       ? conversionController
    //                                                           .convertingIntoDiffFormats(
    //                                                           context,
    //                                                           widget.imagePath,
    //                                                           'heic',
    //                                                           'bmp',
    //                                                         )
    //                                                       : conversionController
    //                                                                   .selectedIndex
    //                                                                   .value ==
    //                                                               2
    //                                                           ? conversionController
    //                                                               .convertingIntoDiffFormats(
    //                                                               context,
    //                                                               widget
    //                                                                   .imagePath,
    //                                                               'heic',
    //                                                               'svg',
    //                                                             )
    //                                                           : const SizedBox();
    //                         }
    //                       },
    //                       child: Obx(
    //                         () => Container(
    //                           height: 50,
    //                           width: MediaQuery.of(context).size.width / 5.5,
    //                           decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(8),
    //                             color: UiColors.lightblueColor,
    //                           ),
    //                           child: conversionController.showLoader.value ==
    //                                   false
    //                               ? Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.center,
    //                                   children: [
    //                                     SizedBox(
    //                                         width: MediaQuery.of(context)
    //                                                 .size
    //                                                 .width /
    //                                             8,
    //                                         child: Text(
    //                                           AppLocalizations.of(context)!
    //                                               .convert_file,
    //                                           // "Convert File ",
    //                                           maxLines: 1,
    //                                           overflow: TextOverflow.ellipsis,
    //                                           textAlign: TextAlign.center,
    //                                           style: TextStyle(
    //                                             fontSize: 16,
    //                                             fontWeight: FontWeight.w700,
    //                                             color: UiColors.whiteColor,
    //                                           ),
    //                                         )),
    //                                     const SizedBox(
    //                                       width: 10,
    //                                     ),
    //                                     Image.asset(
    //                                       "assets/Convert.png",
    //                                       color: UiColors.whiteColor,
    //                                       height: 20,
    //                                     ),
    //                                   ],
    //                                 )
    //                               : const Center(
    //                                   child: CircularProgressIndicator(
    //                                     strokeWidth: 2,
    //                                     color: Colors.white,
    //                                   ),
    //                                 ),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               )
    //             : Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   const SizedBox(
    //                     height: 80,
    //                   ),
    //                   Center(
    //                     child: Obx(
    //                       () => Stack(
    //                         alignment: Alignment.center,
    //                         children: [
    //                           CircularPercentIndicator(
    //                             backgroundColor: Colors.black.withOpacity(0.1),
    //                             radius: 120.0,
    //                             lineWidth: 8.0,
    //                             percent:
    //                                 conversionController.percentage.value / 100,
    //                             progressColor: UiColors.lightblueColor,
    //                           ),
    //                           Positioned(
    //                             child: Stack(
    //                               alignment: Alignment.center,
    //                               children: [
    //                                 Container(
    //                                   height: 120,
    //                                   width: 120,
    //                                   decoration: BoxDecoration(
    //                                     color: Colors.white,
    //                                     boxShadow: [
    //                                       BoxShadow(
    //                                         color: UiColors.lightblueColor
    //                                             .withOpacity(0.1),
    //                                         spreadRadius: 4,
    //                                         blurRadius: 7,
    //                                         offset: const Offset(0,
    //                                             1.5), // changes position of shadow
    //                                       ),
    //                                     ],
    //                                     borderRadius:
    //                                         BorderRadius.circular(256),
    //                                   ),
    //                                 ),
    //                                 Positioned(
    //                                   child: Image.asset(
    //                                     conversionController
    //                                                 .isDownloading.value ==
    //                                             false
    //                                         ? "assets/Processing.png"
    //                                         : "assets/Complete.png",
    //                                     height: 70,
    //                                   ),
    //                                 )
    //                               ],
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 30,
    //                   ),
    //                   Text(
    //                     conversionController.isDownloading.value == false
    //                         ? AppLocalizations.of(context)!
    //                             .your_file_is_converting
    //                         : AppLocalizations.of(context)!.converted,
    //                     style: TextStyle(
    //                       fontSize: 22,
    //                       fontWeight: FontWeight.w500,
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 10,
    //                   ),
    //                   // const Spacer(),
    //                   SizedBox(
    //                     width: MediaQuery.sizeOf(context).width / 2,
    //                     child: RichText(
    //                       textAlign: TextAlign.center,
    //                       text: TextSpan(
    //                         style: TextStyle(
    //                           fontSize: 14,
    //                           // fontWeight: FontWeight.w500,
    //                           color: Colors.black,
    //                         ),
    //                         children: [
    //                           TextSpan(
    //                             text: AppLocalizations.of(context)!
    //                                 .files_are_uploaded_over_an_encrypted,
    //                           ),
    //                           TextSpan(
    //                             text: AppLocalizations.of(context)!
    //                                 .privacy_policy,
    //                             style: TextStyle(
    //                                 color: UiColors.lightblueColor),
    //                             recognizer: TapGestureRecognizer()
    //                               ..onTap = () {
    //                                 launchURLFunction(
    //                                   "www.eclixtech.com/privacy-policy",
    //                                 );
    //                               },
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 20,
    //                   ),
    //                 ],
    //               ),
    //       ],
    //     ),
    //   ),
    // );
  }

  launchURLFunction(String url) async {
    final Uri params = Uri(
      scheme: 'https',
      path: url,
    );
    launchUrl(params);
  }

  // conversionMethod() async {
  //   // int toolValue = await SharedPref().getToolValue();

  //   // int webpValue = await SharedPref().getWEBPValue();
  //   // int svgValue = await SharedPref().getSVGValue();
  //   // CustomEvent.firebaseCustom('OUTPUT_FORMAT_SCREEN_CONVERT_FILES_BTN');
  //   print("RERETTTTT ${conversionController.selectedIndex.value}");
  //   if (conversionController.selectedIndex.value == 10) {
  //     // ++toolValue;
  //     // await SharedPref().setToolValue(toolValue);
  //     // if (pdfValue <= 10 || isPremium.value) {
  //     try {
  //       if (conversionController.selectedIndex.value == 0) {
  //         Get.snackbar(
  //           backgroundColor: UiColors.whiteColor,
  //           duration: const Duration(seconds: 4),
  //           AppLocalizations.of(Get.context!)!.attention,
  //           "Please Select an option in which you want to convert!",
  //           // AppLocalizations.of(Get.context!)!
  //           //     .please_select_an_option_in_which_you_want_to_convert,
  //         );
  //         // conversionController.conversionOptionList(
  //         //     Get.context!, widget.imagePath!);
  //       }

  //       // await loopFunction();
  //       if (widget.imagePath[0].toLowerCase().endsWith('.jpg') ||
  //           widget.imagePath[0].toLowerCase().endsWith('.jpeg')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertJpgToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertJpgToPdfMulti(
  //                     Get.context!, widget.imagePath)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertJpgToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath,
  //                             widget.imagePath
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertJpgToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertJpgToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertJpgToBMPMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath[0].toLowerCase().endsWith('.png')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertPngToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertPngToPdfMulti(
  //                     Get.context!, widget.imagePath)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertPngToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertPngToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertPngToJPEGMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertPngToBMPMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.gif')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertGifToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertGifToPdfMulti(
  //                     Get.context!, widget.imagePath!)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertGifToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertGifToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertGifToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertGifToBmpMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.bmp')) {
  //         print("@@@@BMP");
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertBmpToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertBmpToPdfMulti(
  //                     Get.context!, widget.imagePath!)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertBmpToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertBmpToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertBmpToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertBmpToBmpMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.tiff') ||
  //           widget.imagePath![0].toLowerCase().endsWith('.tif')) {
  //         print("@@@@tif");
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertTifToJpg(
  //                 Get.context!, widget.imagePath![0])
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertTifToPdf(
  //                     Get.context!, widget.imagePath![0])
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertTifToPng(
  //                         Get.context!, widget.imagePath![0])
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertTiffToGif(
  //                                 Get.context!, widget.imagePath[0])
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertTiffToJpeg(
  //                                     Get.context!, widget.imagePath[0])
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController.convertTiffToBmp(
  //                                         Get.context!, widget.imagePath[0])
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath[0].toLowerCase().endsWith('.heic')) {
  //         print("@@@@heic");

  //         conversionController.convertingIntoDiffFormatsMulti(
  //           Get.context!,
  //           widget.imagePath,
  //           widget.imagePath
  //               .map((filePath) =>
  //                   path.extension(filePath).replaceFirst('.', ''))
  //               .toList(),
  //           conversionController.selectedIndex.value == 1
  //               ? 'jpg'
  //               : conversionController.selectedIndex.value == 2
  //                   ? 'gif'
  //                   : conversionController.selectedIndex.value == 3
  //                       ? 'jpeg'
  //                       : conversionController.selectedIndex.value == 4
  //                           ? 'png'
  //                           : conversionController.selectedIndex.value == 5
  //                               ? 'svg'
  //                               : conversionController.selectedIndex.value == 6
  //                                   ? 'webp'
  //                                   : conversionController
  //                                               .selectedIndex.value ==
  //                                           7
  //                                       ? 'bmp'
  //                                       : conversionController
  //                                                   .selectedIndex.value ==
  //                                               8
  //                                           ? 'doc'
  //                                           : conversionController
  //                                                       .selectedIndex.value ==
  //                                                   9
  //                                               ? 'txt'
  //                                               : conversionController
  //                                                           .selectedIndex
  //                                                           .value ==
  //                                                       10
  //                                                   ? 'pdf'
  //                                                   : conversionController
  //                                                               .selectedIndex
  //                                                               .value ==
  //                                                           11
  //                                                       ? 'xls'
  //                                                       : 'heic',
  //         );
  //       }
  //     } catch (e) {
  //       Get.snackbar(
  //           backgroundColor: UiColors.whiteColor,
  //           duration: const Duration(seconds: 4),
  //           AppLocalizations.of(Get.context!)!.attention,
  //           // AppLocalizations.of(Get.context!)!
  //           //     .please_try_again_after_some_time
  //           "Please try again after some time");
  //     }
  //     // }
  //     // else {
  //     //   Get.to(() => const PremiumPage());
  //     // }
  //   } else if (conversionController.selectedIndex.value == 6) {
  //     // int webp = await SharedPref().getWEBPValue();

  //     // ++webp;
  //     // await SharedPref().setWEBPValue(webp);
  //     // await SharedPref().setToolValue(toolValue);
  //     // if (webpValue <= 10 || isPremium.value) {
  //     try {
  //       if (conversionController.selectedIndex.value == 0) {
  //         Get.snackbar(
  //             backgroundColor: UiColors.whiteColor,
  //             duration: const Duration(seconds: 4),
  //             AppLocalizations.of(Get.context!)!.attention,
  //             "Please select an option in which you want to convert"
  //             // AppLocalizations.of(Get.context!)!
  //             //     .please_select_an_option_in_which_you_want_to_convert,
  //             );
  //         conversionController.conversionOptionList(
  //             Get.context!, widget.imagePath);
  //       }

  //       // await loopFunction();
  //       if (widget.imagePath[0].toLowerCase().endsWith('.jpg') ||
  //           widget.imagePath[0].toLowerCase().endsWith('.jpeg')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertJpgToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertJpgToPdfMulti(
  //                     Get.context!, widget.imagePath)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertJpgToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath,
  //                             widget.imagePath
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertJpgToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertJpgToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertJpgToBMPMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.png')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertPngToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertPngToPdfMulti(
  //                     Get.context!, widget.imagePath)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertPngToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath,
  //                             widget.imagePath
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertPngToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertPngToJPEGMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertPngToBMPMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath,
  //                                             widget.imagePath
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath[0].toLowerCase().endsWith('.gif')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertGifToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertGifToPdfMulti(
  //                     Get.context!, widget.imagePath)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertGifToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath,
  //                             widget.imagePath
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertGifToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertGifToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertGifToBmpMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath[0].toLowerCase().endsWith('.bmp')) {
  //         print("@@@@BMP");
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertBmpToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertBmpToPdfMulti(
  //                     Get.context!, widget.imagePath!)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertBmpToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath,
  //                             widget.imagePath
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertBmpToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertBmpToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertBmpToBmpMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.tiff') ||
  //           widget.imagePath![0].toLowerCase().endsWith('.tif')) {
  //         print("@@@@tif");
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertTifToJpg(
  //                 Get.context!, widget.imagePath![0])
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertTifToPdf(
  //                     Get.context!, widget.imagePath![0])
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertTifToPng(
  //                         Get.context!, widget.imagePath![0])
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertTiffToGif(
  //                                 Get.context!, widget.imagePath![0])
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertTiffToJpeg(
  //                                     Get.context!, widget.imagePath![0])
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController.convertTiffToBmp(
  //                                         Get.context!, widget.imagePath![0])
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.heic')) {
  //         print("@@@@heic");

  //         conversionController.convertingIntoDiffFormatsMulti(
  //           Get.context!,
  //           widget.imagePath!,
  //           widget.imagePath!
  //               .map((filePath) =>
  //                   path.extension(filePath).replaceFirst('.', ''))
  //               .toList(),
  //           conversionController.selectedIndex.value == 1
  //               ? 'jpg'
  //               : conversionController.selectedIndex.value == 2
  //                   ? 'gif'
  //                   : conversionController.selectedIndex.value == 3
  //                       ? 'jpeg'
  //                       : conversionController.selectedIndex.value == 4
  //                           ? 'png'
  //                           : conversionController.selectedIndex.value == 5
  //                               ? 'svg'
  //                               : conversionController.selectedIndex.value == 6
  //                                   ? 'webp'
  //                                   : conversionController
  //                                               .selectedIndex.value ==
  //                                           7
  //                                       ? 'bmp'
  //                                       : conversionController
  //                                                   .selectedIndex.value ==
  //                                               8
  //                                           ? 'doc'
  //                                           : conversionController
  //                                                       .selectedIndex.value ==
  //                                                   9
  //                                               ? 'txt'
  //                                               : conversionController
  //                                                           .selectedIndex
  //                                                           .value ==
  //                                                       10
  //                                                   ? 'pdf'
  //                                                   : conversionController
  //                                                               .selectedIndex
  //                                                               .value ==
  //                                                           11
  //                                                       ? 'xls'
  //                                                       : 'heic',
  //         );
  //       }
  //     } catch (e) {
  //       Get.snackbar(
  //           backgroundColor: UiColors.whiteColor,
  //           duration: const Duration(seconds: 4),
  //           AppLocalizations.of(Get.context!)!.attention,
  //           "Please try agin after some time"
  //           // AppLocalizations.of(Get.context!)!
  //           //     .please_try_again_after_some_time
  //           );
  //     }
  //     // } else {
  //     //   Get.to(() => const PremiumPage());
  //     // }
  //   } else if (conversionController.selectedIndex.value == 5) {
  //     // ++toolValue;
  //     // await SharedPref().setToolValue(toolValue);
  //     // int svgLimit = await SharedPref().getSVGValue();

  //     // ++svgLimit;
  //     // await SharedPref().setSVGValue(svgLimit);
  //     // if (svgValue <= 10 || isPremium.value) {
  //     try {
  //       if (conversionController.selectedIndex.value == 0) {
  //         Get.snackbar(
  //             backgroundColor: UiColors.whiteColor,
  //             duration: const Duration(seconds: 4),
  //             AppLocalizations.of(Get.context!)!.attention,
  //             "Please select an option in which you want to convert"
  //             // AppLocalizations.of(Get.context!)!
  //             //     .please_select_an_option_in_which_you_want_to_convert,
  //             );
  //         conversionController.conversionOptionList(
  //             Get.context!, widget.imagePath);
  //       }

  //       // await loopFunction();
  //       if (widget.imagePath![0].toLowerCase().endsWith('.jpg') ||
  //           widget.imagePath![0].toLowerCase().endsWith('.jpeg')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertJpgToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertJpgToPdfMulti(
  //                     Get.context!, widget.imagePath)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertJpgToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath,
  //                             widget.imagePath
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertJpgToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertJpgToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertJpgToBMPMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath,
  //                                             widget.imagePath
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath[0].toLowerCase().endsWith('.png')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertPngToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertPngToPdfMulti(
  //                     Get.context!, widget.imagePath)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertPngToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertPngToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertPngToJPEGMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertPngToBMPMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.gif')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertGifToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertGifToPdfMulti(
  //                     Get.context!, widget.imagePath!)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertGifToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertGifToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertGifToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertGifToBmpMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.bmp')) {
  //         print("@@@@BMP");
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertBmpToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertBmpToPdfMulti(
  //                     Get.context!, widget.imagePath!)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertBmpToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertBmpToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertBmpToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertBmpToBmpMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.tiff') ||
  //           widget.imagePath![0].toLowerCase().endsWith('.tif')) {
  //         print("@@@@tif");
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertTifToJpg(
  //                 Get.context!, widget.imagePath![0])
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertTifToPdf(
  //                     Get.context!, widget.imagePath![0])
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertTifToPng(
  //                         Get.context!, widget.imagePath![0])
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertTiffToGif(
  //                                 Get.context!, widget.imagePath![0])
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertTiffToJpeg(
  //                                     Get.context!, widget.imagePath![0])
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController.convertTiffToBmp(
  //                                         Get.context!, widget.imagePath![0])
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.heic')) {
  //         print("@@@@heic");

  //         conversionController.convertingIntoDiffFormatsMulti(
  //           Get.context!,
  //           widget.imagePath!,
  //           widget.imagePath!
  //               .map((filePath) =>
  //                   path.extension(filePath).replaceFirst('.', ''))
  //               .toList(),
  //           conversionController.selectedIndex.value == 1
  //               ? 'jpg'
  //               : conversionController.selectedIndex.value == 2
  //                   ? 'gif'
  //                   : conversionController.selectedIndex.value == 3
  //                       ? 'jpeg'
  //                       : conversionController.selectedIndex.value == 4
  //                           ? 'png'
  //                           : conversionController.selectedIndex.value == 5
  //                               ? 'svg'
  //                               : conversionController.selectedIndex.value == 6
  //                                   ? 'webp'
  //                                   : conversionController
  //                                               .selectedIndex.value ==
  //                                           7
  //                                       ? 'bmp'
  //                                       : conversionController
  //                                                   .selectedIndex.value ==
  //                                               8
  //                                           ? 'doc'
  //                                           : conversionController
  //                                                       .selectedIndex.value ==
  //                                                   9
  //                                               ? 'txt'
  //                                               : conversionController
  //                                                           .selectedIndex
  //                                                           .value ==
  //                                                       10
  //                                                   ? 'pdf'
  //                                                   : conversionController
  //                                                               .selectedIndex
  //                                                               .value ==
  //                                                           11
  //                                                       ? 'xls'
  //                                                       : 'heic',
  //         );
  //       }
  //     } catch (e) {
  //       Get.snackbar(
  //           backgroundColor: UiColors.whiteColor,
  //           duration: const Duration(seconds: 4),
  //           AppLocalizations.of(Get.context!)!.attention,
  //           "Please try again after some time"
  //           // AppLocalizations.of(Get.context!)!
  //           //     .please_try_again_after_some_time
  //           );
  //     }
  //     // } else {
  //     //   Get.to(() => const PremiumPage());
  //     // }
  //   } else if (conversionController.selectedIndex.value == 1 ||
  //       conversionController.selectedIndex.value == 4 ||
  //       conversionController.selectedIndex.value == 2 ||
  //       conversionController.selectedIndex.value == 3 ||
  //       conversionController.selectedIndex.value == 7) {
  //     try {
  //       if (conversionController.selectedIndex.value == 0) {
  //         Get.snackbar(
  //           backgroundColor: UiColors.whiteColor,
  //           duration: const Duration(seconds: 4),
  //           AppLocalizations.of(Get.context!)!.attention,
  //           // AppLocalizations.of(Get.context!)!
  //           //     .please_select_an_option_in_which_you_want_to_convert,
  //           "Please select an option in which you want to convert",
  //         );
  //         conversionController.conversionOptionList(
  //             Get.context!, widget.imagePath);
  //       }

  //       // await loopFunction();
  //       if (widget.imagePath![0].toLowerCase().endsWith('.jpg') ||
  //           widget.imagePath![0].toLowerCase().endsWith('.jpeg')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertJpgToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertJpgToPdfMulti(
  //                     Get.context!, widget.imagePath)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertJpgToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertJpgToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertJpgToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertJpgToBMPMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.png')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertPngToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertPngToPdfMulti(
  //                     Get.context!, widget.imagePath)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertPngToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertPngToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertPngToJPEGMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertPngToBMPMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.gif')) {
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertGifToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertGifToPdfMulti(
  //                     Get.context!, widget.imagePath!)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertGifToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertGifToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertGifToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertGifToBmpMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.bmp')) {
  //         print("@@@@BMP");
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertBmpToJpgMulti(
  //                 Get.context!, widget.imagePath)
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertBmpToPdfMulti(
  //                     Get.context!, widget.imagePath!)
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertBmpToPngMulti(
  //                         Get.context!, widget.imagePath)
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertBmpToGifMulti(
  //                                 Get.context!, widget.imagePath)
  //                             : conversionController.selectedIndex.value == 3
  //                                 ? conversionController.convertBmpToJpegMulti(
  //                                     Get.context!, widget.imagePath)
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController
  //                                         .convertBmpToBmpMulti(
  //                                             Get.context!, widget.imagePath)
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.tiff') ||
  //           widget.imagePath![0].toLowerCase().endsWith('.tif')) {
  //         print("@@@@tif");
  //         conversionController.selectedIndex.value == 1
  //             ? conversionController.convertTifToJpg(
  //                 Get.context!, widget.imagePath![0])
  //             : conversionController.selectedIndex.value == 10
  //                 ? conversionController.convertTifToPdf(
  //                     Get.context!, widget.imagePath![0])
  //                 : conversionController.selectedIndex.value == 4
  //                     ? conversionController.convertTifToPng(
  //                         Get.context!, widget.imagePath![0])
  //                     : conversionController.selectedIndex.value == 6
  //                         ? conversionController.convertingIntoDiffFormatsMulti(
  //                             Get.context!,
  //                             widget.imagePath!,
  //                             widget.imagePath!
  //                                 .map((filePath) => path
  //                                     .extension(filePath)
  //                                     .replaceFirst('.', ''))
  //                                 .toList(),
  //                             'webp',
  //                           )
  //                         : conversionController.selectedIndex.value == 2
  //                             ? conversionController.convertTiffToGif(
  //                                 Get.context!, widget.imagePath![0])
  //                             : conversionController.selectedIndex.value == 2
  //                                 ? conversionController.convertTiffToJpeg(
  //                                     Get.context!, widget.imagePath![0])
  //                                 : conversionController.selectedIndex.value ==
  //                                         7
  //                                     ? conversionController.convertTiffToBmp(
  //                                         Get.context!, widget.imagePath![0])
  //                                     : conversionController
  //                                                 .selectedIndex.value ==
  //                                             5
  //                                         ? conversionController
  //                                             .convertingIntoDiffFormatsMulti(
  //                                             Get.context!,
  //                                             widget.imagePath!,
  //                                             widget.imagePath!
  //                                                 .map((filePath) => path
  //                                                     .extension(filePath)
  //                                                     .replaceFirst('.', ''))
  //                                                 .toList(),
  //                                             'svg',
  //                                           )
  //                                         : const SizedBox();
  //       } else if (widget.imagePath![0].toLowerCase().endsWith('.heic')) {
  //         print("@@@@heic");

  //         conversionController.convertingIntoDiffFormatsMulti(
  //           Get.context!,
  //           widget.imagePath!,
  //           widget.imagePath!
  //               .map((filePath) =>
  //                   path.extension(filePath).replaceFirst('.', ''))
  //               .toList(),
  //           conversionController.selectedIndex.value == 1
  //               ? 'jpg'
  //               : conversionController.selectedIndex.value == 2
  //                   ? 'gif'
  //                   : conversionController.selectedIndex.value == 3
  //                       ? 'jpeg'
  //                       : conversionController.selectedIndex.value == 4
  //                           ? 'png'
  //                           : conversionController.selectedIndex.value == 5
  //                               ? 'svg'
  //                               : conversionController.selectedIndex.value == 6
  //                                   ? 'webp'
  //                                   : conversionController
  //                                               .selectedIndex.value ==
  //                                           7
  //                                       ? 'bmp'
  //                                       : conversionController
  //                                                   .selectedIndex.value ==
  //                                               8
  //                                           ? 'doc'
  //                                           : conversionController
  //                                                       .selectedIndex.value ==
  //                                                   9
  //                                               ? 'txt'
  //                                               : conversionController
  //                                                           .selectedIndex
  //                                                           .value ==
  //                                                       10
  //                                                   ? 'pdf'
  //                                                   : conversionController
  //                                                               .selectedIndex
  //                                                               .value ==
  //                                                           11
  //                                                       ? 'xls'
  //                                                       : 'heic',
  //         );
  //       }
  //     } catch (e) {
  //       Get.snackbar(
  //         backgroundColor: UiColors.whiteColor,
  //         duration: const Duration(seconds: 4),
  //         AppLocalizations.of(Get.context!)!.attention,
  //         // AppLocalizations.of(Get.context!)!
  //         //     .please_try_again_after_some_time
  //         "Please try again after some time",
  //       );
  //       Get.back();
  //     }
  //   } else if (conversionController.selectedIndex.value == 9) {
  //     // ++toolValue;
  //     // await SharedPref().setToolValue(toolValue);
  //     print("Image to Text New Tool");
  //     conversionController.imageToTextTool(
  //       Get.context!,
  //       widget.imagePath!,
  //       widget.imagePath!
  //           .map((filePath) => path.extension(filePath).replaceFirst('.', ''))
  //           .toList(),
  //       'txt',
  //     );
  //   } else if (conversionController.selectedIndex.value == 8) {
  //     // ++toolValue;
  //     // await SharedPref().setToolValue(toolValue);
  //     await conversionController.imageToDocTool(
  //         Get.context!, widget.imagePath!, 'doc');
  //   } else if (conversionController.selectedIndex.value == 11) {
  //     if (widget.imagePath!.first.contains('.BMP') ||
  //         widget.imagePath!.first.contains('.bmp')) {
  //       log("I am triggered");
  //       List<String> tempList = [];
  //       Directory? dir = await getTemporaryDirectory();
  //       print("%%%%directory $dir");

  //       var path =
  //           '${dir.path}/Img_${DateTime.now().microsecondsSinceEpoch}.png';
  //       // print("%%%%path  $path");

  //       im.Image? bmpImage =
  //           im.decodeImage(await File(widget.imagePath!.first).readAsBytes());

  //       File file = File(path);
  //       file.writeAsBytesSync(
  //         im.encodeJpg(
  //           bmpImage!,
  //         ),
  //       );
  //       tempList.add(file.path);
  //       await conversionController.imageToExcelTool(
  //           Get.context!, tempList, 'xlsx');
  //     } else {
  //       await conversionController.imageToExcelTool(
  //           Get.context!, widget.imagePath!, 'xlsx');
  //     }
  //   } else if (conversionController.selectedIndex.value == 12 ||
  //       conversionController.selectedIndex.value == 13 ||
  //       conversionController.selectedIndex.value == 14 ||
  //       conversionController.selectedIndex.value == 15 ||
  //       conversionController.selectedIndex.value == 16 ||
  //       conversionController.selectedIndex.value == 17 ||
  //       conversionController.selectedIndex.value == 18) {
  //     print("NEW TOOLS CONVERSIONS");
  //     // ++toolValue;
  //     // await SharedPref().setToolValue(toolValue);
  //     // setToolsValue();
  //     if (widget.imagePath!.first.contains('.png') ||
  //         widget.imagePath!.first.contains('.jpg') ||
  //         widget.imagePath!.first.contains('.jpeg')) {
  //       print("CORRECT");
  //       conversionController.selectedIndex.value == 12 ||
  //               conversionController.selectedIndex.value == 13 ||
  //               conversionController.selectedIndex.value == 14 ||
  //               conversionController.selectedIndex.value == 15 ||
  //               conversionController.selectedIndex.value == 16 ||
  //               conversionController.selectedIndex.value == 17 ||
  //               conversionController.selectedIndex.value == 18
  //           ? conversionController.convertingIntoDiffFormatsMulti(
  //               Get.context!,
  //               widget.imagePath!,
  //               widget.imagePath!
  //                   .map((filePath) =>
  //                       path.extension(filePath).replaceFirst('.', ''))
  //                   .toList(),
  //               conversionController.selectedIndex.value == 12
  //                   ? 'tiff'
  //                   : conversionController.selectedIndex.value == 13
  //                       ? 'raw'
  //                       : conversionController.selectedIndex.value == 14
  //                           ? 'psd'
  //                           : conversionController.selectedIndex.value == 15
  //                               ? 'dds'
  //                               : conversionController.selectedIndex.value == 16
  //                                   ? 'heic'
  //                                   : conversionController
  //                                               .selectedIndex.value ==
  //                                           17
  //                                       ? 'ppm'
  //                                       : conversionController
  //                                                   .selectedIndex.value ==
  //                                               18
  //                                           ? 'tga'
  //                                           : 'tiff',
  //             )
  //           : const SizedBox();
  //     } else {
  //       print("Wrong");
  //     }
  //   }
  // }
}
