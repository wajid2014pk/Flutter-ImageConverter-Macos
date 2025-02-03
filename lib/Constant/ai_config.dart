import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'package:dio/dio.dart' as dio;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Constant/global.dart';
import 'package:image_converter_macos/Presentation/home_screen.dart';

class AIHandler {
  Future<dynamic> sendImageAndPromptToChatGPT(String base64Image) async {
    if (apikey == '') await fetchApiKey();
    print("Enter...");
    dio.Dio dios = dio.Dio();
    const url = 'https://api.openai.com/v1/chat/completions'; // Verify this URL
    // const apiKey =
    //     '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'; // Ensure this API key is correct
    // const apiKey =
    //     'sk-proj-eSi2tyiUP3vfmPlnPENrT3BlbkFJHgU7SaRArFc4ZeaeKaP4'; // Ensure this API key is correct
    print("Enter11111...");
    try {
      dio.Response response = await dios.post(
        url,
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apikey',
          },
        ),
        data: jsonEncode({
          // 'model': 'gpt-4-turbo', // Verify this model name
          'model': 'gpt-4o-mini', // Verify this model name
          "max_tokens": 14000,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text':
                      // 'in flutter i want to create excel file so in response of this  only return extracted text from all tables seperate every field with coma of this image that i can use to create excel sheet in flutter do not write any thing extra in response only extracted text, if one column share 2 rows make it same like that and if givn image have nested table give me that also and data of same row should be in same row extract with maximum accuracy  and make sure text is extracted in correct order ,data of same row remain in same row dont go up or down ,title of table should be in the top most row in center of full width then start rows and columns of data'

                      // "Extract text from given image as rows and columns and make keys and values in double quotes.Don't send any extra text like explanation or headings, just the JSON code. I repeat, need only JSON, also dont add json in start of response.The JSON format should be like below. No Extra Changes in json format but you can extend rows and columns according to data. Just like this:[{'0': 'row1-column1','1': 'row1-column2','2': 'row1-column3','3': 'row1-column4','4': 'row1-column5','5': 'row1-column6',},{'0': 'row2-column1','1': 'row2-column2','2': 'row2-column3','3': 'row2-column4','4': 'row2-column5','5': 'row2-column6',},]"
                      // "Extract text from given image as rows and columns and make keys and values in double quotes.Don't send any extra text like explanation or headings, just the JSON code. I repeat, need only JSON, also dont add json in start of response.The JSON format should be like below. No Extra Changes in json format but you can extend rows and columns according to data and give empty space in empty cell. if there are nested rows in heading consider last one. Just like this:[{'0': 'row1-column1','1': 'row1-column2','2': 'row1-column3','3': 'row1-column4','4': 'row1-column5','5': 'row1-column6',},{'0': 'row2-column1','1': 'row2-column2','2': 'row2-column3','3': 'row2-column4','4': 'row2-column5','5': 'row2-column6',},] it can have more then thess rows and columns its just a format."
                      "Extract text from given image as rows and columns and make keys and values in double quotes,Don't send any extra text like explanation or headings, just the JSON code. I repeat, need only JSON not even ```json in the start just and only simple json, also dont add json in start of response.The JSON format should be like below. No Extra Changes in json format.complete json with noValue if there is no value in cell and close brakets as in format. Just like this:[{'0': 'row1-column1','1': 'row1-column2','2': 'row1-column3','3': 'row1-column4','4': 'row1-column5','5': 'row1-column6'},{'0': 'row2-column1','1': 'row2-column2','2': 'row2-column3','3': 'row2-column4''4': 'row2-column5','5': 'row2-column6'},]"
                },
                {
                  "type": "image_url",
                  "image_url": {
                    "url": "data:image/jpeg;base64,$base64Image",
                  }
                }
              ],
            },
          ],
        }),
      );
      print("Enter...33333");
      if (response.statusCode == 200) {
        print("Enter...444444444");
        return response.data; // Process response as needed
      } else {
        throw Exception(
            'Failed to send image and prompt to ChatGPT API: ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      print("Enter...55555555");
      log("DioException: ${e.message}");
      // if (e.message == null) {
      Get.offAll(() => HomeScreen(index: 1));
      Get.snackbar(
          backgroundColor: UiColors.whiteColor,
          duration: const Duration(seconds: 4),
          AppLocalizations.of(Get.context!)!.attention,
          "Please check your internet connection"
          // AppLocalizations.of(Get.context!)!
          //     .please_check_your_internet_connection,
          );
      // }
      log("Response data: ${e.response?.data}");
      log("Response status: ${e.response?.statusCode}");
      return e;
    } catch (e) {
      log("Error: $e");
      return e;
    }
  }

  static Future<void> fetchApiKey({bool isGoHome = true}) async {
    log("message");
    // Dio instance
    dio.Dio dios = dio.Dio();

    // The URL of the API
    String url = "https://www.cardscanner.co/api/get-openai-key";

    // Data to be sent in the body
    Map<String, dynamic> data = {
      "app_name": (Platform.isAndroid)
          ? "com.image.converter.convert.photos.jpg.png.jpeg"
          : "com.image.converter.heic.convert.photos.jpg.png.jpeg"
      // "app_name": "com.image.converter.heic.convert.photos.jpg.png.jpeg"
    };

    try {
      // Sending the POST request
      dio.Response response = await dios.post(url, data: data);

      // Check if the response was successful
      if (response.statusCode == 200) {
        // Successfully received response
        print("Response: ${response.data}");
        apikey = response.data.toString();

        // Do something with the key
      } else {
        // Handle unsuccessful response
        // String IMAGE_TO_EXCEL_KEY = "NO_KEY";
        Get.offAll(() => HomeScreen(index: 1));
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 2),
          message: "Server Error!!!!",
        ));
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      // Handle error
      if (e is dio.DioException) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 2),
          title: "Error",
          message: "PLease Try Again!",
        ));
        Get.offAll(() => HomeScreen(index: 1));

        print("Dio error: ${e.message}");
      } else {
        print("Error: $e");
      }
    }
  }

  static Future<void> checkInternet() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      debugPrint("Internet is Connexted");
      isInternetConneted.value = true;
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      debugPrint("No Internet");

      isInternetConneted.value = false;
    }
  }
}
