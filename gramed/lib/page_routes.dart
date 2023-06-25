import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gramed/home.dart';
import 'package:gramed/login.dart';

class PageRoutes {

    static routeToHome(context) async {
    var duration = const Duration(milliseconds: 10);
    return Timer(duration, (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
        return const Home(session: 'home');
      }));
    });
  } 
  static routeToLogin(context) async {
    var duration = const Duration(milliseconds: 10);
    return Timer(duration, (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
        return const Login();
      }));
    });
  }   
  
}