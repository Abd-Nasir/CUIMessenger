import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cui_messenger/chat/constants/message_enum.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/widgets/play_audio.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/widgets/show_file_preview.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:any_link_preview/any_link_preview.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String photoUrl;
  final String message;
  final MessageEnum type;
  final bool isSender;
  final String? date;
  DisplayTextImageGIF({
    Key? key,
    required this.photoUrl,
    required this.message,
    required this.type,
    required this.isSender,
    this.date,
  }) : super(key: key);

  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final imageProvider = CachedNetworkImageProvider(message);

    return type == MessageEnum.link
        ? AnyLinkPreview(
            link: message,
            displayDirection: UIDirection.uiDirectionHorizontal,
            showMultimedia: true,
            bodyMaxLines: 5,
            bodyTextOverflow: TextOverflow.ellipsis,
            titleStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            placeholderWidget: Text(
              message,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 141, 181, 250)),
            ),
            errorWidget: TextButton(
              onPressed: () {
                _launchUrl(message);
              },
              child: Text(
                message,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 141, 181, 250)),
              ),
            ),
            bodyStyle: const TextStyle(color: Colors.black, fontSize: 12),
            // errorBody: 'Show my custom error body',
            // errorTitle: 'Show my custom error title',
            // errorWidget: Container(
            //     color: Colors.grey[300],
            //     child: const Text('Oops!'),
            // ),
            // errorImage: "https://google.com/",
            cache: const Duration(days: 7),
            backgroundColor: Colors.white,
            borderRadius: 12,
            removeElevation: false,
            // boxShadow: [const BoxShadow(blurRadius: 3, color: Colors.white)],
            onTap: () {
              _launchUrl(message);
            }, // This disables tap event
          )
        : type == MessageEnum.text
            ? message == "/////TYPINGZK????"
                ? SizedBox(
                    width: 80,
                    child: JumpingDots(
                      color: isSender
                          ? (Colors.white.withOpacity(0.4))
                          : Palette.cuiPurple.withOpacity(0.4),
                      radius: 8,
                      numberOfDots: 3,
                    ),
                  )
                : TextSelectionTheme(
                    // primaryColor: Colors.red,
                    data: TextSelectionThemeData(
                      // cursorColor: Colors.red,
                      selectionColor: isSender
                          ? (Colors.white.withOpacity(0.4))
                          : Palette.cuiPurple.withOpacity(0.4),
                      selectionHandleColor: Colors.red,
                    ),
                    child: Text(
                      message,

                      // cursorColor: Colors.white,
                      // showCursor: true,

                      // selectionControls: Se,
                      // toolbarOptions:
                      //     const ToolbarOptions(copy: true, selectAll: true),
                      style: TextStyle(
                          fontSize: 16,
                          color: date != null
                              ? date == "null"
                                  ? Colors.grey
                                  : isSender
                                      ? Colors.white
                                      : Colors.black
                              : isSender
                                  ? Colors.white
                                  : Colors.black),
                    ),
                  )
            : type == MessageEnum.audio
                ? PlayAudio(
                    photoUrl: photoUrl,
                    audioUrl: message,
                    isSender: isSender,
                  )
                : type == MessageEnum.file
                    ? SizedBox(
                        width: size.width / 1.8,
                        child: ShowFilePreview(
                          url: message,
                          isSender: isSender,
                        ),
                      )
                    // : type == MessageEnum.gif
                    //             ? CachedNetworkImage(
                    //                 imageUrl: message,
                    //               )
                    : SizedBox(
                        width: size.width / 1.8,
                        height: 300,
                        child: InkWell(
                          onTap: () {
                            showImageViewer(context, imageProvider,
                                onViewerDismissed: () {
                              print("dismissed");
                            });
                          },
                          child: CachedNetworkImage(
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            placeholderFadeInDuration: Duration.zero,
                            imageUrl: message,
                            height: 300,
                            width: size.width / 1.8,
                            fit: BoxFit.fitWidth,
                            // placeholder: (context, url) =>
                            //     Image.asset("assets/placeholder.jpg"),
                            progressIndicatorBuilder: (context, url, progress) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset("assets/placeholder.jpg"),
                                  CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
  }

  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
