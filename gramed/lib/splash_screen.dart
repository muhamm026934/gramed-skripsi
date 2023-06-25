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
  late String nmUser = "";
  late String username = "";
  late String pasword = "";
  late String pt = "";
  late String alamat = "";
  late String level = "";

  Future<void> _getPref() async {
    Service.getPref().then((preferences) {
      setState(() {
        value = preferences.getString('value').toString();
        idUsersApp = preferences.getString('idUsersApp').toString();
        nmUser = preferences.getString('nmUser').toString();
        username = preferences.getString('username').toString();
        pasword = preferences.getString('pasword').toString();
        pt = preferences.getString('pt').toString();
        alamat = preferences.getString('alamat').toString();
        level = preferences.getString('level').toString();

        if (value == "1") {
          PageRoutes.routeToHome(context);                    
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