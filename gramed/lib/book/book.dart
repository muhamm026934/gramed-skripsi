import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gramed/api/postlist.dart';
import 'package:gramed/service.dart';
import 'package:gramed/web_custom_scroll_behavior.dart';

class Book extends StatefulWidget {
  const Book({Key? key, required this.session}) : super(key: key);
  final String session;

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  
  @override
  void initState() {
    super.initState();
    _getPref();
    _getDataBuku("","","","","");
    _loading;
  }

  bool _loading = false ;
  late String value = "";
  late String idUsersApp = "";
  late String nmUser = "";
  late String username = "";
  late String password = "";
  late String tokenUsers = "";
  late String userFoto = "";
  late String telp = "";
  late String email = "";
  late String level = "";

  Future<void> _getPref() async {
    Service.getPref().then((preferences) {
      setState(() {
        value = preferences.getString('value');
        idUsersApp = preferences.getString('idUsersApp');
        nmUser = preferences.getString('nmUser');
        username = preferences.getString('username');
        password = preferences.getString('password');
        tokenUsers = preferences.getString('tokenUsers');
        userFoto = preferences.getString('userFoto');
        telp = preferences.getString('telp');
        email = preferences.getString('email');
        level = preferences.getString('level');
      });
    });
  }

  late File filePickerVal;
  String txtFilePicker = "";
  selectFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      );
    
    if (result != null) {
        setState(() {
          txtFilePicker = result.files.single.name;
          filePickerVal = File(result.files.single.path.toString());
          print(filePickerVal);
        });
    } else {
      // User canceled the picker
    }    
  }

  clearFile(){
    setState(() {
      txtFilePicker = "";
    });
  }

  TextStyle _customFont() {
  return const TextStyle(color: Colors.white);
  }

  Color _colorIcon() {
    return Colors.white;
  }

    TextEditingController cBookJudul = TextEditingController();
    TextEditingController cBookPenerbit = TextEditingController();
    TextEditingController cBookPengarang= TextEditingController();
    TextEditingController cBookTahun = TextEditingController();
    TextEditingController cBookDeskripsi = TextEditingController();
    TextEditingController cBookGRQty = TextEditingController();
    TextEditingController cBookGRTgl = TextEditingController();

  List<PostList?> _listBuku = [];
  List<PostList?> _allListBuku = [];

  _getDataBuku(action,idBuku,judulBuku,penerbit,tahun) async{
    setState(() {
      _loading = true;
    });
    Service.getDataBuku(action,idBuku,judulBuku,penerbit,tahun,idUsersApp).then((value) async {
      setState(() {
        _listBuku = value;
        _allListBuku = value;
        _loading = false;
      });
    });
  }

 String message = "", values = "";
 List<PostList?> _messageUpload = [];
 _functionUploadDataBuku() async{
  setState(() {
    _loading = true;
  });
  Service.functionUploadDataBuku(
    "", cBookJudul.text, cBookPenerbit.text, cBookPengarang.text 
    ,cBookTahun.text ,cBookDeskripsi.text,
    filePickerVal, txtFilePicker, idUsersApp, ).then((value) async {
    setState(() {
      _messageUpload = value;
      _loading = false;
      message = _messageUpload[0]!.message;
      values = _messageUpload[0]!.value;   
      print(message);
      print(values);    
      
      if (message == "1") {
        setState(() {
          _commandAlertMessage("", "", false);
          _commandAlertMessageResponse(values, message, true);
          _clearCtext();
        });
      }else{
        setState(() {
        _commandAlertMessage("", "", false);
        _commandAlertMessageResponse(values, message, true);          
        });
      }
    });
  });
 }

 _clearCtext(){
  setState(() {
    cBookJudul.text = "";
    cBookPenerbit.text = "";
    cBookPengarang.text = "";
    cBookTahun.text = "";
    cBookDeskripsi.text = "";
    cBookGRQty.text = "";
    cBookGRTgl.text = "";
  });
 }
  _alertMessage(){
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width* 0.8,
        height: MediaQuery.of(context).size.height* 0.3,        
        child: Card(
          color: Colors.green,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0,left: 8.0,right: 8.0),
                child: Center(child: Text(headerText, style:_customFont(),textAlign: TextAlign.center,)),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(child: Text(titleText, style:_customFont())),
              ),
              Padding(
                padding: const EdgeInsets.only(top :18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      color: Colors.blue,
                      child: TextButton(
                        style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.blue,
                        padding: const EdgeInsets.all(10.0),
                        textStyle: const TextStyle(fontSize: 12),
                        ), child: const Text('OK',style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          _functionUploadDataBuku();
                        },
                      ),
                    ),   
                    Card(
                      color: Colors.orangeAccent,
                      child: TextButton(
                        style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.blue,
                        padding: const EdgeInsets.all(10.0),
                        textStyle: const TextStyle(fontSize: 12),
                        ), child: const Text('Batal',style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          _commandAlertMessage("", "", false);
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
    );
  }

  String valueResponse = "";
  String messageResponse = "";
  bool tampilAlertMessageResponse = false;
  _commandAlertMessageResponse(valueResponses, messageResponses, tampilAlertMessageResponses){
    setState(() {
      valueResponse = valueResponses;
      messageResponse = messageResponses;
      tampilAlertMessageResponse = tampilAlertMessageResponses;
    });
  }

  _alertMessageResponse(){
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width* 0.8,
        height: MediaQuery.of(context).size.height* 0.3,        
        child: Card(
          color: valueResponse == "1" ? Colors.green: Colors.red,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0,left: 8.0,right: 8.0),
                child: Center(child: Text(messageResponse, style:_customFont(),textAlign: TextAlign.center,)),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(child: Text(titleText, style:_customFont())),
              ),
              Padding(
                padding: const EdgeInsets.only(top :18.0),
                child: Card(
                  color: Colors.orangeAccent,
                  child: TextButton(
                    style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.blue,
                    padding: const EdgeInsets.all(10.0),
                    textStyle: const TextStyle(fontSize: 12),
                    ), child: const Text('Keluar',style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      _commandAlertMessageResponse("", "", false);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool tampilFormUpdateAdd = false;
  String textFormUpdateAdd = "";

  _commandFormUpdateAdd(textFormUpdateAdds, tampilFormUpdateAdds){
    setState(() {
      textFormUpdateAdd = textFormUpdateAdds;
      tampilFormUpdateAdd = tampilFormUpdateAdds;
    });
  }

  String headerText = "";
  String titleText = "";
  bool tampilAlertMessage = false;
  _commandAlertMessage(headers, titles, tampilAlertMessages){
    setState(() {
      headerText = headers;
      titleText = titles;
      tampilAlertMessage = tampilAlertMessages;
    });
  }

  _editDataBuku(cBookJuduls,cBookPenerbits,cBookPengarangs,cBookTahuns,cBookDeskripsis){
    setState(() {
        cBookJudul = cBookJuduls;
        cBookPenerbit = cBookPenerbits;
        cBookPengarang= cBookPengarangs;
        cBookTahun = cBookTahuns;
        cBookDeskripsi = cBookDeskripsis;
        _commandFormUpdateAdd("Form Edit Buku", true);
    });
  }

  _formUpdateAdd(){
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width* 0.8,
            height: MediaQuery.of(context).size.height* 0.9,
            child: ListView(
              children:  [
                Padding(
                  padding: const EdgeInsets.only(left :12.0,right :5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Form $textFormUpdateAdd"),
                      IconButton(
                        color: Colors.red,
                        onPressed: (){
                          _commandFormUpdateAdd("", false);
                        }, icon: const Icon(Icons.close,size: 20.0,)),
                    ],
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      controller: cBookJudul,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Judul Buku",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      controller: cBookPenerbit,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Penerbit Buku",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ),  
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      controller: cBookPengarang,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Pengarang Buku",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ),  
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: cBookTahun,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Tahun Buku",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ), 
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      controller: cBookDeskripsi,
                      maxLines: 2,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Deskripsi Buku",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ),                 
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Row(
                      mainAxisAlignment: txtFilePicker != "" ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                      children: [
                        txtFilePicker == ""
                        ? Container()
                        : Card(
                          color: Colors.green,
                          child: TextButton(
                            style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            surfaceTintColor: Colors.blue,
                            padding: const EdgeInsets.all(10.0),
                            textStyle: const TextStyle(fontSize: 12),
                            ), child: const Text('Simpan Data',style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              _commandAlertMessage("Simpan Data ${cBookJudul.text}","Pastikan Data Benar",true);
                            },
                          ),
                        ),
                        Card(
                          color: Colors.blue,
                          child: TextButton(
                            style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            surfaceTintColor: Colors.blue,
                            padding: const EdgeInsets.all(10.0),
                            textStyle: const TextStyle(fontSize: 12),
                            ), child: const Text('Foto Buku',style: TextStyle(color: Colors.white),),
                            onPressed: 
                            (){
                              selectFile();
                            },
                          ), 
                        ),                      
                      ],
                    ),
                  ),
                ),
                txtFilePicker == ""     
                ? Container()  
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Image.file(filePickerVal,
                    width: 100,
                    height: 100,
                    ),
                  ),
                )                                                                             
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
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
            Padding(
              padding: const EdgeInsets.only(top:1.0,right: 8.0,left: 8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 1,
                child: ScrollConfiguration(
                  behavior: WebCustomScrollBehavior(),
                  child: ListView.builder(
                    itemCount: _listBuku.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context,index){
                      final listDataBuku = _listBuku[index]; 
                      return Card(
                        color: Colors.blue,
                        child: ListTile(
                          title: Text("Judul : ${listDataBuku!.judul}",style: _customFont()),
                          subtitle: Text("Penerbit : ${listDataBuku.penerbit}",style: _customFont(),),
                          leading: IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: _colorIcon())),
                          trailing: IconButton(onPressed: (){
                            _editDataBuku(
                              listDataBuku.judul,
                              listDataBuku.penerbit,
                              listDataBuku.pengarang,
                              listDataBuku.tahun,
                              listDataBuku.description);
                          }, icon: Icon(Icons.edit,color: _colorIcon())),
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
            tampilFormUpdateAdd == true
            ? _formUpdateAdd()
            :Container(),
            tampilAlertMessage == true
            ? _alertMessage()
            : Container(),
            tampilAlertMessageResponse == true
            ? _alertMessageResponse()
            : Container()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _commandFormUpdateAdd("Tambah Buku",true);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}