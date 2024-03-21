import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<FileSystemEntity> allfiles = [];
  Directory? directory;

  RxInt selectCategory = 1.obs;
  RxInt selectedFileIndex = (-1).obs;
  RxBool isSearchBarVisible = false.obs;

  RxBool showOnTapOptions = false.obs;

  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  String selectedFormat = 'All';

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.backgroundColor,
      body: Obx(
        () => Column(
          children: [
            isSearchBarVisible.value
                ? Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 1.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: TextField(
                                textAlign: TextAlign.start,
                                controller: searchController,
                                focusNode: focusNode,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface),
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(Get.context!)!
                                      .search_image,
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  _runFilter(value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            Container(
              margin:
                  const EdgeInsets.only(top: 6, left: 4, right: 4, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectCategory.value = 1;
                      _selectCategory("All");
                    },
                    child: getCategory(
                        "All",
                        selectCategory.value == 1
                            ? UiColors.blueColor
                            : UiColors.blackColor.withOpacity(0.1),
                        selectCategory.value == 1
                            ? UiColors.whiteColor
                            : Theme.of(context).hintColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectCategory.value = 2;
                      _selectCategory("png");
                    },
                    child: getCategory(
                        "PNG",
                        selectCategory.value == 2
                            ? UiColors.blueColor
                            : UiColors.blackColor.withOpacity(0.1),
                        selectCategory.value == 2
                            ? UiColors.whiteColor
                            : Theme.of(context).hintColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectCategory.value = 3;
                      _selectCategory("jpg");
                    },
                    child: getCategory(
                        "JPG",
                        selectCategory.value == 3
                            ? UiColors.blueColor
                            : UiColors.blackColor.withOpacity(0.1),
                        selectCategory.value == 3
                            ? UiColors.whiteColor
                            : Theme.of(context).hintColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectCategory.value = 4;
                      _selectCategory("pdf");
                    },
                    child: getCategory(
                        "PDF",
                        selectCategory.value == 4
                            ? UiColors.blueColor
                            : UiColors.blackColor.withOpacity(0.1),
                        selectCategory.value == 4
                            ? UiColors.whiteColor
                            : Theme.of(context).hintColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectCategory.value = 6;
                      _selectCategory("bmp");
                    },
                    child: getCategory(
                        "BMP",
                        selectCategory.value == 6
                            ? UiColors.blueColor
                            : UiColors.blackColor.withOpacity(0.1),
                        selectCategory.value == 6
                            ? UiColors.whiteColor
                            : Theme.of(context).hintColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectCategory.value = 7;
                      _selectCategory("gif");
                    },
                    child: getCategory(
                        "Gif",
                        selectCategory.value == 7
                            ? UiColors.blueColor
                            : UiColors.blackColor.withOpacity(0.1),
                        selectCategory.value == 7
                            ? UiColors.whiteColor
                            : Theme.of(context).hintColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectCategory.value = 8;
                      _selectCategory("webp");
                    },
                    child: getCategory(
                        "WEBP",
                        selectCategory.value == 8
                            ? UiColors.blueColor
                            : UiColors.blackColor.withOpacity(0.1),
                        selectCategory.value == 8
                            ? UiColors.whiteColor
                            : Theme.of(context).hintColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectCategory.value = 9;
                      _selectCategory("svg");
                    },
                    child: getCategory(
                        "SVG",
                        selectCategory.value == 9
                            ? UiColors.blueColor
                            : UiColors.blackColor.withOpacity(0.1),
                        selectCategory.value == 9
                            ? UiColors.whiteColor
                            : Theme.of(context).hintColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectCategory.value = 10;
                      _selectCategory("jpeg");
                    },
                    child: getCategory(
                        "JPEG",
                        selectCategory.value == 10
                            ? UiColors.blueColor
                            : UiColors.blackColor.withOpacity(0.1),
                        selectCategory.value == 10
                            ? UiColors.whiteColor
                            : Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: _buildGridView(context)),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    if (allfiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/empty.json'),
            InkWell(
              onTap: () {
                print("bdhdh ${showOnTapOptions.value}");
              },
              child: Text(
                AppLocalizations.of(Get.context!)!.no_data_found,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: (1.01 / .25)),
      itemCount: allfiles.length,
      itemBuilder: (BuildContext context, int index) {
        String fileName = allfiles[index].uri.pathSegments.last;
        String displayedFileName =
            fileName.length > 20 ? fileName.substring(0, 20) : fileName;

        String creationDate = _getCreationDate(allfiles[index]);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: InkWell(
            onTap: () {
              _openFile(allfiles[index]);
            },
            child: Container(
              decoration: BoxDecoration(
                color: UiColors.backgroundColor,
                border: Border(
                  right: BorderSide(
                      width: 1.0, color: UiColors.blackColor.withOpacity(0.2)),
                  bottom: BorderSide(
                      width: 1.0, color: UiColors.blackColor.withOpacity(0.2)),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      height: 65.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: _getFileIcon(fileName),
                    ),
                  ),
                  const SizedBox(width: 11.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 7,
                        child: Text(
                          displayedFileName,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        creationDate,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: UiColors.blackColor.withOpacity(0.4),
                              fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    icon: const Icon(
                      Icons.more_vert,
                      size: 25.0,
                    ),
                    itemBuilder: (BuildContext context) {
                      return [
                        AppLocalizations.of(Get.context!)!.delete,
                        AppLocalizations.of(Get.context!)!.share
                      ].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(
                            choice,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16.0),
                            ),
                          ),
                        );
                      }).toList();
                    },
                    onSelected: (value) async {
                      if (value == AppLocalizations.of(Get.context!)!.delete) {
                        _deleteFile(allfiles[index]);
                      } else if (value ==
                          AppLocalizations.of(Get.context!)!.share) {
                        _shareFile(allfiles[index]);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getCreationDate(FileSystemEntity file) {
    DateTime creationDateTime = file.statSync().modified;
    String formattedDate =
        '${creationDateTime.day}-${creationDateTime.month}-${creationDateTime.year}';
    return formattedDate;
  }

  static getCategory(String text, Color containerColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            color: containerColor, borderRadius: BorderRadius.circular(5)),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            )),
      ),
    );
  }

  void _selectCategory(String format) {
    setState(() {
      selectedFormat = format;
      _loadFiles();
    });
  }

  void _runFilter(String value) {
    setState(() {
      allfiles = allfiles
          .where((file) => file.uri.pathSegments.last
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });

    if (value.isEmpty) {
      _loadFiles();
    }

    if (allfiles.isEmpty) {
      print('No Data Found');
    }
  }

  Future<void> _loadFiles() async {
    directory = await getApplicationCacheDirectory();

    String folderName = 'ImageConverter';
    String folderPath = join(directory!.path, folderName);

    if (await Directory(folderPath).exists()) {
      setState(() {
        allfiles = Directory(folderPath).listSync().where((file) {
          if (selectedFormat == "All") {
            return true; // Show all files
          } else {
            return file.uri.pathSegments.last
                .toLowerCase()
                .endsWith(selectedFormat);
          }
        }).toList()
          ..sort((a, b) =>
              (b.statSync().modified.compareTo(a.statSync().modified)));

        print("Files $allfiles");
      });
    } else {
      print('!!!!Directory does not exist: $folderPath');
    }
  }

  Future<void> _deleteFile(FileSystemEntity file) async {
    try {
      await file.delete();
      showOnTapOptions.value = false;

      Future.delayed(const Duration(milliseconds: 300), () {
        _loadFiles();
      });
      // Reload files after deletion
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  void _shareFile(FileSystemEntity fileEntity) {
    if (fileEntity is File) {
      String fileName = fileEntity.uri.pathSegments.last;
      Share.shareFiles([fileEntity.path],
          text:
              '${AppLocalizations.of(Get.context!)!.sharing_file}: $fileName');
    } else {
      print('Selected item is not a file.');
    }
  }

  _getFileIcon(String fileName) {
    if (fileName.toLowerCase().endsWith('.pdf')) {
      return Image.asset(
        'assets/PDF.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.png')) {
      return Image.asset(
        'assets/PNG.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.jpg')) {
      return Image.asset(
        'assets/JPG.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.gif')) {
      return Image.asset(
        'assets/GIF.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.jpeg')) {
      return Image.asset(
        'assets/JPEG.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.bmp')) {
      return Image.asset(
        'assets/BMP.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.svg')) {
      return Image.asset(
        'assets/SVG.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.webp')) {
      return Image.asset(
        'assets/WEBP.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.heic')) {
      return Image.asset(
        'assets/logo.png',
        height: 40,
        width: 40,
      );
    } else {
      return const SizedBox();
    }
  }

  optionList(String imageName, VoidCallback onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: UiColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Image.asset(
            // "assets/Preveiw.png",
            imageName,
            height: 30,
            width: 30,
          ),
        ),
      ),
    );
  }

  Future<void> _openFile(FileSystemEntity file) async {
    try {
      final filePath = file.uri.toFilePath();
      await OpenFile.open(filePath);
    } catch (e) {
      print('Error opening file: $e');
      Get.snackbar(
        colorText: Colors.black,
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 4),
        "${AppLocalizations.of(Get.context!)!.error} !!!",
        AppLocalizations.of(Get.context!)!.no_app_found_to_open,
      );
    }
  }
}
