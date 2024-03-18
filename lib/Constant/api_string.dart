import 'package:dio/dio.dart';

class ApiString {
  static String apiUrl = "https://theonlineconverter.com/api/data";
  static Options options = Options(
    sendTimeout: const Duration(seconds: 60 * 1000),
    receiveTimeout: const Duration(seconds: 60 * 1000),
  );
}
