import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/convert_images_controller.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;

class ConversionResult extends StatefulWidget {
  final String imageFormat;
  final String originalFilePath;
  final File convertedFile;
  const ConversionResult({
    required this.imageFormat,
    required this.originalFilePath,
    required this.convertedFile,
    super.key,
  });

  @override
  State<ConversionResult> createState() => _ConversionResultState();
}

class _ConversionResultState extends State<ConversionResult> {
  final conversionController = Get.put(ConvertImagesController());
  @override
  void initState() {
    super.initState();
    print("originalFilePath ${widget.originalFilePath}");
    print("convertedFile ${widget.convertedFile.path}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const HomeScreen());
        return false;
      },
      child: Scaffold(
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
                  onTap: () => Get.offAll(() => const HomeScreen()),
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 30.0, left: 10, right: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
              onTap: () {
                _shareFile(widget.convertedFile);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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
                      horizontal: 20.0, vertical: 15),
                  child: Image.asset(
                    "assets/share.png",
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 30,
            ),
            optionList("assets/EXport.png", "Export", () async {
              _exportFile(widget.convertedFile);
            }),
            const SizedBox(
              width: 30,
            ),
            optionList("assets/Convert.png", "Reconvert",
                // AppLocalizations.of(context)!.reconvert,
                () async {
              conversionController.selectedIndex.value = 0;
              Get.back();
            }),
            // InkWell(
            //   onTap: () {
            //     conversionController.selectedIndex.value = 0;
            //     Get.back();
            //   },
            //   child: Container(
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(12),
            //         color: UiColors.whiteColor,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(0.4),
            //             blurRadius: 8,
            //             offset: const Offset(0, 0),
            //           ),
            //         ]),
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: 15.0, vertical: 15),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           SizedBox(
            //             width: MediaQuery.of(context).size.width / 5,
            //             child: Text(
            //               // AppLocalizations.of(context)!.reconvert,
            //               "Reconvert",
            //               maxLines: 1,
            //               overflow: TextOverflow.ellipsis,
            //               style: GoogleFonts.poppins(
            //                 fontSize: 14,
            //               ),
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           Image.asset(
            //             "assets/Convert.png",
            //             height: 20,
            //             width: 20,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ]),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: UiColors.whiteColor),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: Image.asset(
                                widget.imageFormat == '.jpg'
                                    ? "assets/JPG.png"
                                    : widget.imageFormat == '.pdf'
                                        ? "assets/PDF.png"
                                        : widget.imageFormat == '.png'
                                            ? "assets/PNG.png"
                                            : widget.imageFormat == '.webp'
                                                ? "assets/WEBP.png"
                                                : widget.imageFormat == '.gif'
                                                    ? "assets/GIF.png"
                                                    : widget.imageFormat ==
                                                            '.jpeg'
                                                        ? "assets/JPEG.png"
                                                        : widget.imageFormat ==
                                                                '.bmp'
                                                            ? "assets/BMP.png"
                                                            : widget.imageFormat ==
                                                                    '.svg'
                                                                ? "assets/SVG.png"
                                                                : "assets/JPG.png",
                                height: 55,
                              ),
                            ),
                            Text(
                              widget.originalFilePath.length > 20
                                  ? '${widget.originalFilePath.substring(0, 10)}...${widget.originalFilePath.substring(widget.originalFilePath.length - 10)}'
                                  : widget.originalFilePath,
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 40),
                        child: Image.asset(
                          "assets/Convert.png",
                          height: 40,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: UiColors.whiteColor),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: Image.asset(
                                conversionController.selectedIndex.value == 1
                                    ? "assets/JPG.png"
                                    : conversionController
                                                .selectedIndex.value ==
                                            2
                                        ? "assets/PDF.png"
                                        : conversionController
                                                    .selectedIndex.value ==
                                                3
                                            ? "assets/PNG.png"
                                            : conversionController
                                                        .selectedIndex.value ==
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
                                height: 55,
                              ),
                            ),
                            Text(
                              widget.convertedFile.path.length > 20
                                  ? '${widget.convertedFile.path.substring(0, 10)}...${widget.convertedFile.path.substring(widget.convertedFile.path.length - 10)}'
                                  : widget.convertedFile.path,
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 70,
                  ),
                  conversionController.selectedIndex.value == 2 ||
                          conversionController.selectedIndex.value == 4 ||
                          conversionController.selectedIndex.value == 8
                      ? Stack(
                          children: [
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: Image.asset(
                                "assets/logo.png",
                                // height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 10,
                              child: InkWell(
                                onTap: () {
                                  _openFile(widget.convertedFile);
                                },
                                child: Image.asset(
                                  "assets/Zom.png",
                                  height: 50,
                                  width: 60,
                                ),
                              ),
                            )
                          ],
                        )
                      : Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all()),
                              width: 350,
                              height: 250,
                              child: Image.file(
                                File(
                                  widget.convertedFile.path,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: InkWell(
                                onTap: () {
                                  _openFile(widget.convertedFile);
                                },
                                child: Image.asset(
                                  "assets/Zom.png",
                                  height: 50,
                                  width: 60,
                                ),
                              ),
                            )
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  optionList(String imageName, String name, VoidCallback onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: UiColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Image.asset(
                imageName,
                height: 25,
                width: 25,
              ),
            ],
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

      final documentsDir = await getApplicationDocumentsDirectory();
      print("documentsDir $documentsDir");

      // Create the folder if it doesn't exist
      final pdfFolder = Directory(documentsDir.path);
      if (!pdfFolder.existsSync()) {
        pdfFolder.createSync(recursive: true);
      }

      final destinationPath =
          path.join(pdfFolder.path, file.uri.pathSegments.last);
      print("destinationPath $destinationPath");

      await File(filePath).copy(destinationPath);

      Get.offAll(() => const HomeScreen());
      print('PDF saved to documents: $destinationPath');
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
