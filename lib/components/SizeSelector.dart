import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quickresize/components/hwtTopView.dart';
import 'package:quickresize/provider/model.dart';
import 'package:gal/gal.dart';
import 'package:image/image.dart' as img;
import 'package:quickresize/styles/colors.dart';
import 'package:quickresize/styles/styles.dart';

Future<void> findOptimalQualityAndSave(img.Image image, int maxSizeKB) async {
  int quality = 100;
  Uint8List compressedImage = img.encodeJpg(image, quality: quality);
  int sizeInKB = (compressedImage.length / 1024).round();

  if (sizeInKB <= maxSizeKB) {
    await saveImage(compressedImage, quality);
    return;
  }

  int bestQuality = quality;
  Uint8List bestCompressedImage = compressedImage;
  int bestSize = sizeInKB;

  while (quality > 10) {
    quality -= 5;
    compressedImage = img.encodeJpg(image, quality: quality);
    sizeInKB = (compressedImage.length / 1024).round();

    if (sizeInKB <= maxSizeKB) {
      await saveImage(compressedImage, quality);
      return;
    }

    if (sizeInKB < bestSize) {
      bestSize = sizeInKB;
      bestQuality = quality;
      bestCompressedImage = compressedImage;
    }
  }

  await saveImage(bestCompressedImage, bestQuality);
}

Future<void> saveImage(Uint8List imageData, int quality) async {
  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/compressed_image.jpg';

  File file = File(filePath);
  await file.writeAsBytes(imageData);

  await Gal.putImage(filePath);

  print("Image saved to gallery with quality: $quality");
}

Future<int> reduceImageQualityTo10AndGetSizeKB(img.Image imgs) async {
  List<int> compressedBytes = img.encodeJpg(imgs, quality: 10);

  int sizeInKB = (compressedBytes.length / 1024).round();

  return sizeInKB;
}


Future<bool> _requestStoragePermission(BuildContext context) async {
  if (await Permission.manageExternalStorage.status.isGranted) {
    return true;
  }
  if (await Permission.photos.status.isGranted && await Permission.videos.status.isGranted && await Permission.audio.status.isGranted) {
    return true;
  }

  if (await Permission.manageExternalStorage.request().isGranted) {
    return true;
  }

  if (await Permission.photos.request().isGranted && await Permission.videos.request().isGranted && await Permission.audio.request().isGranted) {
    return true;
  }

  final apiLevel = await getAndroidSDKVersion();
  if (apiLevel >= 33) {
    // Android 13 (API 33) and later
    final photosStatus = await Permission.photos.request();
    final videosStatus = await Permission.videos.request();
    final audioStatus = await Permission.audio.request();

    if (photosStatus.isGranted && videosStatus.isGranted && audioStatus.isGranted) {
      return true;
    } else if (photosStatus.isDenied || videosStatus.isDenied || audioStatus.isDenied) {
      return await _showPermissionDialog(context);
    } else if (photosStatus.isPermanentlyDenied ||
        videosStatus.isPermanentlyDenied ||
        audioStatus.isPermanentlyDenied) {
      return await _showPermissionDialog(context);
    } else {
      return false;
    }
  } else {
    // Android 12 (API 32) and earlier
    final status = await Permission.storage.request();

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      return await _showPermissionDialog(context);
    } else if (status.isPermanentlyDenied) {
      return await _showPermissionDialog(context);
    } else {
      return false;
    }
  }
}

Future<bool> _showPermissionDialog(BuildContext context) async {
  bool? userResponse = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Storage Permission Required',
            style: TextStyle(color: Colors.white)),
        content: Text(
            'This app needs storage permission to download images. Please allow it in the app settings.',
            style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('Open Settings', style: TextStyle(color: Colors.lightBlue)),
            onPressed: () async {
              await openAppSettings();
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
  return userResponse ?? false;
}

Future<int> getAndroidSDKVersion() async {
  const MethodChannel methodChannel = MethodChannel('android_api_level');
  try {
    final int sdkVersion = await methodChannel.invokeMethod('getSDKInt');
    return sdkVersion;
  } catch (e) {
    print("error getting sdk version: $e");
    return 0;
  }
}

class SizeSelector extends StatefulWidget {
  final  imagge;
  const SizeSelector({super.key,required this.imagge});

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  @override

  Widget build(BuildContext context) {
    TextEditingController sizeController = TextEditingController();
    final stateProvider = Provider.of<StateProvider>(context);

    return Scaffold(
      floatingActionButton: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.sizeOf(context).height * 0.17,
                  right: MediaQuery.sizeOf(context).width * 0.04,
                ),
                child: Stack(
                  children: [
                    FloatingActionButton(
                      onPressed: ()async {
           
                      if(sizeController.text!=""){
                              final status = await _requestStoragePermission(context);
                        print("$status");
                        if(status==true){
                 var imgggg = await (  findOptimalQualityAndSave(widget.imagge,int.parse(sizeController.text) ));
                 showDialog(context: context, builder: (_)=>AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Resize Complete',
            style: TextStyle(color: Colors.white)),
        content: Text(
            'Image resized and saved to your photos app',
            style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            child: Text('Ok', style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          
        ],
      )  );
                   
                 }
                      }
                  
  
                      },
                      child: Icon(
                        Icons.send,
                        color: AppColors.buttonBackground,
                      ),
                      backgroundColor: AppColors.resizeButton,
                    ),
                  ],
                ),
              ),
              backgroundColor: AppColors.backgroud,

      body: SafeArea(
        child: FutureBuilder(
          future: reduceImageQualityTo10AndGetSizeKB(stateProvider.img.resizedImg),
          builder:(context, snapshot){ 
            if(snapshot.connectionState == ConnectionState.done){
            print('KB - ${snapshot.data}');
            return Column(
              children: [
                    Expanded(
                      flex: 1,
                      child: Image.file(
                        File(stateProvider.img.path),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    HWTopView(),
          
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.03,
               
                    ),
   
               
                                                   Container(
                                                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).height * 0.03,),
                                                    padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.07,),
                                                     child: TextField(
                                                       decoration: textfieldStyle(hintText: "Size no less than ${snapshot.data} KB"),
                                                       style: TextStyle(color: AppColors.defaultText),
                                                       keyboardType: TextInputType.number,
                                                       controller:sizeController ,
                                                       onChanged: (value) {
                                                  
                                                      
                                                       },
                                                       inputFormatters: <TextInputFormatter>[
                                                         FilteringTextInputFormatter.digitsOnly
                                                       ], 
                                                     ),
                                                   ),
                  ],
               
            
            );}
            else{
              return Text("");
            }
            }
            
        ),
      ),
    );
  }
}
