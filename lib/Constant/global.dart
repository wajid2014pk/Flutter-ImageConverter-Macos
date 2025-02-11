import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/utils/shared_pref.dart';

RxInt originalSize = 0.obs;
RxInt convertedSize = 0.obs;
RxBool isInternetConneted = false.obs;
RxBool svgAndBmpApi = false.obs;
RxString excelString = "".obs;
RxString excelApiresult = "".obs;
String apikey = '';
RxList<String> textToolDataList = <String>[].obs;
RxList<String> textToolImagePathList = <String>[].obs;
RxString textToolData = "".obs;
RxString textToolImagePath = "".obs;
OverlayEntry? overlayEntry;

Future setToolsValue(int selectedIndexValue) async {
  switch (selectedIndexValue) {
    case 5:
      int limit = await SharedPref().getSVGValue();

      ++limit;
      log(" case 5 before========================> $limit ");
      await SharedPref().setSVGValue(limit);

      break;
    case 6:
      int limit = await SharedPref().getWEBPValue();
      log(" case 6 before========================> $limit ");

      limit++;
      log(" setting case  6 ========================> $limit ");

      await SharedPref().setWEBPValue(limit);

      break;
    case 7:
      int limit = await SharedPref().getBmpLimit();

      ++limit;

      log(" setting case  7========================> $limit ");
      await SharedPref().setBmpLimit(limit);

      break;
    case 12:
      int limit = await SharedPref().getTiffLimit();
      log(" before tiff========================> $limit ");

      limit++;
      log(" case 6 after ====>  $limit ");
      await SharedPref().setTiffLimit(limit);

      break;
    case 13:
      int limit = await SharedPref().getRawLimit();

      limit++;
      log(" setting case  13  $limit ");
      await SharedPref().setRawLimit(limit);

      break;
    case 14:
      int limit = await SharedPref().getPsdLimit();
      log(" setting case  14 $limit ");

      limit++;
      await SharedPref().setPsdLimit(limit);

      break;
    case 15:
      int limit = await SharedPref().getDdsLimit();
      log(" setting case  15   $limit ");

      limit++;
      await SharedPref().setDdsLimit(limit);

      break;
    case 16:
      int limit = await SharedPref().getHeicLimit();
      log(" setting case  16$limit ");

      limit++;
      await SharedPref().setHeicLimit(limit);

      break;
    case 17:
      int limit = await SharedPref().getPpmLimit();

      limit++;
      log(" ssetting case  17  $limit ");
      await SharedPref().setPpmLimit(limit);

      break;
    case 18:
      int limit = await SharedPref().getTgaLimit();
      log(" setting case  18 $limit ");

      limit++;
      await SharedPref().setTgaLimit(limit);

      break;
  }
}

RxInt webpLimit = 1.obs;
RxInt svgLimit = 1.obs;
RxInt bmpLimit = 1.obs;
RxInt tiffLimit = 1.obs;
RxInt rawLimit = 1.obs;
RxInt psdLimit = 1.obs;
RxInt ddsLimit = 1.obs;
RxInt heicLimit = 1.obs;
RxInt ppmLimit = 1.obs;
RxInt tgaLimit = 1.obs;

//------image to excel tool-------------
RxList<String> xlsxImageList = <String>[].obs;
RxList<File> xlsxFilePathList = <File>[].obs;
//------image to excel tool-------------

RxString convertedFileName = "".obs;
SizedBox sizedBoxWidth = const SizedBox(
  width: 12,
);
Container customShareButton(String imagePath) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
      decoration: BoxDecoration(
          color: Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Image.asset(
          imagePath,
          height: 22,
          width: 22,
        ),
      ));
}

Container downloadButton({
  required String imagePath,
  int? index,
  double? buttonWidth,
}) {
  return Container(
      width: buttonWidth,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: UiColors().linearGradientBlueColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 22,
            width: 22,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            "Download",
            style: TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ));
}

Container customBackButton() {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        color: Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(8)),
    child: Image.asset(
      'assets/back_arrow.png',
      height: 20,
      width: 20,
    ),
  );
}
