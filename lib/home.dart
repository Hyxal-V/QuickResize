import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quickresize/components/getImageButton.dart';
import 'package:quickresize/resizer.dart';
import 'package:quickresize/styles/colors.dart';
import 'package:quickresize/styles/styles.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroud,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 0,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(
                        left: MediaQuery.sizeOf(context).width * 0.05,
                        top: MediaQuery.sizeOf(context).height * 0.05),
                    child: Text(
                      "QuickResize",
                      style: textDesigns.headText,
                    ))),
            Expanded(
                flex: 0,
                child: Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.sizeOf(context).width * 0.06,
                        top: MediaQuery.sizeOf(context).height * 0.02),
                    child: Text(
                      "Press + to select an image to resize",
                      style: textDesigns.basicPanelText,
                    ))),
            getImageButton()
          ],
        ),
      ),
    );
  }
}
