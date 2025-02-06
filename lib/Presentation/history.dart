import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
// import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as path;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  GlobalKey imageConvertorKey = GlobalKey();
  OverlayEntry? overlayEntry;

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
              child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.1, vertical: 22),
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

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 22),
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
                        padding: EdgeInsets.only(left: 12),
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
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 22, left: 12),
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  )),
              GestureDetector(
                key: imageConvertorKey,
                onTap: () {
                  showPopup(imageConvertorKey);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
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
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1),
            itemCount: allfiles.length,
            itemBuilder: (BuildContext context, int index) {
              String fileName = allfiles[index].uri.pathSegments.last;
              String displayedFileName =
                  fileName.length > 20 ? fileName.substring(0, 20) : fileName;

              String creationDate = _getCreationDate(allfiles[index]);

              return Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    color: UiColors.whiteColor,
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: GestureDetector(
                  onTap: () {
                    print(
                        "path.extension(allfiles[index].path ${path.extension(allfiles[index].path)}");
                    if ((path.extension(allfiles[index].path) == '.webp') ||
                        (path.extension(allfiles[index].path) == '.tiff') ||
                        (path.extension(allfiles[index].path) == '.raw') ||
                        (path.extension(allfiles[index].path) == '.psd') ||
                        (path.extension(allfiles[index].path) == '.heic') ||
                        (path.extension(allfiles[index].path) == '.ppm') ||
                        (path.extension(allfiles[index].path) == '.tga')) {
                      Get.snackbar(
                        colorText: Colors.black,
                        backgroundColor: Colors.white,
                        duration: const Duration(seconds: 4),
                        "Note",
                        "Cannot preview this file!",
                      );
                    } else {
                      _openFile(allfiles[index]);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 65.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: _getFileIcon(fileName),
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
                      // const Spacer(),
                      // PopupMenuButton(
                      //   color: Colors.white,
                      //   surfaceTintColor: Colors.white,
                      //   icon: const Icon(
                      //     Icons.more_vert,
                      //     size: 25.0,
                      //   ),
                      //   itemBuilder: (BuildContext context) {
                      //     return [
                      //       AppLocalizations.of(Get.context!)!.delete,
                      //       AppLocalizations.of(Get.context!)!.share,
                      //       "Download"
                      //     ].map((String choice) {
                      //       return PopupMenuItem<String>(
                      //         value: choice,
                      //         child: Text(
                      //           choice,
                      //           style: GoogleFonts.poppins(
                      //             textStyle: const TextStyle(
                      //                 fontWeight: FontWeight.w400, fontSize: 16.0),
                      //           ),
                      //         ),
                      //       );
                      //     }).toList();
                      //   },
                      //   onSelected: (value) async {
                      //     if (value == AppLocalizations.of(Get.context!)!.delete) {
                      //       _deleteFile(allfiles[index]);
                      //     } else if (value ==
                      //         AppLocalizations.of(Get.context!)!.share) {
                      //       _shareFile(allfiles[index]);
                      //     } else if (value == "Download") {
                      //       File file = File(allfiles[index].path);
                      //       print("###file $file");

                      //       // Separate the file name and extension
                      //       String fileName =
                      //           path.basenameWithoutExtension(file.path);
                      //       String fileExtension = path
                      //           .extension(file.path)
                      //           .replaceFirst('.', ''); // remove the leading dot
                      //       print("###fileName $fileName");
                      //       print("###fileExtension $fileExtension");

                      //       final bytes = await file.readAsBytes();

                      //       final result = await FileSaver.instance.saveAs(
                      //         name: fileName,
                      //         bytes: bytes,
                      //         ext: fileExtension == 'jpg'
                      //             ? 'jpg'
                      //             : fileExtension == 'jpeg'
                      //                 ? 'jpeg'
                      //                 : fileExtension == 'png'
                      //                     ? 'png'
                      //                     : fileExtension == 'gif'
                      //                         ? 'gif'
                      //                         : fileExtension == 'bmp'
                      //                             ? 'bmp'
                      //                             : fileExtension == 'svg'
                      //                                 ? 'svg'
                      //                                 : fileExtension == 'webp'
                      //                                     ? 'webp'
                      //                                     : fileExtension == 'pdf'
                      //                                         ? 'pdf'
                      //                                         : 'svg',
                      //         mimeType: fileExtension == 'jpg'
                      //             ? MimeType.jpeg
                      //             : fileExtension == 'jpeg'
                      //                 ? MimeType.jpeg
                      //                 : fileExtension == 'png'
                      //                     ? MimeType.png
                      //                     : fileExtension == 'gif'
                      //                         ? MimeType.gif
                      //                         : fileExtension == 'bmp'
                      //                             ? MimeType.bmp
                      //                             : fileExtension == 'svg'
                      //                                 ? MimeType.other
                      //                                 : fileExtension == 'webp'
                      //                                     ? MimeType.other
                      //                                     : fileExtension == 'pdf'
                      //                                         ? MimeType.pdf
                      //                                         : MimeType.other,
                      //       );

                      //       if (result != "") {
                      //         ScaffoldMessenger.of(Get.context!).showSnackBar(
                      //           const SnackBar(
                      //               content: Text(
                      //                   'File saved successfully in Downloads Folder!')),
                      //         );
                      //       } else {
                      //         ScaffoldMessenger.of(Get.context!).showSnackBar(
                      //           const SnackBar(
                      //               content: Text('Failed to save file.')),
                      //         );
                      //       }
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
              );
            },
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
    String folderPath = path.join(directory!.path, folderName);

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
    if (fileName.toLowerCase().endsWith('.doc') ||
        fileName.toLowerCase().endsWith('.docx')) {
      return Image.asset(
        'assets/DOC_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.xlsx')) {
      return Image.asset(
        'assets/XLS_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.txt')) {
      return Image.asset(
        'assets/TXT_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.pdf')) {
      return Image.asset(
        'assets/PDF_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.jpg')) {
      return Image.asset(
        'assets/jpg_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.gif')) {
      return Image.asset(
        'assets/gif_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.jpeg')) {
      return Image.asset(
        'assets/jpeg_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.png')) {
      return Image.asset(
        'assets/png_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.svg')) {
      return Image.asset(
        'assets/svg_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.webp')) {
      return Image.asset(
        'assets/webp_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.bmp')) {
      return Image.asset(
        'assets/bmp_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.tiff')) {
      return Image.asset(
        'assets/tiff_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.raw')) {
      return Image.asset(
        'assets/raw_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.psd')) {
      return Image.asset(
        'assets/psd_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.dds')) {
      return Image.asset(
        'assets/dds_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.heic')) {
      return Image.asset(
        'assets/heic_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.ppm')) {
      return Image.asset(
        'assets/ppm_icon.png',
        height: 40,
        width: 40,
      );
    } else if (fileName.toLowerCase().endsWith('.tga')) {
      return Image.asset(
        'assets/tga_icon.png',
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

  // aaaa() {
  //   final List<String> filterOptions = [
  //     "All",
  //     "JPG",
  //     "JPEG",
  //     "SVG",
  //     "WEBP",
  //     "BMP",
  //     "DOC",
  //     "TXT",
  //     "PDF",
  //     "XLS"
  //   ];

  //   Get.dialog(
  //     Scaffold(
  //       body:  Container(
  //         height: 200,
  //         width: 200,
  //         decoration: BoxDecoration(color: UiColors.whiteColor),
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [Text("Filter by")],
  //             ),
  //             Expanded(
  //               child: GridView.builder(
  //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: 3, // Number of columns in the grid
  //                   crossAxisSpacing: 10.0, // Spacing between columns
  //                   mainAxisSpacing: 10.0, // Spacing between rows
  //                   childAspectRatio: 2.5, // Adjust this for button size
  //                 ),
  //                 itemCount: filterOptions.length,
  //                 shrinkWrap:
  //                     true, // Prevents unnecessary scrolling inside another scrollable widget
  //                 physics:
  //                     const NeverScrollableScrollPhysics(), // Disables GridView's scrolling if inside a ListView
  //                 itemBuilder: (context, index) {
  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       color: Colors.blue, // Change color as needed
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     alignment: Alignment.center,
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       filterOptions[index],
  //                       style: const TextStyle(color: Colors.white, fontSize: 14),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //             Text("OOII"),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void showPopup(GlobalKey key) {
    // removePopup(); // Remove any existing popup first

    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 22,
        // popupPositionValue.value, // Centering
        top: offset.dy + size.height + 10, // Below the button
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              // Center(
              //   child: CustomPaint(
              //     size: const Size(30, 20), // Adjust size
              //     painter: TrianglePainter(),
              //   ),
              // ),
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
                              // if (index == 0) {
                              //   toolIndex.value = 10;
                              //   removePopup();
                              //   await homeScreenController.handleDriveImage();
                              // } else if (index == 1) {
                              //   toolIndex.value = 10;
                              //   removePopup();
                              //   await homeScreenController
                              //       .imageResizerFunction();
                              // } else if (index == 2) {
                              //   toolIndex.value = 10;
                              //   removePopup();
                              //   await homeScreenController
                              //       .imageCompressorFunction();
                              // }
                            },
                            child: Text("IIUUU"),
                            // customPopupButton(
                            //     "assets/upload_image.png",
                            //     // AppLocalizations.of(context)!.file_from_url,
                            //     "Upload Image",
                            //     index),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // if (index == 0) {
                              //   toolIndex.value = 10;
                              //   removePopup();
                              //   await homeScreenController.handleDriveImage();
                              // } else if (index == 1) {
                              //   toolIndex.value = 10;
                              //   removePopup();
                              //   await homeScreenController
                              //       .imageResizerFunction();
                              // } else if (index == 2) {
                              //   toolIndex.value = 10;
                              //   removePopup();
                              //   await homeScreenController
                              //       .imageCompressorFunction();
                              // }
                            },
                            child: Text("OOIII"),
                            // customPopupButton(
                            //     'assets/drive_image.png', "G-Drive", index
                            //     // AppLocalizations.of(context)!.choose_from_files,
                            //     ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // if (index == 0) {
                              //   toolIndex.value = 10;
                              //   removePopup();
                              //   await homeScreenController
                              //       .handleUrlImage(index);
                              // } else if (index == 1) {
                              //   toolIndex.value = 10;
                              //   removePopup();
                              //   await homeScreenController
                              //       .handleUrlImage(index);
                              // } else if (index == 2) {
                              //   toolIndex.value = 10;
                              //   removePopup();
                              //   await homeScreenController
                              //       .handleUrlImage(index);
                              // }
                            },
                            child: Text("OOOOO"),
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
      // ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }
}
