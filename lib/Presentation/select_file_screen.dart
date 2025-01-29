import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Controller/HomeScreenController/home_screen_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectFileScreen extends StatefulWidget {
  const SelectFileScreen({super.key});

  @override
  State<SelectFileScreen> createState() => _SelectFileScreenState();
}

class _SelectFileScreenState extends State<SelectFileScreen> {
  final homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: UiColors.whiteColor,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    imagePickupOptions(
                      "assets/image_convertor.png",
                      "Image Converter",
                      // AppLocalizations.of(context)!.image_converter,
                      () {
                        homeScreenController.handleDriveImage();
                        // Get.to(() => ImagePickupScreen(
                        //       toolName:
                        //           AppLocalizations.of(context)!.image_converter,
                        //     ));
                      },
                    ),
                    sizedBoxWidth,
                    imagePickupOptions(
                      "assets/image_resizer.png",
                      "Image Resizer",
                      // AppLocalizations.of(context)!.imageResizer,
                      () {
                        homeScreenController.imageResizerFunction();
                        // Get.to(() => ImagePickupScreen(
                        //       toolName:
                        //           AppLocalizations.of(context)!.imageResizer,
                        //     ));
                      },
                    ),
                    sizedBoxWidth,
                    imagePickupOptions(
                      "assets/image_compressor.png",
                      "Image Compressor",
                      // AppLocalizations.of(context)!.image_converter,
                      () {
                        homeScreenController.handleDriveImage();
                        // Get.to(() => ImagePickupScreen(
                        //       toolName:
                        //           AppLocalizations.of(context)!.image_converter,
                        //     ));
                      },
                    ),
                    sizedBoxWidth,
                    imagePickupOptions(
                      "assets/image_enhancer.png",
                      // AppLocalizations.of(context)!.imageResizer,
                      "Image Enhancer",
                      () {
                        homeScreenController.handleDriveImage();
                        // Get.to(() => ImagePickupScreen(
                        //       toolName:
                        //           AppLocalizations.of(context)!.imageResizer,
                        //     ));
                      },
                    ),
                  ],
                )
                // InkWell(
                //   onTap: () => homeScreenController.handleDriveImage(),
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: DottedBorder(
                //       color: UiColors.blackColor.withOpacity(0.2),
                //       borderType: BorderType.RRect,
                //       dashPattern: const [10, 6],
                //       strokeWidth: 2.3,
                //       radius: const Radius.circular(16.0),
                //       child: DropTarget(
                //         onDragDone: (DropDoneDetails details) async {
                //           await homeScreenController.handleDragDropImage(details);
                //         },
                //         child: Container(
                //           width: MediaQuery.sizeOf(context).width * 0.58,
                //           height: 270,
                //           padding: const EdgeInsets.symmetric(vertical: 30.0),
                //           decoration: BoxDecoration(
                //               color: UiColors.whiteColor,
                //               borderRadius: BorderRadius.circular(15.0)),
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Image.asset(
                //                 "assets/Import.png",
                //                 height: 80.0,
                //                 width: 80.0,
                //               ),
                //               const SizedBox(
                //                 height: 20.0,
                //               ),
                //               Text(
                //                 // "Drag or Paste File",
                //                 AppLocalizations.of(context)!.drag_or_paste_file,
                //                 style: GoogleFonts.poppins(
                //                   textStyle: const TextStyle(
                //                       fontSize: 20.0,
                //                       fontWeight: FontWeight.w500),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customHomeButton(
                  "assets/link.png",
                  AppLocalizations.of(context)!.url_link,
                  AppLocalizations.of(context)!.file_from_url,
                  () {
                    homeScreenController.handleUrlImage();
                  },
                ),
                const SizedBox(
                  width: 20.0,
                ),
                customHomeButton(
                  'assets/Drive.png',
                  AppLocalizations.of(context)!.google_drive,
                  AppLocalizations.of(context)!.choose_from_files,
                  () async {
                    await homeScreenController.handleDriveImage();
                  },
                ),
                const SizedBox(
                  width: 20.0,
                ),
                customHomeButton(
                  'assets/dropbox.png',
                  AppLocalizations.of(context)!.dropbox,
                  AppLocalizations.of(context)!.choose_from_files,
                  () async {
                    await homeScreenController.handleDriveImage();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  customHomeButton(
    String icon,
    String text,
    String descriptionText,
    final VoidCallback? onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: UiColors.whiteColor),
        height: 60,
        width: 210,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 26.0,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  maxLines: 1,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  descriptionText,
                  maxLines: 1,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black.withOpacity(0.4),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  imagePickupOptions(
      String optionImage, String optionName, VoidCallback onPress) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: onPress,
        child: Container(
          height: 145,
          width: 160,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                optionImage,
                height: 60,
                width: 60,
              ),
              const SizedBox(height: 15),
              Text(
                optionName,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
