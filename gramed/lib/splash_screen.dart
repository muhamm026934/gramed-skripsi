import 'package:flutter/material.dart';
import 'package:gramed/page_routes.dart';
import 'package:gramed/service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
     _getPref();
    super.initState();
  }

  late String value = "";
  late String idUsersApp = "";
  late String name = "";
  late String username = "";
  late String password = "";
  late String address = "";
  late String level = "";
  late String email = "";
  late String noTelp = "";
  late String token = "";

  Future<void> _getPref() async {
    Service.getPref().then((preferences) {
      setState(() {
        value = preferences.getString('value');
        idUsersApp = preferences.getString('idUsersApp');
        name = preferences.getString('name');
        username = preferences.getString('username');
        password = preferences.getString('password');
        address = preferences.getString('address');
        level = preferences.getString('level');
        email = preferences.getString('email');
        noTelp = preferences.getString('noTelp');
        token = preferences.getString('token');
        if (name == "") {
          PageRoutes.routeToLogin(context);
        }else{
          PageRoutes.routeToHome(context);
        }
      });
    });
  }
   
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.blue,
          color: Colors.white,
        ),
      ),
    );
  }
}