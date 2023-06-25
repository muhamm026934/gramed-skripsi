import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gramed/web_custom_scroll_behavior.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.session}) : super(key: key);
  final String session;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late File filePickerVal;
  String txtFilePicker = "";
  selectFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
        setState(() {
          txtFilePicker = result.files.single.name;
          filePickerVal = File(result.files.single.path.toString());
        });
    } else {
      // User canceled the picker
    }    
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