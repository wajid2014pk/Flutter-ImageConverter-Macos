import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Presentation/convert_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as di;
import 'package:path/path.dart' as path;

class HomeScreenController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  RxInt sideBarSelectedIndex = 1.obs;

  RxBool isVisible = false.obs;

  TextEditingController textController = TextEditingController();

  bool isArabicOrPersianOrHebrew = [
    'ar',
    'fa',
    'he',
  ].contains(Localizations.localeOf(Get.context!).languageCode);

  customAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: UiColors.whiteColor,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset(
            'assets/mac_logo.png',
            height: 40,
            width: 40,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Image Converter',
            style: GoogleFonts.poppins(
              color: UiColors.blackColor,
              fontSize: 24.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  sideBarItem(
      String assetName, String sideBarItem, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        sideBarSelectedIndex.value = index;
      },
      child: Row(
        children: [
          Image.asset(
            assetName,
            height: 28,
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
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: UiColors.blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          sideBarSelectedIndex.value == index
              ? Image.asset(
                  'assets/selection_bar.png',
                  height: 40,
                )
              : const SizedBox()
        ],
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

      Get.to(() => ConvertFile(imagePath: file.path));
    } else {
      print('User canceled file selection');
    }
  }

  Future<void> handleDragDropImage(var details) async {
    // Ensure only one file is dropped
    if (details.files.length == 1) {
      // Get the path of the dropped file
      String imagePath = details.files.first.path;

      // Check if the file extension is either PNG or JPG
      if (imagePath.toLowerCase().endsWith('.png') ||
          imagePath.toLowerCase().endsWith('.jpg') ||
          imagePath.toLowerCase().endsWith('.jpeg') ||
          imagePath.toLowerCase().endsWith('.bmp') ||
          imagePath.toLowerCase().endsWith('.heic') ||
          imagePath.toLowerCase().endsWith('.gif') ||
          imagePath.toLowerCase().endsWith('.webp')) {
        // Proceed to handle the image
        Get.to(() => ConvertFile(imagePath: imagePath));
      } else {
        // Display a toast message for invalid image format
        Get.snackbar(
          'Attention',
          "Invalid image format",
        );
        // Fluttertoast.showToast(
        //     msg: "Invalid image format",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }
    } else {
      // Display a toast message for dropping multiple files

      Get.snackbar(
        'Attention',
        "Only one image can be dropped at a time.",
      );
      // Fluttertoast.showToast(
      //     msg: "Only one image can be dropped at a time.",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
  }

  // Future<void> handleDragDropImage(details) async {
  //   var data = details.file;

  //   if (data is List<String>) {
  //     String imagePath = data.first;

  //     // Check if the file extension is either PNG or JPG
  //     if (imagePath.toLowerCase().endsWith('.png') ||
  //         imagePath.toLowerCase().endsWith('.jpg')) {
  //       // Proceed to handle the image
  //       Get.to(() => ConvertFile(imagePath: imagePath));
  //     } else {
  //       // Display a toast message for invalid image format
  //       Fluttertoast.showToast(
  //           msg: "Invalid image format. Only PNG and JPG images are allowed.",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   } else {
  //     print('Invalid drag data');
  //   }
  // }

  Future<void> handleUrlImage() async {
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
                      hintText: "Paste Url Here",
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
                          "Cancel",
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
                              } catch (e) {
                                ScaffoldMessenger.of(Get.context!)
                                    .showSnackBar(const SnackBar(
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    "Please Enter Valid URL",
                                  ),
                                ));
                              }
                              print("YYYYYY $filePath");
                              print("DDDD ${directory.path}");
                              // Get.to(() => ConvertFile(
                              //       imagePath: filePath,
                              //     ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please Enter Valid URL",
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please Enter Valid URL",
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          print('Error in onPressed: $e');
                        }
                      },
                      child: const Text(
                        // AppLocalizations.of(context)!.proceed,
                        "Proceed",
                        style: TextStyle(color: Colors.white),
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
}
