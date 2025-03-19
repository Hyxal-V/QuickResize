import 'dart:io';

import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier{
  
  late Photo img;
  String uiState = "HW";
 // String resizeState = "getInput"; //getInput,resizing,resized
void setPhoto({required String path,required int originalHeight,required int originalWidth,required targetHeight,required targetWidth}){
  img = Photo(path: path, originalHeight: originalHeight, originalWidth: originalWidth,targetHeight:targetHeight,targetWidth: targetWidth);
  
}

}
class Photo{
  int targetWidth;
  int targetHeight;
 final int originalWidth;
 final int originalHeight;
 late var resizedImg;

 final String path;
 Photo({required this.path,required this.originalHeight,required this.originalWidth,required this.targetHeight,required this.targetWidth});
 void outputInfo(){
  //print('targetWidth:$targetWidth');
  //print('targetHeight:$targetHeight');
  print('originalWidth:$originalWidth');
  print('originalHeight: $originalHeight');
 }
}