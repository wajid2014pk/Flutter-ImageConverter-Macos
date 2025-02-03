import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as im;
import 'package:excel/excel.dart' as xlsx;
import 'package:path/path.dart' as path;
import 'package:image_converter_macos/Constant/ai_config.dart';
import 'package:image_converter_macos/Constant/api_string.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Controller/PremiumPopUpController/premium_controller.dart';
import 'package:image_converter_macos/Presentation/conversion_result.dart';
import 'package:image_converter_macos/Presentation/convert_file.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:image_converter_macos/Screens/premium_popup.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dio/dio.dart' as api;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConvertImagesController extends GetxController {
  double sliderValue = 0.7;
  RxBool isError = false.obs;
  RxInt selectedIndex = 0.obs;
  DateTime dateTime = DateTime.now();

  int simpleLimit = 0;
  api.Dio dio = api.Dio();
  RxInt convertedSize = 0.obs;
  RxDouble progress = 0.0.obs;
  RxDouble percentage = 0.0.obs;
  RxBool loadingState = false.obs;

  RxBool isDownloading = false.obs;

  RxBool showLoader = false.obs;

  final payWallController = Get.put(PayWallController());
  RxList<String> textToolDataList = <String>[].obs;
  RxList<String> textToolImagePathList = <String>[].obs;
  RxString textToolData = "".obs;
  RxString textToolImagePath = "".obs;

  convertJpgToJpgMulti(BuildContext context, List<String>? filePath) async {
    List<File> imageFile = [];
    List<File> convertedFile = [];
    int counter = 0;
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          // var path =
          convertedFile.add(File(
              '${targetDirectoryPath}jpgtojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second} ${counter++}.jpg'));

          // print("%%%%path  $path");

          imageFile.add(File(filePath[i]));

          Directory(targetDirectoryPath).createSync(recursive: true);

          await imageFile[i].copy(convertedFile[i].path);
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpg",
            originalFilePath: convertedFile[0].path,
            convertedFile: convertedFile,
          ),
        );

        showLoader.value = false;
        for (int i = 0; i < filePath.length; i++) {
          print("%%%%converted Image ${imageFile[i].path}");
        }
      }
    } catch (e) {
      Get.offAll(() =>
          // BottomTab()
          // const HomePage()
          const HomeScreen(index: 1));
      print("%%%%Error of file $e");
    }
  }

  convertJpgToJpegMulti(BuildContext context, List<String>? filePath) async {
    List<File> imageFile = [];
    List<File> convertedFile = [];
    int counter = 0;
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          convertedFile.add(File(
              '${targetDirectoryPath}jpgtojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second} ${counter++}.jpeg'));

          imageFile.add(File(filePath[i]));

          Directory(targetDirectoryPath).createSync(recursive: true);

          await imageFile[i].copy(convertedFile[i].path);
        }
        print("imageFileimageFileimageFileimageFile $imageFile");
        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpeg",
            convertedFile: convertedFile,
            originalFilePath: convertedFile[0].path,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.to(() =>
              // const HomePage()
              const HomeScreen(index: 1)
          // BottomTab()
          );
      print("%%%%Error of file $e");
    }
  }

  convertJpgToBMPMulti(context, List<String>? filePath) async {
    List<File> imageFile = [];
    List<File> compressedImage = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          if (selectedIndex.value == 7) {
            // int bmpLimit = await SharedPref().getBmpLimit();

            // ++bmpLimit;
            // await SharedPref().setBmpLimit(bmpLimit);

            // log("how many times i am trigered ");
          }
          // log("££££££££££ @@@@@@@@@@@  Asad ${i}");
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          var path =
              '${targetDirectoryPath}jpgtobmp_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
          print("%%%%path BMP: $path");

          imageFile.add(File(filePath[i]));

          im.Image? image = im.decodeImage(await imageFile[i].readAsBytes());

          print("%%%%image BMP: $image");

          im.Image smallerImage = im.copyResize(image!, width: 800);
          print("%%%%smallerImage BMP: $smallerImage");

          Directory(targetDirectoryPath)
              .createSync(recursive: true); // Ensure target directory exists

          compressedImage.add(
              File('$path.bmp')..writeAsBytesSync(im.encodeBmp(smallerImage)));
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            originalFilePath: compressedImage[0].path,
            convertedFile: compressedImage,
          ),
        );

        showLoader.value = false;
      }
    } catch (e) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => const HomePage(),
      //     // BottomTab(),
      //   ),
      // );
      Get.offAll(const HomeScreen(index: 1));

      print("%%%%Error of file webp: $e");
    }
  }

  convertJpgToGifMulti(context, List<String>? filePath) async {
    List<File> imageFile = [];
    List<File> compressedImage = [];
    try {
      showLoader.value = true;
      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          var path =
              '${targetDirectoryPath}jpgtogif_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
          print("%%%%path  $path");
          imageFile.add(File(filePath[i]));

          im.Image? image = im.decodeImage(await imageFile[i].readAsBytes());

          print("%%%%image $image");
          Uint8List imageBytes = await imageFile[i].readAsBytes();

          // Get the size in kilobytes (KB)
          double imageSizeInKB = imageBytes.lengthInBytes / 1024;
          im.Image smallerImage;
          // Check if the size is greater than 500KB
          if (imageSizeInKB > 500) {
            smallerImage = im.copyResize(image!, width: 300);
            print("Greater than 500");
          } else {
            smallerImage = im.copyResize(image!, width: 400);
            print("Less than 500");
          }

          Directory(targetDirectoryPath)
              .createSync(recursive: true); // Ensure target directory exists

          compressedImage.add(
              File('$path.gif')..writeAsBytesSync(im.encodeGif(smallerImage)));
        }

        Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            // dateTime: [getFormattedDateTime(dateTime)],
            convertedFile: compressedImage,
            originalFilePath: compressedImage[0].path,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen(index: 1)
          // BottomTab()
          );

      print("%%%%Error of file $e");
    }
  }

  convertJpgToPngMulti(context, List<String>? filePath) async {
    List<File> imageFile = [];
    List<File> compressedImage = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          var path =
              '${targetDirectoryPath}jpgtopng_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
          print("%%%%path  $path");

          imageFile.add(File(filePath[i]));
          im.Image? image = im.decodeImage(await imageFile[i].readAsBytes());
          im.Image smallerImage;
          print("%%%%image $image");
          Uint8List imageBytes = await imageFile[i].readAsBytes();
          // Get the size in kilobytes (KB)
          double imageSizeInKB = imageBytes.lengthInBytes / 1024;

          if (imageSizeInKB > 500) {
            smallerImage = im.copyResize(image!, width: 300);
            print("%%%%smallerImage $smallerImage");
          } else {
            smallerImage = im.copyResize(image!, width: 400);
            print("%%%%smallerImage $smallerImage");
          }

          Directory(targetDirectoryPath)
              .createSync(recursive: true); // Ensure target directory exists

          compressedImage.add(File('$path.png')
            ..writeAsBytesSync(im.encodePng(
              smallerImage,
              level: 4,
            )));
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".png",
            // dateTime: [getFormattedDateTime(dateTime)],
            convertedFile: compressedImage,
            originalFilePath: compressedImage[0].path,
          ),
        );

        showLoader.value = false;
      }
    } catch (e) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) => const HomePage()
      //       // BottomTab(),
      //       ),
      // );
      Get.offAll(const HomeScreen(index: 1));

      print("%%%%Error of file $e");
    }
  }

  convertJpgToPdfMulti(BuildContext context, List<String>? filePath) async {
    List<File> pdfFile = [];
    int counter = 0;
    showLoader.value = true;

    if (filePath == null) {
      return;
    }
    for (int i = 0; i < filePath.length; i++) {
      final File imageFile = File(filePath[i]);

      final pdf = pw.Document();

      final image = pw.MemoryImage(imageFile.readAsBytesSync());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Stack(
                children: [
                  pw.Center(child: pw.Image(image)),
                ],
              ),
            );
          },
        ),
      );

      Directory? dir = Platform.isMacOS
          ? await getApplicationCacheDirectory()
          : await getExternalStorageDirectory();

      // var path =
      pdfFile.add(File(
          '${dir?.path}/ImageConverter/jpgtopdf_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}${counter++}.pdf'));

      final file = File(pdfFile[i].path)..createSync(recursive: true);
      // print("path before $path");

      await file.writeAsBytes(await pdf.save());
    }

    await Get.to(
      () => ConversionResult(
        imageFormat: ".pdf",
        // dateTime: [getFormattedDateTime(dateTime)],
        convertedFile: pdfFile,
        originalFilePath: pdfFile[0].path,
      ),
    );

    showLoader.value = false;

    // print("File directory $file");

    print("File converting");
  }

  convertingIntoDiffFormatsMulti(BuildContext context, List<String> filePath,
      List<String> from, String to) async {
    isError.value = false;

    List<String> imageFile = [];
    List<File> selectedFile = [];
    String uploadurl = ApiString.apiUrl;
    // try {
    print("FFFFFF $filePath wweee${filePath.length}");
    print("eeeeee $from rrrrrrr${from.length}");
    print("eeeeee 1: $to");

    for (int i = 0; i < filePath.length; i++) {
      api.FormData formdata = api.FormData.fromMap({
        "file":
            await api.MultipartFile.fromFile(filePath[i], filename: filePath[i]
                //show only filename from path
                ),
        "from": from[i],
        "to": to,
      });
      api.Response? response;

      try {
        response = await dio.post(
          uploadurl,
          data: formdata,
          options: ApiString.options,
          onSendProgress: (int sent, int total) {
            percentage.value = normalizeValue(
                (double.parse(((sent / total) * 100).toStringAsFixed(2)))
                    .abs());
            loadingState.value = true;
            progress.value = percentage.value;
            print('Progress show1133 ${progress.value}');
          },
        );

        int dateTime = DateTime.now().microsecondsSinceEpoch;
        log("response of $i ${response}");
        Map valueMap = json.decode(response.data);
        Directory? dir = Platform.isMacOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        // imageFile.add(
        //     "${dir?.path}/ImageConverter/${from[i]}to${to}_$dateTime#${basename(valueMap['d_url'])}");
        // selectedFile.add(File(
        //     "${dir?.path}/ImageConverter/${from[i]}to${to}_$dateTime#${basename(valueMap['d_url'])}"));
        if (valueMap['d_url'] != null) {
          imageFile.add(
              "${dir?.path}/ImageConverter/${from[i]}to${to}_$dateTime.$to");
          selectedFile.add(File(
              "${dir?.path}/ImageConverter/${from[i]}to${to}_$dateTime.$to"));
          isDownloading.value = true;
          var downloadRes;
          try {
            downloadRes = await dio.download(
              "${valueMap['d_url']}",
              // path,
              imageFile[i],
              onReceiveProgress: (int recieve, int total) {
                percentage.value =
                    normalizeValue((recieve / total * 100)).abs();

                progress.value = percentage.value;

                // print('Progress show $progress');
              },
            );

            loadingState.value = false;
            isDownloading.value = false;
            setToolsValue();
          } catch (e) {
            log("message e $e");
          }
          print("Response Download $i===========> ${downloadRes}");
        }
      } catch (e) {
        log("message e $e");

        Get.offAll(const HomeScreen(index: 1));
        Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            // AppLocalizations.of(Get.context!)!
            //     .please_try_again_after_some_time
            "Please try again after some time");
        isError.value = true;
        return;
      }
    }
    print("OOPPP${[".$to"]}");
    if (isError.value) {
      return;
    } else {
      await Get.to(
        () => ConversionResult(
          imageFormat: ".$to",
          // dateTime: [getFormattedDateTime(dateTime)],
          convertedFile: selectedFile,
          originalFilePath: selectedFile[0].path,
        ),
      );
    }
  }

  Future setToolsValue() async {
    switch (selectedIndex.value) {
      case 5:
        // int limit = await SharedPref().getSVGValue();

        // ++limit;
        // log(" case 5 before========================> $limit ");
        // await SharedPref().setSVGValue(limit);

        break;
      case 6:
        // int limit = await SharedPref().getWEBPValue();
        // log(" case 6 before========================> $limit ");

        // limit++;
        // log(" setting case  6 ========================> $limit ");

        // await SharedPref().setWEBPValue(limit);

        break;
      case 7:
        // int limit = await SharedPref().getBmpLimit();

        // ++limit;

        // log(" setting case  7========================> $limit ");
        // await SharedPref().setBmpLimit(limit);

        break;
      case 12:
        // int limit = await SharedPref().getTiffLimit();
        // log(" before tiff========================> $limit ");

        // limit++;
        // log(" case 6 after ====>  $limit ");
        // await SharedPref().setTiffLimit(limit);

        break;
      case 13:
        // int limit = await SharedPref().getRawLimit();

        // limit++;
        // log(" setting case  13  $limit ");
        // await SharedPref().setRawLimit(limit);

        break;
      case 14:
        // int limit = await SharedPref().getPsdLimit();
        // log(" setting case  14 $limit ");

        // limit++;
        // await SharedPref().setPsdLimit(limit);

        break;
      case 15:
        // int limit = await SharedPref().getDdsLimit();
        // log(" setting case  15   $limit ");

        // limit++;
        // await SharedPref().setDdsLimit(limit);

        break;
      case 16:
        // int limit = await SharedPref().getHeicLimit();
        // log(" setting case  16$limit ");

        // limit++;
        // await SharedPref().setHeicLimit(limit);

        break;
      case 17:
        // int limit = await SharedPref().getPpmLimit();

        // limit++;
        // log(" ssetting case  17  $limit ");
        // await SharedPref().setPpmLimit(limit);

        break;
      case 18:
        // int limit = await SharedPref().getTgaLimit();
        // log(" setting case  18 $limit ");

        // limit++;
        // await SharedPref().setTgaLimit(limit);

        break;
    }
  }

  double normalizeValue(double value) {
    // print("Value ${value.abs()}");
    // print("UUYYY ${(value / (value + 2))}");
    if (value.abs() >= 100) {
      return 0.99;
    } else {
      return value / (value + 2);
    }
  }

  //Tif Conversions
  convertTifToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isMacOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/tiftojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        im.Image? tifImage = im.decodeTiff(await selectedFile.readAsBytes());
        File jpgImageFile = File('$path.jpg')
          ..writeAsBytesSync(
            im.encodeJpg(
              tifImage!,
            ),
          );

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpg",
            // dateTime: [getFormattedDateTime(dateTime)],
            convertedFile: [jpgImageFile],
            originalFilePath: jpgImageFile.path,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPG Image ${jpgImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertTifToPdf(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isMacOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/tiftopdf_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);
        print("%%%%selectedFile  $selectedFile");

        im.Image? tifImage = im.decodeTiff(await selectedFile.readAsBytes());
        final pdf = pw.Document();

        print("%%%%pdf  $pdf");

        final image = pw.MemoryImage(im.encodePng(tifImage!));

        print("%%%%image  $image");

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Stack(
                  children: [
                    pw.Center(child: pw.Image(image)),
                  ],
                ),
              );
            },
          ),
        );

        final file = File('$path.pdf')..createSync(recursive: true);
        print("path before $path");

        await file.writeAsBytes(await pdf.save());

        await Get.to(
          () => ConversionResult(
            imageFormat: ".pdf",
            // dateTime: [getFormattedDateTime(dateTime)],
            convertedFile: [file],
            originalFilePath: file.path,
          ),
        );
      }
      showLoader.value = false;
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertTifToPng(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isMacOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/tiftopng_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        im.Image? tifImage = im.decodeTiff(await selectedFile.readAsBytes());
        File pngImageFile = File('$path.png')
          ..writeAsBytesSync(
            im.encodePng(
              tifImage!,
            ),
          );

        convertedSize.value = await getFileSize(pngImageFile.path);

        await Get.to(
          () => ConversionResult(
            imageFormat: ".png",
            // dateTime: [getFormattedDateTime(dateTime)],
            convertedFile: [pngImageFile],
            originalFilePath: pngImageFile.path,
          ),
        );

        showLoader.value = false;

        print("%%%%converted PNG Image ${pngImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertTiffToGif(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isMacOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/tifftogif_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);
        print("%%%%selectedFile  $selectedFile");

        // Convert TIFF to GIF
        im.Image? tiffImage = im.decodeTiff(await selectedFile.readAsBytes());
        File gifImageFile = File('$path.gif')
          ..writeAsBytesSync(
            im.encodeGif(
              tiffImage!,
            ),
          );

        convertedSize.value = await getFileSize(gifImageFile.path);

        await Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            convertedFile: [gifImageFile],
            originalFilePath: gifImageFile.path,
          ),
        );

        showLoader.value = false;

        print("%%%%converted GIF Image: ${gifImageFile.path}");

        // You can save the GIF file wherever needed.
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertTiffToJpeg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isMacOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/tifftojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        // Convert TIFF to JPEG
        im.Image? tiffImage = im.decodeTiff(await selectedFile.readAsBytes());
        File jpegImageFile = File('$path.jpeg')
          ..writeAsBytesSync(
            im.encodeJpg(
              tiffImage!,
            ),
          );

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpeg",
            // dateTime: [getFormattedDateTime(dateTime)],
            convertedFile: [jpegImageFile],
            originalFilePath: jpegImageFile.path,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPEG Image ${jpegImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertTiffToBmp(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isMacOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/tifftobmp_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);
        print("%%%%selectedFile  $selectedFile");

        // Convert tiff to JPG
        im.Image? tiffImage = im.decodeTiff(await selectedFile.readAsBytes());

        // Convert JPG to BMP
        im.Image? jpgImage = im.copyResize(tiffImage!, width: 800);
        File bmpImageFile = File('$path.bmp')
          ..writeAsBytesSync(
            im.encodeBmp(
              jpgImage,
            ),
          );

        convertedSize.value = await getFileSize(bmpImageFile.path);
        if (selectedIndex.value == 7) {
          // int bmpLimit = await SharedPref().getBmpLimit();

          // ++bmpLimit;
          // await SharedPref().setBmpLimit(bmpLimit);

          log("how many times i am trigered ");
        }
        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            // dateTime: [getFormattedDateTime(dateTime)],
            convertedFile: [bmpImageFile],
            originalFilePath: bmpImageFile.path,
          ),
        );

        showLoader.value = false;

        print("%%%%compressed Image BMP: ${bmpImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertBmpToJpgMulti(BuildContext context, List<String>? filePath) async {
    List<File> selectedFile = [];
    List<File> jpgImageFile = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();
          print("%%%%directory $dir");

          var path =
              '${dir?.path}/ImageConverter/bmptojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
          print("%%%%path  $path");

          selectedFile.add(File(filePath[i]));

          im.Image? bmpImage =
              im.decodeImage(await selectedFile[i].readAsBytes());

          jpgImageFile.add(File('$path.jpg')
            ..writeAsBytesSync(
              im.encodeJpg(
                bmpImage!,
              ),
            ));
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpg",
            // dateTime: [getFormattedDateTime(dateTime)],

            convertedFile: jpgImageFile,
            originalFilePath: jpgImageFile[0].path,
          ),
        );

        showLoader.value = false;
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertBmpToPdfMulti(BuildContext context, List<String>? filePaths) async {
    List<File> directoryPath = [];
    // List<File> jpgImageFile = [];
    int counter = 0;
    try {
      showLoader.value = true;

      if (filePaths != null) {
        for (int i = 0; i < filePaths.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();
          print("%%%%directory $dir");

          // var directoryPath =
          directoryPath.add(File(
              '${dir?.path}/ImageConverter/bmptopdf_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}${counter++}'));
          print("%%%%directoryPath  $directoryPath");

          // Create the directory if it doesn't exist
          Directory(directoryPath[i].path).createSync(recursive: true);

          for (String filePath in filePaths) {
            File selectedFile = File(filePath);
            print("%%%%selectedFile  $selectedFile");

            im.Image? bmpImage =
                im.decodeImage(await selectedFile.readAsBytes());
            print("%%%%bmpImage  $bmpImage");

            final pdf = pw.Document();

            print("%%%%pdf  $pdf");

            final image = pw.MemoryImage(im.encodePng(bmpImage!));

            print("%%%%image  $image");

            pdf.addPage(
              pw.Page(
                pageFormat: PdfPageFormat.a4,
                build: (pw.Context context) {
                  return pw.Center(
                    child: pw.Stack(
                      children: [
                        pw.Center(child: pw.Image(image)),
                      ],
                    ),
                  );
                },
              ),
            );

            String fileName =
                selectedFile.path.split('/').last.replaceAll('.bmp', '');
            final file = File('$directoryPath/$fileName.pdf');

            await file.writeAsBytes(await pdf.save());
          }
          await Get.to(
            () => ConversionResult(
              imageFormat: ".pdf",

              convertedFile: directoryPath,
              originalFilePath: directoryPath[0].path,
              // [file],
            ),
          );

          showLoader.value = false;
        }
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertBmpToPngMulti(BuildContext context, List<String>? filePath) async {
    List<File> selectedFile = [];
    List<File> pngImageFile = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();
          print("%%%%directory $dir");

          var path =
              '${dir?.path}/ImageConverter/bmptopng_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
          print("%%%%path  $path");

          selectedFile.add(File(filePath[i]));

          im.Image? bmpImage =
              im.decodeImage(await selectedFile[i].readAsBytes());

          pngImageFile.add(File('$path.png')
            ..writeAsBytesSync(
              im.encodePng(
                bmpImage!,
              ),
            ));
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".png",
            convertedFile: pngImageFile,
            originalFilePath: pngImageFile[0].path,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertBmpToGifMulti(BuildContext context, List<String>? filePath) async {
    List<File> selectedFile = [];
    List<File> gifImageFile = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();
          print("%%%%directory $dir");

          var path =
              '${dir?.path}/ImageConverter/bmptogif_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
          print("%%%%path  $path");

          selectedFile.add(File(filePath[i]));
          print("%%%%selectedFile  $selectedFile");

          im.Image? bmpImage =
              im.decodeImage(await selectedFile[i].readAsBytes());

          gifImageFile.add(File('$path.gif')
            ..writeAsBytesSync(
              im.encodeGif(
                bmpImage!,
              ),
            ));
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            convertedFile: gifImageFile,
            originalFilePath: gifImageFile[0].path,
          ),
        );

        showLoader.value = false;
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertBmpToJpegMulti(BuildContext context, List<String>? filePath) async {
    List<File> selectedFile = [];
    List<File> jpegImageFile = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();
          print("%%%%directory $dir");

          var path =
              '${dir?.path}/ImageConverter/bmptojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
          print("%%%%path  $path");

          selectedFile.add(File(filePath[i]));

          im.Image? bmpImage =
              im.decodeImage(await selectedFile[i].readAsBytes());

          jpegImageFile.add(File('$path.jpeg')
            ..writeAsBytesSync(
              im.encodeJpg(
                bmpImage!,
              ),
            ));
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpeg",
            convertedFile: jpegImageFile,
            originalFilePath: jpegImageFile[0].path,
          ),
        );

        showLoader.value = false;
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertBmpToBmpMulti(BuildContext context, List<String>? filePath) async {
    List<File> imageFile = [];

    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          var path =
              '${targetDirectoryPath}bmptobmp_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.gif';
          print("%%%%path  $path");

          imageFile.add(File(filePath[i]));

          Directory(targetDirectoryPath).createSync(recursive: true);

          await imageFile[i].copy(path);
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            convertedFile: imageFile,
            originalFilePath: imageFile[0].path,
          ),
        );

        showLoader.value = false;
        if (selectedIndex.value == 7) {
          // int bmpLimit = await SharedPref().getBmpLimit();

          // ++bmpLimit;
          // await SharedPref().setBmpLimit(bmpLimit);

          log("how many times i am trigered ");
        }
      }
    } catch (e) {
      Get.offAll(() =>
              //  const HomePage()
              const HomeScreen(index: 1)

          // BottomTab()
          );
      print("%%%%Error of file $e");
    }
  }

  //GIF Conversion

  convertGifToPdfMulti(BuildContext context, List<String>? filePath) async {
    List<File> pdfFile = [];
    int counter = 0;
    showLoader.value = true;

    if (filePath == null) {
      return;
    }
    for (int i = 0; i < filePath.length; i++) {
      final File imageFile = File(filePath[i]);

      final pdf = pw.Document();

      final image = pw.MemoryImage(imageFile.readAsBytesSync());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Stack(
                children: [
                  pw.Center(child: pw.Image(image)),
                ],
              ),
            );
          },
        ),
      );

      Directory? dir = Platform.isMacOS
          ? await getApplicationCacheDirectory()
          : await getExternalStorageDirectory();

      // var path =
      pdfFile.add(File(
          '${dir?.path}/ImageConverter/giftopdf_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}${counter++}.pdf'));

      final file = File(pdfFile[i].path)..createSync(recursive: true);
      // print("path before $path");

      await file.writeAsBytes(await pdf.save());
    }

    await Get.to(
      () => ConversionResult(
        imageFormat: ".pdf",
        // dateTime: [getFormattedDateTime(dateTime)],
        convertedFile: pdfFile,
        originalFilePath: pdfFile[0].path,
      ),
    );

    showLoader.value = false;

