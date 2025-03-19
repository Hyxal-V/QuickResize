import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickresize/provider/model.dart';
import 'package:quickresize/styles/styles.dart';

class HWTopView extends StatefulWidget {
  const HWTopView({super.key});

  @override
  State<HWTopView> createState() => _HWTopViewState();
}

class _HWTopViewState extends State<HWTopView> {
  @override
  Widget build(BuildContext context) {
    final stateProvider = Provider.of<StateProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(
        alignment: Alignment.bottomLeft,
        margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*0.05,top: MediaQuery.sizeOf(context).height*0.02),
        child: Text("QuickResize",style: textDesigns.headText,)),
        Container(
         
         margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*0.06,top: MediaQuery.sizeOf(context).height*0.01),
         child: Text(stateProvider.uiState=="HW"?"Select Height and Width:":"Select Size in (KB)",style: textDesigns.basicPanelText,)),
    ],);
  }
}