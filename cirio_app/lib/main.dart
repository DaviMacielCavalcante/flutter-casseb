import 'package:cirio_app/screens/map_screen.dart';
import 'package:cirio_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: "Onde a Santa está?",
    debugShowCheckedModeBanner: false,
    home: WelcomeScreen(),
  ));
}