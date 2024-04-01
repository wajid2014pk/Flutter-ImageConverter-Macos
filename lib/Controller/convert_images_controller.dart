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
import 'package:image_converter_macos/Controller/PremiumPopUpController/premium_controller.dart';
import 'package:image_converter_macos/Presentation/conversion_result.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';
import 'package:image_converter_macos/Screens/premium_popup.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dio/dio.dart' as api;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  final payWallController = Get.put(PayWallController());

  convertingIntoDiffFormats(
      BuildContext context, String? filePath, String from, String to) async {
    String uploadurl = ApiString.apiUrl;
    try {
      loadingState.value = true;
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

          progress.value = percentage.value;
          print('Progress show $percentage');
        },
      );

      DateTime dateTime = DateTime.now();
      Map valueMap = json.decode(response.data);
      Directory? dir = await getApplicationCacheDirectory();
      var path =
          "${dir.path}/ImageConverter/${from}to${to}_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}#${basename(valueMap['d_url'])}";
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

      await Get.to(
        () => ConversionResult(
          imageFormat: ".$from",
          originalFilePath: filePath,
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
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  //Jpg Conversion
  convertJpgToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();

        var targetDirectoryPath = '${dir.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}jpgtojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.jpg';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        Directory(targetDirectoryPath).createSync(recursive: true);

        await imageFile.copy(path);

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpg",
            originalFilePath: filePath,
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
        Directory? dir = await getApplicationCacheDirectory();

        var targetDirectoryPath = '${dir.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}jpgtojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.jpeg';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        Directory(targetDirectoryPath).createSync(recursive: true);

        await imageFile.copy(path);

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpg",
            originalFilePath: filePath,
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
        Directory? dir = await getApplicationCacheDirectory();
        var targetDirectoryPath = '${dir.path}/ImageConverter/';

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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpg",
            originalFilePath: filePath,
            convertedFile: compressedImage,
          ),
        );

        showLoader.value = false;

        print("%%%%compressed Image BMP: ${compressedImage.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());

      print("%%%%Error of file webp: $e");
    }
  }

  convertJpgToGif(context, String? filePath) async {
    try {
      showLoader.value = true;
      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        var targetDirectoryPath = '${dir.path}/ImageConverter/';

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

        Get.to(
          () => ConversionResult(
            imageFormat: ".jpg",
            originalFilePath: filePath,
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
        Directory? dir = await getApplicationCacheDirectory();

        var targetDirectoryPath = '${dir.path}/ImageConverter/';

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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".jpg",
            originalFilePath: filePath,
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

    Directory? dir = await getApplicationCacheDirectory();

    var path =
        '${dir.path}/ImageConverter/jpgtopdf_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.pdf';
    final file = File(path)..createSync(recursive: true);
    print("path before $path");

    await file.writeAsBytes(await pdf.save());

    await Get.to(
      () => ConversionResult(
        imageFormat: ".jpg",
        originalFilePath: filePath,
        convertedFile:
            // file,
            File(path),
      ),
    );

    showLoader.value = false;

    print("File directory $file");

    print("File converting");
  }

  //Png Conversion
  convertPngToJPEG(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();

        Directory? dir = await getApplicationCacheDirectory();
        var targetDirectoryPath = '${dir.path}/ImageConverter/';

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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".png",
            originalFilePath: filePath,
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

        Directory? dir = await getApplicationCacheDirectory();

        var targetDirectoryPath = '${dir.path}/ImageConverter/';

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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".png",
            originalFilePath: filePath,
            convertedFile: compressedImage,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());

      print("%%%%Error of file $e");
    }
  }

  convertPngToBMP(context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        //Directory? dir = Platform.isIOS

        Directory? dir = await getApplicationCacheDirectory();

        var targetDirectoryPath = '${dir.path}/ImageConverter/';

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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".png",
            originalFilePath: filePath,
            convertedFile: compressedImage,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());

      print("%%%%Error of file webp: $e");
    }
  }

  convertPngToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();

        Directory? dir = await getApplicationCacheDirectory();

        var targetDirectoryPath = '${dir.path}/ImageConverter/';

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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".png",
            originalFilePath: filePath,
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
        Directory? dir = await getApplicationCacheDirectory();

        var targetDirectoryPath = '${dir.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}pngtopng_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.png';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        Directory(targetDirectoryPath).createSync(recursive: true);

        await imageFile.copy(path);

        print("%%%%converted Image ${imageFile.path}");

        await Get.to(
          () => ConversionResult(
            imageFormat: ".png",
            originalFilePath: filePath,
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
    try {
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

      Directory? dir = await getApplicationCacheDirectory();

      var path =
          '${dir.path}/ImageConverter/pngtopdf_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.pdf';
      final file = File(path)..createSync(recursive: true);
      print("path before $path");

      await file.writeAsBytes(await pdf.save());

      await Get.to(
        () => ConversionResult(
          imageFormat: ".png",
          originalFilePath: filePath,
          convertedFile: File(path),
        ),
      );
      showLoader.value = false;
    } catch (e) {
      Get.to(() => const HomeScreen());
      print("%%%%Error of file $e");
    }
  }

  //Tif Conversions
  convertTifToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/tiftojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
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
            imageFormat: ".tif",
            originalFilePath: filePath,
            convertedFile: jpgImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPG Image ${jpgImageFile.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertTifToPdf(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/tiftopdf_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
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
            imageFormat: ".tif",
            originalFilePath: filePath,
            convertedFile: file,
          ),
        );
      }
      showLoader.value = false;
    } catch (e) {
      Get.to(() => const HomeScreen());
      print("%%%%Error of file $e");
    }
  }

  convertTifToPng(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/tiftopng_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        im.Image? tifImage = im.decodeTiff(await selectedFile.readAsBytes());
        File pngImageFile = File('$path.png')
          ..writeAsBytesSync(
            im.encodePng(
              tifImage!,
            ),
          );

        await Get.to(
          () => ConversionResult(
            imageFormat: ".tif",
            originalFilePath: filePath,
            convertedFile: pngImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted PNG Image ${pngImageFile.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertTiffToGif(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/tifftogif_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".tif",
            originalFilePath: filePath,
            convertedFile: gifImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted GIF Image: ${gifImageFile.path}");

        // You can save the GIF file wherever needed.
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertTiffToJpeg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/tifftojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
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
            imageFormat: ".tif",
            originalFilePath: filePath,
            convertedFile: jpegImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPEG Image ${jpegImageFile.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertTiffToBmp(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/tifftobmp_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".tif",
            originalFilePath: filePath,
            convertedFile: bmpImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%compressed Image BMP: ${bmpImageFile.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  //

  //BMP Conversions
  convertBmpToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/bmptojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        im.Image? bmpImage = im.decodeImage(await selectedFile.readAsBytes());
        File jpgImageFile = File('$path.jpg')
          ..writeAsBytesSync(
            im.encodeJpg(
              bmpImage!,
            ),
          );

        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            originalFilePath: filePath,
            convertedFile: jpgImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPG Image ${jpgImageFile.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertBmpToPdf(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/bmptopdf_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            originalFilePath: filePath,
            convertedFile: file,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertBmpToPng(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/bmptopng_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        im.Image? bmpImage = im.decodeImage(await selectedFile.readAsBytes());
        File pngImageFile = File('$path.png')
          ..writeAsBytesSync(
            im.encodePng(
              bmpImage!,
            ),
          );

        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            originalFilePath: filePath,
            convertedFile: pngImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted PNG Image ${pngImageFile.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertBmpToGif(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/bmptogif_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            originalFilePath: filePath,
            convertedFile: gifImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted GIF Image: ${gifImageFile.path}");

        // You can save the GIF file wherever needed.
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertBmpToJpeg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/bmptojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
        print("%%%%path  $path");

        File selectedFile = File(filePath);

        im.Image? bmpImage = im.decodeImage(await selectedFile.readAsBytes());
        File jpegImageFile = File('$path.jpeg')
          ..writeAsBytesSync(
            im.encodeJpg(
              bmpImage!,
            ),
          );

        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            originalFilePath: filePath,
            convertedFile: jpegImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPEG Image ${jpegImageFile.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertBmpToBmp(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();

        var targetDirectoryPath = '${dir.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}bmptobmp_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.gif';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        Directory(targetDirectoryPath).createSync(recursive: true);

        await imageFile.copy(path);

        print("%%%%converted Image ${imageFile.path}");

        await Get.to(
          () => ConversionResult(
            imageFormat: ".bmp",
            originalFilePath: filePath,
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
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/giftopdf_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            originalFilePath: filePath,
            convertedFile: file,
          ),
        );
        showLoader.value = false;
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertGifToGif(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();

        var targetDirectoryPath = '${dir.path}/ImageConverter/';

        var path =
            '${targetDirectoryPath}giftogif_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}.gif';
        print("%%%%path  $path");

        File imageFile = File(filePath);

        Directory(targetDirectoryPath).createSync(recursive: true);

        await imageFile.copy(path);

        print("%%%%converted Image ${imageFile.path}");

        await Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            originalFilePath: filePath,
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
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/giftopng_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            originalFilePath: filePath,
            convertedFile: pngImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted PNG Image ${pngImageFile.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertGifToJpg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/giftojpg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            originalFilePath: filePath,
            convertedFile: jpgImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPG Image ${jpgImageFile.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertGifToBmp(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/giftobmp_${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}';
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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            originalFilePath: filePath,
            convertedFile: bmpImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%compressed Image BMP: ${bmpImageFile.path}");

        // You can save the BMP file wherever needed.
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
  }

  convertGifToJpeg(BuildContext context, String? filePath) async {
    try {
      showLoader.value = true;

      if (filePath != null) {
        DateTime dateTime = DateTime.now();
        //Directory? dir = Platform.isIOS

        Directory? dir = await getApplicationCacheDirectory();
        print("%%%%directory $dir");

        var path =
            '${dir.path}/ImageConverter/giftojpeg_$dateTime#File ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
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

        await Get.to(
          () => ConversionResult(
            imageFormat: ".gif",
            originalFilePath: filePath,
            convertedFile: jpgImageFile,
          ),
        );

        showLoader.value = false;

        print("%%%%converted JPG Image ${jpgImageFile.path}");
      }
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      Get.snackbar(
          backgroundColor: Colors.white,
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.please_try_again);
      print("Error of file $e");
    }
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
                contentPadding: const EdgeInsets.all(0),
                content: Container(
                  decoration: BoxDecoration(
                      color: UiColors.whiteColor,
                      borderRadius: BorderRadius.circular(8)),
                  height: 300,
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 8.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Text(
                          "Choose File Format",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          conversionOptions(
                              ".JPG", 'assets/JPG.png', 1, context),
                          conversionOptions(
                              ".PDF", 'assets/PDF.png', 2, context),
                          conversionOptions(
                              ".PNG", 'assets/PNG.png', 3, context),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          conversionOptions(
                              ".WEBP", 'assets/WEBP.png', 4, context),
                          conversionOptions(
                              ".GIF", 'assets/GIF.png', 5, context),
                          conversionOptions(
                              ".JPEG", 'assets/JPEG.png', 6, context),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          conversionOptions(
                              ".BMP", 'assets/BMP.png', 7, context),
                          conversionOptions(
                              ".SVG", 'assets/SVG.png', 8, context),
                          const SizedBox(
                            width: 133,
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

    //--------

    //  Container(
    //   decoration: BoxDecoration(
    //       color: UiColors.whiteColor, borderRadius: BorderRadius.circular(8)),
    //   height: 260,
    //   width: MediaQuery.of(context).size.width / 2.6,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text(
    //           "Choose File Format",
    //           textAlign: TextAlign.center,
    //           style: GoogleFonts.poppins(
    //             fontSize: 14,
    //             color: Colors.black.withOpacity(0.7),
    //           ),
    //         ),
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           conversionOptions(".JPG", 'assets/JPG.png', 1, context),
    //           conversionOptions(".PDF", 'assets/PDF.png', 2, context),
    //           conversionOptions(".PNG", 'assets/PNG.png', 3, context),
    //         ],
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           conversionOptions(".WEBP", 'assets/WEBP.png', 4, context),
    //           conversionOptions(".GIF", 'assets/GIF.png', 5, context),
    //           conversionOptions(".JPEG", 'assets/JPEG.png', 6, context),
    //         ],
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           conversionOptions(".BMP", 'assets/BMP.png', 7, context),
    //           conversionOptions(".SVG", 'assets/SVG.png', 8, context),
    //           const SizedBox(
    //             width: 133,
    //           )
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }

  conversionOptions(String extensionName, String extensionImage, int index,
      BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index == 1 ||
            index == 3 ||
            index == 5 ||
            index == 6 ||
            index == 7) {
          selectedIndex.value = index;
          Get.back();
        }
        if (index == 2 || index == 4 || index == 8) {
          payWallController.isPro.value == true
              ? selectedIndex.value = index
              : PremiumPopUp().premiumScreenPopUp(context);
        }
      },
      child: Obx(
        () => Padding(
          padding:
              const EdgeInsets.only(left: 10.0, right: 10, top: 12, bottom: 12),
          child: Container(
            width: 125,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: UiColors.lightGreyBackground.withOpacity(0.3),
              border: Border.all(
                color: selectedIndex.value == index
                    ? UiColors.lightblueColor
                    : Colors.transparent,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  extensionImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  extensionName,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  width: 2,
                ),
                if (index == 2 || index == 4 || index == 8)
                  Image.asset(
                    'assets/Star.png',
                    height: 20,
                    width: 20,
                  ),
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
