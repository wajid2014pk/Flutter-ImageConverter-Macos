import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FeedBack extends StatefulWidget {
  const FeedBack({
    super.key,
  });

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      {
        final Uri params = Uri(
          scheme: 'mailto',
          path: 'mailto:eclix.suport@gmail.com',
          query: 'subject=Image Converter Feedback',
        );
        launchUrl(params);
      }
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
         AppLocalizations.of(context)!.feedback,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
