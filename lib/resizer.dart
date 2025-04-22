import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui; // Import ui for decodeImageFromList

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickresize/components/SizeSelector.dart';
import 'package:quickresize/components/aspectRatioSelector.dart';
import 'package:quickresize/components/hwtTopView.dart';
import 'package:quickresize/provider/model.dart';
import 'package:quickresize/styles/colors.dart';
import 'package:image/image.dart' as img;

Future<ui.Image> getWidthHeight({required String path}) async {
  File file = File(path);
  Uint8List bytes = await file.readAsBytes();
  ui.Image decodedImage = await decodeImageFromList(bytes);
  return decodedImage;
}

class ResizePanel extends StatefulWidget {
  final FilePickerResult image;
  const ResizePanel({super.key, required this.image});

  @override
  State<ResizePanel> createState() => _ResizePanelState();
}

class _ResizePanelState extends State<ResizePanel> {
  @override
  Widget build(BuildContext context) {
    final stateProvider = Provider.of<StateProvider>(context);

    return FutureBuilder<ui.Image>(
      // Specify FutureBuilder type
      future: getWidthHeight(
          path: widget.image.files.first.path!), // Use non-nullable path
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            ui.Image decodedImage = snapshot.data!; // Use non-null operator
            stateProvider.setPhoto(
              path: widget.image.files.first.path!, // Use non-nullable path
              originalHeight: decodedImage.height,
              originalWidth: decodedImage.width,
              targetHeight: 0,
              targetWidth: 0,
            );
            //stateProvider.img.outputInfo();

            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.file(
                        File(widget.image.files.first.path!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    HWTopView(),
                    AspectRatioSelector(),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.03,
                    ),
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.06,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (stateProvider.img.targetHeight == 0 ||
                              stateProvider.img.targetWidth == 0) {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      backgroundColor: AppColors.backgroud,
                                      title: Text('Error',
                                          style: TextStyle(
                                              color: AppColors.defaultText)),
                                      content: Text(
                                          'Height and Width cannot be 0',
                                          style: TextStyle(
                                              color: AppColors.defaultText)),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Ok',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.defaultText)),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ],
                                    ));
                          } else if (stateProvider.img.targetHeight >= 3000 ||
                              stateProvider.img.targetWidth >= 3000) {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      backgroundColor: AppColors.backgroud,
                                      title: Text('Error',
                                          style: TextStyle(
                                              color: AppColors.defaultText)),
                                      content: Text(
                                          'Height and Width cannot be 3000 or greater',
                                          style: TextStyle(
                                              color: AppColors.defaultText)),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Ok',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.defaultText)),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ],
                                    ));
                          } else {
                            setState(() {
                              //   if (stateProvider.uiState == "HW") {
                              var image = img.decodeImage(
                                  File(stateProvider.img.path)
                                      .readAsBytesSync());
                              stateProvider.img.resizedImg = img.copyResize(
                                  image!,
                                  width: stateProvider.img.targetWidth,
                                  height: stateProvider.img.targetHeight);
                              print('well ${stateProvider.img.resizedImg}');
                              stateProvider.uiState = "BS";
                              //    print(stateProvider.img.resizedImg);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SizeSelector(
                                          imagge: stateProvider.img.resizedImg,
                                        )),
                              );
                            }
                                // }
                                );
                          }
                          //  print(stateProvider.img.targetHeight);
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                              color: AppColors.defaultText,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.nextButton,
                          shape: RoundedRectangleBorder(
                            // Rounded corners
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    // SizeSelector(),
                  ],
                ),
              ),
              backgroundColor: AppColors.backgroud,
            );
          } else if (snapshot.hasError) {
            return Text(
                'Error loading image: ${snapshot.error}'); // Handle error
          } else {
            return Text('No image data'); // Handle no data
          }
        } else {
          return Center(
              child: CircularProgressIndicator()); // Show loading indicator
        }
      },
    );
  }
}
