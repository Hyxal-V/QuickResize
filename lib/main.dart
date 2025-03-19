import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickresize/home.dart';
import 'package:quickresize/styles/colors.dart';

import 'package:quickresize/provider/model.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StateProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
debugShowCheckedModeBanner: false ,
      home: const SafeArea(child: Home()),
    );
  }
}
