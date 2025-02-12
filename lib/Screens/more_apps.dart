import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreApp extends StatefulWidget {
  const MoreApp({
    super.key,
  });

  @override
  State<MoreApp> createState() => _MoreAppState();
}

class _MoreAppState extends State<MoreApp> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      // launchUrl(Uri.parse("https://apps.apple.com/us/app/1608350899"));
      launchUrl(Uri.parse(
          "https://apps.apple.com/us/developer/asad-ahsan/id1326954499"));
    });

    super.initState();
  }

  // launchURLFunction(String url) async {
  //   final Uri params = Uri(
  //     scheme: 'https',
  //     path: url,
  //   );
  //   launchUrl(params);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.backgroundColor,
      body: Center(
        child: Text(
          "More Apps",
          // AppLocalizations.of(context)!.privacy_policy,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
