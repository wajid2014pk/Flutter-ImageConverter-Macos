import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as p;

class ConversionPageNew extends StatefulWidget {
  String imageFormat;
  String originalFilePath;
  File convertedFile;
  String toolName;
  ConversionPageNew(
      {super.key,
      required this.imageFormat,
      required this.originalFilePath,
      required this.convertedFile,
      required this.toolName});

  @override
  State<ConversionPageNew> createState() => _ConversionPageNewState();
}

class _ConversionPageNewState extends State<ConversionPageNew> {
  RxString extensionData = "".obs;
  RxString fileNameData = "".obs;
  RxString fileSizeData = "".obs;
  void initState() {
    getDataFromFile();
    super.initState();
  }

  getDataFromFile() {
    extensionData.value = p.extension(widget.convertedFile.path);
    String fileName = p.basenameWithoutExtension(widget.convertedFile.path);

    // Extract the desired part before the first space or special character
    String extractedName = fileName.split(RegExp(r'[ #]'))[0];
    fileNameData.value = extractedName;

    if (widget.convertedFile.existsSync()) {
      int fileSizeInBytes = widget.convertedFile.lengthSync();
      double fileSizeInKB = fileSizeInBytes / 1024;
      fileSizeData.value = "${fileSizeInKB.toStringAsFixed(2)} KB";
      print("fileSizeData.value ${fileSizeData.value}");
    }
    print("extensionData ${extensionData.value}");
    print("fileNameData ${fileNameData.value}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: UiColors.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => HomeScreen(
                            index: 1,
                          ));
                    },
                    child: customBackButton(),
                  ),
                  sizedBoxWidth,
                  sizedBoxWidth,
                  Text(
                    widget.toolName == "ImageResizer"
                        ? "Image Resizer"
                        : widget.toolName == "ImageCompressor"
                            ? "Image Compressor"
                            : "",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        // 'assets/jpg_icon.png',
                        extensionData.value == '.png'
                            ? 'assets/png_icon.png'
                            : 'assets/png_icon.png',
                        height: 62,
                        width: 62,
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            fileNameData.value,
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Text(
                            extensionData.value == ".png" ? "PNG" : "PNG",
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            " | ",
                            style: TextStyle(
                              color: UiColors.greyColor,
                            ),
                          ),
                          Text(
                            fileSizeData.value,
                            // "124 KB",
                            style: TextStyle(
                              color: UiColors.greyColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        shareFile(widget.convertedFile);
                      },
                      child: customShareButton("assets/share_icon.png")),
                  sizedBoxWidth,
                  // Image.asset('assets/copy_icon.png'),
                  GestureDetector(
                      onTap: () async {
                        await OpenFile.open(widget.convertedFile.path);
                      },
                      child: customShareButton("assets/ic_preview.png")),
                  sizedBoxWidth,
                  GestureDetector(
                      onTap: () async {
                        final bytes = await widget.convertedFile.readAsBytes();

                        final result = await FileSaver.instance.saveAs(
                            name: fileNameData.value,
                            bytes: bytes,
                            ext: 'png',
                            mimeType: MimeType.png);

                        if (result != "") {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'File saved successfully in Downloads Folder!')),
                          );
                        } else {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to save file.')),
                          );
                        }
                      },
                      child: downloadButton(
                          imagePath: "assets/download_icon.png")),
                ],
              ),
              SizedBox(
                height: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void shareFile(FileSystemEntity fileEntity) {
    if (fileEntity is File) {
      String fileName = fileEntity.uri.pathSegments.last;
      Share.shareFiles([fileEntity.path],
          text:
              '${AppLocalizations.of(Get.context!)!.sharing_file}: $fileName');
    } else {
      print('Selected item is not a file.');
    }
  }
}
