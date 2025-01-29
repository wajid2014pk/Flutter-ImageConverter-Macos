import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Controller/resize_image_controller/resize_image_controller.dart';

class ImageResizerScreen extends StatefulWidget {
  final File? file;
  ImageResizerScreen({super.key, required this.file});

  @override
  State<ImageResizerScreen> createState() => _ImageResizerScreenState();
}

class _ImageResizerScreenState extends State<ImageResizerScreen> {
  final resizedController = Get.put(ResizeImageController());
  RxInt qualitySelectedIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.whiteColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width / 3.5),
          child: GestureDetector(
            onTap: () {
              print("IBBIBIUI");
              // Get.to(() => const LoaderScreen());
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: Platform.isAndroid ? 10.0 : 0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: UiColors.blueColor),
                child: const Center(
                  child: Text(
                    // AppLocalizations.of(context)!.resizeImage,
                    "Resize Image",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //- Image Preview
            widget.file != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.file(
                        File(widget.file!.path),
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
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
                                                        .resizeOption.value ==
                                                    'Quality'
                                                ? UiColors.blueColor
                                                : Colors.transparent),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Dimension",
                                          // AppLocalizations.of(context)!.dimension,
                                          style: TextStyle(
                                            color: resizedController
                                                        .resizeOption.value ==
                                                    ''
                                                ? UiColors.blueColor
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
                                                        .resizeOption.value ==
                                                    'Percentage'
                                                ? UiColors.blueColor
                                                : Colors.transparent),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Percentage",
                                          // AppLocalizations.of(context)!
                                          //     .percentage,
                                          style: TextStyle(
                                            color: resizedController
                                                        .resizeOption.value ==
                                                    'Percentage'
                                                ? UiColors.blueColor
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
                                    ? UiColors.blueColor
                                    : UiColors.blackColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Reduce Dimensions By",
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
                                },
                                child: reduceQualityWidget("100 x 100", 0)),
                            GestureDetector(
                                onTap: () {
                                  qualitySelectedIndex.value = 1;
                                },
                                child: reduceQualityWidget("250 x 250", 1)),
                            GestureDetector(
                                onTap: () {
                                  qualitySelectedIndex.value = 2;
                                },
                                child: reduceQualityWidget("500 x 500", 2)),
                            GestureDetector(
                                onTap: () {
                                  qualitySelectedIndex.value = 3;
                                },
                                child: reduceQualityWidget("750 x 750", 3)),
                            GestureDetector(
                                onTap: () {
                                  qualitySelectedIndex.value = 4;
                                },
                                child: reduceQualityWidget("1000 x 1000", 4)),
                            GestureDetector(
                                onTap: () {
                                  qualitySelectedIndex.value = 5;
                                },
                                child: reduceQualityWidget("1200 x 1200", 5)),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  qualitySelectedIndex.value = 6;
                                },
                                child: reduceQualityWidget("1500 x 1500", 6)),
                            GestureDetector(
                                onTap: () {
                                  qualitySelectedIndex.value = 7;
                                },
                                child: reduceQualityWidget("2000 x 2000", 7)),
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
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.radio_button_checked_rounded,
                                  color: resizedController
                                              .selectedResizeType.value ==
                                          'Custom'
                                      ? UiColors.blueColor
                                      : UiColors.blackColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Custom",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                    child: IgnorePointer(
                                      ignoring: resizedController
                                              .selectedResizeType.value !=
                                          'Custom',
                                      child: TextField(
                                        controller:
                                            resizedController.widthController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        cursorColor: UiColors.blueColor,
                                        onTapOutside: (PointerDownEvent event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Width",
                                          // AppLocalizations.of(context)!
                                          //     .width,
                                          hintStyle:
                                              const TextStyle(fontSize: 12),
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
                                              color: UiColors.blueColor
                                                  .withOpacity(0.6),
                                              width: 1.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                        ),
                                        onChanged: (_) => validateInput(),
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
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                    child: IgnorePointer(
                                      ignoring: resizedController
                                              .selectedResizeType.value !=
                                          'Custom',
                                      child: TextField(
                                        controller:
                                            resizedController.heightController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        onTapOutside: (PointerDownEvent event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        cursorColor: UiColors.blueColor,
                                        decoration: InputDecoration(
                                          hintText: "Height",
                                          // AppLocalizations.of(context)!
                                          //     .height,
                                          hintStyle:
                                              const TextStyle(fontSize: 12),
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
                                              color: UiColors.blueColor
                                                  .withOpacity(0.6),
                                              width: 1.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                        ),
                                        onChanged: (_) => validateInput(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (resizedController.widthError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 4),
                                child: Text(
                                  resizedController.widthError!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            if (resizedController.heightError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 4),
                                child: Text(
                                  resizedController.heightError!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ])
                    : resizedController.resizeOption.value == 'Percentage'
                        ?
                        // if (resizedController.resizeOption.value == 'Percentage') ...
                        Column(children: [
                            // Radio buttons for Increase and Decrease
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      resizedController
                                          .resizeDimensionBy.value = 'Increase';
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.radio_button_checked_rounded,
                                          color: resizedController
                                                      .resizeDimensionBy
                                                      .value ==
                                                  'Increase'
                                              ? UiColors.blueColor
                                              : UiColors.blackColor,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Increase",
                                          // AppLocalizations.of(context)!.increase,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  GestureDetector(
                                    onTap: () {
                                      print(
                                          "befor : ${resizedController.resizeDimensionBy.value}");
                                      resizedController
                                          .resizeDimensionBy.value = 'Decrease';
                                      print(
                                          "after : ${resizedController.resizeDimensionBy.value}");
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.radio_button_checked_rounded,
                                          color: resizedController
                                                      .resizeDimensionBy
                                                      .value ==
                                                  'Decrease'
                                              ? UiColors.blueColor
                                              : UiColors.blackColor,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Decrease",
                                          // AppLocalizations.of(context)!.decrease,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Preset Dimensions in GridView
                            const Text("IIIII"),
                            // GridView.builder(
                            //   shrinkWrap: true,
                            //   itemCount: resizedController.percentageDimensions.length,
                            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            //     crossAxisCount: 3,
                            //     crossAxisSpacing: 10,
                            //     mainAxisSpacing: 10,
                            //     childAspectRatio: (0.5 / 0.2),
                            //   ),
                            //   itemBuilder: (context, index) {
                            //     final dimension =
                            //         resizedController.percentageDimensions[index];
                            //     return GestureDetector(
                            //       onTap: () {
                            //         setState(() {
                            //           resizedController.selectedPercentageDimensions =
                            //               dimension;
                            //           print(
                            //               "selectedPercentageDimensions ${resizedController.selectedPercentageDimensions}");
                            //           resizedController.selectedDimension = '';
                            //           resizedController.customWidth = null;
                            //           resizedController.customHeight = null;
                            //         });
                            //       },
                            //       child: Container(
                            //         decoration: BoxDecoration(
                            //           color:
                            //               resizedController.selectedPercentageDimensions ==
                            //                       dimension
                            //                   ? UiColors.blueColor.withOpacity(0.1)
                            //                   : Colors.white,
                            //           borderRadius: BorderRadius.circular(10),
                            //           border: Border.all(
                            //             color: resizedController
                            //                         .selectedPercentageDimensions ==
                            //                     dimension
                            //                 ? Colors.transparent
                            //                 : UiColors.blackColor,
                            //           ),
                            //         ),
                            //         alignment: Alignment.center,
                            //         child: Text(
                            //           dimension,
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //             color: resizedController
                            //                         .selectedPercentageDimensions ==
                            //                     dimension
                            //                 ? UiColors.blueColor
                            //                 : Colors.black,
                            //             fontWeight: resizedController
                            //                         .selectedPercentageDimensions ==
                            //                     dimension
                            //                 ? FontWeight.w500
                            //                 : FontWeight.w400,
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ])
                        : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
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
                  ? UiColors.blueColor.withOpacity(0.1)
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
                    ? UiColors.blueColor
                    : UiColors.blackColor),
          ))),
    );
  }

  void validateInput() {
    setState(() {
      final widthValue =
          double.tryParse(resizedController.widthController.text);
      final heightValue =
          double.tryParse(resizedController.heightController.text);

      if (widthValue == null || widthValue < 1 || widthValue > 6000) {
        resizedController.widthError = "Width must be between 1 and 6000";
      } else {
        resizedController.widthError = null;
        resizedController.customWidth = widthValue;
      }

      if (heightValue == null || heightValue < 1 || heightValue > 6000) {
        resizedController.heightError = "Height must be between 1 and 6000";
      } else {
        resizedController.heightError = null;
        resizedController.customHeight = heightValue;
      }
    });
  }
}
