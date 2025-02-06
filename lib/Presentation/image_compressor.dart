import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/api_string.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Controller/ImageCompressorController/image_compressor_controller.dart';
import 'package:image_converter_macos/Controller/resize_image_controller/resize_image_controller.dart';
import 'package:image_converter_macos/Presentation/conversion_result.dart';
import 'package:image_converter_macos/Presentation/conversion_result_new.dart';
import 'package:image_converter_macos/Presentation/loader_screen.dart';
import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageCompressorScreen extends StatefulWidget {
  final File? file;
  ImageCompressorScreen({super.key, required this.file});

  @override
  State<ImageCompressorScreen> createState() => _ImageCompressorScreenState();
}

class _ImageCompressorScreenState extends State<ImageCompressorScreen>
    with TickerProviderStateMixin {
  final imageCompressorController = Get.put(ImageCompressorController());
  RxInt qualitySelectedIndex = 0.obs;
  RxInt percentgeSelectedIndex = 0.obs;
  RxInt sizeSelectedIndex = 0.obs;
  final dioObject = dio.Dio();
  getx.RxBool loadingState = false.obs;
  getx.RxString selectedOption = "Quality".obs;
  String? selectedQuality;
  String? selectedSize;
  double? actualFileSize;
  RxDouble percentage = 0.0.obs;
  RxDouble progress = 0.0.obs;
  dio.Response? downloadRes;
  // AnimationController? controller;
  // Animation<double>? progressAnimation;
  late AnimationController controller;
  late Animation<double> progressAnimation;
  getx.RxDouble infiniteProgress = 0.0.obs;
  TextEditingController textfieldController = TextEditingController();
  RxString isKbMb = "KB".obs;

  final TextEditingController customQualityController = TextEditingController();
  @override
  void initState() {
    sizeSelectedIndex.value = 10;
    super.initState();
    selectedQuality = "10%";
    actualFileSize = _getFileSizeInKB(widget.file!); // Convert file size to kB
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.whiteColor,
      bottomNavigationBar: SafeArea(
        child: loadingState.value == false
            ? Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width / 2.25),
                child: GestureDetector(
                  onTap: () {
                    print("selectedQuality $selectedQuality");
                    print("selectedSize $selectedSize ${isKbMb.value}");
                    if (selectedQuality != null ||
                        selectedSize != null ||
                        customQualityController.text.isNotEmpty) {
                      controller = AnimationController(
                        vsync: this,
                        duration: const Duration(
                            seconds:
                                10), // Adjust the speed of progress animation
                      );
                      progressAnimation = Tween<double>(begin: 0.0, end: 1.0)
                          .animate(controller!)
                        ..addListener(() {
                          infiniteProgress.value = progressAnimation!.value;
                          setState(() {});
                        });

                      controller!.repeat(reverse: false);
                      uploadFile(context);
                    } else {
                      getx.Get.snackbar(
                          "Attension", "Please select any option");
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: UiColors.blueColorNew),
                    child: Center(
                      child: Text(
                        "Compress",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        // child: GestureDetector(
        //   onTap: () {

        //   },
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         margin: EdgeInsets.only(bottom: 22),
        //         height: 50,
        //         width: 120,
        //         decoration: BoxDecoration(
        //           gradient: UiColors().linearGradientBlueColor,
        //           borderRadius: BorderRadius.circular(14),
        //         ),
        //         child: const Center(
        //           child: Text(
        //             "Compress",
        //             style: TextStyle(
        //                 fontWeight: FontWeight.w600,
        //                 color: Colors.white,
        //                 fontSize: 16),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
      body: Obx(
        () => loadingState.value == false
            ? SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 22, right: 22, top: 22, bottom: 22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: UiColors.lightGreyBackground
                                    .withOpacity(0.5),
                              ),
                              child: Image.asset(
                                'assets/back_arrow.png',
                                height: 22,
                                width: 22,
                              ),
                            ),
                          ),
                          sizedBoxWidth,
                          sizedBoxWidth,
                          Text(
                            "Image Compressor",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      //- Image Preview
                      widget.file != null
                          ? Container(
                              height: 240,
                              width: 240,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(
                                  File(widget.file!.path),
                                )),
                                border: Border.all(
                                    color: UiColors.lightGreyBackground,
                                    width: 8),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            )
                          : const Center(
                              child: Text(
                                "No Image Selected",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      const SizedBox(height: 20),

                      //- Options

                      SizedBox(
                        height: 22,
                      ),
                      // if (resizedController.resizeOption.value == 'Dimensions') ...
                      Obx(
                        () => SizedBox(
                            width: Get.width / 1.92,
                            child: Column(children: [
                              GestureDetector(
                                onTap: () {
                                  selectedOption.value = 'Quality';
                                  imageCompressorController.widthController
                                      .clear();
                                  imageCompressorController.heightController
                                      .clear();
                                  sizeSelectedIndex.value = 10;
                                  selectedSize = "";
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.radio_button_checked_rounded,
                                      color: selectedOption.value == 'Quality'
                                          ? UiColors.blueColorNew
                                          : UiColors.blackColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Reduce by Quality",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Preset Dimensions in GridView
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        qualitySelectedIndex.value = 0;
                                        selectedQuality = "10%";
                                      },
                                      child: IgnorePointer(
                                          ignoring:
                                              selectedOption.value != 'Quality',
                                          child:
                                              reduceQualityWidget("10%", 0))),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != 'Quality',
                                    child: GestureDetector(
                                        onTap: () {
                                          qualitySelectedIndex.value = 1;
                                          selectedQuality = "20%";
                                        },
                                        child: reduceQualityWidget("20%", 1)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != 'Quality',
                                    child: GestureDetector(
                                        onTap: () {
                                          qualitySelectedIndex.value = 2;
                                          selectedQuality = "30%";
                                        },
                                        child: reduceQualityWidget("30%", 2)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != 'Quality',
                                    child: GestureDetector(
                                        onTap: () {
                                          qualitySelectedIndex.value = 3;
                                          selectedQuality = "40%";
                                        },
                                        child: reduceQualityWidget("40%", 3)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != 'Quality',
                                    child: GestureDetector(
                                        onTap: () {
                                          qualitySelectedIndex.value = 4;
                                          selectedQuality = "50%";
                                        },
                                        child: reduceQualityWidget("50%", 4)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != 'Quality',
                                    child: GestureDetector(
                                        onTap: () {
                                          qualitySelectedIndex.value = 5;
                                          selectedQuality = "60%";
                                        },
                                        child: reduceQualityWidget("60%", 5)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IgnorePointer(
                                    ignoring: selectedOption.value != 'Quality',
                                    child: GestureDetector(
                                        onTap: () {
                                          qualitySelectedIndex.value = 6;
                                          selectedQuality = "70%";
                                        },
                                        child: reduceQualityWidget("70%", 6)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != 'Quality',
                                    child: GestureDetector(
                                        onTap: () {
                                          qualitySelectedIndex.value = 7;
                                          selectedQuality = "80%";
                                        },
                                        child: reduceQualityWidget("80%", 7)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != 'Quality',
                                    child: GestureDetector(
                                        onTap: () {
                                          qualitySelectedIndex.value = 8;
                                          selectedQuality = "90%";
                                        },
                                        child: reduceQualityWidget("90%", 8)),
                                  ),
                                ],
                              ),

                              // Custom Dimensions
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    selectedQuality = "";
                                    // imageCompressorController
                                    //     .selectedResizeType.value = 'Custom';
                                    selectedOption.value = "Size";
                                    // imageCompressorController
                                    //     .selectedDimension = '';
                                    qualitySelectedIndex.value = 10;
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.radio_button_checked_rounded,
                                        color: selectedOption.value == 'Size'
                                            ? UiColors.blueColorNew
                                            : UiColors.blackColor,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Reduce by Size",
                                        // AppLocalizations.of(context)!.custom,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IgnorePointer(
                                    ignoring: selectedOption.value != "Size"
                                        ? true
                                        : false,
                                    child: GestureDetector(
                                        onTap: () {
                                          sizeSelectedIndex.value = 0;
                                          selectedSize = "100";
                                          isKbMb.value = "KB";
                                          textfieldController.text = '';
                                        },
                                        child: reduceSizeWidget("100 KB", 0)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != "Size"
                                        ? true
                                        : false,
                                    child: GestureDetector(
                                        onTap: () {
                                          sizeSelectedIndex.value = 1;
                                          selectedSize = "250";
                                          isKbMb.value = "KB";
                                          textfieldController.text = '';
                                        },
                                        child: reduceSizeWidget("250 KB", 1)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != "Size"
                                        ? true
                                        : false,
                                    child: GestureDetector(
                                        onTap: () {
                                          sizeSelectedIndex.value = 2;
                                          selectedSize = "500";
                                          isKbMb.value = "KB";
                                          textfieldController.text = '';
                                        },
                                        child: reduceSizeWidget("500 KB", 2)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != "Size"
                                        ? true
                                        : false,
                                    child: GestureDetector(
                                        onTap: () {
                                          sizeSelectedIndex.value = 3;
                                          selectedSize = "1";
                                          isKbMb.value = "MB";
                                          textfieldController.text = '';
                                        },
                                        child: reduceSizeWidget("1 MB", 3)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != "Size"
                                        ? true
                                        : false,
                                    child: GestureDetector(
                                        onTap: () {
                                          sizeSelectedIndex.value = 4;
                                          selectedSize = "1.5";
                                          isKbMb.value = "MB";
                                          textfieldController.text = '';
                                        },
                                        child: reduceSizeWidget("1.5 MB", 4)),
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedOption.value != "Size"
                                        ? true
                                        : false,
                                    child: GestureDetector(
                                        onTap: () {
                                          sizeSelectedIndex.value = 5;
                                          selectedSize = "2 MB";
                                          isKbMb.value = "MB";
                                          textfieldController.text = '';
                                        },
                                        child: reduceSizeWidget("2 MB", 5)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                height: 42,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: UiColors.lightGreyBackground),
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IgnorePointer(
                                        ignoring: selectedOption.value != "Size"
                                            ? true
                                            : false,
                                        child: TextField(
                                          controller: textfieldController,
                                          onTap: () {
                                            sizeSelectedIndex.value = 10;

                                            textfieldController.text = '';
                                          },
                                          onChanged: (String text) {
                                            setState(() {
                                              selectedSize = text;
                                            });
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]')),
                                          ],
                                          cursorColor: UiColors.blueColorNew,
                                          onTapOutside:
                                              (PointerDownEvent event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Custom Size",
                                            // AppLocalizations.of(context)!
                                            //     .width,
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: UiColors.greyColor
                                                    .withOpacity(0.8)),
                                            border: InputBorder.none,

                                            focusedBorder: InputBorder.none,

                                            contentPadding:
                                                const EdgeInsets.only(
                                                    bottom: 12.0,
                                                    left: 20.0,
                                                    right: 20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        isKbMb.value = "KB";
                                      },
                                      child: Obx(
                                        () => Text(
                                          "KB",
                                          style: TextStyle(
                                              color: isKbMb.value == "KB"
                                                  ? UiColors.blueColorNew
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        isKbMb.value = "MB";
                                      },
                                      child: Obx(
                                        () => Text(
                                          "MB",
                                          style: TextStyle(
                                              color: isKbMb.value == "MB"
                                                  ? UiColors.blueColorNew
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                  ],
                                ),
                              )
                              // Container(
                              //   height: 40,
                              //   width: Get.width / 2,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(12),
                              //     color: Colors.white,
                              //   ),
                              //   child: IgnorePointer(
                              //     ignoring: selectedOption.value != "Size"
                              //         ? true
                              //         : false,
                              //     child: TextField(
                              //       controller: textfieldController,
                              //       keyboardType: TextInputType.number,
                              //       inputFormatters: <TextInputFormatter>[
                              //         FilteringTextInputFormatter.allow(
                              //             RegExp(r'[0-9.]')),
                              //       ],
                              //       cursorColor: UiColors.blueColorNew,
                              //       onTapOutside: (PointerDownEvent event) {
                              //         FocusManager.instance.primaryFocus
                              //             ?.unfocus();
                              //       },
                              //       decoration: InputDecoration(
                              //         hintText: "Custom Size",
                              //         // AppLocalizations.of(context)!
                              //         //     .width,
                              //         hintStyle: const TextStyle(fontSize: 12),
                              //         border: InputBorder.none,
                              //         // border: OutlineInputBorder(
                              //         //   borderRadius: BorderRadius.circular(12),
                              //         //   borderSide:
                              //         //       const BorderSide(color: Colors.grey),
                              //         // ),
                              //         // focusedBorder: OutlineInputBorder(
                              //         //   borderRadius: BorderRadius.circular(12),
                              //         //   borderSide: BorderSide(
                              //         //     color: UiColors.blueColorNew
                              //         //         .withOpacity(0.6),
                              //         //     width: 1.0,
                              //         //   ),
                              //         // ),
                              //         focusedBorder: InputBorder.none,
                              //         enabledBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(12),
                              //           borderSide: const BorderSide(
                              //               color: Colors.grey),
                              //         ),
                              //         contentPadding:
                              //             const EdgeInsets.symmetric(
                              //                 vertical: 10.0, horizontal: 20.0),
                              //       ),
                              //       // onChanged: (_) =>
                              //       //     validateInputWidth(),
                              //     ),
                              //   ),
                              //   // Text("222"),
                              //   // Text("777"),
                              // ),
                            ])),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: getx.Obx(
                      () => Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularPercentIndicator(
                            backgroundColor: Colors.black.withOpacity(0.1),
                            radius: 120.0,
                            lineWidth: 8.0,
                            percent: infiniteProgress.value,
                            progressColor: UiColors.blueColorNew,
                          ),
                          Positioned(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: UiColors.blueColorNew
                                            .withOpacity(0.1),
                                        spreadRadius: 4,
                                        blurRadius: 7,
                                        offset: const Offset(0,
                                            1.5), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(256),
                                  ),
                                ),
                                Positioned(
                                  child: getx.Obx(
                                    () => Image.asset(
                                      infiniteProgress.value >= 0.96
                                          ? "assets/Complete.png"
                                          : "assets/Processing.png",
                                      height: 70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  getx.Obx(
                    () => Text(
                      infiniteProgress.value >= 0.88 &&
                              infiniteProgress.value <= 0.9
                          ? AppLocalizations.of(context)!
                              .your_file_is_converting
                          : AppLocalizations.of(context)!
                              .your_file_is_converting,
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
      ),
    );
  }

  Obx percentageCustomWidget(String text, int isSelectedIndex) {
    return Obx(
      () => Container(
          margin: EdgeInsets.only(right: 8),
          padding: EdgeInsets.symmetric(vertical: 6),
          width: 100,
          decoration: BoxDecoration(
              color: percentgeSelectedIndex.value == isSelectedIndex
                  ? UiColors.blueColorNew.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: percentgeSelectedIndex.value != isSelectedIndex
                      ? UiColors.lightGreyBackground
                      : Colors.transparent)),
          child: Center(
              child: Text(text,
                  style: TextStyle(
                    color: percentgeSelectedIndex.value == isSelectedIndex
                        ? UiColors.blueColorNew
                        : UiColors.blackColor,
                  )))),
    );
  }

  Obx reduceQualityWidget(String dimension, int index) {
    return Obx(
      () => Container(
          width: 104,
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: qualitySelectedIndex.value == index
                  ? UiColors.blueColorNew.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: qualitySelectedIndex.value == index
                    ? Colors.transparent
                    : UiColors.lightGreyBackground,
              )),
          child: Center(
              child: Text(
            dimension,
            style: TextStyle(
                color: qualitySelectedIndex.value == index
                    ? UiColors.blueColorNew
                    : UiColors.blackColor),
          ))),
    );
  }

  Obx reduceSizeWidget(String dimension, int index) {
    return Obx(
      () => Container(
          width: 104,
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: sizeSelectedIndex.value == index
                  ? UiColors.blueColorNew.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: sizeSelectedIndex.value == index
                    ? Colors.transparent
                    : UiColors.lightGreyBackground,
              )),
          child: Center(
              child: Text(
            dimension,
            style: TextStyle(
                color: sizeSelectedIndex.value == index
                    ? UiColors.blueColorNew
                    : UiColors.blackColor),
          ))),
    );
  }

  uploadFile(context) async {
    String uploadurl = ApiString.apiUrl;
    loadingState.value = true;
    try {
      int? qualityInput;
      print("selectedOption $selectedOption");
      print("selectedSize $selectedSize");
      if (selectedOption.value == "Quality" && selectedQuality != null) {
        qualityInput = int.parse(selectedQuality!.replaceAll("%", ""));
      } else if (selectedOption.value == "Size" && selectedSize != null) {
        // Convert selected size to kB or MB
        double selectedSizeInKB = double.parse(selectedSize!.split(' ')[0]);
        if (selectedSize!.contains("MB")) {
          selectedSizeInKB *= 1024; // Convert MB to kB
        }
        print("actualFileSize $actualFileSize");
        qualityInput =
            calculateQualityPercentage(actualFileSize!, selectedSizeInKB);
      }
      print("qualityInput $qualityInput");

      if (qualityInput == null || qualityInput < 1 || qualityInput > 100) {
        getx.Get.snackbar(context, "Please select validate option");
        return;
      }

      print("Calculated QUALITY: $qualityInput");
      dio.FormData formdata = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(widget.file!.path,
            filename: widget.file!.path
            //show only filename from path
            ),
        "from": "png",
        "to": "compress",
        "quality": "$qualityInput",
      });

      dio.Response response = await dioObject.post(
        uploadurl,
        data: formdata,
        options: ApiString.options,
        onSendProgress: (int sent, int total) {
          percentage.value = normalizeValue(
              (double.parse(((sent / total) * 100).toStringAsFixed(2))).abs());
          // conversionController.loadingState.value = true;
          progress.value = percentage.value;
          print('Progress show1133 ${progress.value}');
        },
      );
      print("Response of dio ${response.data}");

      DateTime dateTime = DateTime.now();
      Map valueMap = json.decode(response.data);
      Directory? dir = Platform.isMacOS
          ? await getApplicationCacheDirectory()
          : await getExternalStorageDirectory();
      var path =
          "${dir!.path}/ImageConverter/ImageCompression___$dateTime#${basename(valueMap['d_url'])}";
      downloadRes = await dioObject.download("${valueMap['d_url']}", path,
          onReceiveProgress: (int recieve, int total) {
        percentage.value = normalizeValue((recieve / total * 100)).abs();

        progress.value = percentage.value;
      });
      print("path after convert $path");

      print("Link ${valueMap['d_url']}");

      Directory('${dir.path}/openerfile').createSync(recursive: true);
      // var openResult;
      var fileOpen = basename(path.toString());
      var parts = fileOpen.split('#');
      var finalName = parts.sublist(1).join('#').trim();

      File(path.toString()).copySync('${dir.path}/openerfile/$finalName');

      await getx.Get.to(
        () => ConversionPageNew(
          imageFormat: "png",
          originalFilePath: path,
          convertedFile: File(path),
          toolName: 'ImageCompressor',
        ),
      );
      print("Response Download ${downloadRes!.data}");
      loadingState.value = false;
      controller!.dispose();
      if (response.statusCode == 200) {
        print(response.toString());
      } else {
        getx.Get.snackbar("Error", "Error while converting");

        print("%%%%%Error during connection to server.");
      }
    } catch (e) {
      print("%%%%%Error of file $e");
      loadingState.value = false;
      // conversionController.loadingState.value = false;
      // getx.Get.offAll(const BottomNavBar());

      getx.Get.snackbar("Error", "Error While Converting");
    }
  }

  int calculateQualityPercentage(double actualSize, double selectedSize) {
    if (actualSize <= 0 || selectedSize <= 0 || selectedSize >= actualSize) {
      return 100;
    }

    double remainingSize = selectedSize / actualSize;
    return (remainingSize * 100).toInt();
  }

  double normalizeValue(double value) {
    // print("Value ${value.abs()}");
    // print("UUYYY ${(value / (value + 2))}");
    if (value.abs() >= 100) {
      return 0.99;
    } else {
      return value / (value + 2);
    }
  }

  double _getFileSizeInKB(File file) {
    final bytes = file.lengthSync();
    return bytes / 1024; // Convert bytes to kB
  }

  @override
  void dispose() {
    // Dispose the AnimationController if it has been initialized
    if (controller != null) {
      controller!.dispose();
    }

    // Dispose other controllers if necessary
    customQualityController.dispose();
    textfieldController.dispose();

    // Call super.dispose() at the end
    super.dispose();
  }
}