// print("File directory $file");

    print("File converting");
  }

  convertGifToGifMulti(BuildContext context, List<String>? filePath) async {
    List<File> imageFile = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          var path =
              '${targetDirectoryPath}giftogif_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.gif';
          print("%%%%path  $path");

          imageFile.add(File(filePath[i]));

          Directory(targetDirectoryPath).createSync(recursive: true);

          await imageFile[i].copy(path);
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            convertedFile: imageFile,
            originalFilePath: imageFile[0].path,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.to(() => const HomeScreen(index: 1)

          // BottomTab()
          );
      print("%%%%Error of file $e");
    }
  }

  convertGifToPngMulti(BuildContext context, List<String>? filePath) async {
    List<File> pngImageFile = [];
    try {
      showLoader.value = true;

      print("%%%%filePath $filePath");

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();
          print("%%%%directory $dir");

          var path =
              '${dir?.path}/ImageConverter/giftopng_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
          print("%%%%path1 $path");

          print("%%%%path check  $path");

          im.Image? gifImage =
              im.decodeGif(await File(filePath[i]).readAsBytes());

          pngImageFile.add(
              File('$path.png')..writeAsBytesSync(im.encodePng(gifImage!)));
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".png",
            convertedFile: pngImageFile,
            originalFilePath: pngImageFile[0].path,
          ),
        );

        showLoader.value = false;
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertGifToJpgMulti(BuildContext context, List<String>? filePath) async {
    List<File> selectedFile = [];
    List<File> jpgImageFile = [];
    // try {
    showLoader.value = true;

    if (filePath != null) {
      for (int i = 0; i < filePath.length; i++) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isMacOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/giftojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        // File selectedFile =

        selectedFile.add(File(filePath[i]));

        print("%%%%selectedFile  $selectedFile");

        im.Image? gifImage = im.decodeGif(await selectedFile[i].readAsBytes());
        print("%%%%gifImage  $gifImage");

        // File jpgImageFile =
        jpgImageFile.add(File('$path.jpg')
          ..writeAsBytesSync(
            im.encodeJpg(
              gifImage!,
            ),
          ));
      }
      showLoader.value = false;
      await Get.to(
        () => ConversionResult(
          imageFormat: ".jpg",
          convertedFile: jpgImageFile,
          originalFilePath: jpgImageFile[0].path,
        ),
      );
    }
  }

  convertGifToBmpMulti(BuildContext context, List<String>? filePath) async {
    List<File> selectedFile = [];
    List<File> bmpImageFile = [];
    try {
      showLoader.value = true;
      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          if (selectedIndex.value == 7) {
            // int bmpLimit = await SharedPref().getBmpLimit();

            // ++bmpLimit;
            // await SharedPref().setBmpLimit(bmpLimit);

            log("how many times i am trigered ");
          }
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();
          print("%%%%directory $dir");

          var path =
              '${dir?.path}/ImageConverter/giftobmp_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
          print("%%%%path  $path");

          // File selectedFile =
          selectedFile.add(File(filePath[i]));
          print("%%%%selectedFile  $selectedFile");

          // Convert GIF to JPG
          im.Image? gifImage =
              im.decodeGif(await selectedFile[i].readAsBytes());

          // Convert JPG to BMP
          im.Image? jpgImage = im.copyResize(gifImage!, width: 800);
          // File bmpImageFile =
          bmpImageFile.add(File('$path.bmp')
            ..writeAsBytesSync(
              im.encodeBmp(
                jpgImage,
              ),
            ));
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            convertedFile: bmpImageFile,
            originalFilePath: bmpImageFile[0].path,
          ),
        );

        showLoader.value = false;
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertGifToJpegMulti(BuildContext context, List<String>? filePath) async {
    List<File> selectedFile = [];
    List<File> jpgImageFile = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          //Directory? dir = Platform.isMacOS

          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();
          print("%%%%directory $dir");

          var path =
              '${dir?.path}/ImageConverter/giftojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
          print("%%%%path  $path");

          // File selectedFile =

          selectedFile.add(File(filePath[i]));

          print("%%%%selectedFile  $selectedFile");

          im.Image? gifImage =
              im.decodeGif(await selectedFile[i].readAsBytes());
          print("%%%%gifImage  $gifImage");

          // File jpgImageFile =
          jpgImageFile.add(File('$path.jpeg')
            ..writeAsBytesSync(
              im.encodeJpg(
                gifImage!,
              ),
            ));
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpeg",
            // dateTime: [getFormattedDateTime(dateTime)],
            convertedFile: jpgImageFile,
            originalFilePath: jpgImageFile[0].path,
          ),
        );

        showLoader.value = false;

        // print("%%%%converted JPG Image ${jpgImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  //

  //Png Conversion
  convertPngToJPEGMulti(BuildContext context, List<String>? filePath) async {
    List<File> imageFile = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();

          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          var path =
              '${targetDirectoryPath}PngtoJpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
          print("%%%%path  $path");

          // File imageFile =

          imageFile.add(File(filePath[i]));

          // Use flutter_image_compress to decode PNG image
          List<int> compressedBytes =
              await FlutterImageCompress.compressWithList(
            await imageFile[i].readAsBytes(),
            format: CompressFormat.png,
          );

          // Convert compressed bytes to Image object
          im.Image? image = im.decodeImage(Uint8List.fromList(compressedBytes));

          print("%%%%image $image");

          im.Image smallerImage = im.copyResize(image!, width: 800);
          print("%%%%smallerImage $smallerImage");

          Directory(targetDirectoryPath).createSync(recursive: true);

          // Use flutter_image_compress to encode Image as GIF
          File compressedImage = File('$path.jpeg')
            ..writeAsBytesSync(
              await FlutterImageCompress.compressWithList(
                im.encodeJpg(smallerImage),
                format: CompressFormat.jpeg,
              ),
            );

          print("%%%%compressed Image ${compressedImage.path}");
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpeg",
            convertedFile: imageFile,
            originalFilePath: imageFile[0].path,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.to(() => const HomeScreen(index: 1));

      print("%%%%Error of file $e");
    }
  }

  convertPngToGifMulti(context, List<String>? filePath) async {
    List<File> imageFile = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();

          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          var path =
              '${targetDirectoryPath}Pngtogif_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
          print("%%%%path  $path");

          // File imageFile =

          imageFile.add(File(filePath[i]));

          im.Image? image = im.decodeImage(await imageFile[i].readAsBytes());

          print("%%%%image $image");

          im.Image smallerImage = im.copyResize(image!, width: 800);
          print("%%%%smallerImage $smallerImage");

          Directory(targetDirectoryPath)
              .createSync(recursive: true); // Ensure target directory exists

          File compressedImage = File('$path.gif')
            ..writeAsBytesSync(im.encodeGif(smallerImage));

          print("%%%%compressed Image ${compressedImage.path}");
        }
        await Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            convertedFile: imageFile,
            originalFilePath: imageFile[0].path,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HomeScreen(index: 1)

            // BottomTab(),
            ),
      );

      print("%%%%Error of file $e");
    }
  }

  convertPngToBMPMulti(context, List<String>? filePath) async {
    List<File> imageFile = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          if (selectedIndex.value == 7) {
            // int bmpLimit = await SharedPref().getBmpLimit();

            // ++bmpLimit;
            // await SharedPref().setBmpLimit(bmpLimit);

            log("how many times i am trigered ");
          }
          DateTime dateTime = DateTime.now();
          //Directory? dir = Platform.isMacOS

          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          var path =
              '${targetDirectoryPath}Pngtobmp_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
          print("%%%%path BMP: $path");

          // File imageFile =
          imageFile.add(File(filePath[i]));

          im.Image? image = im.decodeImage(await imageFile[i].readAsBytes());

          print("%%%%image BMP: $image");

          im.Image smallerImage = im.copyResize(image!, width: 800);
          print("%%%%smallerImage BMP: $smallerImage");

          Directory(targetDirectoryPath)
              .createSync(recursive: true); // Ensure target directory exists

          File compressedImage = File('$path.bmp')
            ..writeAsBytesSync(im.encodeBmp(smallerImage));

          print("%%%%compressed Image BMP: ${compressedImage.path}");
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            // dateTime: [getFormattedDateTime(dateTime)],
            convertedFile: imageFile,
            originalFilePath: imageFile[0].path,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HomeScreen(index: 1)),
      );

      print("%%%%Error of file webp: $e");
    }
  }

  convertPngToJpgMulti(BuildContext context, List<String>? filePath) async {
    List<File> imageFile = [];
    List<File> compressedImage = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();

          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          var path =
              '${targetDirectoryPath}pngtojpg_$dateTime#File ${getFormattedDateTime(dateTime)}';
          print("%%%%path  $path");

          // File imageFile =
          imageFile.add(File(filePath[i]));

          List<int> bytes = await FlutterImageCompress.compressWithList(
            imageFile[i].readAsBytesSync(),
            minHeight: 800,
            minWidth: 800,
            quality: 88,
          );

          Directory(targetDirectoryPath).createSync(recursive: true);

          // File compressedImage =

          compressedImage.add(File('$path.jpg')..writeAsBytesSync(bytes));
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpg",
            // dateTime: [getFormattedDateTime(dateTime)],
            convertedFile: compressedImage,
            originalFilePath: compressedImage[0].path,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.to(() =>
          // BottomTab()
          const HomeScreen(index: 1));
      print("%%%%Error of file $e");
    }
  }

  convertPngToPngMulti(BuildContext context, List<String>? filePath) async {
    List<File> imageFile = [];
    try {
      showLoader.value = true;

      if (filePath != null) {
        for (int i = 0; i < filePath.length; i++) {
          DateTime dateTime = DateTime.now();
          Directory? dir = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          var targetDirectoryPath = '${dir?.path}/ImageConverter/';

          var path =
              '${targetDirectoryPath}pngtopng_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.png';
          print("%%%%path  $path");

          // File imageFile =

          imageFile.add(File(filePath[i]));

          Directory(targetDirectoryPath).createSync(recursive: true);

          await imageFile[i].copy(path);
        }

        await Get.to(
          () => ConversionResult(
            imageFormat: ".png",
            convertedFile: imageFile,
            originalFilePath: imageFile[0].path,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.to(() => const HomeScreen(index: 1));
      print("%%%%Error of file $e");
    }
  }

  convertPngToPdfMulti(BuildContext context, List<String>? filePath) async {
    List<File> pdfFile = [];
    int counter = 0;
    showLoader.value = true;

    if (filePath == null) {
      return;
    }
    for (int i = 0; i < filePath.length; i++) {
      final File imageFile = File(filePath[i]);

      final pdf = pw.Document();

      final image = pw.MemoryImage(imageFile.readAsBytesSync());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Stack(
                children: [
                  pw.Center(child: pw.Image(image)),
                ],
              ),
            );
          },
        ),
      );

      Directory? dir = Platform.isMacOS
          ? await getApplicationCacheDirectory()
          : await getExternalStorageDirectory();

      // var path =
      pdfFile.add(File(
          '${dir?.path}/ImageConverter/pngtopdf_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}${counter++}.pdf'));

      final file = File(pdfFile[i].path)..createSync(recursive: true);
      // print("path before $path");

      await file.writeAsBytes(await pdf.save());
    }

    await Get.to(
      () => ConversionResult(
        imageFormat: ".pdf",
        // dateTime: [getFormattedDateTime(dateTime)],
        convertedFile: pdfFile,
        originalFilePath: pdfFile[0].path,
      ),
    );

    showLoader.value = false;

