import 'package:flutter/material.dart';
import 'package:gramed/page_routes.dart';
import 'package:gramed/service.dart';
import 'package:gramed/user/customAlertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPasword = TextEditingController();

  late bool _loading;
  String message = "", values = "";
  
  showMyDialog(title,content,backgroundColor,onPressedOks,onPressedNotOKs,textButtonOK,textButtonNotOK,textColor,buttonColorOk,buttonColorNotOK) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
        title: title, 
        content: content, 
        backgroundColor: backgroundColor, 
        onPressedOk: onPressedOks, 
        onPressedNotOK: onPressedNotOKs, 
        textButtonOK: textButtonOK, 
        textButtonNotOK: textButtonNotOK,
        textColor: textColor,
        buttonColorOk:buttonColorOk,
        buttonColorNotOK:buttonColorNotOK,
      )
    );
  }

  _pageRoutesAfterLogin(){
    PageRoutes.routeToHome(context);
  }

  _logins(username,password) async{
    setState(() {
      _loading = true;
    });
    Service.logins(username,password).then((valueUser) async {
      setState(() {
        message = valueUser['message'];
        values = valueUser['value'];
        _loading = false;                             
      });
      switch (values) {
        case "1":
          String values = valueUser['value'].toString();
          String idUsersApps = valueUser['id_user'].toString();
          String names = valueUser['name'].toString();
          String usernames = valueUser['username'].toString();
          String passwords = valueUser['password'].toString();
          String addresss = valueUser['address'].toString();
          String levels = valueUser['level'].toString();
          String emails = valueUser['email'].toString();
          String noTelps = valueUser['no_telp'].toString();
          String tokens = valueUser['token'].toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('value', values);
          prefs.setString('idUsersApp', idUsersApps);
          prefs.setString('name', names);           
          prefs.setString('username', usernames);
          prefs.setString('password', passwords);
          prefs.setString('address', addresss);
          prefs.setString('level', levels);
          prefs.setString('email', emails);
          prefs.setString('noTelp', noTelps);
          prefs.setString('token', tokens);  
          Service.writeSR(
            values, 
            idUsersApps, 
            names, 
            usernames, 
            passwords,
            addresss, 
            levels, 
            emails, 
            noTelps, 
            tokens).then((prefs) {
          prefs.setString('value', values);
          prefs.setString('idUsersApp', idUsersApps);
          prefs.setString('name', names);           
          prefs.setString('username', usernames);
          prefs.setString('password', passwords);
          prefs.setString('address', addresss);
          prefs.setString('level', levels);
          prefs.setString('email', emails);
          prefs.setString('noTelp', noTelps);
          prefs.setString('token', tokens);  

          _pageRoutesAfterLogin();
             });          
          break;          
        default:
          showMyDialog(
            "",
            message,
            values == "1"? Colors.greenAccent : Colors.red ,
            (){ Navigator.pop(context, 'Cancel'); },
            (){ Navigator.pop(context, 'Cancel'); },
            "Close","",
            Colors.white,
            Colors.black,      
            Colors.red,      
          );                
      }  
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controllerUsername,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Username'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controllerPasword,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Password'),
                      ),
                    ),
                  ),   
                  Padding(
                    padding: const EdgeInsets.only(top:20.0,right: 8.0,left: 8.0),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            surfaceTintColor: Colors.blue,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                            ), child: const Text('Login',style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              _logins(controllerUsername.text,controllerPasword.text);
                            },
                          ),
                        ),
                      ],
                    ),
                  )               
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}