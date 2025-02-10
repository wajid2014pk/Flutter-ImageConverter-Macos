import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Controller/HomeScreenController/home_screen_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_converter_macos/Controller/PremiumPopUpController/premium_controller.dart';
import 'package:image_converter_macos/Presentation/convert_file.dart';
import 'package:window_manager/window_manager.dart';

class SelectFileScreen extends StatefulWidget {
  const SelectFileScreen({super.key});

  @override
  State<SelectFileScreen> createState() => _SelectFileScreenState();
}

class _SelectFileScreenState extends State<SelectFileScreen>
    with WindowListener {
  GlobalKey? lastTappedKey; // Store the last tapped key
  final payWallController = Get.put(PayWallController());
  void initState() {
    detectScreenSize(); // Initial screen size detection

    // Continuously listen for screen size changes
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void onWindowResized() {
    detectScreenSize();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    removePopup();
    super.dispose();
  }

  final homeScreenController = Get.put(HomeScreenController());
  RxDouble screenSize = 0.0.obs;
  OverlayEntry? overlayEntry;
  GlobalKey imageConvertorKey = GlobalKey();
  GlobalKey imageResizerKey = GlobalKey();
  GlobalKey imageCompressorKey = GlobalKey();
  GlobalKey imageEnhancerKey = GlobalKey();
  RxInt popupPositionValue = 185.obs;
  RxInt toolIndex = 10.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        removePopup();
      },
      child: Scaffold(
        backgroundColor: UiColors.backgroundColor,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: Get.width * 0.07,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            key: imageConvertorKey,
                            onTap: () {
                              toolIndex.value = 0;
                              print("toolIndex${toolIndex.value}");
                              showPopup(imageConvertorKey, 0);
                            },
                            child: imagePickupOptions(
                                "assets/image_convertor.png",
                                "Image Converter",
                                0),
                          ),
                          GestureDetector(
                            key: imageResizerKey,
                            onTap: () {
                              toolIndex.value = 1;
                              print("toolIndex${toolIndex.value}");
                              showPopup(imageResizerKey, 1);
                            },
                            child: imagePickupOptions(
                                "assets/image_resizer.png", "Image Resizer", 1),
                          ),
                          GestureDetector(
                            key: imageCompressorKey,
                            onTap: () {
                              toolIndex.value = 2;
                              print("toolIndex${toolIndex.value}");
                              showPopup(imageCompressorKey, 2);
                            },
                            child: imagePickupOptions(
                                "assets/image_compressor.png",
                                "Image Compressor",
                                2),
                          ),
                          GestureDetector(
                            key: imageEnhancerKey,
                            onTap: () {
                              toolIndex.value = 3;
                              print("toolIndex${toolIndex.value}");
                              showPopup(imageEnhancerKey, 3);
                            },
                            child: imagePickupOptions(
                                "assets/image_enhancer.png",
                                // AppLocalizations.of(context)!.imageResizer,
                                "Image Enhancer",
                                3),
                          ),
                        ],
                      )),
                ],
              ),
              const Spacer(),
              Obx(
                () => payWallController.isPro.value == false
                    ? GestureDetector(
                        onTap: () {
                          payWallController.offerings == null
                              ? payWallController.getProductsPrice()
                              : null;
                          payWallController.selectPackage.value = 1;
                          payWallController.offerings == null
                              ? Get.snackbar(
                                  backgroundColor: Colors.white,
                                  "Failed",
                                  "No Internet Connecion")
                              : payWallController.makePurchase();
                        },
                        child: Container(
                            height: Get.width * 0.085,
                            width: Get.width / 2.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/pro_banner_container.png',
                                  ),
                                  fit: BoxFit.cover),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Unlimited Conversion’s",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.25,
                                            child: Text(
                                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: UiColors
                                                      .proBannerGreyColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 22, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: UiColors.blueColorNew,
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          "Upgrade Now",
                                          style: TextStyle(
                                              color: UiColors.whiteColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    : SizedBox(),
              ),
              const SizedBox(
                height: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container customPopupButton(String icon, String descriptionText, int index) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: UiColors.backgroundColor),
      height: 80,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            height: 22.0,
          ),
          const SizedBox(
            height: 12.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                descriptionText,
                maxLines: 1,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 10.0,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Obx imagePickupOptions(String optionImage, String optionName, int index) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(8.0),
        decoration: index == toolIndex.value
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    spreadRadius: 1,
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  )
                ],
              )
            : BoxDecoration(),
        child: Container(
          height: 115,
          width: 170,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                optionImage,
                height: 45,
                width: 45,
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

  //------------overlay----------------

  void showPopup(GlobalKey key, int index) {
    removePopup(); // Remove any existing popup first

    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) => Obx(
        () => Positioned(
          left: offset.dx +
              size.width / 2 -
              popupPositionValue.value, // Centering
          top: offset.dy + size.height + 10, // Below the button
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Center(
                  child: CustomPaint(
                    size: const Size(30, 20), // Adjust size
                    painter: TrianglePainter(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (index == 0) {
                                  toolIndex.value = 10;
                                  removePopup();
                                  await homeScreenController.handleDriveImage();
                                } else if (index == 1) {
                                  toolIndex.value = 10;
                                  removePopup();
                                  await homeScreenController
                                      .imageResizerFunction();
                                } else if (index == 2) {
                                  toolIndex.value = 10;
                                  removePopup();
                                  await homeScreenController
                                      .imageCompressorFunction();
                                }
                              },
                              child: customPopupButton(
                                  "assets/upload_image.png",
                                  // AppLocalizations.of(context)!.file_from_url,
                                  "Upload Image",
                                  index),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (index == 0) {
                                  toolIndex.value = 10;
                                  removePopup();
                                  await homeScreenController.handleDriveImage();
                                } else if (index == 1) {
                                  toolIndex.value = 10;
                                  removePopup();
                                  await homeScreenController
                                      .imageResizerFunction();
                                } else if (index == 2) {
                                  toolIndex.value = 10;
                                  removePopup();
                                  await homeScreenController
                                      .imageCompressorFunction();
                                }
                              },
                              child: customPopupButton(
                                  'assets/drive_image.png', "G-Drive", index
                                  // AppLocalizations.of(context)!.choose_from_files,
                                  ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (index == 0) {
                                  toolIndex.value = 10;
                                  removePopup();
                                  await homeScreenController
                                      .handleUrlImage(index);
                                } else if (index == 1) {
                                  toolIndex.value = 10;
                                  removePopup();
                                  await homeScreenController
                                      .handleUrlImage(index);
                                } else if (index == 2) {
                                  toolIndex.value = 10;
                                  removePopup();
                                  await homeScreenController
                                      .handleUrlImage(index);
                                }
                              },
                              child: customPopupButton(
                                  'assets/link_image.png', "URL Link", index
                                  // AppLocalizations.of(context)!.choose_from_files,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void removePopup() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  detectScreenSize() async {
    double screenRect =
        await windowManager.getSize().then((display) => display.aspectRatio);
    screenSize.value = screenRect;
    print("window size :: ${screenSize.value}");
    if (screenSize.value < 1.8) {
      popupPositionValue.value = 185;
    } else if (screenSize.value >= 1.8) {
      popupPositionValue.value = 185;
    }

    // setState(() {
    //   screenSize = Size(screenRect.width, screenRect.height);
    // });
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white // Triangle color
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width / 2, 0); // Top center
    path.lineTo(0, size.height); // Bottom left
    path.lineTo(size.width, size.height); // Bottom right
    path.close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
