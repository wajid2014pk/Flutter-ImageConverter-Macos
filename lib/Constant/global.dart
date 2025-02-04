import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

//------image to excel tool-------------
RxList<String> xlsxImageList = <String>[].obs;
RxList<File> xlsxFilePathList = <File>[].obs;
//------image to excel tool-------------

RxString convertedFileName = "".obs;
SizedBox sizedBoxWidth = const SizedBox(
  width: 12,
);
