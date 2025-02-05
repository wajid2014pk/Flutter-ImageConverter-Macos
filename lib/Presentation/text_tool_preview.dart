import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class TextToolPreviewPage extends StatefulWidget {
  String text;
  String imagePath;
  TextToolPreviewPage({super.key, required this.text, required this.imagePath});

  @override
  State<TextToolPreviewPage> createState() => _TextToolPreviewPageState();
}

class _TextToolPreviewPageState extends State<TextToolPreviewPage> {
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();

    setState(() {
      //  textController = TextEditingController(text: widget.text);
      textController.text = widget.text;
    });
    log("Enter11 ${textController.text}");
  }

  @override
  Widget build(BuildContext context) {
    // void initState() {
    //   print("Enter11");
    //   textController = TextEditingController(text: widget.text);
    //   print("textController $textController");
    //   super.initState();
    // }

    return Scaffold(
      backgroundColor: UiColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 22),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.converted,
                      style: TextStyle(
                        color: UiColors.blackColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
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
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: UiColors.blackColor),
                        child: Image.file(
                          File(widget.imagePath),
                          // fit: BoxFit.fitWidth,
                        )),
                  ),
                  sizedBoxWidth,
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: UiColors.greyColor.withOpacity(0.5))),
                        child: SingleChildScrollView(
                            child:
                                // TextField(controller: textController)
                                TextField(
                          controller: textController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),

                          // "${textToolData.value}"
                        ))),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await shareTextFileMacOS(textController.text);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: UiColors.lightGreyBackground.withOpacity(0.5),
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
                    await downloadTextFileMacOS(textController.text);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
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
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            "Download",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )
                        ],
                      )),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            // Text(widget.imagePath),
          ],
        ),
      ),
    );
  }

  Future<void> downloadTextFileMacOS(String fileContent) async {
    try {
      // Get the downloads directory
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception("Downloads directory not found");
      }

      final fileName = 'ImagetoText_${DateTime.now().millisecondsSinceEpoch}';
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);

      // Write text content to file
      await file.writeAsString(fileContent);

      // Read file bytes (optional for saving with FileSaver)
      Uint8List bytes = await file.readAsBytes();

      // Save the file using FileSaver
      final result = await FileSaver.instance.saveAs(
        name: fileName,
        bytes: bytes,
        ext: 'txt',
        mimeType: MimeType.text,
      );

      if (result != "") {
        Get.snackbar(
          "Note",
          "File Saved Successfully",
          colorText: Colors.black,
          backgroundColor: Colors.grey.withOpacity(0.3),
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          "Note",
          "Error while downloading file",
          colorText: Colors.black,
          backgroundColor: Colors.grey.withOpacity(0.3),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Error exporting file on macOS: $e');
    }
  }

  Future<void> shareTextFileMacOS(String fileContent) async {
    try {
      // Get the downloads directory
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception("Downloads directory not found");
      }

      final fileName = 'ImagetoText_${DateTime.now().millisecondsSinceEpoch}';
      final filePath = '${downloadsDir.path}/$fileName.txt';
      final file = File(filePath);
      await file.writeAsString(fileContent);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      print('Error exporting file on macOS: $e');
    }
  }

}
