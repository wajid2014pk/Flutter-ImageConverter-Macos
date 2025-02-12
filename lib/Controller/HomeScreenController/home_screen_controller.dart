import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/PremiumPopUpController/premium_controller.dart';
import 'package:image_converter_macos/Presentation/convert_file.dart';
import 'package:image_converter_macos/Presentation/image_compressor.dart';
import 'package:image_converter_macos/Presentation/image_resizer.dart';
import 'package:image_converter_macos/Screens/premium_popup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as di;
import 'package:path/path.dart' as path;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreenController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  RxInt sideBarSelectedIndex = 1.obs;

  RxBool isVisible = false.obs;

  TextEditingController textController = TextEditingController();
  final payWallController = Get.put(PayWallController());

  bool isArabicOrPersianOrHebrew = [
    'ar',
    'fa',
    'he',
  ].contains(Localizations.localeOf(Get.context!).languageCode);

  // @override
  // void onInit() {
  //   super.onInit();
  //   showPremium();
  // }

  customAppBar(BuildContext context) {
    return Obx(
      () => AppBar(
        backgroundColor: UiColors.whiteColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: IntrinsicHeight(
          child: Row(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 40,
                width: 40,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                '${AppLocalizations.of(context)!.image} ${AppLocalizations.of(context)!.converter}',
                style: TextStyle(
                  color: UiColors.blackColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              // sideBarSelectedIndex.value == 2
              //     ? VerticalDivider(
              //         thickness: 1.5,
              //         color: UiColors.blackColor.withOpacity(0.2),
              //       )
              //     : const SizedBox(),
              // const SizedBox(
              //   width: 20,
              // ),
              sideBarSelectedIndex.value == 2
                  ? Text(
                      AppLocalizations.of(context)!.history,
                      style: TextStyle(
                        color: UiColors.blackColor,
                        fontSize: 20.0,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  sideBarItem(
      String assetName, String sideBarItem, int index, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        sideBarSelectedIndex.value = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
            color: sideBarSelectedIndex.value == index
                ? UiColors.blueColorNew
                : null,
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Image.asset(
              assetName,
              height: 20,
              color: sideBarSelectedIndex.value == index
                  ? UiColors.whiteColor
                  : UiColors.blackColor,
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 8,
              child: Text(
                sideBarItem,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Manrope-Regular',
                  fontWeight: FontWeight.w300,
                  color: sideBarSelectedIndex.value == index
                      ? UiColors.whiteColor
                      : UiColors.blackColor,
                  // fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  divider() {
    return Padding(
      padding: EdgeInsets.fromLTRB(isArabicOrPersianOrHebrew ? 20 : 0, 8,
          isArabicOrPersianOrHebrew ? 0 : 20, 8),
      child: const Divider(thickness: 1),
    );
  }

  Future<void> handleDriveImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: payWallController.isPro.value ? true : false,
      allowedExtensions: [
        'bmp',
        'tiff',
        'heic',
        'png',
        'jpg',
        'jpeg',
        'gif',
      ],
    );

    print("Result : $result ");

    if (result != null) {
      List<String> file = [];
      for (int i = 0; i < result.files.length; i++) {
        file.add(result.files[i].path!);
      }

      // for(int i=0;i<result.files.length;i++)
      // {

      // }
      // int fileSizeInBytes = File(file.path!).lengthSync();
      // double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
      // print("Size in Mb $fileSizeInMb ");

      // if (fileSizeInMb > 3 && payWallController.isPro.value == false) {
      //   Get.snackbar(
      //     AppLocalizations.of(Get.context!)!.attention,
      //     "File Size is greater then 3 MBs. Buy Premium to Convert",
      //   );

      //   Future.delayed(const Duration(seconds: 3), () {
      //     PremiumPopUp().premiumScreenPopUp(Get.context!);
      //   });
      //   return;
      // }

      Get.to(() => ConvertFile(imagePath: file));
    } else {
      print('User canceled file selection');
    }
  }

  Future<void> imageResizerFunction() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: [
        'bmp',
        'tiff',
        'heic',
        'bmp',
        'png',
        'jpg',
        'jpeg',
        'gif'
      ],
    );

    print("Result : $result ");

    if (result != null) {
      PlatformFile file = result.files.first;
      int fileSizeInBytes = File(file.path!).lengthSync();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
      print("Size in Mb $fileSizeInMb ");

      if (fileSizeInMb > 3 && payWallController.isPro.value == false) {
        Get.snackbar(
          AppLocalizations.of(Get.context!)!.attention,
          "File Size is greater then 3 MBs. Buy Premium to Convert",
        );

        Future.delayed(const Duration(seconds: 3), () {
          PremiumPopUp().premiumScreenPopUp(Get.context!);
        });
        return;
      }

      Get.to(() => ImageResizerScreen(file: File(file.path!)));
    } else {
      print('User canceled file selection');
    }
  }

  Future<void> imageCompressorFunction() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: [
        'bmp',
        'tiff',
        'heic',
        'bmp',
        'png',
        'jpg',
        'jpeg',
        'gif'
      ],
    );

    print("Result : $result ");

    if (result != null) {
      List<PlatformFile> file = result.files;

      int fileSizeInBytes = File(file[0].path!).lengthSync();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
      print("Size in Mb $fileSizeInMb ");

      if (fileSizeInMb > 3 && payWallController.isPro.value == false) {
        Get.snackbar(
          AppLocalizations.of(Get.context!)!.attention,
          "File Size is greater then 3 MBs. Buy Premium to Convert",
        );

        Future.delayed(const Duration(seconds: 3), () {
          PremiumPopUp().premiumScreenPopUp(Get.context!);
        });
        return;
      }

      Get.to(() => ImageCompressorScreen(file: File(file[0].path!)));
    } else {
      print('User canceled file selection');
    }
  }

  // Future<void> handleDragDropImage(var details) async {
  //   if (details.files.length == 1) {
  //     String imagePath = details.files.first.path;

  //     int fileSizeInBytes = File(imagePath).lengthSync();
  //     double fileSizeInMb = fileSizeInBytes / (1024 * 1024);

  //     if (fileSizeInMb > 3 && payWallController.isPro.value == false) {
  //       Get.snackbar(
  //         AppLocalizations.of(Get.context!)!.attention,
  //         "File Size is greater then 3 MBs. Buy Premium to Convert",
  //       );
  //       Future.delayed(const Duration(seconds: 3), () {
  //         PremiumPopUp().premiumScreenPopUp(Get.context!);
  //       });
  //       return;
  //     }

  //     if (imagePath.toLowerCase().endsWith('.png') ||
  //         imagePath.toLowerCase().endsWith('.jpg') ||
  //         imagePath.toLowerCase().endsWith('.jpeg') ||
  //         imagePath.toLowerCase().endsWith('.bmp') ||
  //         imagePath.toLowerCase().endsWith('.heic') ||
  //         imagePath.toLowerCase().endsWith('.gif') ||
  //         imagePath.toLowerCase().endsWith('.webp')) {
  //       Get.to(() => ConvertFile(imagePath: imagePath));
  //     } else {
  //       Get.snackbar(
  //         AppLocalizations.of(Get.context!)!.attention,
  //         AppLocalizations.of(Get.context!)!.invalid_image_format,
  //       );
  //     }
  //   } else {
  //     Get.snackbar(
  //       AppLocalizations.of(Get.context!)!.attention,
  //       AppLocalizations.of(Get.context!)!
  //           .only_one_image_can_be_dropped_at_a_time,
  //     );
  //   }
  // }

  Future<void> handleUrlImage(int index) async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: SizedBox(
            height: 120,
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.3))),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color(0xff5500FF),
                      )),
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.paste_url_here,
                      hintStyle:
                          const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          textController.clear();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.3),
                              fontSize: 14),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        backgroundColor: UiColors.lightblueColor,
                      ),
                      onPressed: () async {
                        try {
                          String enteredUrl =
                              // 'https://upload.wikimedia.org/wikipedia/commons/4/41/Sunflower_from_Silesia2.jpg';
                              textController.text.trim();
                          Uri? uri = Uri.tryParse(enteredUrl);
                          String fileExtension = path.extension(enteredUrl);
                          if (fileExtension == ".png" ||
                              fileExtension == ".jpg" ||
                              fileExtension == ".jpeg" ||
                              fileExtension == ".gif") {
                            if (enteredUrl.isNotEmpty) {
                              final directory = await getTemporaryDirectory();
                              final filePath =
                                  '${directory.path}/${uri!.pathSegments.last}';
                              final dio = di.Dio();
                              try {
                                await dio.download(enteredUrl, filePath);

                                // Check file size
                                int fileSizeInBytes =
                                    File(filePath).lengthSync();
                                double fileSizeInMb =
                                    fileSizeInBytes / (1024 * 1024);
                                if (fileSizeInMb > 3 &&
                                    payWallController.isPro.value == false) {
                                  Get.snackbar(
                                    AppLocalizations.of(Get.context!)!
                                        .attention,
                                    "File Size is greater then 3 MBs. Buy Premium to Convert",
                                  );
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    PremiumPopUp()
                                        .premiumScreenPopUp(Get.context!);
                                  });
                                  return;
                                }

                                // Proceed to convert file
                                if (index == 0) {
                                  Get.to(() => ConvertFile(
                                        imagePath: [filePath],
                                      ));
                                } else if (index == 1) {
                                  Get.to(() => ImageResizerScreen(
                                        file: File(filePath),
                                      ));
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(Get.context!)
                                    .showSnackBar(SnackBar(
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    AppLocalizations.of(Get.context!)!
                                        .please_enter_valid_url,
                                  ),
                                ));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(Get.context!)!
                                        .please_enter_valid_url,
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(Get.context!)!
                                      .please_enter_valid_url,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          print('Error in onPressed: $e');
                        }
                        textController.clear();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.proceed,
                        // "Proceed",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showPremium() {
    Future.delayed(const Duration(seconds: 1), () {
      payWallController.isPro.value == false
          ? PremiumPopUp().premiumScreenPopUp(Get.context!)
          : () {};
    });
  }
}