// print("File directory $file");

    print("File converting");
  }

  conversionOptionList(BuildContext context, List<String> dataList) async {
    // Variable to store the result
    bool showOtherConversions = dataList.every((path) {
      final extension =
          path.split('.').last.toLowerCase(); // Get the file extension
      return ['png', 'jpg', 'jpeg']
          .contains(extension); // Check if it's one of the allowed extensions
    });

    // await getAllLimitValues();
    // log("tiff VAlue ==========> ${tiffLimit.value}");
    // usedConversion = await SharedPref().getToolValue();
    // print("####1 usedConversion $usedConversion");

    print("showOtherConversions $showOtherConversions");
    return showDialog(
      barrierDismissible: true,
      context: Get.context!,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                insetPadding: const EdgeInsets.only(top: 0),
                elevation: 4.0,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          child: Center(
                            child: Text(
                              "Choose File Format",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: UiColors.blackColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.close)),
                    ],
                  ),
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          conversionOptions(
                              extensionImage: 'DOC_icon',
                              index: 1,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'PDF_icon',
                              index: 2,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'TXT_icon',
                              index: 3,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'XLS_icon',
                              index: 4,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'jpg_icon',
                              index: 5,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'gif_icon',
                              index: 6,
                              imagePath: dataList),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          conversionOptions(
                              extensionImage: 'jpeg_icon',
                              index: 7,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'png_icon',
                              index: 8,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'svg_icon',
                              index: 9,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'webp_icon',
                              index: 10,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'bmp_icon',
                              index: 11,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'tiff_icon',
                              index: 12,
                              imagePath: dataList),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      // showOtherConversions
                      //     ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          conversionOptions(
                              extensionImage: 'raw_icon',
                              index: 13,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'psd_icon',
                              index: 14,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'dds_icon',
                              index: 15,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'heic_icon',
                              index: 16,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'ppm_icon',
                              index: 17,
                              imagePath: dataList),
                          conversionOptions(
                              extensionImage: 'tga_icon',
                              index: 18,
                              imagePath: dataList),
                        ],
                      )
                      // : const SizedBox(),
                      // const SizedBox(
                      //   height: 6,
                      // ),
                      // showOtherConversions
                      //     ? Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //         children: [
                      //           conversionOptions(
                      //               extensionImage: 'ppm',
                      //               index: 17,
                      //               imagePath: dataList),
                      //           conversionOptions(
                      //               extensionImage: 'tga',
                      //               index: 18,
                      //               imagePath: dataList),
                      //           conversionOptions(
                      //               extensionImage: 'doc',
                      //               index: 8,
                      //               imagePath: dataList),
                      //           conversionOptions(
                      //               extensionImage: 'xlsx',
                      //               index: 11,
                      //               imagePath: dataList),
                      //         ],
                      //       )
                      //     : const SizedBox(),
                      // const SizedBox(
                      //   height: 6,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     conversionOptions(
                      //         extensionImage: 'text',
                      //         index: 9,
                      //         imagePath: dataList),
                      //     conversionOptions(
                      //         extensionImage: 'pdf_image',
                      //         index: 10,
                      //         imagePath: dataList),
                      //     showOtherConversions
                      //         ? const SizedBox(height: 52, width: 68)
                      //         : conversionOptions(
                      //             extensionImage: 'xlsx',
                      //             index: 11,
                      //             imagePath: dataList),
                      //     const SizedBox(height: 52, width: 68),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  conversionOptions({
    required String extensionImage,
    required int index,
    required List<String> imagePath,
  }) {
    return GestureDetector(
      onTap: () async {
        await AIHandler.checkInternet();

        selectedIndex.value = index;
        // await getAllLimitValues();
        print("selectedIndex1 ${selectedIndex.value}");
        // Get.back();
        if (selectedIndex.value == 5 ||
            selectedIndex.value == 6 ||
            selectedIndex.value == 12 ||
            selectedIndex.value == 13 ||
            selectedIndex.value == 14 ||
            selectedIndex.value == 15 ||
            selectedIndex.value == 16 ||
            selectedIndex.value == 17 ||
            selectedIndex.value == 18) {
          svgAndBmpApi.value = true;
        }
        // simpleLimit = await SharedPref().getToolValue();
        // int webpValue = await SharedPref().getWEBPValue();
        // int svgValue = await SharedPref().getSVGValue();
        if (selectedIndex.value == 1 ||
            selectedIndex.value == 2 ||
            selectedIndex.value == 3 ||
            selectedIndex.value == 4 ||
            selectedIndex.value == 7) {
          // print("image path 111 $imagePath");
          // if (selectedIndex.value == 7) {
          //   //  Bmp Limit Check

          //   if (payWallController.isPro.value) {
          //     Get.to(() => ConvertFile(imagePath: imagePath));
          //   } else {
          //     // Get.to(const PremiumPage());
          //     PremiumPopUp().premiumScreenPopUp(Get.context!);
          //   }
          // } else {
          //   Get.to(() => ConvertFile(imagePath: imagePath));
          // }
          print("selectedIndex2 ${selectedIndex.value}");
          // Get.back();

          // Get.to(() => ConvertFile(imagePath: imagePath));
          print("BBBBB $imagePath");
        } else {
          // image to excel tool------------------------
          if (selectedIndex.value == 11) {
            if (isInternetConneted.value) {
              // if (bottomNavBarController.currentScans.value < scanLmit.value) {
              // log("bottomNavBarController.currentScans ${bottomNavBarController.currentScans}");
              if (imagePath.length > 1) {
                Get.snackbar(
                    backgroundColor: UiColors.whiteColor,
                    duration: const Duration(seconds: 4),
                    AppLocalizations.of(Get.context!)!.attention,
                    "Only 1 image should be selected"
                    // AppLocalizations.of(Get.context!)!
                    //     .only_1_image_should_be_selected,
                    );
                // Get.to(() => ConvertFile(imagePath: [imagePath[0]]));
              } else {
                Get.to(() => ConvertFile(imagePath: imagePath));
              }

              // } else {
              //   // Get.snackbar("title", "Scan Limit Reached!");
              //   // limitDialogue(Get.context!);
              //    PremiumPopUp().premiumScreenPopUp(Get.context!);
              // }
            } else {
              Get.back();
              Get.snackbar(
                  backgroundColor: UiColors.whiteColor,
                  duration: const Duration(seconds: 4),
                  AppLocalizations.of(Get.context!)!.attention,
                  // AppLocalizations.of(Get.context!)!
                  //     .please_check_your_internet_connection,
                  "Please check your internet connection");
            }
          }
          // image to excel tool------------------------
          //--------image to text tool----------------
          if (selectedIndex.value == 9 || selectedIndex.value == 8) {
            if (imagePath.length > 1) {
              Get.snackbar(
                  backgroundColor: UiColors.whiteColor,
                  duration: const Duration(seconds: 4),
                  AppLocalizations.of(Get.context!)!.attention,
                  // AppLocalizations.of(Get.context!)!
                  //     .only_1_image_should_be_selected,
                  "Only 1 image should be selected");
            } else {
              if (payWallController.isPro.value) {
                Get.to(() => ConvertFile(imagePath: imagePath));
              } else {
                // Get.to(const PremiumPage());
                PremiumPopUp().premiumScreenPopUp(Get.context!);
              }
            }
          }
          //---------image to text tool ---------------

          if (selectedIndex.value == 5) {
            //------------- Svg Tool Limit Check

            if (payWallController.isPro.value) {
              Get.to(() => ConvertFile(imagePath: imagePath));
            } else {
              // Get.to(const PremiumPage());
              PremiumPopUp().premiumScreenPopUp(Get.context!);
            }
          }
          if (selectedIndex.value == 12 ||
              selectedIndex.value == 13 ||
              selectedIndex.value == 14 ||
              selectedIndex.value == 15 ||
              selectedIndex.value == 16 ||
              selectedIndex.value == 17 ||
              selectedIndex.value == 18) {
            if (Platform.isAndroid) {
              // if (toolValue < 10 || isPremium.value) {
              //   Get.to(() => ConvertFile(imagePath: imagePath));
              // } else {
              //   limitDialogue(Get.context!);
              // }

              // log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ selectedIndex.value == 12  ${selectedIndex.value == 12}");
              // log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@isPremium.value ${!isPremium.value}");
              // log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ selectedIndex.value ${tiffLimit.value >= 5}");
              // --------------------- TIFF LIMIT CHECK
              if (selectedIndex.value == 12) {
                // if (tiffLimit.value >= 5 && !isPremium.value) {
                //   // Get.to(() => const PremiumPage());
                //   log("bcccdscsdcvsdcvaadasdfadsrvsdfvdfsvdsfcvbsfdxcvbdfxvdca");

                //   limitDialogue(Get.context!);
                // } else {
                //   log("bcccdscsdcvsdcvadca");
                Get.to(() => ConvertFile(imagePath: imagePath));
                // }
              }
              // --------------------- RAW LIMIT CHECK
              else if (selectedIndex.value == 13) {
                // if (rawLimit.value >= 5 && !isPremium.value) {
                //   // Get.to(() => const PremiumPage());
                //   limitDialogue(Get.context!);
                // } else {
                Get.to(() => ConvertFile(imagePath: imagePath));
                // }
              }
              // // --------------------- PSD LIMIT CHECK
              else if (selectedIndex.value == 14) {
                // if (psdLimit.value >= 5 && !isPremium.value) {
                //   // Get.to(() => const PremiumPage());
                //   limitDialogue(Get.context!);
                // } else {
                Get.to(() => ConvertFile(imagePath: imagePath));
                // }
              }
              // // --------------------- DDS LIMIT CHECK
              else if (selectedIndex.value == 15) {
                // if (ddsLimit.value >= 5 && !isPremium.value) {
                //   // Get.to(() => const PremiumPage());
                //   limitDialogue(Get.context!);
                // } else {
                Get.to(() => ConvertFile(imagePath: imagePath));
                // }
              }
              // // --------------------- Heic LIMIT CHECK
              else if (selectedIndex.value == 16) {
                // if (heicLimit.value >= 5 && !isPremium.value) {
                //   // Get.to(() => const PremiumPage());
                //   limitDialogue(Get.context!);
                // } else {
                Get.to(() => ConvertFile(imagePath: imagePath));
                // }
              }
              // // --------------------- PPM LIMIT CHECK
              else if (selectedIndex.value == 17) {
                // if (ppmLimit.value >= 5 && !isPremium.value) {
                //   // Get.to(() => const PremiumPage());
                //   limitDialogue(Get.context!);
                // } else {
                Get.to(() => ConvertFile(imagePath: imagePath));
                // }
              }
              // // --------------------- Tga LIMIT CHECK
              else if (selectedIndex.value == 18) {
                // if (tgaLimit.value >= 5 && !isPremium.value) {
                //   // Get.to(() => const PremiumPage());
                //   limitDialogue(Get.context!);
                // } else {
                Get.to(() => ConvertFile(imagePath: imagePath));
                // }
              }
            } else {
              // if (isPremium.value) {
              //   Get.to(() => ConvertFile(imagePath: imagePath));
              // } else {
              PremiumPopUp().premiumScreenPopUp(Get.context!);
              // }
            }
          }
          if (selectedIndex.value == 6) {
            // if (webpLimit.value < 10 || isPremium.value) {
            //   Get.to(() => ConvertFile(imagePath: imagePath));
            // } else {
            // Get.to(() => const PremiumPage());
            PremiumPopUp().premiumScreenPopUp(Get.context!);

            // limitDialogue(Get.context!);
            // }
          }
          if (selectedIndex.value == 10) {
            log("toolValue $simpleLimit");

            if (payWallController.isPro.value) {
              Get.to(() => ConvertFile(imagePath: imagePath));
            } else {
              PremiumPopUp().premiumScreenPopUp(Get.context!);
            }
          }
        }
        await conversionMethod(imagePath);
      },
      child: Container(
        width: 70,
        height: 70,
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Image.asset(
                  // extensionImage,
                  'assets/$extensionImage.png',
                  height: 62,
                  width: 62,
                ),
                //FOR IOS

                // extensionImage == 'xlsx'
                //     ? !(bottomNavBarController.currentScans.value <
                //             scanLmit.value)
                //         ? !isPremium.value
                //             ? dimondWidget()
                //             : const SizedBox()
                //         : const SizedBox()
                //     : const SizedBox(),

                // FOR ANDROID
                // if (extensionImage == 'svg_image' &&
                //     Platform.isAndroid &&
                //     svgLimit.value > 9 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'bmp' &&
                //     Platform.isAndroid &&
                //     bmpLimit.value > 9 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'webp' &&
                //     Platform.isAndroid &&
                //     webpLimit.value > 9 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'tiff' &&
                //     Platform.isAndroid &&
                //     tiffLimit.value >= 5 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'raw' &&
                //     Platform.isAndroid &&
                //     rawLimit.value >= 5 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'psd' &&
                //     Platform.isAndroid &&
                //     psdLimit.value >= 5 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'dds' &&
                //     Platform.isAndroid &&
                //     ddsLimit.value >= 5 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'heic' &&
                //     Platform.isAndroid &&
                //     heicLimit.value >= 5 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'ppm' &&
                //     Platform.isAndroid &&
                //     ppmLimit.value >= 5 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'tga' &&
                //     Platform.isAndroid &&
                //     tgaLimit.value >= 5 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'pdf_image' &&
                //     Platform.isAndroid &&
                //     simpleLimit >= 10 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'doc' &&
                //     Platform.isAndroid &&
                //     simpleLimit >= 10 &&
                //     !isPremium.value)
                //   dimondWidget(),
                // if (extensionImage == 'text' &&
                //     Platform.isAndroid &&
                //     simpleLimit >= 10 &&
                //     !isPremium.value)
                //   dimondWidget(),

                // --------------------------------------------------------

                // extensionImage == 'svg_image' ||
                //         extensionImage == 'bmp' ||
                //         extensionImage == 'tiff' ||
                //         extensionImage == 'raw' ||
                //         extensionImage == 'psd' ||
                //         extensionImage == 'dds' ||
                //         extensionImage == 'heic' ||
                //         extensionImage == 'ppm' ||
                //         extensionImage == 'tga' ||
                //         extensionImage == 'doc' ||
                //         extensionImage == 'text' ||
                //         extensionImage == 'pdf_image'
                //     ? (Platform.isAndroid && usedConversion! > 9)
                //         ? !isPremium.value
                //             ? Positioned(
                //                 top: 5,
                //                 left: 5,
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(4),
                //                       color: Colors.black.withOpacity(0.1)),
                //                   child: Lottie.asset(
                //                     'assets/anim_diamond.json',
                //                     width: 20.0,
                //                   ),
                //                 ),
                //               )
                //             : const SizedBox()
                //         : const SizedBox()
                //     : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Future getAllLimitValues() async {
  //   // switch (selectedIndex.value) {
  //   //   case 5:
  //   svgLimit.value = await SharedPref().getSVGValue();
  //   log("svg ==========================================>${svgLimit.value}");

  //   // break;
  //   // case 6:
  //   webpLimit.value = await SharedPref().getWEBPValue();
  //   log("Webp =>${webpLimit.value}");
  //   // break;
  //   // case 7:
  //   bmpLimit.value = await SharedPref().getBmpLimit();
  //   log("bmp =>${bmpLimit.value}");

  //   // break;
  //   // case 12:
  //   tiffLimit.value = await SharedPref().getTiffLimit();
  //   log("getAllLimitValues tiff ===========================================>${tiffLimit.value}");

  //   // break;
  //   // case 13:
  //   rawLimit.value = await SharedPref().getRawLimit();
  //   log("raw =>${rawLimit.value}");

  //   // break;
  //   // case 14:
  //   psdLimit.value = await SharedPref().getPsdLimit();
  //   log("psd =>${psdLimit.value}");

  //   // break;
  //   // case 15:
  //   ddsLimit.value = await SharedPref().getDdsLimit();
  //   log("dsd =>${ddsLimit.value}");

  //   // break;
  //   // case 16:
  //   heicLimit.value = await SharedPref().getHeicLimit();
  //   log("heinc =>${heicLimit.value}");

  //   // break;
  //   // case 17:
  //   ppmLimit.value = await SharedPref().getPpmLimit();
  //   log("ppm =>${ppmLimit.value}");

  //   // break;
  //   // case 18:
  //   tgaLimit.value = await SharedPref().getTgaLimit();
  //   log("tga =>${tgaLimit.value}");

  //   // break;
  //   // default:
  //   // log("Deafukt");
  //   // }
  // }

  Future<int> getFileSize(String filePath) async {
    try {
      File file = File(filePath);
      int sizeInBytes = await file.length();
      return sizeInBytes;
    } catch (e) {
      print("Error getting file size: $e");
      return -1; // or handle the error appropriately
    }
  }

  String getFormattedDateTime(DateTime dateTime) {
    try {
      String period = dateTime.hour < 12 ? 'AM' : 'PM';
      int formattedHour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
      String formattedMinute = dateTime.minute.toString().padLeft(2, '0');
      String formattedSecond = dateTime.second.toString().padLeft(2, '0');

      String formattedDateTime =
          "$formattedHour:$formattedMinute:$formattedSecond $period";
      return formattedDateTime;
    } catch (e) {
      print("Error formatting date and time: $e");
      return "";
    }
  }

//------------image to text tool ------------------------
  imageToTextTool(BuildContext context, List<String> filePath,
      List<String> from, String to) async {
    isError.value = false;
    textToolDataList.value = [];
    textToolImagePathList.value = [];
    print("filePath $filePath");
    print("from $from");
    print("to $to");

    List<String> imageFile = [];
    List<File> selectedFile = [];
    // int counter = 0;

    try {
      for (int i = 0; i < filePath.length; i++) {
        api.Dio dio = api.Dio();
        api.FormData formData = api.FormData.fromMap({
          'api': 'c3c35a68edd632e4be0d619e57a8fff0',
          'image': await api.MultipartFile.fromFile(filePath[i]),
        });
        api.Response response = await dio.post(
          'https://www.cardscanner.co/api/imagetotext',
          data: formData,
          onSendProgress: (int sent, int total) {
            percentage.value = normalizeValue(
                (double.parse(((sent / total) * 100).toStringAsFixed(2)))
                    .abs());
            loadingState.value = true;
            progress.value = percentage.value;
            print('Progress show1133 ${progress.value}');
          },
          onReceiveProgress: (int recieve, int total) {
            percentage.value = normalizeValue((recieve / total * 100)).abs();

            progress.value = percentage.value;

            print('Progress show $progress');
          },
        );

        // DateTime dateTime = DateTime.now();
        print("response.data111 ${response.data}");

        // Get the application documents directory
        Directory? directory = Platform.isMacOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        textToolImagePath.value = filePath.first;
        // Define the directory path where the text file will be saved
        String targetDir = "${directory!.path}/ImageConverter/";

        // Create the directory if it doesn't exist
        Directory(targetDir).createSync(recursive: true);

        // Define the full path of the file with a unique name
        String filePathToSave =
            "${targetDir}imagetotext_${DateTime.now().microsecondsSinceEpoch}.txt";

        final file = File(filePathToSave);

        // Write the text response from the API to the file
        await file.writeAsString(
            response.data['text'] ?? ''); // Check if 'text' is valid

        print("File saved to: ${file.path}");

        imageFile.add(file.path);
        selectedFile.add(file);
        // counter++;

        log("Text => ${response.data['text']}");
        textToolData.value = response.data['text'];
        textToolDataList.add(response.data['text']);
        textToolImagePathList.add(filePath[i]);
      }
      if (isError.value) {
        // Get.offAll(const HomeScreen(index:1));
        return;
      } else {
        // await Get.to(() => const TextToolPreviewPage());
      }
    } catch (e) {
      Get.snackbar(
        backgroundColor: UiColors.whiteColor,
        duration: const Duration(seconds: 4),
        AppLocalizations.of(Get.context!)!.attention,
        // AppLocalizations.of(Get.context!)!
        //     .please_check_your_internet_connection,
        "Please check your internet connection",
      );
      // Get.back();
      Get.offAll(const HomeScreen(index: 1));
      print("%%%%Error saving file: $e");
    }
  }

//------------image to doc tool ------------------------
  imageToDocTool(BuildContext context, List<String> filePath, String to) async {
    {
      isError.value = false;
      textToolDataList.value = [];
      textToolImagePathList.value = [];
      print("filePath $filePath");
      // print("from $from");
      // print("to $to");

      List<String> imageFile = [];
      List<File> selectedFile = [];
      // int counter = 0;
      try {
        for (int i = 0; i < filePath.length; i++) {
          api.Dio dio = api.Dio();
          api.FormData formData = api.FormData.fromMap({
            'api': 'c3c35a68edd632e4be0d619e57a8fff0',
            'image': await api.MultipartFile.fromFile(filePath[i]),
          });
          api.Response response = await dio.post(
            'https://www.cardscanner.co/api/imagetotext',
            data: formData,
            onSendProgress: (int sent, int total) {
              percentage.value = normalizeValue(
                  (double.parse(((sent / total) * 100).toStringAsFixed(2)))
                      .abs());
              loadingState.value = true;
              progress.value = percentage.value;
              print('Progress show1133 ${progress.value}');
            },
            onReceiveProgress: (int recieve, int total) {
              percentage.value = normalizeValue((recieve / total * 100)).abs();

              progress.value = percentage.value;

              print('Progress show $progress');
            },
          );

          // DateTime dateTime = DateTime.now();
          print("response.data111 ${response.data}");

          // Get the application documents directory
          Directory? directory = Platform.isMacOS
              ? await getApplicationCacheDirectory()
              : await getExternalStorageDirectory();

          // Define the directory path where the text file will be saved
          String targetDir = "${directory!.path}/ImageConverter/";

          // Create the directory if it doesn't exist
          Directory(targetDir).createSync(recursive: true);

          // Define the full path of the file with a unique name
          String filePathToSave =
              "${targetDir}imagetodoc_${DateTime.now().microsecondsSinceEpoch}.doc";

          final file = File(filePathToSave);

          // Write the text response from the API to the file
          await file.writeAsString(
              response.data['text'] ?? ''); // Check if 'text' is valid

          print("File saved to: ${file.path}");

          imageFile.add(file.path);
          selectedFile.add(file);
          // counter++;

          textToolDataList.add(response.data['text']);
          textToolImagePathList.add(filePath[i]);
        }
        if (isError.value) {
          // Get.offAll(const HomeScreen(index:1));
          return;
        } else {
          await Get.to(
            () => ConversionResult(
              imageFormat: ".$to",
              // dateTime: [getFormattedDateTime(DateTime.now())],
              convertedFile: selectedFile,
              originalFilePath: selectedFile[0].path,
            ),
          );
        }
      } catch (e) {
        Get.snackbar(
          backgroundColor: UiColors.whiteColor,
          duration: const Duration(seconds: 4),
          AppLocalizations.of(Get.context!)!.attention,
          // AppLocalizations.of(Get.context!)!
          //     .please_check_your_internet_connection,
          "Please check your internet connection",
        );
        // Get.back();
        Get.offAll(const HomeScreen(index: 1));
        print("%%%%Error saving file: $e");
      }
    }
  }

//------------------image to excel ----------
  imageToExcelTool(
      BuildContext context, List<String> filePath, String to) async {
    int counter = 0;
    isError.value = false;
    xlsxImageList.value = [];
    xlsxFilePathList.value = [];
    dynamic result;
    for (String pickedImage in filePath) {
      xlsxImageList.add(pickedImage);
      print("### counter $counter");
      counter++;
      File imageFile = File(pickedImage);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      try {
        debugPrint("=>>>>>>>>>>>>>>>>>>>>> GOing for APi");
        result = await AIHandler().sendImageAndPromptToChatGPT(base64Image);
        excelString.value = result['choices'][0]['message']['content'];
        excelApiresult.value =
            {result['choices'][0]['message']['content']}.toString();
        debugPrint(
            "result is     ${result['choices'][0]['message']['content']}");
        String extractedText = result['choices'][0]['message']['content'];
        extractedText = extractedText.replaceAll('```json', '');
        List<dynamic> data = jsonDecode(extractedText);
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        debugPrint("=>>>>>>>>>>>>>>>>>>>>> Creating excel $data opo");

        await createMultipleExcel(data, false, counter);
        // if (Platform.isAndroid) {
        //   // currentScans.value = await fetchScanValueFromFile();

        //   incrementCounter();
        // } else {
        //   currentScans.value = prefs.getInt('scanLimit') ?? 0;
        //   currentScans.value = currentScans.value + 1;

        //   await prefs.setInt('scanLimit', currentScans.value);
        // }
        if (Platform.isAndroid) {
          // bottomNavBarController.increamentCounter();
        } else {
          // int limit = await SharedPref().getExcelLimit();
          // limit = limit + 1;
          // log("@@@@@@@@@@@@@   bottomNavBarController.currentScans.value $limit");
          // await SharedPref().setExcelLimit(limit);
        }
      } catch (e) {
        createMultipleExcel(['error'], true, counter);
      }

      // debugPrint("Hive Box Length ${hiveBox.values.length}");
    }
    if (isError.value) {
      // Get.offAll(const HomeScreen(index:1));
      return;
    } else {
      // await Get.to(() =>
      // ConversionResult(
      //   imageFormat: [".$to"],
      //   originalSize: const ['0.2'],
      //   convertedSize: const ['0.56', '0.22'],
      //   dateTime: [getFormattedDateTime(DateTime.now())],
      //   convertedFile: xlsxFilePathList,
      // ),
      // ImageToExcelTool(
      //   imagePath: filePath.first,
      //   excelFile: xlsxFilePathList.first,
      // )
      // );
    }
    debugPrint("done");
  }

  createMultipleExcel(List<dynamic> data, bool isError, int counter) async {
    // convertingExcel.value == false;
    // convertingExcel.value == true;
    try {
      var excel = xlsx.Excel.createExcel();
      xlsx.Sheet sheetObject = excel['Sheet1'];
      if (data.first == 'error') {
        sheetObject.appendRow(['error']);
      } else {
        // Convert JSON to Excel rows
        for (var row in data) {
          List<dynamic> excelRow = [];
          row.forEach((key, value) {
            excelRow.add(value);
          });
          sheetObject.appendRow(excelRow);
        }
      }

      // String fileName = 'Excel_${DateTime.now().microsecondsSinceEpoch ~/ 99999}';
      // String filePath = '${rawFilesFolder.value}/$fileName.xlsx';

      // String imageName =
      //     'IMG_${DateTime.now().microsecondsSinceEpoch ~/ 99999}.png';
      // String imagePath = '${rawFilesFolder.value}/$imageName';

      // final list = await File(capturedImage.value!.path).readAsBytes();
      // File(imagePath).writeAsBytes(list);
      Directory? directory = Platform.isMacOS
          ? await getApplicationCacheDirectory()
          : await getExternalStorageDirectory();

      // Define the directory path where the text file will be saved
      String targetDir = "${directory!.path}/ImageConverter/";

      // Create the directory if it doesn't exist
      Directory(targetDir).createSync(recursive: true);

      // Define the full path of the file with a unique name
      String filePathToSave =
          "${targetDir}imagetoexcel_${dateTime.year}-${dateTime.month}-${dateTime.day}_ ${dateTime.microsecond}$counter.xlsx";

      final file = File(filePathToSave);

      // Write the text response from the API to the file
      file.writeAsBytesSync(excel.encode()!);
      xlsxFilePathList.add(file);
      print("@@@path data ${file.path}");
    } catch (e) {
      Get.snackbar(
        backgroundColor: UiColors.whiteColor,
        duration: const Duration(seconds: 4),
        AppLocalizations.of(Get.context!)!.attention,
        // AppLocalizations.of(Get.context!)!
        //     .please_check_your_internet_connection,
        "Please check your internet connection",
      );
      Get.back();
    }
  }

//------------------image to excel-------------------
  conversionMethod(List<String> imagePath) async {
    // int toolValue = await SharedPref().getToolValue();

    // int webpValue = await SharedPref().getWEBPValue();
    // int svgValue = await SharedPref().getSVGValue();
    // CustomEvent.firebaseCustom('OUTPUT_FORMAT_SCREEN_CONVERT_FILES_BTN');
    print("RERETTTTT ${selectedIndex.value}");
    if (selectedIndex.value == 10) {
      // ++toolValue;
      // await SharedPref().setToolValue(toolValue);
      // if (pdfValue <= 10 || isPremium.value) {
      try {
       

        // await loopFunction();
        if (imagePath[0].toLowerCase().endsWith('.jpg') ||
            imagePath[0].toLowerCase().endsWith('.jpeg')) {
          selectedIndex.value == 1
              ? convertJpgToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertJpgToPdfMulti(Get.context!, imagePath)
                  : selectedIndex.value == 4
                      ? convertJpgToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath,
                              imagePath
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertJpgToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertJpgToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertJpgToBMPMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath[0].toLowerCase().endsWith('.png')) {
          selectedIndex.value == 1
              ? convertPngToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertPngToPdfMulti(Get.context!, imagePath)
                  : selectedIndex.value == 4
                      ? convertPngToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertPngToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertPngToJPEGMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertPngToBMPMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.gif')) {
          selectedIndex.value == 1
              ? convertGifToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertGifToPdfMulti(Get.context!, imagePath!)
                  : selectedIndex.value == 4
                      ? convertGifToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertGifToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertGifToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertGifToBmpMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.bmp')) {
          print("@@@@BMP");
          selectedIndex.value == 1
              ? convertBmpToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertBmpToPdfMulti(Get.context!, imagePath!)
                  : selectedIndex.value == 4
                      ? convertBmpToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertBmpToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertBmpToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertBmpToBmpMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.tiff') ||
            imagePath![0].toLowerCase().endsWith('.tif')) {
          print("@@@@tif");
          selectedIndex.value == 1
              ? convertTifToJpg(Get.context!, imagePath![0])
              : selectedIndex.value == 10
                  ? convertTifToPdf(Get.context!, imagePath![0])
                  : selectedIndex.value == 4
                      ? convertTifToPng(Get.context!, imagePath![0])
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertTiffToGif(Get.context!, imagePath[0])
                              : selectedIndex.value == 3
                                  ? convertTiffToJpeg(
                                      Get.context!, imagePath[0])
                                  : selectedIndex.value == 7
                                      ? convertTiffToBmp(
                                          Get.context!, imagePath[0])
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath[0].toLowerCase().endsWith('.heic')) {
          print("@@@@heic");

          convertingIntoDiffFormatsMulti(
            Get.context!,
            imagePath,
            imagePath
                .map((filePath) =>
                    path.extension(filePath).replaceFirst('.', ''))
                .toList(),
            selectedIndex.value == 1
                ? 'jpg'
                : selectedIndex.value == 2
                    ? 'gif'
                    : selectedIndex.value == 3
                        ? 'jpeg'
                        : selectedIndex.value == 4
                            ? 'png'
                            : selectedIndex.value == 5
                                ? 'svg'
                                : selectedIndex.value == 6
                                    ? 'webp'
                                    : selectedIndex.value == 7
                                        ? 'bmp'
                                        : selectedIndex.value == 8
                                            ? 'doc'
                                            : selectedIndex.value == 9
                                                ? 'txt'
                                                : selectedIndex.value == 10
                                                    ? 'pdf'
                                                    : selectedIndex.value == 11
                                                        ? 'xls'
                                                        : 'heic',
          );
        }
      } catch (e) {
        Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            // AppLocalizations.of(Get.context!)!
            //     .please_try_again_after_some_time
            "Please try again after some time");
      }
      // }
      // else {
      //   Get.to(() => const PremiumPage());
      // }
    } else if (selectedIndex.value == 6) {
      // int webp = await SharedPref().getWEBPValue();

      // ++webp;
      // await SharedPref().setWEBPValue(webp);
      // await SharedPref().setToolValue(toolValue);
      // if (webpValue <= 10 || isPremium.value) {
      try {
        if (selectedIndex.value == 0) {
          Get.snackbar(
              backgroundColor: UiColors.whiteColor,
              duration: const Duration(seconds: 4),
              AppLocalizations.of(Get.context!)!.attention,
              "Please select an option in which you want to convert"
              // AppLocalizations.of(Get.context!)!
              //     .please_select_an_option_in_which_you_want_to_convert,
              );
          conversionOptionList(Get.context!, imagePath);
        }

        // await loopFunction();
        if (imagePath[0].toLowerCase().endsWith('.jpg') ||
            imagePath[0].toLowerCase().endsWith('.jpeg')) {
          selectedIndex.value == 1
              ? convertJpgToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertJpgToPdfMulti(Get.context!, imagePath)
                  : selectedIndex.value == 4
                      ? convertJpgToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath,
                              imagePath
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertJpgToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertJpgToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertJpgToBMPMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.png')) {
          selectedIndex.value == 1
              ? convertPngToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertPngToPdfMulti(Get.context!, imagePath)
                  : selectedIndex.value == 4
                      ? convertPngToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath,
                              imagePath
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertPngToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertPngToJPEGMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertPngToBMPMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath,
                                              imagePath
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath[0].toLowerCase().endsWith('.gif')) {
          selectedIndex.value == 1
              ? convertGifToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertGifToPdfMulti(Get.context!, imagePath)
                  : selectedIndex.value == 4
                      ? convertGifToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath,
                              imagePath
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertGifToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertGifToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertGifToBmpMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath[0].toLowerCase().endsWith('.bmp')) {
          print("@@@@BMP");
          selectedIndex.value == 1
              ? convertBmpToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertBmpToPdfMulti(Get.context!, imagePath!)
                  : selectedIndex.value == 4
                      ? convertBmpToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath,
                              imagePath
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertBmpToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertBmpToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertBmpToBmpMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.tiff') ||
            imagePath![0].toLowerCase().endsWith('.tif')) {
          print("@@@@tif");
          selectedIndex.value == 1
              ? convertTifToJpg(Get.context!, imagePath![0])
              : selectedIndex.value == 10
                  ? convertTifToPdf(Get.context!, imagePath![0])
                  : selectedIndex.value == 4
                      ? convertTifToPng(Get.context!, imagePath![0])
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertTiffToGif(Get.context!, imagePath![0])
                              : selectedIndex.value == 3
                                  ? convertTiffToJpeg(
                                      Get.context!, imagePath![0])
                                  : selectedIndex.value == 7
                                      ? convertTiffToBmp(
                                          Get.context!, imagePath![0])
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.heic')) {
          print("@@@@heic");

          convertingIntoDiffFormatsMulti(
            Get.context!,
            imagePath!,
            imagePath!
                .map((filePath) =>
                    path.extension(filePath).replaceFirst('.', ''))
                .toList(),
            selectedIndex.value == 1
                ? 'jpg'
                : selectedIndex.value == 2
                    ? 'gif'
                    : selectedIndex.value == 3
                        ? 'jpeg'
                        : selectedIndex.value == 4
                            ? 'png'
                            : selectedIndex.value == 5
                                ? 'svg'
                                : selectedIndex.value == 6
                                    ? 'webp'
                                    : selectedIndex.value == 7
                                        ? 'bmp'
                                        : selectedIndex.value == 8
                                            ? 'doc'
                                            : selectedIndex.value == 9
                                                ? 'txt'
                                                : selectedIndex.value == 10
                                                    ? 'pdf'
                                                    : selectedIndex.value == 11
                                                        ? 'xls'
                                                        : 'heic',
          );
        }
      } catch (e) {
        Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            "Please try agin after some time"
            // AppLocalizations.of(Get.context!)!
            //     .please_try_again_after_some_time
            );
      }
      // } else {
      //   Get.to(() => const PremiumPage());
      // }
    } else if (selectedIndex.value == 5) {
      // ++toolValue;
      // await SharedPref().setToolValue(toolValue);
      // int svgLimit = await SharedPref().getSVGValue();

      // ++svgLimit;
      // await SharedPref().setSVGValue(svgLimit);
      // if (svgValue <= 10 || isPremium.value) {
      try {
        if (selectedIndex.value == 0) {
          Get.snackbar(
              backgroundColor: UiColors.whiteColor,
              duration: const Duration(seconds: 4),
              AppLocalizations.of(Get.context!)!.attention,
              "Please select an option in which you want to convert"
              // AppLocalizations.of(Get.context!)!
              //     .please_select_an_option_in_which_you_want_to_convert,
              );
          conversionOptionList(Get.context!, imagePath);
        }

        // await loopFunction();
        if (imagePath![0].toLowerCase().endsWith('.jpg') ||
            imagePath![0].toLowerCase().endsWith('.jpeg')) {
          selectedIndex.value == 1
              ? convertJpgToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertJpgToPdfMulti(Get.context!, imagePath)
                  : selectedIndex.value == 4
                      ? convertJpgToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath,
                              imagePath
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertJpgToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertJpgToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertJpgToBMPMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath,
                                              imagePath
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath[0].toLowerCase().endsWith('.png')) {
          selectedIndex.value == 1
              ? convertPngToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertPngToPdfMulti(Get.context!, imagePath)
                  : selectedIndex.value == 4
                      ? convertPngToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertPngToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertPngToJPEGMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertPngToBMPMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.gif')) {
          selectedIndex.value == 1
              ? convertGifToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertGifToPdfMulti(Get.context!, imagePath!)
                  : selectedIndex.value == 4
                      ? convertGifToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertGifToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertGifToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertGifToBmpMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.bmp')) {
          print("@@@@BMP");
          selectedIndex.value == 1
              ? convertBmpToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertBmpToPdfMulti(Get.context!, imagePath!)
                  : selectedIndex.value == 4
                      ? convertBmpToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertBmpToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertBmpToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertBmpToBmpMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.tiff') ||
            imagePath![0].toLowerCase().endsWith('.tif')) {
          print("@@@@tif");
          selectedIndex.value == 1
              ? convertTifToJpg(Get.context!, imagePath![0])
              : selectedIndex.value == 10
                  ? convertTifToPdf(Get.context!, imagePath![0])
                  : selectedIndex.value == 4
                      ? convertTifToPng(Get.context!, imagePath![0])
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertTiffToGif(Get.context!, imagePath![0])
                              : selectedIndex.value == 3
                                  ? convertTiffToJpeg(
                                      Get.context!, imagePath![0])
                                  : selectedIndex.value == 7
                                      ? convertTiffToBmp(
                                          Get.context!, imagePath![0])
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.heic')) {
          print("@@@@heic");

          convertingIntoDiffFormatsMulti(
            Get.context!,
            imagePath!,
            imagePath!
                .map((filePath) =>
                    path.extension(filePath).replaceFirst('.', ''))
                .toList(),
            selectedIndex.value == 1
                ? 'jpg'
                : selectedIndex.value == 2
                    ? 'gif'
                    : selectedIndex.value == 3
                        ? 'jpeg'
                        : selectedIndex.value == 4
                            ? 'png'
                            : selectedIndex.value == 5
                                ? 'svg'
                                : selectedIndex.value == 6
                                    ? 'webp'
                                    : selectedIndex.value == 7
                                        ? 'bmp'
                                        : selectedIndex.value == 8
                                            ? 'doc'
                                            : selectedIndex.value == 9
                                                ? 'txt'
                                                : selectedIndex.value == 10
                                                    ? 'pdf'
                                                    : selectedIndex.value == 11
                                                        ? 'xls'
                                                        : 'heic',
          );
        }
      } catch (e) {
        Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            "Please try again after some time"
            // AppLocalizations.of(Get.context!)!
            //     .please_try_again_after_some_time
            );
      }
      // } else {
      //   Get.to(() => const PremiumPage());
      // }
    } else if (selectedIndex.value == 1 ||
        selectedIndex.value == 4 ||
        selectedIndex.value == 2 ||
        selectedIndex.value == 3 ||
        selectedIndex.value == 7) {
      try {
        if (selectedIndex.value == 0) {
          Get.snackbar(
            backgroundColor: UiColors.whiteColor,
            duration: const Duration(seconds: 4),
            AppLocalizations.of(Get.context!)!.attention,
            // AppLocalizations.of(Get.context!)!
            //     .please_select_an_option_in_which_you_want_to_convert,
            "Please select an option in which you want to convert",
          );
          conversionOptionList(Get.context!, imagePath);
        }

        // await loopFunction();
        if (imagePath![0].toLowerCase().endsWith('.jpg') ||
            imagePath![0].toLowerCase().endsWith('.jpeg')) {
          selectedIndex.value == 1
              ? convertJpgToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertJpgToPdfMulti(Get.context!, imagePath)
                  : selectedIndex.value == 4
                      ? convertJpgToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertJpgToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertJpgToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertJpgToBMPMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.png')) {
          selectedIndex.value == 1
              ? convertPngToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertPngToPdfMulti(Get.context!, imagePath)
                  : selectedIndex.value == 4
                      ? convertPngToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertPngToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertPngToJPEGMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertPngToBMPMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.gif')) {
          selectedIndex.value == 1
              ? convertGifToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertGifToPdfMulti(Get.context!, imagePath!)
                  : selectedIndex.value == 4
                      ? convertGifToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertGifToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertGifToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertGifToBmpMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.bmp')) {
          print("@@@@BMP");
          selectedIndex.value == 1
              ? convertBmpToJpgMulti(Get.context!, imagePath)
              : selectedIndex.value == 10
                  ? convertBmpToPdfMulti(Get.context!, imagePath!)
                  : selectedIndex.value == 4
                      ? convertBmpToPngMulti(Get.context!, imagePath)
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertBmpToGifMulti(Get.context!, imagePath)
                              : selectedIndex.value == 3
                                  ? convertBmpToJpegMulti(
                                      Get.context!, imagePath)
                                  : selectedIndex.value == 7
                                      ? convertBmpToBmpMulti(
                                          Get.context!, imagePath)
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.tiff') ||
            imagePath![0].toLowerCase().endsWith('.tif')) {
          print("@@@@tif");
          selectedIndex.value == 1
              ? convertTifToJpg(Get.context!, imagePath![0])
              : selectedIndex.value == 10
                  ? convertTifToPdf(Get.context!, imagePath![0])
                  : selectedIndex.value == 4
                      ? convertTifToPng(Get.context!, imagePath![0])
                      : selectedIndex.value == 6
                          ? convertingIntoDiffFormatsMulti(
                              Get.context!,
                              imagePath!,
                              imagePath!
                                  .map((filePath) => path
                                      .extension(filePath)
                                      .replaceFirst('.', ''))
                                  .toList(),
                              'webp',
                            )
                          : selectedIndex.value == 2
                              ? convertTiffToGif(Get.context!, imagePath![0])
                              : selectedIndex.value == 2
                                  ? convertTiffToJpeg(
                                      Get.context!, imagePath![0])
                                  : selectedIndex.value == 7
                                      ? convertTiffToBmp(
                                          Get.context!, imagePath![0])
                                      : selectedIndex.value == 5
                                          ? convertingIntoDiffFormatsMulti(
                                              Get.context!,
                                              imagePath!,
                                              imagePath!
                                                  .map((filePath) => path
                                                      .extension(filePath)
                                                      .replaceFirst('.', ''))
                                                  .toList(),
                                              'svg',
                                            )
                                          : const SizedBox();
        } else if (imagePath![0].toLowerCase().endsWith('.heic')) {
          print("@@@@heic");

          convertingIntoDiffFormatsMulti(
            Get.context!,
            imagePath!,
            imagePath!
                .map((filePath) =>
                    path.extension(filePath).replaceFirst('.', ''))
                .toList(),
            selectedIndex.value == 1
                ? 'jpg'
                : selectedIndex.value == 2
                    ? 'gif'
                    : selectedIndex.value == 3
                        ? 'jpeg'
                        : selectedIndex.value == 4
                            ? 'png'
                            : selectedIndex.value == 5
                                ? 'svg'
                                : selectedIndex.value == 6
                                    ? 'webp'
                                    : selectedIndex.value == 7
                                        ? 'bmp'
                                        : selectedIndex.value == 8
                                            ? 'doc'
                                            : selectedIndex.value == 9
                                                ? 'txt'
                                                : selectedIndex.value == 10
                                                    ? 'pdf'
                                                    : selectedIndex.value == 11
                                                        ? 'xls'
                                                        : 'heic',
          );
        }
      } catch (e) {
        Get.snackbar(
          backgroundColor: UiColors.whiteColor,
          duration: const Duration(seconds: 4),
          AppLocalizations.of(Get.context!)!.attention,
          // AppLocalizations.of(Get.context!)!
          //     .please_try_again_after_some_time
          "Please try again after some time",
        );
        Get.back();
      }
    } else if (selectedIndex.value == 9) {
      // ++toolValue;
      // await SharedPref().setToolValue(toolValue);
      print("Image to Text New Tool");
      imageToTextTool(
        Get.context!,
        imagePath!,
        imagePath!
            .map((filePath) => path.extension(filePath).replaceFirst('.', ''))
            .toList(),
        'txt',
      );
    } else if (selectedIndex.value == 8) {
      // ++toolValue;
      // await SharedPref().setToolValue(toolValue);
      await imageToDocTool(Get.context!, imagePath!, 'doc');
    } else if (selectedIndex.value == 11) {
      if (imagePath!.first.contains('.BMP') ||
          imagePath!.first.contains('.bmp')) {
        log("I am triggered");
        List<String> tempList = [];
        Directory? dir = await getTemporaryDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/Img_${DateTime.now().microsecondsSinceEpoch}.png';
        // print("%%%%path  $path");

        im.Image? bmpImage =
            im.decodeImage(await File(imagePath!.first).readAsBytes());

        File file = File(path);
        file.writeAsBytesSync(
          im.encodeJpg(
            bmpImage!,
          ),
        );
        tempList.add(file.path);
        await imageToExcelTool(Get.context!, tempList, 'xlsx');
      } else {
        await imageToExcelTool(Get.context!, imagePath!, 'xlsx');
      }
    } else if (selectedIndex.value == 12 ||
        selectedIndex.value == 13 ||
        selectedIndex.value == 14 ||
        selectedIndex.value == 15 ||
        selectedIndex.value == 16 ||
        selectedIndex.value == 17 ||
        selectedIndex.value == 18) {
      print("NEW TOOLS CONVERSIONS");
      // ++toolValue;
      // await SharedPref().setToolValue(toolValue);
      // setToolsValue();
      if (imagePath!.first.contains('.png') ||
          imagePath!.first.contains('.jpg') ||
          imagePath!.first.contains('.jpeg')) {
        print("CORRECT");
        selectedIndex.value == 12 ||
                selectedIndex.value == 13 ||
                selectedIndex.value == 14 ||
                selectedIndex.value == 15 ||
                selectedIndex.value == 16 ||
                selectedIndex.value == 17 ||
                selectedIndex.value == 18
            ? convertingIntoDiffFormatsMulti(
                Get.context!,
                imagePath!,
                imagePath!
                    .map((filePath) =>
                        path.extension(filePath).replaceFirst('.', ''))
                    .toList(),
                selectedIndex.value == 12
                    ? 'tiff'
                    : selectedIndex.value == 13
                        ? 'raw'
                        : selectedIndex.value == 14
                            ? 'psd'
                            : selectedIndex.value == 15
                                ? 'dds'
                                : selectedIndex.value == 16
                                    ? 'heic'
                                    : selectedIndex.value == 17
                                        ? 'ppm'
                                        : selectedIndex.value == 18
                                            ? 'tga'
                                            : 'tiff',
              )
            : const SizedBox();
      } else {
        print("Wrong");
      }
    }
  }
}
