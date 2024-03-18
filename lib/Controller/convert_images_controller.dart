import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as im;
import 'package:image_converter_macos/Constant/api_string.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Presentation/conversion_result.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dio/dio.dart' as api;

class ConvertImagesController extends GetxController {
  double sliderValue = 0.7;

  RxInt selectedIndex = 0.obs;
  DateTime dateTime = DateTime.now();

  api.Dio dio = api.Dio();

  RxDouble progress = 0.0.obs;
  RxDouble percentage = 0.0.obs;
  RxBool loadingState = false.obs;

  RxBool isDownloading = false.obs;

  RxBool showLoader = false.obs;

  //Jpg Conversion
  convertJpgToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}jpgtojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.jpg';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        Directory(targetDirectoryPath).createSync(recursive: true);

        await imageFile.copy(path);

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(imageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".jpg",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: imageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted Image ${imageFile.path}");
      }
    } catch (e) {
      Get.to(() => const HomeScreen());
      print("%%%%Error of file $e");
    }
  }

  convertJpgToJpeg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}jpgtojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.jpeg';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        Directory(targetDirectoryPath).createSync(recursive: true);

        await imageFile.copy(path);

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(imageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".jpeg",
            originalSize:
            "${((originalSize.value) / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${((convertedSize.value) / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: imageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted Image ${imageFile.path}");
      }
    } catch (e) {
      Get.to(() => const HomeScreen());
      print("%%%%Error of file $e");
    }
  }

  convertJpgToBMP(context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}jpgtobmp_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path BMP: $path");

        File imageFile = File(filePath);

        im.Image? image = im.decodeImage(await imageFile.readAsBytes());

        print("%%%%image BMP: $image");

        im.Image smallerImage = im.copyResize(image!, width: 800);
        print("%%%%smallerImage BMP: $smallerImage");

        Directory(targetDirectoryPath)
            .createSync(recursive: true); // Ensure target directory exists

        File compressedImage = File('$path.bmp')
          ..writeAsBytesSync(im.encodeBmp(smallerImage));

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(compressedImage.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".bmp",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: compressedImage,
          ),
        );

        showLoader.value = false;

        print("%%%%compressed Image BMP: ${compressedImage.path}");
      }
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

      print("%%%%Error of file webp: $e");
    }
  }

  convertJpgToGif(context, String? filePath) async {
    try {
      showLoader.value = true;
      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}jpgtogif_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        im.Image? image = im.decodeImage(await imageFile.readAsBytes());

        print("%%%%image $image");

        im.Image smallerImage = im.copyResize(image!, width: 800);
        print("%%%%smallerImage $smallerImage");

        Directory(targetDirectoryPath)
            .createSync(recursive: true); // Ensure target directory exists

        File compressedImage = File('$path.gif')
          ..writeAsBytesSync(im.encodeGif(smallerImage));

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(compressedImage.path);

        Get.to(
              () => ConversionResult(
            imageFormat: ".gif",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: compressedImage,
          ),
        );
        showLoader.value = false;

        print("%%%%compressed Image ${compressedImage.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());

      print("%%%%Error of file $e");
    }
  }

  convertJpgToPng(context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}jpgtopng_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        im.Image? image = im.decodeImage(await imageFile.readAsBytes());

        print("%%%%image $image");

        im.Image smallerImage = im.copyResize(image!, width: 800);
        print("%%%%smallerImage $smallerImage");

        Directory(targetDirectoryPath)
            .createSync(recursive: true); // Ensure target directory exists

        File compressedImage = File('$path.png')
          ..writeAsBytesSync(im.encodePng(smallerImage, level: 8));

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(compressedImage.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".png",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: compressedImage,
          ),
        );

        showLoader.value = false;

        print("%%%%compressed Image ${compressedImage.path}");
      }
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

      print("%%%%Error of file $e");
    }
  }

  convertJpgToPdf(BuildContext context, String? filePath) async {
    showLoader.value = true;

    if (filePath == null) {
      // Handle the case when imagePath is null
      return;
    }

    final File imageFile = File(filePath);

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

    Directory? dir = Platform.isIOS
        ? await getApplicationCacheDirectory()
        : await getExternalStorageDirectory();

    var path =
        '${dir?.path}/ImageConverter/jpgtopdf_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.pdf';
    final file = File(path)..createSync(recursive: true);
    print("path before $path");

    await file.writeAsBytes(await pdf.save());

    originalSize.value = await getFileSize(filePath);
    convertedSize.value = await getFileSize(file.path);

    await Get.to(
          () => ConversionResult(
        imageFormat: ".pdf",
        originalSize: "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
        convertedSize:
        "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
        dateTime: getFormattedDateTime(dateTime),
        convertedFile:
        // file,
        File(path),
      ),
    );

    showLoader.value = false;

    print("File directory $file");

    print("File converting");
  }

  convertingIntoDiffFormats(
      BuildContext context, String? filePath, String from, String to) async {
    String uploadurl = ApiString.apiUrl;
    try {
      api.FormData formdata = api.FormData.fromMap({
        "file": await api.MultipartFile.fromFile(filePath!, filename: filePath
          //show only filename from path
        ),
        "from": from,
        "to": to,
      });

      api.Response response = await dio.post(
        uploadurl,
        data: formdata,
        options: ApiString.options,
        onSendProgress: (int sent, int total) {
          percentage.value =
              double.parse(((sent / total) * 100).toStringAsFixed(2));
          loadingState.value = true;
          progress.value = percentage.value;
          print('Progress show $percentage');
        },
      );

      DateTime dateTime = DateTime.now();
      Map valueMap = json.decode(response.data);
      Directory? dir = Platform.isIOS
          ? await getApplicationCacheDirectory()
          : await getExternalStorageDirectory();
      var path =
          "${dir?.path}/ImageConverter/ $from To $to _$dateTime#${basename(valueMap['d_url'])}";
      isDownloading.value = true;
      var downloadRes = await dio.download(
        "${valueMap['d_url']}",
        path,
        onReceiveProgress: (int recieve, int total) {
          percentage.value = (recieve / total * 100);
          progress.value = percentage.value;

          print('Progress show $progress');
        },
      );
      print("Response Download ${downloadRes.data}");

      loadingState.value = false;
      isDownloading.value = false;

      int originalSize = await getFileSize(filePath);
      int convertedSize = await getFileSize(path);

      // print("aaaa ")

      await Get.to(
            () => ConversionResult(
          imageFormat: ".$to",
          originalSize:
          "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
          convertedSize:
          "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
          dateTime: getFormattedDateTime(dateTime),
          convertedFile: File(path),
        ),
      );

      if (response.statusCode == 200) {
        print(response.toString());
      } else {
        Get.offAll(() => const HomeScreen());
        print("Error during connection to server.");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(backgroundColor: Colors.white, "ERROR", "Please Try Again");
      print("Error of file $e");
    }
  }

  //Tif Conversions
  convertTifToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
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

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(jpgImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".jpg",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: jpgImageFile,
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
        Directory? dir = Platform.isIOS
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

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(file.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".pdf",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: file,
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
        Directory? dir = Platform.isIOS
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

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(pngImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".png",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: pngImageFile,
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
        Directory? dir = Platform.isIOS
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

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(gifImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".gif",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: gifImageFile,
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
        Directory? dir = Platform.isIOS
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

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(jpegImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".jpeg",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: jpegImageFile,
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
        Directory? dir = Platform.isIOS
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

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(bmpImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".bmp",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: bmpImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%compressed Image BMP: ${bmpImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  //

  //BMP Conversions
  convertBmpToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/bmptojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        im.Image? bmpImage = im.decodeImage(await selectedFile.readAsBytes());
        File jpgImageFile = File('$path.jpg')
          ..writeAsBytesSync(
            im.encodeJpg(
              bmpImage!,
            ),
          );

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(jpgImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".jpg",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: jpgImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPG Image ${jpgImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertBmpToPdf(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/bmptopdf_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);
        print("%%%%selectedFile  $selectedFile");

        im.Image? bmpImage = im.decodeImage(await selectedFile.readAsBytes());
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

        final file = File('$path.pdf')..createSync(recursive: true);
        print("path before $path");

        await file.writeAsBytes(await pdf.save());

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(file.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".pdf",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: file,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertBmpToPng(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/bmptopng_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        im.Image? bmpImage = im.decodeImage(await selectedFile.readAsBytes());
        File pngImageFile = File('$path.png')
          ..writeAsBytesSync(
            im.encodePng(
              bmpImage!,
            ),
          );

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(pngImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".png",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: pngImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted PNG Image ${pngImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertBmpToGif(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/bmptogif_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);
        print("%%%%selectedFile  $selectedFile");

        // Convert BMP to GIF
        im.Image? bmpImage = im.decodeImage(await selectedFile.readAsBytes());
        File gifImageFile = File('$path.gif')
          ..writeAsBytesSync(
            im.encodeGif(
              bmpImage!,
            ),
          );

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(gifImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".gif",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: gifImageFile,
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

  convertBmpToJpeg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/bmptojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        im.Image? bmpImage = im.decodeImage(await selectedFile.readAsBytes());
        File jpegImageFile = File('$path.jpeg')
          ..writeAsBytesSync(
            im.encodeJpg(
              bmpImage!,
            ),
          );

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(jpegImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".jpeg",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: jpegImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPEG Image ${jpegImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertBmpToBmp(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}bmptobmp_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.gif';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        Directory(targetDirectoryPath).createSync(recursive: true);

        await imageFile.copy(path);

        print("%%%%converted Image ${imageFile.path}");
        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(filePath);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".bmp",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: imageFile,
          ),
        );

        showLoader.value = false;
      }
    } catch (e) {
      Get.to(() => const HomeScreen());
      print("%%%%Error of file $e");
    }
  }
  //

  //GIF Conversion
  convertGifToPdf(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/giftopdf_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);
        print("%%%%selectedFile  $selectedFile");

        im.Image? gifImage = im.decodeGif(await selectedFile.readAsBytes());
        print("%%%%gifImage  $gifImage");

        final pdf = pw.Document();

        print("%%%%pdf  $pdf");

        final image = pw.MemoryImage(im.encodePng(gifImage!));

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

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(file.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".pdf",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: file,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertGifToGif(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}giftogif_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.gif';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        Directory(targetDirectoryPath).createSync(recursive: true);

        await imageFile.copy(path);

        print("%%%%converted Image ${imageFile.path}");
        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(filePath);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".gif",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: imageFile,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.to(() => const HomeScreen());
      print("%%%%Error of file $e");
    }
  }

  convertGifToPng(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      print("%%%%filePath $filePath");

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/giftopng_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
        print("%%%%path1 $path");

        // File selectedFile = File(filePath);
        print("%%%%path check  $path");

        im.Image? gifImage = im.decodeGif(await File(filePath).readAsBytes());
        File pngImageFile = File('$path.png')
          ..writeAsBytesSync(im.encodePng(gifImage!));

        // im.Image? gifImage =
        // im.decodeGif(await selectedFile.readAsBytes());
        // print("%%%%gifImage  $gifImage");
        //
        // var pngBytes = im.encodePng(gifImage!);
        //
        // File pngImageFile = File(path);
        // await pngImageFile.writeAsBytes(pngBytes);

        var originalSize = await File(filePath).length();
        var convertedSize = await pngImageFile.length();

        await Get.to(
              () => ConversionResult(
            imageFormat: ".png",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: pngImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted PNG Image ${pngImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertGifToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/giftojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        print("%%%%selectedFile  $selectedFile");

        im.Image? gifImage = im.decodeGif(await selectedFile.readAsBytes());
        print("%%%%gifImage  $gifImage");

        File jpgImageFile = File('$path.jpg')
          ..writeAsBytesSync(
            im.encodeJpg(
              gifImage!,
            ),
          );

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(jpgImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".jpg",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: jpgImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPG Image ${jpgImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertGifToBmp(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/giftobmp_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);
        print("%%%%selectedFile  $selectedFile");

        // Convert GIF to JPG
        im.Image? gifImage = im.decodeGif(await selectedFile.readAsBytes());

        // Convert JPG to BMP
        im.Image? jpgImage = im.copyResize(gifImage!, width: 800);
        File bmpImageFile = File('$path.bmp')
          ..writeAsBytesSync(
            im.encodeBmp(
              jpgImage,
            ),
          );

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(bmpImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".bmp",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: bmpImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%compressed Image BMP: ${bmpImageFile.path}");

        // You can save the BMP file wherever needed.
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  convertGifToJpeg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        //Directory? dir = Platform.isIOS

        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir?.path}/ImageConverter/giftojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        print("%%%%selectedFile  $selectedFile");

        im.Image? gifImage = im.decodeGif(await selectedFile.readAsBytes());
        print("%%%%gifImage  $gifImage");

        File jpgImageFile = File('$path.jpeg')
          ..writeAsBytesSync(
            im.encodeJpg(
              gifImage!,
            ),
          );

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(jpgImageFile.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".jpeg",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: jpgImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPG Image ${jpgImageFile.path}");
      }
    } catch (e) {
      print("%%%%Error of file $e");
    }
  }

  //

  //Png Conversion
  convertPngToJPEG(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();

        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}PngtoJpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        // Use flutter_image_compress to decode PNG image
        List<int> compressedBytes = await FlutterImageCompress.compressWithList(
          await imageFile.readAsBytes(),
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
        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(compressedImage.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".jpeg",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: compressedImage,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.to(() => const HomeScreen());

      print("%%%%Error of file $e");
    }
  }

  convertPngToGif(context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();

        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}Pngtogif_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        im.Image? image = im.decodeImage(await imageFile.readAsBytes());

        print("%%%%image $image");

        im.Image smallerImage = im.copyResize(image!, width: 800);
        print("%%%%smallerImage $smallerImage");

        Directory(targetDirectoryPath)
            .createSync(recursive: true); // Ensure target directory exists

        File compressedImage = File('$path.gif')
          ..writeAsBytesSync(im.encodeGif(smallerImage));

        print("%%%%compressed Image ${compressedImage.path}");
        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(compressedImage.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".gif",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: compressedImage,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

      print("%%%%Error of file $e");
    }
  }

  convertPngToBMP(context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        //Directory? dir = Platform.isIOS

        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}Pngtobmp_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path BMP: $path");

        File imageFile = File(filePath);

        im.Image? image = im.decodeImage(await imageFile.readAsBytes());

        print("%%%%image BMP: $image");

        im.Image smallerImage = im.copyResize(image!, width: 800);
        print("%%%%smallerImage BMP: $smallerImage");

        Directory(targetDirectoryPath)
            .createSync(recursive: true); // Ensure target directory exists

        File compressedImage = File('$path.bmp')
          ..writeAsBytesSync(im.encodeBmp(smallerImage));

        print("%%%%compressed Image BMP: ${compressedImage.path}");

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(compressedImage.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".bmp",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: compressedImage,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

      print("%%%%Error of file webp: $e");
    }
  }

  convertPngToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();

        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}pngtojpg_$dateTime#File ${getFormattedDateTime(dateTime)}';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        List<int> bytes = await FlutterImageCompress.compressWithList(
          imageFile.readAsBytesSync(),
          minHeight: 800,
          minWidth: 800,
          quality: 88,
        );

        Directory(targetDirectoryPath).createSync(recursive: true);

        File compressedImage = File('$path.jpg')..writeAsBytesSync(bytes);

        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(compressedImage.path);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".jpg",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: compressedImage,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.to(() => const HomeScreen());
      print("%%%%Error of file $e");
    }
  }

  convertPngToPng(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = Platform.isIOS
            ? await getApplicationCacheDirectory()
            : await getExternalStorageDirectory();

        var targetDirectoryPath = '${dir?.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}pngtopng_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.png';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        Directory(targetDirectoryPath).createSync(recursive: true);

        await imageFile.copy(path);

        print("%%%%converted Image ${imageFile.path}");
        originalSize.value = await getFileSize(filePath);
        convertedSize.value = await getFileSize(filePath);

        await Get.to(
              () => ConversionResult(
            imageFormat: ".png",
            originalSize:
            "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            convertedSize:
            "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
            dateTime: getFormattedDateTime(dateTime),
            convertedFile: imageFile,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.to(() => const HomeScreen());
      print("%%%%Error of file $e");
    }
  }

  convertPngToPdf(BuildContext context, String? filePath) async {
    showLoader.value = true;

    if (filePath == null) {
      // Handle the case when imagePath is null
      return;
    }

    final File imageFile = File(filePath);

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

    Directory? dir = Platform.isIOS
        ? await getApplicationCacheDirectory()
        : await getExternalStorageDirectory();

    var path =
        '${dir?.path}/ImageConverter/pngtopdf_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.pdf';
    final file = File(path)..createSync(recursive: true);
    print("path before $path");

    await file.writeAsBytes(await pdf.save());

    originalSize.value = await getFileSize(filePath);
    convertedSize.value = await getFileSize(file.path);

    await Get.to(
          () => ConversionResult(
        imageFormat: ".pdf",
        originalSize: "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
        convertedSize:
        "${(convertedSize / (1024 * 1024)).toStringAsFixed(2)} MB",
        dateTime: getFormattedDateTime(dateTime),
        convertedFile: File(path),
      ),
    );
    showLoader.value = false;
  }

  conversionOptionList(BuildContext context) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                insetPadding: const EdgeInsets.only(top: 0),
                elevation: 4.0,
                title: Text(
                  "Choose File Format",
                  // AppLocalizations.of(context)!.choose_the_file_output_format,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: UiColors.blackColor.withOpacity(0.6),
                  ),
                ),
                contentPadding: const EdgeInsets.all(0),
                content: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          conversionOptions(
                            ".JPG",
                            'assets/JPG.png',
                            1,
                          ),
                          conversionOptions(
                            ".PDF",
                            'assets/PDF.png',
                            2,
                          ),
                          conversionOptions(
                            ".PNG",
                            'assets/PNG.png',
                            3,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          conversionOptions(
                            ".WEBP",
                            'assets/WEBP.png',
                            4,
                          ),
                          conversionOptions(
                            ".GIF",
                            'assets/GIF.png',
                            5,
                          ),
                          conversionOptions(
                            ".JPEG",
                            'assets/JPEG.png',
                            6,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          conversionOptions(
                            ".BMP",
                            'assets/BMP.png',
                            7,
                          ),
                          conversionOptions(
                            ".SVG",
                            'assets/SVG.png',
                            8,
                          ),
                          const SizedBox(
                            width: 100,
                          )
                        ],
                      ),
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

  conversionOptions(String extensionName, String extensionImage, int index) {
    return GestureDetector(
      onTap: () {
        selectedIndex.value = index;
        Get.back();
      },
      child: Obx(
            () => Padding(
          padding:
          const EdgeInsets.only(left: 6.0, right: 6, top: 8, bottom: 8),
          child: Container(
            width: 90,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              border: Border.all(
                color: selectedIndex.value == index
                    ? Colors.blue
                    : Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  extensionImage,
                  height: 22,
                  width: 22,
                ),
                Text(
                  extensionName,
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

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
}