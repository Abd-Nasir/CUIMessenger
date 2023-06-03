import 'dart:async';
import 'dart:io';

import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/notification/model/pdf_viewer_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:folder_file_saver/folder_file_saver.dart';
import 'package:open_filex/open_filex.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerOnline extends StatefulWidget {
  final PDFViewerPage pdf;
  const PdfViewerOnline({Key? key, required this.pdf}) : super(key: key);

  @override
  State<PdfViewerOnline> createState() => _PdfViewerOnlineState();
}

class _PdfViewerOnlineState extends State<PdfViewerOnline> {
  bool isLoading = true;
  // PDFDocument? doc;

  String remotePDFpath = "";

  //PDF View Items
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
        isLoading = false;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    debugPrint("Start download file from internet!");
    try {
      String url = widget.pdf.url;
      final String filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      debugPrint("Download files");
      // debugPrint("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  // Future<void> loadPDF() async {
  //   try {
  //     doc = await PDFDocument.fromURL(
  //       "https://app.ecobeam.eu/images/20220906211455-AGB'S-deutsch-ECB.pdf",
  //     );
  //     if (doc != null) {
  //       debugPrint("Inside doc loaded.\n${doc!.count}");
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (error) {
  //     debugPrint("Error occured in loading PDF:\n $error");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.cuiPurple,
        onPressed: () async {
          File checkFile = File(
              "/storage/emulated/0/Documents/CUI Messenger /Documents/${widget.pdf.fileName}");

          if (await checkFile.exists()) {
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
            var response = await Dio().get(widget.pdf.url,
                options: Options(responseType: ResponseType.bytes));

            // final iosDirectory =
            //     await getApplicationSupportDirectory();
            final dir = Platform.isIOS
                ? await getApplicationSupportDirectory()
                : await getApplicationDocumentsDirectory();
            File savedFile = await File("${dir.path}/${widget.pdf.fileName}")
                .writeAsBytes(response.data);

            if (Platform.isAndroid) {
              final result1 = await FolderFileSaver.saveFileIntoCustomDir(
                  dirNamed: "/Documents",
                  filePath: savedFile.path,
                  removeOriginFile: true);

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
              OpenFilex.open(savedFile.path);
              // final open = OpenFile.open(savedFile.path);
              // print(open.toString());
            }
          }
        },
        child: const Icon(Icons.download_for_offline),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.04,
                  vertical: mediaQuery.size.height * 0.02),
              margin: EdgeInsets.only(
                left: mediaQuery.size.width * 0.04,
                right: mediaQuery.size.width * 0.04,
                top: mediaQuery.size.height * 0.01,
                bottom: mediaQuery.size.height * 0.01,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        RouteGenerator.navigatorKey.currentState!.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Palette.black,
                    ),
                  ),
                  SizedBox(width: mediaQuery.size.width * 0.04),
                  Text(
                    widget.pdf.fileName,
                    style: const TextStyle(
                      color: Palette.cuiPurple,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Palette.cuiPurple,
                    ),
                  )
                : Expanded(
                    child: PDFView(
                      filePath: remotePDFpath,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageFling: true,
                      pageSnap: true,
                      defaultPage: currentPage!,
                      fitPolicy: FitPolicy.BOTH,
                      preventLinkNavigation:
                          false, // if set to true the link is handled in flutter
                      onRender: (pages) {
                        setState(() {
                          pages = pages;
                          isReady = true;
                        });
                      },
                      onError: (error) {
                        setState(() {
                          errorMessage = error.toString();
                        });
                        debugPrint(error.toString());
                      },
                      onPageError: (page, error) {
                        setState(() {
                          errorMessage = '$page: ${error.toString()}';
                        });
                        debugPrint('$page: ${error.toString()}');
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onLinkHandler: (String? uri) {
                        debugPrint('goto uri: $uri');
                      },
                      onPageChanged: (int? page, int? total) {
                        debugPrint('page change: $page/$total');
                        setState(() {
                          currentPage = page;
                        });
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
