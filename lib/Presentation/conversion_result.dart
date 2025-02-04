import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Controller/convert_images_controller.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:image_converter_macos/Presentation/rating_dialog.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:path/path.dart' as path;

class ConversionResult extends StatefulWidget {
  final String imageFormat;
  final String originalFilePath;
  final List<File> convertedFile;
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
  RxList<String> fileName = <String>[].obs;
  RxList<double> fileSize = <double>[].obs;
  int? rateUs;
  Directory? directory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      rateUs = prefs.getInt("rateUs");
      rateUs == null
          ? DialogBoxRating().dialogRating(Get.context!)
          : const SizedBox();
      print("88777 ${conversionController.selectedIndex.value}");
    });
    print("convertedFile ${widget.convertedFile}");
    for (int i = 0; i < widget.convertedFile.length; i++) {
      fileSize.add(getFileSizeInKB(widget.convertedFile[i]));
    }
    for (int i = 0; i < widget.convertedFile.length; i++) {
      fileName.add(getName(widget.convertedFile[i].path));
    }
    print("fileName $fileName");
  }

  double getFileSizeInKB(File file) {
    final bytes = file.lengthSync();
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
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const HomeScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: UiColors.whiteColor,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Get.offAll(() => const HomeScreen(
                          index: 1,
                        )),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: UiColors.greyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8)),
                      child: Image.asset(
                        'assets/back_arrow.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  GestureDetector(
                    onTap: () => Get.offAll(() => const HomeScreen(
                          index: 1,
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.converted,
                          style: TextStyle(
                            color: UiColors.blackColor,
                            fontSize: 26.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "You can download, Share and Preview converted files",
                          style: TextStyle(
                            color: UiColors.blackColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              widget.convertedFile.length == 1 ? Spacer() : SizedBox(),
              SizedBox(
                height: Get.width * 0.05,
              ),
              // Obx(
              //   () => (
              // ((conversionController.selectedIndex.value == 1) ||
              //           (conversionController.selectedIndex.value == 2) ||
              //           (conversionController.selectedIndex.value == 3) ||
              //           (conversionController.selectedIndex.value == 4) ||
              //           (conversionController.selectedIndex.value == 5) ||
              //           (conversionController.selectedIndex.value == 6) ||
              //           (conversionController.selectedIndex.value == 7) ||
              //           (conversionController.selectedIndex.value == 12) ||
              //           (conversionController.selectedIndex.value == 8) ||
              //           (conversionController.selectedIndex.value == 13) ||
              //           (conversionController.selectedIndex.value == 14) ||
              //           (conversionController.selectedIndex.value == 15) ||
              //           (conversionController.selectedIndex.value == 16) ||
              //           (conversionController.selectedIndex.value == 17) ||
              //           (conversionController.selectedIndex.value == 18) ||
              //           (conversionController.selectedIndex.value == 10)) &&
              widget.convertedFile.length > 1
                  // )
                  ? Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: 140),
                          itemCount: widget.convertedFile.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: UiColors.lightGreyBackground)),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    widget.imageFormat == '.jpg'
                                        ? 'assets/jpg_icon.png'
                                        : widget.imageFormat == '.gif'
                                            ? 'assets/gif_icon.png'
                                            : widget.imageFormat == '.jpeg'
                                                ? 'assets/jpeg_icon.png'
                                                : widget.imageFormat == '.png'
                                                    ? 'assets/png_icon.png'
                                                    : widget.imageFormat ==
                                                            '.svg'
                                                        ? 'assets/svg_icon.png'
                                                        : widget.imageFormat ==
                                                                '.webp'
                                                            ? 'assets/webp_icon.png'
                                                            : widget.imageFormat ==
                                                                    '.bmp'
                                                                ? 'assets/bmp_icon.png'
                                                                : widget.imageFormat ==
                                                                        '.tiff'
                                                                    ? 'assets/tiff_icon.png'
                                                                    : widget.imageFormat ==
                                                                            '.doc'
                                                                        ? 'assets/DOC_icon.png'
                                                                        : widget.imageFormat ==
                                                                                '.raw'
                                                                            ? 'assets/raw_icon.png'
                                                                            : widget.imageFormat == '.psd'
                                                                                ? 'assets/psd_icon.png'
                                                                                : widget.imageFormat == '.dds'
                                                                                    ? 'assets/dds_icon.png'
                                                                                    : widget.imageFormat == '.heic'
                                                                                        ? 'assets/heic_icon.png'
                                                                                        : widget.imageFormat == '.ppm'
                                                                                            ? 'assets/ppm_icon.png'
                                                                                            : widget.imageFormat == '.tga'
                                                                                                ? 'assets/tga_icon.png'
                                                                                                : widget.imageFormat == '.pdf'
                                                                                                    ? 'assets/pdf_icon.png'
                                                                                                    : 'assets/jpg_icon.png',
                                    height: 62,
                                    width: 62,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  SizedBox(
                                      width: Get.width * 0.2,
                                      child: TextScroll(
                                        fileName[index],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                        mode: TextScrollMode.endless,
                                        velocity: const Velocity(
                                            pixelsPerSecond: Offset(20, 0)),
                                        delayBefore:
                                            const Duration(milliseconds: 500),
                                        numberOfReps: 1111,
                                        pauseBetween:
                                            const Duration(milliseconds: 500),
                                        textAlign: TextAlign.right,
                                        selectable: true,
                                      )),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.imageFormat
                                            .split('.')[1]
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: UiColors.blackColor,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        " | ",
                                        style: TextStyle(
                                            color: UiColors.greyColor,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${fileSize[index].toInt().toString()}KB",
                                        style: TextStyle(
                                            color: UiColors.greyColor,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  // Text('Item $index',
                                  //     style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Spacer(),
                        Image.asset(
                          widget.imageFormat == '.jpg'
                              ? 'assets/jpg_icon.png'
                              : widget.imageFormat == '.gif'
                                  ? 'assets/gif_icon.png'
                                  : widget.imageFormat == '.jpeg'
                                      ? 'assets/jpeg_icon.png'
                                      : widget.imageFormat == '.png'
                                          ? 'assets/png_icon.png'
                                          : widget.imageFormat == '.svg'
                                              ? 'assets/svg_icon.png'
                                              : widget.imageFormat == '.webp'
                                                  ? 'assets/webp_icon.png'
                                                  : widget.imageFormat == '.bmp'
                                                      ? 'assets/bmp_icon.png'
                                                      : widget.imageFormat ==
                                                              '.tiff'
                                                          ? 'assets/tiff_icon.png'
                                                          : widget.imageFormat ==
                                                                  '.doc'
                                                              ? 'assets/DOC_icon.png'
                                                              : widget.imageFormat ==
                                                                      '.raw'
                                                                  ? 'assets/raw_icon.png'
                                                                  : widget.imageFormat ==
                                                                          '.psd'
                                                                      ? 'assets/psd_icon.png'
                                                                      : widget.imageFormat ==
                                                                              '.dds'
                                                                          ? 'assets/dds_icon.png'
                                                                          : widget.imageFormat == '.heic'
                                                                              ? 'assets/heic_icon.png'
                                                                              : widget.imageFormat == '.ppm'
                                                                                  ? 'assets/ppm_icon.png'
                                                                                  : widget.imageFormat == '.tga'
                                                                                      ? 'assets/tga_icon.png'
                                                                                      : widget.imageFormat == '.pdf'
                                                                                          ? 'assets/pdf_icon.png'
                                                                                          : 'assets/jpg_icon.png',
                          height: 62,
                          width: 62,
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        Text(fileName[0]),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                widget.imageFormat.split('.')[1].toUpperCase()),
                            Text(" | "),
                            Text(
                                "${fileSize[0].toInt() == 0 ? fileSize[0].toStringAsPrecision(2) : fileSize[0].toInt().toString()} KB"),
                          ],
                        ),
                      ],
                    ),
              // ),
              widget.convertedFile.length == 1 ? Spacer() : SizedBox(),
              SizedBox(
                height: 28,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (widget.convertedFile.length == 1) {
                      } else {
                        await createZip(true, widget.convertedFile);
                      }
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                            color:
                                UiColors.lightGreyBackground.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Image.asset(
                            'assets/share_icon.png',
                            height: 22,
                            width: 22,
                          ),
                        )),
                  ),
                  sizedBoxWidth,
                  GestureDetector(
                    onTap: () async {
                      if (widget.convertedFile.length == 1) {
                        if (path.extension(widget.convertedFile[0].path) ==
                            '.txt') {
                          textToolData.value = textToolDataList[0];
                          textToolImagePath.value = textToolImagePathList[0];
                          print("YYUUOO");
                          await downloadTextFile(
                              path.basenameWithoutExtension(
                                  widget.convertedFile[0].path),
                              // textToolImagePath.value,
                              textToolData.value
                              // textToolDataList[0]
                              );
                        } else if (path
                                .extension(widget.convertedFile[0].path) ==
                            '.svg') {
                          Get.snackbar(
                            colorText: Colors.black,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            duration: const Duration(seconds: 4),
                            // AppLocalizations.of(Get.context!)!.note,
                            "Note",
                            "this Picture cannot be downloaded",
                            // AppLocalizations.of(Get.context!)!
                            //     .this_picture_cannot_be_downloaded
                          );
                        } else if (path
                                    .extension(widget.convertedFile[0].path) ==
                                '.doc' ||
                            path.extension(widget.convertedFile[0].path) ==
                                '.docx') {
                          File file = File(widget.convertedFile[0].path);
                          print("###file $file");

                          final bytes = await file.readAsBytes();
                          print("###bytes $bytes");

                          final result = await FileSaver.instance.saveAs(
                            name:
                                'ImagetoDoc_${DateTime.now().millisecondsSinceEpoch}',
                            bytes: bytes,
                            ext: 'docx',
                            mimeType: MimeType.microsoftWord,
                          );

                          if (result != "") {
                            Get.snackbar(
                                colorText: Colors.black,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                duration: const Duration(seconds: 4),
                                // AppLocalizations.of(Get.context!)!.note,
                                "Note",
                                "File Saved Successfully");
                          } else {
                            Get.snackbar(
                                colorText: Colors.black,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                duration: const Duration(seconds: 4),
                                // AppLocalizations.of(Get.context!)!.note,
                                "Note",
                                "Error while downloading file"
                                // AppLocalizations.of(Get.context!)!
                                //     .error_while_downloading_file
                                );
                          }
                          // await downloadDocFile(
                          //     path.basenameWithoutExtension(
                          //         widget.convertedFile[0].path),
                          //     textToolDataList[0]);
                        } else if (path
                                .extension(widget.convertedFile[0].path) ==
                            '.xlsx') {
                          await downloadExcelFile(widget.convertedFile[0]);
                        } else if (path
                                .extension(widget.convertedFile[0].path) ==
                            '.pdf') {
                          await downloadPdfFile(widget.convertedFile[0]);
                        } else {
                          await _exportFile(widget.convertedFile[0], false);
                        }
                        Future.delayed(const Duration(milliseconds: 100),
                            () async {
                          // if (Platform.isIOS) {
                          // DialogBoxRating().showNativeRating();
                          // } else {
                          //   log("Rating calue ${await SharedPref().getRatingValue()}");
                          //   await SharedPref().getRatingValue() == false
                          //       ? DialogBoxRating()
                          //           .dialogRating(context: Get.context!)
                          //       : const SizedBox();
                          // }
                        });
                        // print()
                        // await _exportFile(widget.convertedFile[0]);
                      } else {
                        await createZip(false, widget.convertedFile);
                      }
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: UiColors().linearGradientBlueColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/download_icon.png',
                              height: 22,
                              width: 22,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Download",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        )),
                  ),
                ],
              ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 10, right: 10),
              //   child:
              //       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //     InkWell(
              //       onTap: () {
              //         _shareFile(widget.convertedFile[0]);
              //       },
              //       child: Container(
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(8),
              //             color: UiColors.whiteColor,
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.withOpacity(0.4),
              //                 blurRadius: 8,
              //                 offset: const Offset(0, 0),
              //               ),
              //             ]),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 20.0, vertical: 15),
              //           child: Image.asset(
              //             "assets/share.png",
              //             height: 30,
              //             width: 30,
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 30,
              //     ),
              //     optionList(
              //         "assets/EXport.png", AppLocalizations.of(context)!.export,
              //         () async {
              //       _exportFile();
              //     }),
              //     const SizedBox(
              //       width: 30,
              //     ),
              //     optionList("assets/Convert.png",
              //         AppLocalizations.of(context)!.reconvert,
              //         // AppLocalizations.of(context)!.reconvert,
              //         () async {
              //       conversionController.selectedIndex.value = 0;
              //       Get.back();
              //     }),
              //   ]),
              // ),

              SizedBox(
                height: 22,
              ),
            ],
          ),
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
              SizedBox(
                width: 140,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
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

  Future<void> createZip(bool isShare, List<File> convertedFiles) async {
    // Create an archive
    final archive = Archive();
    for (int i = 0; i < convertedFiles.length; i++) {
      final filename = convertedFiles[i].path.split('/').last;
      final fileBytes = convertedFiles[i].readAsBytesSync();
      final archiveFile = ArchiveFile(filename, fileBytes.length, fileBytes);
      archive.addFile(archiveFile);
    }

    // Convert the archive to ZIP format
    final zipBytes = ZipEncoder().encode(archive);

    Directory? folder;
    if (Platform.isMacOS) {
      folder = Directory("${Platform.environment['HOME']}/Downloads");
    } else {
      Directory documentsDirectoryPath =
          await getApplicationDocumentsDirectory();
      folder = Directory('${documentsDirectoryPath.path}/Downloaded Files');
    }

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final zipFile =
        File('${folder.path}/Zip_${DateTime.now().microsecondsSinceEpoch}.zip');

    // Write the ZIP file
    await zipFile.writeAsBytes(zipBytes!);

    if (isShare) {
      Share.shareXFiles([XFile(zipFile.path)]);
    } else {
      Get.snackbar(
        "Zip File created in downloads",
        "Attention",
        colorText: Colors.black,
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // Future<void> createZip(bool isShare, List<File> convertedFiles) async {
  //   // Create an archive
  //   final archive = Archive();
  //   for (int i = 0; i < convertedFiles.length; i++) {

  //     final filename = convertedFiles[i].path.split('/').last;
  //     final fileBytes = convertedFiles[i].readAsBytesSync();
  //     final archiveFile = ArchiveFile(filename, fileBytes.length, fileBytes);
  //     archive.addFile(archiveFile);
  //   }

  //   // Convert the archive to ZIP format
  //   final zipBytes = ZipEncoder().encode(archive);

  //   Directory documentsDirectoryPath =
  //       await getApplicationDocumentsDirectory();
  //   debugPrint("de=> ${documentsDirectoryPath.path}");
  //   String? folderPath;

  //   if (isShare) {
  //     Directory dir = await getTemporaryDirectory();

  //     folderPath = dir.path;
  //   } else {
  //     folderPath = '${documentsDirectoryPath.path}/Downloaded Files';
  //   }
  //   Directory folder = Directory(folderPath);
  //   if (!await folder.exists()) {
  //     await folder.create(recursive: true);
  //   }

  //   debugPrint("folder path is =>>>> ${folder.path}");
  //   final zipFile =
  //       File('$folderPath/Zip_${DateTime.now().microsecondsSinceEpoch}.zip');

  //   // Write the ZIP file
  //   await zipFile.writeAsBytes(zipBytes!);
  //   if (isShare) {
  //     Share.shareXFiles([XFile(zipFile.path)]);
  //   } else {
  //     Get.snackbar(
  //       colorText: Colors.black,
  //       backgroundColor: Colors.white,
  //       duration: const Duration(seconds: 4),
  //       "Zip File created in document",
  //       AppLocalizations.of(Get.context!)!.attention,
  //     );

  //   }
  // }
  Future<void> downloadTextFile(String fileName, String fileContent) async {
    try {
      print("2323233 $fileContent ppp");
      print("PPPPP $fileName");
      // Get the documents directory
      // final directory = await getExternalStorageDirectory();
      final documentsDir = await getApplicationDocumentsDirectory();
      // final destinationPath =
      //     path.join(documentsDir!.path, file.uri.pathSegments.last);

      if (directory != null) {
        // Create the file path
        final filePath =
            '${documentsDir.path}/$fileName${DateTime.now().millisecond}.txt';
        final file = File(filePath);

        // Write the file content
        await file.writeAsString(fileContent);

        print('File saved at: $filePath');
        Get.snackbar(
          colorText: Colors.black,
          backgroundColor: Colors.white,
          duration: const Duration(seconds: 4),
          // AppLocalizations.of(Get.context!)!.note,
          "Note",
          "Text file save to download",
          // AppLocalizations.of(Get.context!)!.text_file_save_to_download,
        );
      } else {
        print('Unable to find the documents directory.');
      }
    } catch (e) {
      Get.snackbar(
        colorText: Colors.black,
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 4),
        // AppLocalizations.of(Get.context!)!.note,
        "Note",
        "Failed to download!",
      );
      print('Error exporting file: $e');
    }
  }

  Future<void> downloadExcelFile(File file) async {
    try {
      // Get the documents directory
      // final directory = await getExternalStorageDirectory();
      final documentsDir = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download')
          : await getApplicationDocumentsDirectory();
      // final destinationPath =
      //     path.join(documentsDir!.path, file.uri.pathSegments.last);
      Uint8List excelData = await file.readAsBytes();
      if (directory != null) {
        final filePath =
            '${documentsDir.path}/${DateTime.now().microsecond}.xlsx';
        final file = File(filePath);

        // Write the file content
        await file.writeAsBytes(excelData);

        print('File saved at: $filePath');
        Get.snackbar(
            colorText: Colors.black,
            backgroundColor: Colors.grey.withOpacity(0.3),
            duration: const Duration(seconds: 4),
            // AppLocalizations.of(Get.context!)!.note,
            "Note",
            "${"File Downloaded at"} $filePath");
      } else {
        print('Unable to find the documents directory.');
      }
    } catch (e) {
      print('Error exporting file: $e');
      Get.snackbar(
        colorText: Colors.black,
        backgroundColor: Colors.grey.withOpacity(0.3),
        duration: const Duration(seconds: 4),
        "Note",
        "Error while downloading",
        // AppLocalizations.of(Get.context!)!.note,
        // AppLocalizations.of(Get.context!)!.error_while_downloading_file
      );
    }
  }

  Future<void> downloadPdfFile(File file) async {
    try {
      // Get the documents directory
      // final directory = await getExternalStorageDirectory();
      final documentsDir = await getApplicationDocumentsDirectory();
      // final destinationPath =
      //     path.join(documentsDir!.path, file.uri.pathSegments.last);
      Uint8List pdfData = await file.readAsBytes();
      if (directory != null) {
        final filePath =
            '${documentsDir.path}/${DateTime.now().microsecond}.pdf';
        final file = File(filePath);

        // Write the file content
        await file.writeAsBytes(pdfData);

        print('File saved at: $filePath');
        Get.snackbar(
            colorText: Colors.black,
            backgroundColor: Colors.grey.withOpacity(0.3),
            duration: const Duration(seconds: 4),
            // AppLocalizations.of(Get.context!)!.note,
            "Note",
            "File Downloaded at $filePath");
      } else {
        print('Unable to find the documents directory.');
      }
    } catch (e) {
      print('Error exporting file: $e');
      Get.snackbar(
          colorText: Colors.black,
          backgroundColor: Colors.grey.withOpacity(0.3),
          duration: const Duration(seconds: 4),
          // AppLocalizations.of(Get.context!)!.note,
          "Note",
          "Error while downloading file"
          // AppLocalizations.of(Get.context!)!.error_while_downloading_file
          );
    }
  }

  Future<void> _exportFile(FileSystemEntity file, bool isBack) async {
    try {
      final filePath = file.uri.toFilePath();
      print("filePath: $filePath");

      // Get the Downloads directory on macOS
      Directory downloadsDirectory = await getDownloadsDirectory() ??
          (await getApplicationDocumentsDirectory()); // Fallback to Documents

      final Directory folder = Directory(downloadsDirectory.path);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      File fileData = File(file.path);

      if (path.extension(filePath).toLowerCase() == '.pdf') {
        // Save PDF file
        File newFile =
            File("${folder.path}/ImageToPdf${DateTime.now().microsecond}.pdf");
        await fileData.copy(newFile.path);

        Get.snackbar(
          colorText: Colors.black,
          backgroundColor: Colors.white,
          duration: const Duration(seconds: 4),
          "Note",
          "PDF saved in Downloads: ${newFile.path}",
        );
      } else if (path.extension(filePath).toLowerCase() == '.txt') {
        // Save TXT file
        File newFile =
            File("${folder.path}/ImageToPdf${DateTime.now().microsecond}.txt");
        await newFile.writeAsString(await fileData.readAsString());

        Get.snackbar(
          colorText: Colors.black,
          backgroundColor: Colors.white,
          duration: const Duration(seconds: 4),
          "Note",
          "Text file saved in Downloads",
        );
      } else if (['.bmp', '.webp', '.png', '.jpg', '.jpeg']
          .contains(path.extension(filePath).toLowerCase())) {
        // Save Images
        File newFile = File(
            "${folder.path}/downloaded_image${DateTime.now().millisecondsSinceEpoch}${path.extension(filePath)}");
        await fileData.copy(newFile.path);

        Get.snackbar(
          colorText: Colors.black,
          backgroundColor: Colors.white,
          duration: const Duration(seconds: 4),
          "Note",
          "Image saved in Downloads",
        );
      } else {
        Get.snackbar(
          colorText: Colors.black,
          backgroundColor: Colors.white,
          duration: const Duration(seconds: 4),
          "Note",
          "Unsupported file type",
        );
      }
    } catch (e) {
      Get.snackbar(
        colorText: Colors.black,
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 4),
        "Error",
        "Failed to export file: $e",
      );
      print('Error exporting file: $e');
    }
  }
}
