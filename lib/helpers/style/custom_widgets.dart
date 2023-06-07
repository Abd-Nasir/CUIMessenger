import 'dart:io';

import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:folder_file_saver/folder_file_saver.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';

class CustomWidgets {
  static BoxDecoration textInputDecoration = BoxDecoration(
      color: Palette.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Palette.cuiPurple.withOpacity(0.25),
          blurRadius: 8.0,
          offset: const Offset(0.0, 2.0),
        ),
      ]);

  static BoxDecoration buttonDecoration = BoxDecoration(
      color: Palette.cuiPurple,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Palette.cuiPurple.withOpacity(0.25),
          blurRadius: 8.0,
          offset: const Offset(0.0, 2.0),
        ),
      ]);

  static GestureDetector textButton(
      {required String text,
      required MediaQueryData mediaQuery,
      double? borderRadius,
      Color? color,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: mediaQuery.size.width,
        padding: EdgeInsets.symmetric(
          vertical: mediaQuery.size.height * 0.02,
        ),
        decoration: BoxDecoration(
            color: color ?? Palette.cuiPurple,
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            boxShadow: [
              BoxShadow(
                color: Palette.cuiBlue.withOpacity(0.25),
                blurRadius: 8.0,
                offset: const Offset(0.0, 2.0),
              ),
            ]),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Palette.white,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static dialogBox(
      {required BuildContext context,
      required MediaQueryData mediaQuery,
      required String text,
      required String buttonText,
      required Color color,
      required IconData icon,
      void Function()? onTap}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Icon(icon, color: color, size: 60),
            content: Text(text, textAlign: TextAlign.center),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              InkWell(
                onTap: onTap,
                child: Container(
                  width: 100,
                  padding: EdgeInsets.symmetric(
                      vertical: mediaQuery.size.height * 0.02,
                      horizontal: mediaQuery.size.width * 0.02),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0.0, 2.0),
                        blurRadius: 16.0,
                        color: color.withOpacity(0.15),
                      )
                    ],
                  ),
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Palette.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  static void saveFile(
      {required String fileUrl, required String fileName}) async {
    //  onTap: () async {
    print("ontap");
    File checkFile = File(
        "/storage/emulated/0/Documents/CUI Messenger /Documents/$fileName");

    if (await checkFile.exists()) {
      print("exists");
      showSimpleNotification(
        const Text(
          "document-already-saved",
          style: TextStyle(
            color: Palette.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Palette.orange.withOpacity(0.9),
        slideDismissDirection: DismissDirection.startToEnd,
      );
    } else {
      var response = await Dio()
          .get(fileUrl, options: Options(responseType: ResponseType.bytes));
      print("Response: $response");
      // final iosDirectory =
      //     await getApplicationSupportDirectory();
      final dir = Platform.isIOS
          ? await getApplicationSupportDirectory()
          : await getApplicationDocumentsDirectory();
      print(dir.path);
      File savedFile =
          await File("${dir.path}/$fileName").writeAsBytes(response.data);

      if (Platform.isAndroid) {
        final result1 = await FolderFileSaver.saveFileIntoCustomDir(
            dirNamed: "/Documents",
            filePath: savedFile.path,
            removeOriginFile: true);
        print(result1);
        if (result1 != null) {
          showSimpleNotification(
            const Text(
              "Document already saved in app directory!",
              style: TextStyle(
                color: Palette.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Palette.green.withOpacity(0.9),
            slideDismissDirection: DismissDirection.startToEnd,
          );
        }
      }
    }
    // },
  }

  static GestureDetector iconButton(
      {required String path, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        decoration: BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Palette.cuiBlue.withOpacity(0.25),
                blurRadius: 8.0,
                offset: const Offset(0.0, 2.0),
              ),
            ]),
        child: SvgPicture.asset(path),
      ),
    );
  }
}
