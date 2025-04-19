import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickresize/provider/model.dart';
import 'package:quickresize/styles/colors.dart';
import 'package:quickresize/styles/styles.dart';

 class AspectRatioSelector extends StatefulWidget {

  const AspectRatioSelector({super.key});
  @override
  
  State<AspectRatioSelector> createState() => _AspectRatioSelectorState();
}

class _AspectRatioSelectorState extends State<AspectRatioSelector> {
      String selectedOption = 'Custom';

  
      TextEditingController heightController = TextEditingController();

      TextEditingController widthController = TextEditingController();


@override
void initState() {
  super.initState();
  heightController = TextEditingController();
  widthController = TextEditingController();
}

@override
void dispose() {
  heightController.dispose();
  widthController.dispose();
  super.dispose();
}
  Widget build(BuildContext context) {
    final stateProvider = Provider.of<StateProvider>(context);


    
    return GestureDetector(
      onTap: (){
   
      },
      child: Container(
        color: AppColors.backgroud,
      
        child: Padding(
          padding: EdgeInsets.only(left:  MediaQuery.sizeOf(context).width*0.08,right:  MediaQuery.sizeOf(context).width*0.1) ,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height:   MediaQuery.sizeOf(context).height*0.02,
              ),
              
              
              SizedBox(
                height:   MediaQuery.sizeOf(context).height*0.01,
              ),
                TextField(
  decoration: textfieldStyle(hintText: "Height"),
  style: TextStyle(color: AppColors.defaultText),
  keyboardType: TextInputType.number,
  controller: heightController,
  onChanged: (value) {
      if(value!=""){
    stateProvider.img.targetHeight = int.parse(value);
    print("Input Value: $value"); 
      }else{
    stateProvider.img.targetHeight = 0;

      }

 
  },
  inputFormatters: <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly
  ], 
),

                 SizedBox(
                height:   MediaQuery.sizeOf(context).height*0.02,
              ),
                TextField(decoration: textfieldStyle(hintText: "Width"),
                style: TextStyle(color: AppColors.defaultText),
                  keyboardType: TextInputType.number,
                controller: widthController,
             inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], 
                 onChanged: (value) {
      if(value!=""){
    stateProvider.img.targetWidth = int.parse(value);

      }  else{
    stateProvider.img.targetWidth = 0;

      }          
              
                  },
                ),
             SizedBox(
                height:   MediaQuery.sizeOf(context).height*0.03,
              ),
              SegmentedButton<String>(
                style:  ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.backgroud; 
        }
        return AppColors.buttonBackground; 
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.resizeButton; 
        }
        return Colors.white; 
      },
    ),
    iconColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        return states.contains(MaterialState.selected)
            ? AppColors.resizeButton 
            : Colors.grey; 
      },
    ),
  ),
                segments: <ButtonSegment<String>>[
                  ButtonSegment<String>(
                    value: 'Original',
                    label: Text('Original'),
                  ),
                  ButtonSegment<String>(
                    value: 'Custom',
                    label: Text('Custom'),
                    ),
                ],
                selected: {selectedOption},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    if(newSelection.last=='Original'){
            heightController.text = '${stateProvider.img.originalHeight}';                      
            widthController.text = '${stateProvider.img.originalWidth}';                      
              stateProvider.img.targetHeight = stateProvider.img.originalHeight;
              stateProvider.img.targetWidth = stateProvider.img.originalWidth;

                    }
                    selectedOption = newSelection.last;
                  });
                },
              ),
      
            ],
          ),
        ),
      ),
    );
  }
}