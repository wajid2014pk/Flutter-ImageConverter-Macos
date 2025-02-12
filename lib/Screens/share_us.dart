import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShareUs extends StatefulWidget {
  const ShareUs({
    super.key,
  });

  @override
  State<ShareUs> createState() => _ShareUsState();
}

class _ShareUsState extends State<ShareUs> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () async {
      await Share.share(
          '${"Hey, download the app now"}!= https://apps.apple.com/us/app/1608350899');
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
          "Share Us",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
