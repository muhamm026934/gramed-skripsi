import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gramed/api/api.dart';
import 'package:gramed/api/postlist.dart';
import 'package:gramed/drawer.dart';
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

  File? filePickerVal;
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
    TextEditingController cBookId = TextEditingController();
    TextEditingController cBookJudul = TextEditingController();
    TextEditingController cBookPenerbit = TextEditingController();
    TextEditingController cBookPengarang= TextEditingController();
    TextEditingController cPrice = TextEditingController();
    TextEditingController cDiskon = TextEditingController();
    TextEditingController cBookTahun = TextEditingController();
    TextEditingController cBookDeskripsi = TextEditingController();
    TextEditingController cBookImage = TextEditingController();
    TextEditingController cBookGRQty = TextEditingController();
    TextEditingController cBookGRTgl = TextEditingController();

    TextEditingController cStockBookId = TextEditingController();
    TextEditingController cStockBookGrDate = TextEditingController();
    TextEditingController cStockBookGrQty = TextEditingController();
    TextEditingController cStockBookNoNota = TextEditingController();

  List<PostList?> _listBuku = [];

  _getDataBuku(action,idBuku,judulBuku,penerbit,tahun) async{
    setState(() {
      _loading = true;
    });
    Service.getDataBuku(action,idBuku,judulBuku,penerbit,tahun,idUsersApp).then((value) async {
      setState(() {
        _listBuku = value;
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
    headerText, cBookId.text ,cBookJudul.text, cBookPenerbit.text, cBookPengarang.text 
    ,cPrice.text,cDiskon.text,cBookTahun.text, cBookDeskripsi.text,
    filePickerVal, txtFilePicker, idUsersApp, ).then((value) async {
    setState(() {
      _messageUpload = value;
      _loading = false;
      message = _messageUpload[0]!.message.toString();
      values = _messageUpload[0]!.value.toString();   
      print("message $message");
      print(values);    
      
      if (values == "1") {
        setState(() {
          _commandAlertMessage("", "", false);
          _commandAlertMessageResponse(values, message, true);
          _commandFormUpdateAdd("", false);
          _getDataBuku("",cBookId.text,"","","");
          txtFilePicker = "";
          _messageUpload.clear();
          message ="";
          values ="";
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
    cBookId.text = "";
    cBookJudul.text = "";
    cBookPenerbit.text = "";
    cBookPengarang.text = "";
    cPrice.text = "";
    cDiskon.text = "";
    cBookTahun.text = "";
    cBookDeskripsi.text = "";
    cBookGRQty.text = "";
    cBookGRTgl.text = "";
    cBookImage.text = "";
  });
 }
  _alertMessage(){
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width* 0.8,
        height: MediaQuery.of(context).size.height* 0.3,        
        child: Card(
          color: 
            textFormUpdateAdd == ApiUrl.tambahBukuText || headerText == ApiUrl.tambahBukuText 
            ? Colors.green
            :textFormUpdateAdd == ApiUrl.editBukuText || headerText == ApiUrl.editBukuText 
            ? Colors.orange
            :textFormUpdateAdd == ApiUrl.deleteBukuText || headerText == ApiUrl.deleteBukuText
            ? Colors.red
            : Colors.blue,
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
                          _commandAlertMessage(headerText, "", false);
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
      headerText = textFormUpdateAdds;
    });
  }

  String headerText = "";
  String titleText = "";
  bool tampilAlertMessage = false;
  _commandAlertMessage(headers, titles, tampilAlertMessages){
    setState(() {
      textFormUpdateAdd = headers;
      headerText = headers;
      titleText = titles;
      tampilAlertMessage = tampilAlertMessages;
    });
  }  

  _editDataBuku(cBookIds,cBookJuduls,cBookPenerbits,cBookPengarangs,cPrices,cDiskons,cBookTahuns,cBookDeskripsis,imageBook,headers){
    setState(() {
        cBookId.text = cBookIds;
        cBookJudul.text = cBookJuduls;
        cBookPenerbit.text = cBookPenerbits;
        cBookPengarang.text = cBookPengarangs;
        cPrice.text = cPrices;
        cDiskon.text = cDiskons;
        cBookTahun.text = cBookTahuns;
        cBookDeskripsi.text = cBookDeskripsis;
        cBookImage.text = imageBook;
        _commandFormUpdateAdd(headers, true);
    });
  }

  _formUpdateAdd(){
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width* 0.9,
            height: MediaQuery.of(context).size.height* 0.9,
            child: ListView(
              children:  [
                Padding(
                  padding: const EdgeInsets.only(left :12.0,right :5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(textFormUpdateAdd),
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
                      enabled: headerText == ApiUrl.detailBukuText ?false : true,
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
                      enabled: headerText == ApiUrl.detailBukuText ?false : true,
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
                      enabled: headerText == ApiUrl.detailBukuText ?false : true,
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
                      enabled: headerText == ApiUrl.detailBukuText ?false : true,
                      controller: cPrice,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Harga Buku",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      enabled: headerText == ApiUrl.detailBukuText ?false : true,
                      controller: cDiskon,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Potongan Harga % / Diskon",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ),                  
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      enabled: headerText == ApiUrl.detailBukuText ?false : true,
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
                      enabled: headerText == ApiUrl.detailBukuText ?false : true,
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
                headerText == ApiUrl.detailBukuText 
                ? Container()            
                : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Row(
                      mainAxisAlignment: txtFilePicker != "" ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                      children: [
                        txtFilePicker == "" && textFormUpdateAdd == ApiUrl.tambahBukuText
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
                              textFormUpdateAdd == ApiUrl.tambahBukuText
                              ?_commandAlertMessage(ApiUrl.tambahBukuText,"Pastikan Data Benar",true)
                              :textFormUpdateAdd == ApiUrl.editBukuText
                              ?_commandAlertMessage(ApiUrl.editBukuText,"Apakah Data Buku Akan Diubah ?",true)
                              :textFormUpdateAdd == ApiUrl.deleteBukuText
                              ?_commandAlertMessage(ApiUrl.deleteBukuText,"Apakah Data Akan Dihapus ?",true)
                              :_commandFormUpdateAdd("", false);
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
                cBookImage.text == ""
                ? Container()
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        const Text("Foto Buku"),
                        Image.network(ApiUrl.viewImageBuku+cBookImage.text,
                        width: 100,
                        height: 100,
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
                    child: Image.file(filePickerVal!,
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
  bool onLongPress = false;
 _onLOngPress(){
  setState(() {
    onLongPress = !onLongPress;
  });
 }

  bool cFormUpdateAddBook = false;
  String textFormUpdateAddBook = "" , idStockBook = "", idBook = "";
 _commandFormUpdateAddBook(idStockBooks,idBooks,cFormUpdateAddBooks,textFormUpdateAddBooks){
  setState(() {
    idBook = idBooks;
    cFormUpdateAddBook = cFormUpdateAddBooks;
    cFormUpdateAddBook = !cFormUpdateAddBook;
    textFormUpdateAddBook = textFormUpdateAddBooks;
    idStockBook = idStockBooks;
    print("object");
    print(idStockBook);
    print(idBook);
    print(cFormUpdateAddBook);

  });
 }

  _formUpdateAddBook(){
    return GestureDetector(
      onTap: (){
      _commandFormUpdateAddBook(
            "",
            "",
            true,
            "");
      },
      child: Container(
        color: Colors.black38,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width* 0.8,
            height: MediaQuery.of(context).size.height* 0.6, 
            child: Card(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left :12.0,right :5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(textFormUpdateAddBook)),
                        IconButton(
                          color: Colors.red,
                          onPressed: (){
                            _commandFormUpdateAddBook(
                                  "",
                                  "",
                                  true,
                                  "");
                          }, icon: const Icon(Icons.close,size: 20.0,)),
                      ],
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        enabled: headerText == ApiUrl.detailBukuText ?false : true,
                        controller: cStockBookGrQty,
                        decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)
                          ),
                          label: Text("Jumlah Buku",style: TextStyle(fontSize: 10,color: Colors.blue),),
                        ), 
                      ),
                    ),
                  ),  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        enabled: headerText == ApiUrl.detailBukuText ?false : true,
                        controller: cStockBookGrDate,
                        decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)
                          ),
                          label: Text("Tanggal Terima Buku",style: TextStyle(fontSize: 10,color: Colors.blue),),
                        ), 
                      ),
                    ),
                  ),  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextField(
                        enabled: headerText == ApiUrl.detailBukuText ?false : true,
                        controller: cStockBookNoNota,
                        decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)
                          ),
                          label: Text("Nomor Nota",style: TextStyle(fontSize: 10,color: Colors.blue),),
                        ), 
                      ),
                    ),
                  ),   
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
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
                          
                        },
                      ),
                    ),
                  ),                          
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

 _dataBook(){
  return ListView.builder(
    itemCount: _listBuku.length,
    scrollDirection: Axis.vertical,
    itemBuilder: (context,index){
      final listDataBuku = _listBuku[index]; 
      return GestureDetector(
        onLongPress: (){
          _onLOngPress();
        },
        child: Card(
          color: Colors.blue,
          child: Column(
            children: [
              ListTile(
                title: Text("Judul : ${listDataBuku!.judul}",style: _customFont()),
                subtitle: Text("Penerbit : ${listDataBuku.penerbit}",style: _customFont(),),
                leading: Image.network(ApiUrl.viewImageBuku+listDataBuku.imageBook),
                trailing: IconButton(onPressed: (){
                        _editDataBuku(
                        listDataBuku.idBuku, 
                        listDataBuku.judul,
                        listDataBuku.penerbit,
                        listDataBuku.pengarang,
                        listDataBuku.priceBuku,
                        listDataBuku.diskon,
                        listDataBuku.tahun,
                        listDataBuku.description,
                        listDataBuku.imageBook,
                        ApiUrl.detailBukuText
                        );                                    
                }, icon: Icon(Icons.remove_red_eye,color: _colorIcon())),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Deskripsi : ${listDataBuku.description}",style: const TextStyle(fontSize: 10,color: Colors.white),),
              ), 
              Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: Text("Harga : Rp. ${listDataBuku.price}",style: const TextStyle(fontSize: 10,color: Colors.white),),
              ), 
              Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: 
                listDataBuku.price != listDataBuku.netPrice
                ? Text("Harga Setelah Diskon ${listDataBuku.diskon}% : Rp. ${listDataBuku.netPrice}",style: const TextStyle(fontSize: 10,color: Colors.white),)
                : const Text("Belum Ada Diskon",style: TextStyle(fontSize: 10,color: Colors.white),),
              ), 
              onLongPress == true                        
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(child: IconButton(onPressed: (){
                      setState(() {
                        cBookId.text = listDataBuku.idBuku;
                      });
                      _commandAlertMessage(ApiUrl.deleteBukuText, listDataBuku.judul, true);
                    }, icon: const Icon(Icons.delete_forever,color: Colors.red))),
                    Card(
                      child: IconButton(onPressed: (){
                      _editDataBuku(
                        listDataBuku.idBuku,
                        listDataBuku.judul,
                        listDataBuku.penerbit,
                        listDataBuku.pengarang,
                        listDataBuku.priceBuku,
                        listDataBuku.diskon,
                        listDataBuku.tahun,
                        listDataBuku.description,
                        listDataBuku.imageBook,
                        ApiUrl.editBukuText
                        );                                  
                      }, icon: const Icon(Icons.edit,color: Colors.orange)),
                    ),
                    Card(child: IconButton(onPressed: (){
                        _commandFormUpdateAddBook(
                          listDataBuku.idStock,
                          listDataBuku.idBuku,
                          false,
                          "Tambah Stock Buku ${listDataBuku.judul}");
                      
                    }, icon: const Icon(Icons.add,color: Colors.green))),   
                    Card(child: IconButton(onPressed: (){
                      setState(() {
                      });
                      
                    }, icon: const Icon(Icons.book_online,color: Colors.green))),                                      
                  ],
                ),
              ):Container()
            ],
          ),
        ),
      );
    }
  );
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(),
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
                  child: _dataBook(),
                ),
              ),
            ),
            cFormUpdateAddBook == true
            ? _formUpdateAddBook()
            : Container(),
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
          _clearCtext();
          _commandFormUpdateAdd(ApiUrl.tambahBukuText,true);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}