import 'package:flutter/material.dart';
import 'package:gramed/home.dart';
import 'package:gramed/midtrans.dart';
import 'package:gramed/splash_screen.dart';



void main() => runApp(MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.blue,
    hoverColor: Colors.blue,
    hintColor: Colors.blue,
    focusColor: Colors.blue,
  ),
  debugShowCheckedModeBanner: false,
  title: "Gramedia",
  home: const Home(session: '',user: '',trans: "")
));