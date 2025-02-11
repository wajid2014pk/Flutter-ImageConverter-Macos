import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
// import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as path;
import 'package:text_scroll/text_scroll.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  OverlayEntry? _popupOverlay;
  // GlobalKey _filterButtonKey = GlobalKey(); // Key for the filter button

  RxList<int> selectedItems = <int>[0].obs; // Tracks selected indices
  RxList<String> filterDataList = <String>[].obs;
  RxList<String> filterSelectedItems = <String>[].obs;
  TextEditingController filterTextEditingController = TextEditingController();
  RxList<FileSystemEntity> filteredListTextField = <FileSystemEntity>[].obs;

  final List<String> filterOptions = [
    "All",
    "JPG",
    "GIF",
    "JPEG",
    "PNG",
    "SVG",
    "WEBP",
    "BMP",
    "TIFF",
    "RAW",
    "PSD",
    "DDS",
    "HEIC",
    "PPM",
    "TGA",
    "DOC",
    "TXT",
    "PDF",
    "XLSX"
  ];
  RxList<double> fileSize = <double>[].obs;
  GlobalKey filterKey = GlobalKey();

  RxList<FileSystemEntity> allfiles = <FileSystemEntity>[].obs;
  Directory? directory;

  RxInt selectCategory = 1.obs;
  RxInt selectedFileIndex = (-1).obs;
  RxBool isSearchBarVisible = false.obs;

  RxBool showOnTapOptions = false.obs;

  // TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  String selectedFormat = 'All';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () async {
      await _loadFiles();
      filteredListTextField.value = allfiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _removePopup,
      child: Scaffold(
        backgroundColor: UiColors.backgroundColor,
        body:
            // Obx(
            //   () =>
            Column(
          children: [
            Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.1, vertical: 22),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: _buildGridView(context)),
            ),
          ],
        ),
        // ),
        // ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    // if (filteredListTextField.isEmpty) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Lottie.asset('assets/empty.json'),
    //         InkWell(
    //           onTap: () {
    //             print("bdhdh ${showOnTapOptions.value}");
    //           },
    //           child: Text(
    //             AppLocalizations.of(Get.context!)!.no_data_found,
    //             style: GoogleFonts.poppins(
    //               fontSize: 14,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 250,
                  height: 32,
                  decoration: BoxDecoration(
                      color: UiColors.whiteColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Image.asset(
                          'assets/search_icon.png',
                          height: 16,
                          width: 16,
                        ),
                      ),
                      Container(
                        width: 210,
                        height: 32,
                        child: TextField(
                          controller: filterTextEditingController,
                          onChanged: (value) {
                            updateSearchQueryCountry(value);
                          },
                          decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: UiColors.newGreyColor,
                                // fontFamily: '',
                              ),
                              contentPadding:
                                  EdgeInsets.only(bottom: 16, left: 12),
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  )),
              Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            print("aaaa ${filterDataList}");
                          },
                          child: const Text("Filter by:")),
                      sizedBoxWidth,
                      Container(
                        height: 22,
                        constraints: BoxConstraints(maxWidth: Get.width * 0.2),
                        child: StatefulBuilder(
                            builder: (context, setStateOverlay) {
                          return Obx(
                            () => ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: filterSelectedItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return filterSelectedItems[index] == "All"
                                      ? SizedBox()
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          padding: const EdgeInsets.only(
                                              left: 6, right: 6),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: Colors.black
                                                      .withOpacity(0.1)),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            color: UiColors.whiteColor,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(filterSelectedItems[index]),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  for (int i = 0;
                                                      i < filterOptions.length;
                                                      i++) {
                                                    if (filterOptions[i] ==
                                                        filterSelectedItems[
                                                            index]) {
                                                      toggleSelection(
                                                          i, setStateOverlay);
                                                    }
                                                  }
                                                  filterSelectedItems
                                                      .removeAt(index);
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 100),
                                                      () async {
                                                    await _loadFiles();
                                                    filteredListTextField
                                                        .value = allfiles;
                                                  });
                                                },
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            UiColors.blackColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32)),
                                                    child: Image.asset(
                                                      'assets/close_icon.png',
                                                      height: 6,
                                                      width: 6,
                                                      color:
                                                          UiColors.whiteColor,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        );
                                }),
                          );
                        }),
                      )
                    ],
                  ),
                  sizedBoxWidth,
                  GestureDetector(
                    key: filterKey,
                    onTap: () {
                      if (_popupOverlay == null) {
                        _showPopup(context);
                      } else {
                        _removePopup();
                      }
                      // showPopup(imageConvertorKey);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: UiColors.whiteColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: Image.asset(
                        'assets/filter.png',
                        height: 22,
                        width: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Obx(
          () => filteredListTextField.isEmpty
              ? Expanded(
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
                )
              : Expanded(
                  child: Obx(
                    () => GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1),
                      itemCount: filteredListTextField.length,
                      itemBuilder: (BuildContext context, int index) {
                        String fileName =
                            filteredListTextField[index].uri.pathSegments.last;
                        String displayedFileName = fileName.length > 20
                            ? fileName.substring(0, 20)
                            : fileName;

                        String creationDate =
                            _getCreationDate(filteredListTextField[index]);

                        return Container(
                          decoration: BoxDecoration(
                              // border: Border.all(),
                              color: UiColors.whiteColor,
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          child: GestureDetector(
                            onTap: () {
                              print(
                                  "path.extension(allfiles[index].path ${path.extension(filteredListTextField[index].path)}");
                              if ((path.extension(
                                          filteredListTextField[index].path) ==
                                      '.webp') ||
                                  (path.extension(
                                          filteredListTextField[index].path) ==
                                      '.tiff') ||
                                  (path.extension(
                                          filteredListTextField[index].path) ==
                                      '.raw') ||
                                  (path.extension(
                                          filteredListTextField[index].path) ==
                                      '.psd') ||
                                  (path.extension(
                                          filteredListTextField[index].path) ==
                                      '.heic') ||
                                  (path.extension(
                                          filteredListTextField[index].path) ==
                                      '.ppm') ||
                                  (path.extension(
                                          filteredListTextField[index].path) ==
                                      '.tga')) {
                                Get.snackbar(
                                  colorText: Colors.black,
                                  backgroundColor: Colors.white,
                                  duration: const Duration(seconds: 4),
                                  "Note",
                                  "Cannot preview this file!",
                                );
                              } else {
                                _openFile(filteredListTextField[index]);
                              }
                            },
                            onLongPress: () {
                              _deleteFile(filteredListTextField[index]);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _getFileIcon(fileName),
                                  const SizedBox(height: 12),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        child: TextScroll(
                                          displayedFileName,
                                          textAlign: TextAlign.start,

                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                          mode: TextScrollMode.endless,
                                          velocity: const Velocity(
                                              pixelsPerSecond: Offset(20, 0)),
                                          delayBefore:
                                              const Duration(milliseconds: 500),
                                          numberOfReps: 1111,
                                          pauseBetween:
                                              const Duration(milliseconds: 500),
                                          // textAlign: TextAlign.right,
                                          selectable: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            path
                                                .extension(
                                                    filteredListTextField[index]
                                                        .path)
                                                .split('.')[1]
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            " | ",
                                            style: TextStyle(
                                              color: UiColors.greyColor,
                                            ),
                                          ),
                                          Text(
                                            "${fileSize[index].toInt() == 0 ? fileSize[index].toStringAsPrecision(2) : fileSize[index].toInt().toString()} KB",
                                            style: TextStyle(
                                              color: UiColors.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ),
      ],
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

  void _selectCategory(List<int> indexes) {
    setState(() {
      selectedItems.value = indexes;
      _loadFiles();
    });
  }

  void _runFilter(String value) {
    setState(() {
      allfiles.value = allfiles
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
    String folderPath = path.join(directory!.path, folderName);

    if (await Directory(folderPath).exists()) {
      setState(() {
        // If "All" (index 0) is selected, show all files
        bool showAll = selectedItems.contains(0);

        allfiles.value = Directory(folderPath).listSync().where((file) {
          String extension =
              file.uri.pathSegments.last.split('.').last.toLowerCase();

          if (showAll) return true; // Show all files

          // Get selected formats from indexes
          List<String> selectedFormats = selectedItems
              .map((index) => filterOptions[index].toLowerCase())
              .toList();

          return selectedFormats.any((format) => extension == format);
        }).toList()
          ..sort(
              (a, b) => b.statSync().modified.compareTo(a.statSync().modified));

        fileSize.clear(); // Clear previous data
        for (var file in allfiles) {
          fileSize.add(getFileSizeInKB(File(file.path)));
        }
        print("fileSize: $fileSize");
      });
    } else {
      print('!!!! Directory does not exist: $folderPath');
    }
  }

  Future<void> _deleteFile(FileSystemEntity file) async {
    // for (int i = 0; i < file.length; i++) {
    //   try {
    //     await file[i].delete();
    //     showOnTapOptions.value = false;

    //     // Future.delayed(const Duration(milliseconds: 300), () {
    //     //   _loadFiles();
    //     // });
    //     // Reload files after deletion
    //   } catch (e) {
    //     print('Error deleting file: $e');
    //   }
    // }
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   _loadFiles();
    // });

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
    if (fileName.toLowerCase().endsWith('.doc') ||
        fileName.toLowerCase().endsWith('.docx')) {
      return Image.asset(
        'assets/DOC_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.xlsx')) {
      return Image.asset(
        'assets/XLS_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.txt')) {
      return Image.asset(
        'assets/TXT_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.pdf')) {
      return Image.asset(
        'assets/PDF_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.jpg')) {
      return Image.asset(
        'assets/jpg_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.gif')) {
      return Image.asset(
        'assets/gif_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.jpeg')) {
      return Image.asset(
        'assets/jpeg_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.png')) {
      return Image.asset(
        'assets/png_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.svg')) {
      return Image.asset(
        'assets/svg_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.webp')) {
      return Image.asset(
        'assets/webp_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.bmp')) {
      return Image.asset(
        'assets/bmp_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.tiff')) {
      return Image.asset(
        'assets/tiff_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.raw')) {
      return Image.asset(
        'assets/raw_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.psd')) {
      return Image.asset(
        'assets/psd_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.dds')) {
      return Image.asset(
        'assets/dds_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.heic')) {
      return Image.asset(
        'assets/heic_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.ppm')) {
      return Image.asset(
        'assets/ppm_icon.png',
        height: 45,
        width: 45,
      );
    } else if (fileName.toLowerCase().endsWith('.tga')) {
      return Image.asset(
        'assets/tga_icon.png',
        height: 45,
        width: 45,
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

  double getFileSizeInKB(File file) {
    final bytes = file.lengthSync();
    double size = bytes / 1024;

    return size;
  }

  void toggleSelection(int index, StateSetter setStateOverlay) {
    setStateOverlay(() {
      if (index == 0) {
        // If first button is selected, clear other selections
        selectedItems.clear();
        selectedItems.add(0);
      } else {
        // If any other button is selected, deselect the first button
        selectedItems.remove(0);
        if (selectedItems.contains(index)) {
          selectedItems.remove(index);
        } else {
          selectedItems.add(index);
        }
      }
      if (selectedItems.isEmpty) {
        selectedItems.add(0);
      }
    });
  }

  void _showPopup(BuildContext context) {
    _removePopup(); // Remove existing popup if open

    OverlayState overlayState = Overlay.of(context);

    _popupOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: 80, // Adjust based on where you want to show the popup
        right: 130,
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.none,
          child: Container(
            width: 300,
            height: 280, // Set a fixed height to avoid layout errors
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Filter By",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setStateOverlay) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          // physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 9,
                            mainAxisExtent: 35,
                          ),
                          itemCount: filterOptions.length, // Number of items
                          itemBuilder: (context, index) {
                            bool isSelected = selectedItems.contains(index);
                            return GestureDetector(
                              onTap: () {
                                toggleSelection(index, setStateOverlay);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? UiColors.blueColorNew
                                        : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    filterOptions[index],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _removePopup();
                      },
                      child: Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        filterSelectedItems.value = [];
                        print("selectedItems $selectedItems");
                        for (int i = 0; i < selectedItems.length; i++) {
                          filterSelectedItems
                              .add(filterOptions[selectedItems[i]]);
                        }

                        await _loadFiles();
                        filteredListTextField.value = allfiles;
                        _removePopup();
                      },
                      child: Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                          color: UiColors.blueColorNew,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Apply",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_popupOverlay!);
  }

  void _removePopup() {
    _popupOverlay?.remove();
    _popupOverlay = null;
  }

  // updateSearchQueryCountry(String query) {
  //   query = query.toLowerCase();
  //   print("allfiles ${allfiles.length}");
  //   filteredListTextField.clear();
  //   setState(() {
  //     if (query.isEmpty) {
  //       filteredListTextField.addAll(allfiles);
  //     } else {
  //       for (var item in allfiles) {
  //         String fileName = item.uri.pathSegments.last;
  //         String displayedFileName =
  //             fileName.length > 20 ? fileName.substring(0, 20) : fileName;
  //         if (displayedFileName.toLowerCase().contains(query)) {
  //           filteredListTextField.add(item);
  //         }
  //       }
  //     }
  //   });
  // }
  void updateSearchQueryCountry(String query) {
    query = query.toLowerCase();
    print("allfiles ${allfiles.length}");

    if (query.isEmpty) {
      filteredListTextField.value = List.from(allfiles);
    } else {
      filteredListTextField.value = allfiles.where((item) {
        String fileName = item.uri.pathSegments.last;
        String displayedFileName =
            fileName.length > 20 ? fileName.substring(0, 20) : fileName;
        return displayedFileName.toLowerCase().contains(query);
      }).toList();
    }
  }
}
