// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_converter_macos/Constant/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogBoxRating {
  RxDouble finalRating = 0.0.obs;

  // static setinitScreen() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt("rateUs", 1);
  //   print("rate us");
  // }

  dialogRating(BuildContext context) {
    bool isArabicOrPersianOrHebrew = [
      'ar',
      'fa',
      'he',
    ].contains(Localizations.localeOf(context).languageCode);
    return showDialog(
      barrierDismissible: false,
      useRootNavigator: false,
      barrierColor: Colors.black.withOpacity(0.2),
      context: context,
      builder: (_) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(8),
          elevation: 4.0,
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 50,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
              Image.asset(
                "assets/logo.png",
                height: 70,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 45,
              ),
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.do_you_like,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${AppLocalizations.of(context)!.image} ${AppLocalizations.of(context)!.converter} ?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.we_are_working_hard,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.we_greatly_appreciate,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          content: SizedBox(
            height: 160,
            width: 400,
            child: Column(
              children: [
                Center(
                  child: Obx(
                    () => finalRating.value != 33
                        ? Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              itemBuilder: (context, _) =>
                                  finalRating.value == 0
                                      ? Image.asset("assets/Rating.png")
                                      : Image.asset("assets/Star.png"),
                              onRatingUpdate: (rating) {
                                finalRating.value = rating;
                                print("rating star: ${finalRating.value}");
                              },
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      AppLocalizations.of(context)!.the_best_we_can_get,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Transform.flip(
                        flipX: isArabicOrPersianOrHebrew == true ? true : false,
                        child: Image.asset(
                          "assets/arrow.png",
                          height: 40,
                          width: 50,
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    // setinitScreen();
                    if (finalRating.value > 0.0 && finalRating.value <= 5.0) {
                      Navigator.pop(context);

                      launch("macappstore://itunes.apple.com/app/6478107897");
                    }
                  },
                  child: Obx(
                    () => Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      decoration: BoxDecoration(
                          color: finalRating.value < 1
                              ? UiColors.buttonColor
                              : UiColors.lightblueColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6))),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.rate_us,
                          style: TextStyle(
                            color: finalRating.value < 1
                                ? UiColors.blackColor.withOpacity(0.5)
                                : UiColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
