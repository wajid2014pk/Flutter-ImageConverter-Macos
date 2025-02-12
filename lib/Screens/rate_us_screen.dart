import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:image_converter_macos/Presentation/rating_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RateUs extends StatefulWidget {
  const RateUs({
    super.key,
  });

  @override
  State<RateUs> createState() => _RateUsState();
}

class _RateUsState extends State<RateUs> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      DialogBoxRating().dialogRating(Get.context!);
    });

    super.initState();
  }

  launchURLFunction(String url) async {
    final Uri params = Uri(
      scheme: 'https',
      path: url,
    );
    launchUrl(params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.backgroundColor,
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.rate_us,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
