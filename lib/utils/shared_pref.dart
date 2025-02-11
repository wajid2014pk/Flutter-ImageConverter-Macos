import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<void> setToolValue(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('toolValue', value);
  }

  Future<int> getToolValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('toolValue') ?? 0;
  }

  //  --------------------------------  Webp -10
  Future<void> setWEBPValue(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('webpLimit', value);
  }

  Future<int> getWEBPValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('webpLimit') ?? 0;
  }
//  --------------------------------  Svg -10

  Future<void> setSVGValue(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('svgLimit', value);
  }

  Future<int> getSVGValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('svgLimit') ?? 0;
  }

//  --------------------------------  Bmp -10

  Future<void> setBmpLimit(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bmpLimit', value);
  }

  Future<int> getBmpLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('bmpLimit') ?? 0;
  }

//  --------------------------------  Tiff -5

  Future<void> setTiffLimit(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tiffLimit', value);
  }

  Future<int> getTiffLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('tiffLimit') ?? 0;
  }
//  --------------------------------  Raw -5

  Future<void> setRawLimit(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rawLimit', value);
  }

  Future<int> getRawLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('rawLimit') ?? 0;
  }
//  --------------------------------  PSD -5

  Future<void> setPsdLimit(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('psdLimit', value);
  }

  Future<int> getPsdLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('psdLimit') ?? 0;
  }
//  --------------------------------  DDS -5

  Future<void> setDdsLimit(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ddsLimit', value);
  }

  Future<int> getDdsLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('ddsLimit') ?? 0;
  }
//  --------------------------------  HEIC -5

  Future<void> setHeicLimit(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('heicLimit', value);
  }

  Future<int> getHeicLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('heicLimit') ?? 0;
  }
//  --------------------------------  PPM -5

  Future<void> setPpmLimit(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ppmLimit', value);
  }

  Future<int> getPpmLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('ppmLimit') ?? 0;
  }
//  --------------------------------  TGA -5

  Future<void> setTgaLimit(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tgaLimit', value);
  }

  Future<int> getTgaLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('tgaLimit') ?? 0;
  }

  Future<void> setExcelLimit(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('excelLimit', value);
  }

  Future<int> getExcelLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('excelLimit') ?? 0;
  }
}
