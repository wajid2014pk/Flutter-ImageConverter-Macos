import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Controller/HomeScreenController/home_screen_controller.dart';

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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: DottedBorder(
                  color: UiColors.blackColor.withOpacity(0.2),
                  borderType: BorderType.RRect,
                  dashPattern: const [10, 6],
                  strokeWidth: 2.3,
                  radius: const Radius.circular(16.0),
                  child: DropTarget(
                    onDragDone: (DropDoneDetails details) async {
                      // await homeScreenController.dragImages(details);
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.58,
                      height: 270,
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      decoration: BoxDecoration(
                          color: UiColors.whiteColor,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/Import.png",
                            height: 80.0,
                            width: 80.0,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Drag or Paste File",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customHomeButton(
                  "assets/link.png",
                  "URL Link",
                  "File from URL",
                  () {
                    homeScreenController.handleUrlImage();
                    // homeScreenController.isVisible.value =!homeScreenController.isVisible.value;
                  },
                ),
                const SizedBox(
                  width: 20.0,
                ),
                customHomeButton(
                  'assets/Drive.png',
                  "Google Drive",
                  "Choose from Files",
                  () async {
                    await homeScreenController.handleDriveImage();
                  },
                ),
                const SizedBox(
                  width: 20.0,
                ),
                customHomeButton(
                  'assets/dropbox.png',
                  "Dropbox",
                  "Choose from Files",
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
}
