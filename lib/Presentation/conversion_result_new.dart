import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
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
      required this.toolName
      });

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
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: UiColors.lightGreyBackground.withOpacity(0.5),
                      ),
                      child: Image.asset(
                        'assets/back_arrow.png',
                        height: 22,
                        width: 22,
                      ),
                    ),
                  ),
                  sizedBoxWidth,
                  Text(widget.toolName == "ImageResizer"?
                    "Image Resizer":
                    widget.toolName == "ImageCompressor"?
                    "Image Compressor":""
                    ,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                        'assets/jpg_icon.png',
                        height: 52,
                        width: 52,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(fileNameData.value),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            extensionData.value == ".png" ? "PNG" : "PNG",
                            // aaaaaa
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            " | ",
                            style: TextStyle(
                                fontSize: 10, color: UiColors.greyColor),
                          ),
                          Text(
                            fileSizeData.value,
                            // "124 KB",
                            style: TextStyle(
                                fontSize: 10, color: UiColors.greyColor),
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
                  // Image.asset('assets/copy_icon.png'),
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: UiColors.lightGreyBackground.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Image.asset(
                          'assets/copy_icon.png',
                          height: 22,
                          width: 22,
                        ),
                      )),
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
                          const SnackBar(content: Text('Failed to save file.')),
                        );
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
