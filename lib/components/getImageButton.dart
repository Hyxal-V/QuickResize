import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quickresize/resizer.dart';
import 'package:quickresize/styles/colors.dart';
import 'package:quickresize/styles/styles.dart';

class getImageButton extends StatelessWidget {
  const getImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    
    return  Expanded(
            flex: 7,
            child: 
             Container(
            margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height*0.05,left: MediaQuery.sizeOf(context).width*0.09,right: MediaQuery.sizeOf(context).width*0.09,bottom:MediaQuery.sizeOf(context).height*0.05),
            child: GestureDetector(
              onTap: (){
                   showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height:  MediaQuery.sizeOf(context).height*0.15,
                    color: AppColors.backgroud,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                   //    ListTile(title: Text("Camera",style: textDesigns.basicPanelText,),leading: Icon(Icons.camera_alt,size: 30,),
                   //    onTap:()=> Navigator.pop(context),
                   //    ),
                       ListTile(
                       onTap:()async{ 
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
          allowedExtensions: ['jpg', 'png'],
                        );
                        if(result!=null){
               Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResizePanel(image: result,)),
        );
                        }
         
                       },
                        title: Text("Select File",style: textDesigns.basicPanelText,),leading: Icon(Icons.folder_copy,size: 30,),)
        
                        ],
                      ),
                    ),
                  );
                },
              );
              },
              child: Container(child: Center(child: Icon(Icons.add,color: AppColors.defaultText,size: 130,),
            
            ),
            
            decoration: BoxDecoration(  color: AppColors.buttonBackground, // Background color
          borderRadius: BorderRadius.circular(50), ),))));
  }
}