import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/convert_images_controller.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    AppLocalizations.of(context)!.converted,
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
            optionList(
                "assets/EXport.png", AppLocalizations.of(context)!.export,
                () async {
              _exportFile(widget.convertedFile);
            }),
            const SizedBox(
              width: 30,
            ),
            optionList(
                "assets/Convert.png", AppLocalizations.of(context)!.reconvert,
                // AppLocalizations.of(context)!.reconvert,
                () async {
              conversionController.selectedIndex.value = 0;
              Get.back();
            }),
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
                              _getFileName(widget.originalFilePath),
                              // widget.originalFilePath.length > 20
                              //     ? '${widget.originalFilePath.substring(0, 10)}...${widget.originalFilePath.substring(widget.originalFilePath.length - 10)}'
                              //     : widget.originalFilePath,
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
                              _getFileName(
                                widget.convertedFile.path,
                              ),
                              // widget.convertedFile.path.length > 20
                              //     ? '${widget.convertedFile.path.substring(0, 10)}...${widget.convertedFile.path.substring(widget.convertedFile.path.length - 10)}'
                              //     : widget.convertedFile.path,
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
                                  "assets/zoom-in.png",
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            )
                          ],
                        )
                      : Stack(
                          children: [
                            SizedBox(
                              // decoration: BoxDecoration(border: Border.all()),
                              width: 300,
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
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          UiColors.blackColor.withOpacity(0.2)),
                                  child: Image.asset(
                                    "assets/zoom-in.png",
                                    height: 30,
                                    width: 30,
                                  ),
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

  Future<void> _exportFile(
    FileSystemEntity file,
  ) async {
    try {
      final filePath = file.uri.toFilePath();
      File imageFile = File(filePath);

      Directory? dir = await getDownloadsDirectory();

      var targetDirectoryPath = '${dir!.path}/ImageConverterExport';

      // Check if the source file exists
      if (!imageFile.existsSync()) {
        print("#### Error: Source file doesn't exist");
        return;
      }

      // Create the target directory if it doesn't exist
      Directory exportDir = Directory(targetDirectoryPath);
      if (!exportDir.existsSync()) {
        exportDir.createSync(recursive: true);
      }

      // Construct the target file path
      String fileName = imageFile.path.split('/').last;
      String targetFilePath = '$targetDirectoryPath/$fileName';

      // Copy the source file to the target file path
      await imageFile.copy(targetFilePath);

      Get.offAll(() => const HomeScreen());

      Get.snackbar(
        backgroundColor: Colors.white,
        AppLocalizations.of(Get.context!)!.attention,
        "File Saved Successfully",
      );

      print("#### Image exported to: $targetFilePath");
    } catch (e) {
      print('####Error exporting file: $e');
    }
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
              SizedBox(
                width: 140,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
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

  String _getFileName(String filePath) {
    String fileName = filePath.split('/').last;
    if (fileName.length > 20) {
      fileName =
          '${fileName.substring(0, 8)}...${fileName.substring(fileName.length - 10)}';
    }
    return fileName;
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
        "${AppLocalizations.of(Get.context!)!.error}!!!",
        AppLocalizations.of(Get.context!)!.no_app_found_to_open,
      );
    }
  }

  void _shareFile(FileSystemEntity fileEntity) {
    if (fileEntity is File) {
      String fileName = fileEntity.uri.pathSegments.last;
      // ignore: deprecated_member_use
      Share.shareFiles([fileEntity.path], text: 'Sharing file: $fileName');
    } else {
      print('Selected item is not a file.');
      Get.snackbar(
          colorText: Colors.black,
          backgroundColor: Colors.grey.withOpacity(0.3),
          duration: const Duration(seconds: 4),
          "${AppLocalizations.of(Get.context!)!.attention}!!!",
          AppLocalizations.of(Get.context!)!.error);
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
