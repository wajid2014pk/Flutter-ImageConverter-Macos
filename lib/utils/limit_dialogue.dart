// import 'package:flutter/material.dart';
// // import 'package:flutter_image_converter/Constant/api_config.dart';
// // import 'package:flutter_image_converter/Constant/color.dart';
// // import 'package:flutter_image_converter/Constant/global.dart';
// // import 'package:flutter_image_converter/Controller/premium_controller.dart';
// // import 'package:flutter_image_converter/Screens/premium_screen.dart';
// import 'package:get/get.dart';
// import 'package:image_converter_macos/Constant/ai_config.dart';
// import 'package:image_converter_macos/Constant/color.dart';
// import 'package:image_converter_macos/Constant/global.dart';
// import 'package:image_converter_macos/Controller/PremiumPopUpController/premium_controller.dart';
// import 'package:image_converter_macos/Screens/premium_popup.dart';
// import 'package:lottie/lottie.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// limitDialogue(BuildContext context) {
//   return showDialog(
//       barrierDismissible: false,
//       useRootNavigator: false,
//       barrierColor: Colors.black.withOpacity(0.2),
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(builder: (context, setState) {
//           return const LimitDialog();
//         });
//       });
// }

// class LimitDialog extends StatefulWidget {
//   const LimitDialog({super.key});

//   @override
//   State<LimitDialog> createState() => _LimitDialogState();
// }

// class _LimitDialogState extends State<LimitDialog> {
//   // PremiumController premiumController = Get.find<PremiumController>();
//   final payWallController = Get.put(PayWallController());
//   @override
//   void initState() {
//     super.initState();

//     if (payWallController.offerings == null) {
//       payWallController.getProductsPrice();
//     }
//     AIHandler.checkInternet();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       surfaceTintColor: Colors.white,
//       insetPadding: const EdgeInsets.all(8),
//       elevation: 4.0,
//       title: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     bottom: 0,
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                       Get.to(() =>
//                           PremiumPopUp().premiumScreenPopUp(Get.context!));
//                     },
//                     child: const Icon(
//                       Icons.close,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: SizedBox(
//                 child: Lottie.asset(
//                   "assets/lottie/photo limit.json",
//                   width: 120,
//                   height: 120,
//                 ),
//               ),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 2.0),
//                   child: Text(
//                     // AppLocalizations.of(Get.context!)!.free_limit_reached,
//                     "Free limit reached!",
//                     style:
//                         const TextStyle(color: Color(0xff374151), fontSize: 16),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: Text(
//                     // AppLocalizations.of(Get.context!)!
//                     //     .upgrade_to_unlock_all_premium_features,
//                     "Upgrade to unlock all premium features",
//                     style:
//                         const TextStyle(color: Color(0xff374151), fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       content: Container(
//         height: 40,
//         width: MediaQuery.of(context).size.width / 4,
//         padding: const EdgeInsets.only(left: 5, right: 5),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               elevation: 0.0, backgroundColor: const Color(0xff374151)),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Lottie.asset(
//                 'assets/lottie/lote.json',
//                 width: 20,
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 // AppLocalizations.of(Get.context!)!.try_premium,
//                 "Try premium",
//                 style: const TextStyle(color: Colors.white, fontSize: 17),
//               ),
//             ],
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             if (isInternetConneted.value == true) {
//               payWallController.selectPackage.value = 1;
//               payWallController.makePurchase();
//             } else {
//               Get.snackbar(
//                   backgroundColor: UiColors.whiteColor,
//                   duration: const Duration(seconds: 4),
//                   AppLocalizations.of(Get.context!)!.attention,
//                   // AppLocalizations.of(Get.context!)!
//                   //     .please_check_your_internet_connection,
//                   "Please check your internet connection");
//             }
//             // Get.to(() => const PremiumPage());
//           },
//         ),
//       ),
//     );
//   }
// }
