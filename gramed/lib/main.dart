import 'package:flutter/material.dart';
import 'package:gramed/book/book.dart';
import 'package:gramed/home.dart';
import 'package:gramed/login.dart';
import 'package:gramed/splash_screen.dart';
import 'package:gramed/user/user.dart';


void main() => runApp(MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.blue,
    hoverColor: Colors.blue,
    hintColor: Colors.blue,
    focusColor: Colors.blue,
  ),
  debugShowCheckedModeBanner: false,
  title: "Gramedia",
  home: const Login()
));