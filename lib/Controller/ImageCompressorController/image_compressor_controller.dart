import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as IMG;
import 'package:image_converter_macos/Controller/convert_images_controller.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressorController extends GetxController {
  File? filePath;
  RxString resizeOption = 'Quality'.obs;
  // RxString selectedResizeType = 'Reduce By Quality'.obs;
  final conversionController = Get.put(ConvertImagesController());

  // Track the selected radio button
  RxString resizeDimensionBy = 'Increase'.obs; // Default option

  // String selectedDimension = '100 x 100';
  String? selectedPercentageDimensions;
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  Uint8List? originalImageBytes;
  Uint8List? processedImageBytes;

  String? widthError;
  String? heightError;

  double? customWidth;
  double? customHeight;
  RxBool loadingState = false.obs;

  RxDouble infiniteProgress = 0.0.obs;
  Animation<double>? progressAnimation;
  AnimationController? controller;

  // final List<String> dimensions = [
  //   '100 x 100',
  //   '250 x 250',
  //   '500 x 500',
  //   '750 x 750',
  //   '1000 x 1000',
  //   '1200 x 1200',
  //   '1500 x 1500',
  //   '2000 x 2000'
  // ];
  // final List<String> percentageDimensions = [
  //   '10%',
  //   '20%',
  //   '30%',
  //   '40%',
  //   '50%',
  //   '60%',
  //   '70%',
  //   '80%',
  //   '90%',
  // ];
  // void resizeByDimensions() {
  //   print("%%%loadingState.value ${loadingState.value}");
  //   if (filePath != null) {
  //     // Decode the image from the file
  //     // final originalImage = IMG.decodePng(filePath!.readAsBytesSync());
  //     final originalImage = Platform.isIOS
  //         ? IMG.decodeJpg(filePath!.readAsBytesSync())
  //         : IMG.decodePng(filePath!.readAsBytesSync());
  //     print("%%%originalImage $originalImage");
  //     if (resizeOption.value == 'Dimensions') {
  //       print("%%%selectedResizeType.value ${selectedResizeType.value}");
  //       if (selectedResizeType.value == 'Custom') {
  //         if (widthController.text.isNotEmpty &&
  //             heightController.text.isNotEmpty) {
  //           int? targetWidth = int.tryParse(widthController.text);
  //           int? targetHeight = int.tryParse(heightController.text);
  //           print("%%%targetHeight $targetHeight");
  //           print("%%%targetWidth $targetWidth");

  //           if (targetWidth != null &&
  //               targetHeight != null &&
  //               originalImage != null) {
  //             final resizedImage = IMG.copyResize(
  //               originalImage,
  //               width: targetWidth,
  //               height: targetHeight,
  //             );
  //             print("%%%resizedImage $resizedImage");
  //             saveResizedImage(resizedImage);
  //           }
  //         }
  //       } else if (selectedResizeType.value == 'Reduce Dimensions by') {
  //         print("%%%selectedDimension 1: $selectedDimension");
  //         if (selectedDimension.isNotEmpty) {
  //           final dimensions =
  //               selectedDimension.split('x').map((e) => e.trim());
  //           print("%%%dimensions 1: $dimensions");

  //           int? targetWidth = int.tryParse(dimensions.first);
  //           int? targetHeight = int.tryParse(dimensions.last);
  //           print("%%%targetHeight 1: $targetHeight");
  //           print("%%%targetWidth 2: $targetWidth");
  //           if (targetWidth != null &&
  //               targetHeight != null &&
  //               originalImage != null) {
  //             final resizedImage = IMG.copyResize(
  //               originalImage,
  //               width: targetWidth,
  //               height: targetHeight,
  //             );
  //             print("%%%resizedImage $resizedImage");

  //             saveResizedImage(resizedImage);
  //           }
  //         }
  //       }
  //       // Handle dimensions
  //     } else if (resizeOption.value == 'Percentage') {
  //       // Handle percentage logic
  //       if (selectedPercentageDimensions!.isNotEmpty) {
  //         int? percentage =
  //             int.tryParse(selectedPercentageDimensions!.replaceAll('%', ''));
  //         if (percentage != null && originalImage != null) {
  //           // Calculate new dimensions based on Increase or Decrease
  //           int adjustedWidth;
  //           int adjustedHeight;

  //           if (resizeDimensionBy.value == 'Increase') {
  //             adjustedWidth = (originalImage.width +
  //                     (originalImage.width * percentage ~/ 100))
  //                 .clamp(1,
  //                     double.maxFinite.toInt()); // Prevent invalid dimensions
  //             adjustedHeight = (originalImage.height +
  //                     (originalImage.height * percentage ~/ 100))
  //                 .clamp(1, double.maxFinite.toInt());
  //           } else if (resizeDimensionBy.value == 'Decrease') {
  //             adjustedWidth = (originalImage.width -
  //                     (originalImage.width * percentage ~/ 100))
  //                 .clamp(1, originalImage.width); // Prevent invalid dimensions
  //             adjustedHeight = (originalImage.height -
  //                     (originalImage.height * percentage ~/ 100))
  //                 .clamp(1, originalImage.height);
  //           } else {
  //             print(
  //                 "Invalid resizeDimensionBy value: ${resizeDimensionBy.value}");
  //             return;
  //           }

  //           print("%%%Adjusted Width: $adjustedWidth");
  //           print("%%%Adjusted Height: $adjustedHeight");

  //           // Resize the image
  //           final resizedImage = IMG.copyResize(
  //             originalImage,
  //             width: adjustedWidth,
  //             height: adjustedHeight,
  //           );
  //           saveResizedImage(resizedImage);
  //         }
  //       }
  //     }
  //   }
  // }

  // Future<void> saveResizedImage(IMG.Image resizedImage) async {
  //   try {
  //     print("%%%%saveResizedImage   $saveResizedImage");
  //     DateTime dateTime = DateTime.now();
  //     print("%%%%dateTime  $dateTime");

  //     Directory? dir = Platform.isIOS
  //         ? await getApplicationCacheDirectory()
  //         : await getExternalStorageDirectory();
  //     print("%%%%dir  $dir");

  //     var targetDirectoryPath = '${dir?.path}/ImageConverter/';
  //     print("%%%%targetDirectoryPath  $targetDirectoryPath");

  //     var path =
  //         '${targetDirectoryPath}ImageResizer_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.png';
  //     print("%%%%path  $path");

  //     // Ensure the directory exists
  //     Directory convertedFilesDir = Directory('${dir!.path}/ImageConverter');
  //     if (!await convertedFilesDir.exists()) {
  //       await convertedFilesDir.create(recursive: true);
  //     }

  //     // Write the image bytes to the file
  //     File file = File(path);
  //     if (Platform.isIOS) {
  //       await file.writeAsBytes(IMG.encodeJpg(resizedImage, quality: 85));
  //     } else {
  //       await file.writeAsBytes(IMG.encodePng(resizedImage));
  //     }
  //     // await file.writeAsBytes(IMG.encodeJpg(resizedImage, quality: 85));

  //     loadingState.value = false;

  //     // await Get.to(
  //     //   () => ConversionResult(
  //     //     imageFormat: const [".png"],
  //     //     dateTime: [conversionController.getFormattedDateTime(dateTime)],
  //     //     convertedFile: [file],
  //     //   ),
  //     // );

  //     print('Image saved at $path');
  //   } catch (e) {
  //     loadingState.value = false;
  //     // Get.offAll(() => const BottomNavBar());
  //     print('Error saving image: $e');
  //   }
  // }

}
