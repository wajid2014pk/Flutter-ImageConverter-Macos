import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart' as excel;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class ExcelToolPreviewPage extends StatefulWidget {
  String imagePath;
  File excelFile;
  ExcelToolPreviewPage(
      {super.key, required this.imagePath, required this.excelFile});

  @override
  State<ExcelToolPreviewPage> createState() => _ExcelToolPreviewPageState();
}

class _ExcelToolPreviewPageState extends State<ExcelToolPreviewPage> {
  WebViewController controller = WebViewController();

  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () async {
      print("POOOOO111 ${widget.imagePath}");
      await convertExcelToHtml();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: customBackButton(),
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
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Manrope-Bold'),
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
                    child: GestureDetector(
                      onTap: () {
                        showImageDialog(context, widget.imagePath);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: UiColors.blackColor),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Image.file(
                                  File(widget.imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                left: 22,
                                top: 22,
                                child: Image.asset(
                                  'assets/preview_icon.png',
                                  height: 22,
                                  width: 22,
                                ),
                              )
                            ],
                          )),
                    ),
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
                        child: WebViewWidget(
                          controller: controller,
                        )),
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
                    await Share.shareXFiles([XFile(widget.excelFile.path)]);
                  },
                  child: customShareButton("assets/share_icon.png"),
                ),
                sizedBoxWidth,
                GestureDetector(
                  onTap: () async {
                    await downloadExcelFileMacOS(widget.excelFile);
                  },
                  child: downloadButton(
                      imagePath: 'assets/download_icon.png', index: 1),
              
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

  Future<void> convertExcelToHtml() async {
    print("PPOOOO ");
    // isHtmlLoading.value = true;
    // debugPrint("isHtmlLoading.value ${isHtmlLoading.value}");

    var bytes = widget.excelFile.readAsBytesSync();
    var excels = excel.Excel.decodeBytes(bytes);

    StringBuffer htmlContent = StringBuffer();

    // Start HTML and body with CSS and set UTF-8 encoding
    htmlContent.write('<html><head><meta charset="UTF-8"><style>');
    htmlContent.write(
        'table { border-collapse: collapse;width: 100%; border: 2px solid black; }');
    htmlContent.write(
        'td, th { padding: 20px; text-align: center; font-size: 40px; border: 1px solid black; }');
    htmlContent.write('</style></head><body>');

    // Write table
    htmlContent.write('<table>');

    for (var table in excels.tables.keys) {
      htmlContent.write('<tr><th colspan="10">$table</th></tr>');
      var sheet = excels.tables[table]!;
      for (var row in sheet.rows) {
        htmlContent.write('<tr>');
        for (var cell in row) {
          // Make sure the cell value is correctly encoded for HTML
          String cellValue = cell?.value.toString() ?? ' ';
          htmlContent
              .write('<td>${const HtmlEscape().convert(cellValue)}</td>');
        }
        htmlContent.write('</tr>');
      }
    }

    // End table and body
    htmlContent.write('</table></body></html>');

    // Save HTML content to a temporary file
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/temp.html');
    await tempFile.writeAsString(htmlContent.toString());

    controller.loadFile(tempFile.path);
    controller.runJavaScript('''
    window.onload = function() {
      HeightChannel.postMessage(document.body.scrollHeight.toString());
      document.body.style.zoom = "5"; // Adjust the zoom level as needed
    }
  ''');
    // isHtmlLoading.value = false;
  }

  void showImageDialog(BuildContext context, String imagePath) {
    Get.dialog(
        // context: context,
        // builder: (BuildContext context) {
        // return
        // (widget)
        Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Image.file(
            File(imagePath), // Replace with your image URL or use AssetImage
          ),
          Positioned(
            right: 22,
            top: 22,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: UiColors.whiteColor,
                      borderRadius: BorderRadius.circular(22)),
                  child: Icon(Icons.close)),
            ),
          )
        ],
      ),
    ));
    // });
  }

  Future<void> downloadExcelFileMacOS(File fileData) async {
    Uint8List bytes = await fileData.readAsBytes();
    try {
      // Get the downloads directory
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception("Downloads directory not found");
      }

      final fileName = 'ImagetoExcel_${DateTime.now().millisecondsSinceEpoch}';
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);

      // Write the binary data to the file
      await file.writeAsBytes(bytes);

      // Save the file using FileSaver (optional, but ensures better cross-platform saving)
      final result = await FileSaver.instance.saveAs(
        name: fileName,
        bytes: bytes,
        ext: 'xlsx',
        mimeType: MimeType.csv,
      );

      if (result != "") {
        Get.snackbar(
          "Success",
          "File Saved Successfully: $filePath",
          colorText: Colors.black,
          backgroundColor: Colors.grey.withOpacity(0.3),
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          "Error",
          "Error while saving the file",
          colorText: Colors.black,
          backgroundColor: Colors.grey.withOpacity(0.3),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      debugPrint('Error exporting Excel file on macOS: $e');
    }
  }
}
