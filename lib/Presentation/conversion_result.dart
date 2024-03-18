import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/convert_images_controller.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class ConversionResult extends StatefulWidget {
  final String imageFormat;
  final String originalSize;
  final String convertedSize;
  final String dateTime;
  final File convertedFile;
  const ConversionResult({
    required this.imageFormat,
    required this.originalSize,
    required this.convertedSize,
    required this.dateTime,
    required this.convertedFile,
    super.key,
  });

  @override
  State<ConversionResult> createState() => _ConversionResultState();
}

class _ConversionResultState extends State<ConversionResult> {
  RxDouble finalRating = 0.0.obs;
  RxBool showRatingBox = true.obs;
  int? rateUs;
  RxBool ratingStatus = false.obs;

  final conversionController = Get.put(ConvertImagesController());
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      rateUs = prefs.getInt("rateUs");
      rateUs == null ? ratingStatus.value = true : const SizedBox();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const HomeScreen());
        return false;
      },
      child: Scaffold(
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
                      height: 25,
                      width: 25,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Converted',
                    style: GoogleFonts.poppins(
                      color: UiColors.blueColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // appBar: AppBar(
        //   centerTitle: true,
        //   automaticallyImplyLeading: false,
        //   title: Text(
        //     // AppLocalizations.of(context)!.converted,
        //     'Converted',
        //     style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        //   ),
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.only(right: 10.0, left: 10.0),
        //       child: InkWell(
        //         onTap: () {
        //           Get.offAll(() => const HomeScreen());
        //         },
        //         child: Image.asset(
        //           "assets/Home.png",
        //           height: 25,
        //           width: 25,
        //         ),
        //       ),
        //     )
        //   ],
        // ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 30.0, left: 10, right: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
              flex: 1,
              child: optionList("assets/Preveiw.png", () {
                widget.imageFormat == '.svg'
                    ? Get.snackbar(
                        // backgroundColor: Colors.white,
                        "Could open this file",
                        "No App found to Open")
                    : _openFile(widget.convertedFile);
              }),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: optionList("assets/share.png", () {
                _shareFile(widget.convertedFile);
              }),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: optionList("assets/EXport.png", () async {
                _exportFile(widget.convertedFile);
              }),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  conversionController.selectedIndex.value = 0;
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: UiColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            // AppLocalizations.of(context)!.reconvert,
                            "Reconvert",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          "assets/Convert.png",
                          height: 20,
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
        body: Column(
          children: [
            Divider(
              thickness: 1,
              color: Colors.grey[200],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  widget.imageFormat == '.webp' ||
                          widget.imageFormat == '.svg' ||
                          widget.imageFormat == '.pdf'
                      ? Image.asset(
                          "assets/logo.png",
                          height: 100,
                          // width: 90,
                        )
                      : SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(File(widget.convertedFile.path)),
                        ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      featureNames(
                          // "${AppLocalizations.of(context)!.image_format}:",
                          'Image format '),
                      const SizedBox(
                        height: 5,
                      ),
                      featureNames(
                          // "${AppLocalizations.of(context)!.original_size}:",
                          'Orignal Size'),
                      const SizedBox(
                        height: 5,
                      ),
                      featureNames(
                          // "${AppLocalizations.of(context)!.converted_size}:",
                          "Converted Size"),
                      const SizedBox(
                        height: 5,
                      ),
                      featureNames(
                          // "${AppLocalizations.of(context)!.date_time}:",
                          "Date/Time"),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.imageFormat,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: UiColors.blackColor.withOpacity(0.5)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.originalSize,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: UiColors.blackColor.withOpacity(0.5)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.convertedSize,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: UiColors.blackColor.withOpacity(0.5)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.dateTime,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: UiColors.blackColor.withOpacity(0.5)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  optionList(String imageName, VoidCallback onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: UiColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Image.asset(
            imageName,
            height: 30,
            width: 30,
          ),
        ),
      ),
    );
  }

  Future<void> _openFile(FileSystemEntity file) async {
    try {
      final filePath = file.uri.toFilePath();

      await OpenFile.open(filePath);
    } catch (e) {
      print('Error opening file: $e');
      Get.snackbar(
        colorText: Colors.black,
        backgroundColor: Colors.grey.withOpacity(0.3),
        duration: const Duration(seconds: 4),
        "${"ERROR"}!!!",
        "${"ERROR"}  ${
        // AppLocalizations.of(context)!.opening_file
        'opening_file'}",
      );
    }
  }

  void _shareFile(FileSystemEntity fileEntity) {
    if (fileEntity is File) {
      String fileName = fileEntity.uri.pathSegments.last;
      Share.shareFiles([fileEntity.path], text: 'Sharing file: $fileName');
    } else {
      print('Selected item is not a file.');
      Get.snackbar(
        colorText: Colors.black,
        backgroundColor: Colors.grey.withOpacity(0.3),
        duration: const Duration(seconds: 4),
        "${"Attention"}!!!",
        "ERROR",
      );
    }
  }

  Future<void> _exportFile(FileSystemEntity file) async {
    try {
      final filePath = file.uri.toFilePath();
      print("filePath $filePath");

      // Check if the file is a PDF
      if (path.extension(filePath).toLowerCase() == '.pdf' ||
          path.extension(filePath).toLowerCase() == '.bmp' ||
          path.extension(filePath).toLowerCase() == '.webp' ||
          path.extension(filePath).toLowerCase() == '.svg') {
        final documentsDir = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();
        print("documentsDir $documentsDir");

        // Create the folder if it doesn't exist
        final pdfFolder = Directory(documentsDir!.path);
        if (!pdfFolder.existsSync()) {
          pdfFolder.createSync(recursive: true);
        }

        final destinationPath =
            path.join(pdfFolder.path, file.uri.pathSegments.last);
        print("destinationPath $destinationPath");

        await File(filePath).copy(destinationPath);

        // Get.snackbar(
        //   colorText: Colors.black,
        //   backgroundColor: Colors.white,
        //   duration: const Duration(seconds: 4),
        //   // "Attention",
        //   // "Attention"
        //   // AppLocalizations.of(context)!.pdf_saved_to_documents,
        //   "Image Saved to Documents"
        //
        // );
        Get.offAll(() => const HomeScreen());
        print('PDF saved to documents: $destinationPath');
      } else {
        // Save other file formats to gallery
        final result = await ImageGallerySaver.saveFile(filePath);

        if (result['isSuccess']) {
          Get.snackbar(
              colorText: Colors.black,
              backgroundColor: Colors.white,
              duration: const Duration(seconds: 4),
              "Attention",
              // AppLocalizations.of(context)!.image_saved_to_gallery,
              "Image SAVED TO GALLERY");
          print('Image saved to gallery!');
          Get.offAll(const HomeScreen());
        } else {
          print('Failed to save image: ${result['errorMessage']}');
        }
      }
    } catch (e) {
      print('Error exporting file: $e');
    }
  }

  featureNames(String featureName) {
    return SizedBox(
      // decoration: BoxDecoration(border: Border.all()),
      width: MediaQuery.of(context).size.width / 2.5,
      child: Text(
        featureName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
            fontSize: 16, color: UiColors.blackColor.withOpacity(0.5)),
      ),
    );
  }
}
