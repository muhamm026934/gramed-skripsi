import 'package:flutter/material.dart';
import 'package:gramed/service.dart';
import 'package:gramed/web_custom_scroll_behavior.dart';

class Homes extends StatefulWidget {
  const Homes({Key? key, required this.session}) : super(key: key);
  final String session;

  @override
  State<Homes> createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  @override
  void initState() {
    super.initState();
    _getPref();
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
      });
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            obscureText: false,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)
              ),
              label: Text("Pencarian Judul Buku, Pengarang dan Penerbit",style: TextStyle(fontSize: 10,color: Colors.white),),
            ),                
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:8.0,right: 8.0,left: 8.0),
                  child: SizedBox(
                    height: 100,
                    child: ScrollConfiguration(
                      behavior: WebCustomScrollBehavior(),
                      child: ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index)=> 
                        Card(
                          color: Colors.blue,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Center(
                              child: Text("Buku $index"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0,right: 8.0,left: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 1,
                      child: ScrollConfiguration(
                        behavior: WebCustomScrollBehavior(),
                        child: ListView.builder(
                          itemCount: 20,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context,index)=> 
                          Card(
                            color: Colors.blue,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Center(
                                child: Text("Buku $index"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),                  
              ],
            )
          ],
        ),
      ),
    );
  }
}