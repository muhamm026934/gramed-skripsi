import 'package:shared_preferences/shared_preferences.dart';

class Service {

    static Future writeSR(
    String value,
    String idUsersApp,
    String nmUser,
    String username,
    String pasword,
    String pt,
    String alamat,
    String level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
     
  static Future getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
  
}