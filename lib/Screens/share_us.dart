import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      await Share.share('https://apps.apple.com/us/app/6673897269');
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
      body: Center(
        child: Text(
          "Share Us",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
