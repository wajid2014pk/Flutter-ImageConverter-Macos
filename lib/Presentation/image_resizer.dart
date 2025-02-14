import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Controller/resize_image_controller/resize_image_controller.dart';
import 'package:image_converter_macos/Presentation/loader_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageResizerScreen extends StatefulWidget {
  final File? file;
  ImageResizerScreen({super.key, required this.file});

  @override
  State<ImageResizerScreen> createState() => _ImageResizerScreenState();
}

class _ImageResizerScreenState extends State<ImageResizerScreen> {
  final resizedController = Get.put(ResizeImageController());
  RxInt qualitySelectedIndex = 0.obs;
  RxInt percentgeSelectedIndex = 0.obs;
  @override
  void initState() {
    percentgeSelectedIndex.value = 0;

    resizedController.selectedPercentageDimensions = "10%";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: UiColors.whiteColor,
        bottomNavigationBar: SafeArea(
          child: GestureDetector(
            onTap: () {
              resizedController.filePath = widget.file!;

              Get.to(() => const LoaderScreen());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 22),
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                    gradient: UiColors().linearGradientBlueColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      "Resize",
                      //  AppLocalizations.of(Get.context!)!.resi
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 22, right: 22, top: 22, bottom: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: customBackButton(),
                    ),
                    sizedBoxWidth,
                    sizedBoxWidth,
                    Text(
                      // "Image Resizer",
                      AppLocalizations.of(Get.context!)!.image_resizer,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                              color: UiColors.lightGreyBackground, width: 8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      )
                    : Center(
                        child: Text(
                          "No Image Selected",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 20),

                //- Options
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      // height: MediaQuery.sizeOf(context).width / 0.82,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dimension/Percentage toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 45,
                                // width: Get.width / 5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(
                                        color: UiColors.lightGreyBackground)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: Get.width * 0.15,
                                      child: GestureDetector(
                                        onTap: () {
                                          resizedController.resizeOption.value =
                                              'Quality';
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.5,
                                                color: resizedController
                                                            .resizeOption
                                                            .value ==
                                                        'Quality'
                                                    ? UiColors.blueColorNew
                                                    : Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              // "Dimensions",

                                              AppLocalizations.of(context)!
                                                  .dimensions,
                                              style: TextStyle(
                                                color: resizedController
                                                            .resizeOption
                                                            .value ==
                                                        'Quality'
                                                    ? UiColors.blueColorNew
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: Get.width * 0.15,
                                      child: GestureDetector(
                                        onTap: () {
                                          resizedController.resizeOption.value =
                                              'Percentage';
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.5,
                                                color: resizedController
                                                            .resizeOption
                                                            .value ==
                                                        'Percentage'
                                                    ? UiColors.blueColorNew
                                                    : Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              // "Percentage",
                                              AppLocalizations.of(Get.context!)!
                                                  .percentage,
                                              // AppLocalizations.of(context)!
                                              //     .percentage,
                                              style: TextStyle(
                                                color: resizedController
                                                            .resizeOption
                                                            .value ==
                                                        'Percentage'
                                                    ? UiColors.blueColorNew
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                // if (resizedController.resizeOption.value == 'Dimensions') ...
                SizedBox(
                  width: Get.width / 1.92,
                  child: Obx(
                    () => resizedController.resizeOption.value == 'Quality'
                        ? Column(children: [
                            GestureDetector(
                              onTap: () {
                                resizedController.selectedResizeType.value =
                                    'Reduce By Quality';
                                resizedController.widthController.clear();
                                resizedController.heightController.clear();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.radio_button_checked_rounded,
                                    color: resizedController
                                                .selectedResizeType.value ==
                                            'Reduce By Quality'
                                        ? UiColors.blueColorNew
                                        : UiColors.blackColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    // "Reduce Dimensions By",
                                    AppLocalizations.of(Get.context!)!
                                        .reduce_by_quality,
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
                                IgnorePointer(
                                  ignoring: resizedController
                                              .selectedResizeType.value ==
                                          'Custom'
                                      ? true
                                      : false,
                                  child: GestureDetector(
                                      onTap: () {
                                        qualitySelectedIndex.value = 0;
                                        setState(() {
                                          resizedController.selectedDimension =
                                              "100 x 100";

                                          resizedController
                                              .selectedPercentageDimensions = '';
                                          resizedController.customWidth = null;
                                          resizedController.customHeight = null;
                                        });
                                      },
                                      child:
                                          reduceQualityWidget("100 x 100", 0)),
                                ),
                                IgnorePointer(
                                  ignoring: resizedController
                                              .selectedResizeType.value ==
                                          'Custom'
                                      ? true
                                      : false,
                                  child: GestureDetector(
                                      onTap: () {
                                        qualitySelectedIndex.value = 1;
                                        setState(() {
                                          resizedController.selectedDimension =
                                              "250 x 250";

                                          resizedController
                                              .selectedPercentageDimensions = '';
                                          resizedController.customWidth = null;
                                          resizedController.customHeight = null;
                                        });
                                      },
                                      child:
                                          reduceQualityWidget("250 x 250", 1)),
                                ),
                                IgnorePointer(
                                  ignoring: resizedController
                                              .selectedResizeType.value ==
                                          'Custom'
                                      ? true
                                      : false,
                                  child: GestureDetector(
                                      onTap: () {
                                        qualitySelectedIndex.value = 2;
                                        setState(() {
                                          resizedController.selectedDimension =
                                              "500 x 500";

                                          resizedController
                                              .selectedPercentageDimensions = '';
                                          resizedController.customWidth = null;
                                          resizedController.customHeight = null;
                                        });
                                      },
                                      child:
                                          reduceQualityWidget("500 x 500", 2)),
                                ),
                                IgnorePointer(
                                  ignoring: resizedController
                                              .selectedResizeType.value ==
                                          'Custom'
                                      ? true
                                      : false,
                                  child: GestureDetector(
                                      onTap: () {
                                        qualitySelectedIndex.value = 3;
                                        setState(() {
                                          resizedController.selectedDimension =
                                              "750 x 750";

                                          resizedController
                                              .selectedPercentageDimensions = '';
                                          resizedController.customWidth = null;
                                          resizedController.customHeight = null;
                                        });
                                      },
                                      child:
                                          reduceQualityWidget("750 x 750", 3)),
                                ),
                                IgnorePointer(
                                  ignoring: resizedController
                                              .selectedResizeType.value ==
                                          'Custom'
                                      ? true
                                      : false,
                                  child: GestureDetector(
                                      onTap: () {
                                        qualitySelectedIndex.value = 4;
                                        setState(() {
                                          resizedController.selectedDimension =
                                              "1000 x 1000";

                                          resizedController
                                              .selectedPercentageDimensions = '';
                                          resizedController.customWidth = null;
                                          resizedController.customHeight = null;
                                        });
                                      },
                                      child: reduceQualityWidget(
                                          "1000 x 1000", 4)),
                                ),
                                IgnorePointer(
                                  ignoring: resizedController
                                              .selectedResizeType.value ==
                                          'Custom'
                                      ? true
                                      : false,
                                  child: GestureDetector(
                                      onTap: () {
                                        qualitySelectedIndex.value = 5;
                                        setState(() {
                                          resizedController.selectedDimension =
                                              "1200 x 1200";

                                          resizedController
                                              .selectedPercentageDimensions = '';
                                          resizedController.customWidth = null;
                                          resizedController.customHeight = null;
                                        });
                                      },
                                      child: reduceQualityWidget(
                                          "1200 x 1200", 5)),
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
                                  ignoring: resizedController
                                              .selectedResizeType.value ==
                                          'Custom'
                                      ? true
                                      : false,
                                  child: GestureDetector(
                                      onTap: () {
                                        qualitySelectedIndex.value = 6;
                                        setState(() {
                                          resizedController.selectedDimension =
                                              "1500 x 1500";

                                          resizedController
                                              .selectedPercentageDimensions = '';
                                          resizedController.customWidth = null;
                                          resizedController.customHeight = null;
                                        });
                                      },
                                      child: reduceQualityWidget(
                                          "1500 x 1500", 6)),
                                ),
                                IgnorePointer(
                                  ignoring: resizedController
                                              .selectedResizeType.value ==
                                          'Custom'
                                      ? true
                                      : false,
                                  child: GestureDetector(
                                      onTap: () {
                                        qualitySelectedIndex.value = 7;
                                        setState(() {
                                          resizedController.selectedDimension =
                                              "2000 x 2000";

                                          resizedController
                                              .selectedPercentageDimensions = '';
                                          resizedController.customWidth = null;
                                          resizedController.customHeight = null;
                                        });
                                      },
                                      child: reduceQualityWidget(
                                          "2000 x 2000", 7)),
                                ),
                              ],
                            ),

                            // Custom Dimensions
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  resizedController.selectedResizeType.value =
                                      'Custom';
                                  resizedController.selectedDimension = '';
                                  qualitySelectedIndex.value = 10;
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.radio_button_checked_rounded,
                                      color: resizedController
                                                  .selectedResizeType.value ==
                                              'Custom'
                                          ? UiColors.blueColorNew
                                          : UiColors.blackColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      // "Custom",
                                      AppLocalizations.of(context)!.custom,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white,
                                        ),
                                        child: IgnorePointer(
                                          ignoring: resizedController
                                                  .selectedResizeType.value !=
                                              'Custom',
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            controller: resizedController
                                                .widthController,
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
                                              hintText:
                                                  // "Width",

                                                  AppLocalizations.of(context)!
                                                      .width,
                                              hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: UiColors.blueColorNew
                                                      .withOpacity(0.6),
                                                  width: 1.0,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                    color: Color(0xFFDFDFDF)),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                            ),
                                            onChanged: (_) =>
                                                validateInputWidth(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Text("X"),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white,
                                        ),
                                        child: IgnorePointer(
                                          ignoring: resizedController
                                                  .selectedResizeType.value !=
                                              'Custom',
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            controller: resizedController
                                                .heightController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9.]')),
                                            ],
                                            onTapOutside:
                                                (PointerDownEvent event) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            cursorColor: UiColors.blueColorNew,
                                            decoration: InputDecoration(
                                              hintText:
                                                  // "Height",
                                                  AppLocalizations.of(context)!
                                                      .height,
                                              hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: UiColors.blueColorNew
                                                      .withOpacity(0.6),
                                                  width: 1.0,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFFDFDFDF)),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                            ),
                                            onChanged: (_) =>
                                                validateInputHeight(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spac,
                                  children: [
                                    resizedController.widthError != null
                                        ? Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, top: 4),
                                              child: Text(
                                                resizedController.widthError!,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          )
                                        : const Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0, top: 4),
                                              child: Text(
                                                "Width must be between 1 and 6000",
                                                style: TextStyle(
                                                    color: Colors.transparent,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                    resizedController.heightError != null
                                        ? Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, top: 4),
                                              child: Text(
                                                resizedController.heightError!,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          )
                                        : const Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0, top: 4),
                                              child: Text(
                                                "Height must be between 1 and 6000",
                                                style: TextStyle(
                                                    color: Colors.transparent,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ])
                        : resizedController.resizeOption.value == 'Percentage'
                            ?
                            // if (resizedController.resizeOption.value == 'Percentage') ...
                            Column(children: [
                                // Radio buttons for Increase and Decrease

                                // Preset Dimensions in GridView
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          percentgeSelectedIndex.value = 0;

                                          resizedController
                                                  .selectedPercentageDimensions =
                                              "10%";
                                        },
                                        child:
                                            percentageCustomWidget("10%", 0)),
                                    GestureDetector(
                                        onTap: () {
                                          percentgeSelectedIndex.value = 1;
                                          resizedController
                                                  .selectedPercentageDimensions =
                                              "20%";
                                        },
                                        child:
                                            percentageCustomWidget("20%", 1)),
                                    GestureDetector(
                                        onTap: () {
                                          percentgeSelectedIndex.value = 2;
                                          resizedController
                                                  .selectedPercentageDimensions =
                                              "30%";
                                        },
                                        child:
                                            percentageCustomWidget("30%", 2)),
                                    GestureDetector(
                                        onTap: () {
                                          percentgeSelectedIndex.value = 3;
                                          resizedController
                                                  .selectedPercentageDimensions =
                                              "40%";
                                        },
                                        child:
                                            percentageCustomWidget("40%", 3)),
                                    GestureDetector(
                                        onTap: () {
                                          percentgeSelectedIndex.value = 4;
                                          resizedController
                                                  .selectedPercentageDimensions =
                                              "50%";
                                        },
                                        child:
                                            percentageCustomWidget("50%", 4)),
                                    GestureDetector(
                                        onTap: () {
                                          percentgeSelectedIndex.value = 5;
                                          resizedController
                                                  .selectedPercentageDimensions =
                                              "60%";
                                        },
                                        child:
                                            percentageCustomWidget("60%", 5)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          percentgeSelectedIndex.value = 6;
                                          resizedController
                                                  .selectedPercentageDimensions =
                                              "70%";
                                        },
                                        child:
                                            percentageCustomWidget("70%", 6)),
                                    GestureDetector(
                                        onTap: () {
                                          percentgeSelectedIndex.value = 7;
                                          resizedController
                                                  .selectedPercentageDimensions =
                                              "80%";
                                        },
                                        child:
                                            percentageCustomWidget("80%", 7)),
                                    GestureDetector(
                                        onTap: () {
                                          percentgeSelectedIndex.value = 8;
                                          resizedController
                                                  .selectedPercentageDimensions =
                                              "90%";
                                        },
                                        child:
                                            percentageCustomWidget("90%", 8)),
                                  ],
                                ),
                              ])
                            : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Obx percentageCustomWidget(String text, int isSelectedIndex) {
    return Obx(
      () => Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 6),
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

  void validateInputHeight() {
    setState(() {
      final heightValue =
          double.tryParse(resizedController.heightController.text);

      if (heightValue == null || heightValue < 1 || heightValue > 6000) {
        resizedController.heightError = "Height must be between 1 and 6000";
      } else {
        resizedController.heightError = null;
        resizedController.customHeight = heightValue;
      }
    });
  }

  void validateInputWidth() {
    setState(() {
      final widthValue =
          double.tryParse(resizedController.widthController.text);

      if (widthValue == null || widthValue < 1 || widthValue > 6000) {
        resizedController.widthError = "Width must be between 1 and 6000";
      } else {
        resizedController.widthError = null;
        resizedController.customWidth = widthValue;
      }
    });
  }
}
