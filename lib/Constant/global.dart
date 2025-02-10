import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/color.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
          color: UiColors.lightGreyBackground.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Image.asset(
          imagePath,
          height: 22,
          width: 22,
        ),
      ));
}

Container downloadButton(
    {required String imagePath, int? index, double? buttonWidth}) {
  return Container(
      width: buttonWidth,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
            index == 1 ? "Download" : "Download zip",
            style: TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ));
}
