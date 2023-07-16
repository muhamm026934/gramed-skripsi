import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gramed/api/api.dart';
import 'package:gramed/api/postlist.dart';
import 'package:gramed/drawer.dart';
import 'package:gramed/page_routes.dart';
import 'package:gramed/service.dart';
import 'package:gramed/web_custom_scroll_behavior.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String session,user,trans;
  const Home({Key? key, 
  required this.session,
  required this.user,
  required this.trans
  }) : super(key: key);


  @override
  State<Home> createState() => _HomeState();
}
class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}

class _HomeState extends State<Home> {

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    _getPref();
    _getDataBukuDiskon("diskon","","","","");
    _getDataBukuNoDiskon("no_diskon","","","","");
    _commandFormUpdateUser(widget.user,true);
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
        if (widget.user == ApiUrl.editUserText) {
          cUserId.text = idUsersApp;
          cName.text = name;
          cUsername.text = username;
          cPassword1.text = password;
          cPassword2.text = password;
          cAddress.text = address;
          cLevel.text = level;
          cEmail.text = email;
          cNoTelp.text = noTelp;
          cToken.text = token;    
          print(cName.text);
          }else{
          cUserId.text = "";
          cName.text = "";
          cUsername.text = "";
          cPassword1.text = "";
          cPassword2.text = "";
          cAddress.text = "";
          cLevel.text = "";
          cEmail.text = "";
          cNoTelp.text = "";
          cToken.text = "";              
          }
          if (widget.trans == 'check_out') {
            _commandformDataKeranjang("","",true,widget.trans);
          }
      });
    });
  }
  
  List<PostList?> _listBukuDiskon = [];
  List<PostList?> _listBukuNoDiskon = [];
  bool _loading = false;
  _getDataBukuDiskon(action,idBuku,judulBuku,penerbit,tahun) async{
    setState(() {
      _loading = true;
    });
    Service.getDataBuku(action,idBuku,judulBuku,penerbit,tahun,idUsersApp).then((value) async {
      setState(() {
        _listBukuDiskon = value;
        _loading = false;
      });
    });
  }

  _getDataBukuNoDiskon(action,idBuku,judulBuku,penerbit,tahun) async{
    setState(() {
      _loading = true;
    });
    Service.getDataBuku(action,idBuku,judulBuku,penerbit,tahun,idUsersApp).then((value) async {
      setState(() {
        _listBukuNoDiskon = value;
        _loading = false;
      });
    });
  }

 bool _openFormAdds = false;
 String tags = "",images ="",juduls ="",deskripsis = "",hargas ="",diskons ="",netHargas ="",potonganHargas = "";
 int qtyBeli = 1;
 String hargaJuals = "0", openFormText = "";
 late int jmlBayar = qtyBeli * int.parse(hargaJuals);
 var jmlBayars = "";
  _openFormAdd(idBookss,openFormAdds,image,judul,deskripsi,harga, diskon, netHarga,potonganHarga,hargaJual,openFormTexts){
    setState(() {
      _openFormAdds = openFormAdds;
      idBooks = idBookss;
      images = image;
      juduls = judul;
      deskripsis = deskripsi;
      hargas = harga;
      diskons = diskon;
      netHargas = netHarga;
      potonganHargas = potonganHarga;
      hargaJuals = hargaJual;
      qtyBeli = 1;     
      jmlBayar = qtyBeli * int.parse(hargaJuals);
      openFormText = openFormTexts;
    });
  }
  _openFormEdit(idBookss,openFormAdds,image,judul,deskripsi,harga, diskon, netHarga,potonganHarga,hargaJual,openFormTexts){
    setState(() {
      _openFormAdds = openFormAdds;
      idBooks = idBookss;
      images = image;
      juduls = judul;
      deskripsis = deskripsi;
      hargas = harga;
      diskons = diskon;
      netHargas = netHarga;
      potonganHargas = potonganHarga;
      hargaJuals = hargaJual;
      qtyBeli = qtyBeli;     
      jmlBayar = qtyBeli * int.parse(hargaJuals);
      openFormText = openFormTexts;
    });
  }

  _addFuntion(){
    setState(() {
      qtyBeli = qtyBeli + 1;
      jmlBayar = qtyBeli * int.parse(hargaJuals);
    });
  }
  _deductFuntion(){
    setState(() {
      if (qtyBeli > 1) {
       qtyBeli = qtyBeli - 1; 
       jmlBayar = qtyBeli * int.parse(hargaJuals);
      }else{
        qtyBeli;
        jmlBayar = qtyBeli * int.parse(hargaJuals);
      }
    });
  }

  TextEditingController cAlamat = TextEditingController();
  bool cFormAlertBuy = false;
  String idBooks = "",
  qtyPicks = "",
  codeTransactions = "",
  totalPayments = "",
  stateTransactions = "",
  idUsers = "";
  
  late int randomNumber;

 
  _cFormAlertBuy(
    cFormAlertBuyss,
    idBookss,
    qtyPickss,
    codeTransactionss,
    totalPaymentss,
    stateTransactionss,
    idUserss
    ){
    setState(() {
      randomNumber = (Random().nextInt(100000));
      cFormAlertBuy = cFormAlertBuyss;
      idBooks = idBookss.toString();
      qtyPicks = qtyPickss.toString();
      codeTransactions = "$idBooks$idUsersApp${randomNumber.toString()}";
      totalPayments = totalPaymentss.toString();
      stateTransactions = stateTransactionss.toString();
      idUsers = idUsersApp.toString(); 
      print(cFormAlertBuy);
    });
  }

  _clearFormAlertBuy(){
    setState(() {
    idBooks = "";
    qtyPicks = "";
    codeTransactions = "";
    totalPayments = "";
    stateTransactions = "";
    idUsers = "";
    });    
  }

  int  textField = 0;
  _formAlertBuy(){
    return GestureDetector(
      onTap: (){
      _cFormAlertBuy(
        false,
        idBooks,
        qtyBeli,
        idBooks,
        jmlBayar,
        "",
        idUsersApp
        );        
      },
      child: Container(
        color: Colors.black45,
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height* 0.5,  
            width: MediaQuery.of(context).size.width* 0.9,          
            child: Card(
              child: ListView(
                children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Judul : $juduls"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Qty : $qtyBeli"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Total Pembayaran : ${CurrencyFormat.convertToIdr(jmlBayar, 2)}",),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Kode Transaksi : $codeTransactions"),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextField(
                          onChanged: (String newVal) {
                            setState(() {
                              textField = newVal.length;
                              print(textField.toString());
                            });
                          },
                          enabled: true,
                          maxLines: 3,
                          controller: cAlamat,
                          decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)
                            ),
                            label: Text("Alamat Tujuan Harus Diisi",style: TextStyle(fontSize: 10,color: Colors.blue),),
                          ), 
                        ),
                      ),
                    ),
                    textField == 0
                    ? Container()
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(child: OutlinedButton.icon(onPressed: (){
                        _commandAlertMessage(openFormText, juduls, true,ApiUrl.tambahBayarText);

                      }, icon: const Icon(Icons.monetization_on), label: const Text("Pembayaran"))),
                    ),                  
                ],
              ),
            ),
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

 String message = "", values = "", stateTransaction = "", idTransaksi = "", headerText = "",textFormUpdateAdd ="";
 List<PostList?> _messageUpload = [];

 _functionUploadDataTransaksi() async{
  setState(() {
    _loading = true;
    print("object $_loading");
  });
  
  Service.functionUploadDataTransaksi(
    headerText, 
    idTransaksi.toString(),
    qtyBeli.toString(), 
    idBooks.toString(),
    codeTransactions.toString(),
    stateTransaction.toString(),
    jmlBayar.toString(),
    idUsersApp.toString(),
    cAlamat.text).then((value) async {
    setState(() {
      _messageUpload = value;
      _loading = false;
      message = _messageUpload[0]!.message.toString();
      values = _messageUpload[0]!.value.toString();   
      print("message $message");
      print(values);    
      
      if (values == "1") {
        setState(() {
          _commandAlertMessageResponse(values, message, true);

          if (funtionAlert == ApiUrl.tambahBayarText) {
            PageRoutes.routeToWebViewPay(
              context,
              juduls.toString(),
              codeTransactions.toString(), 
              name.toString(), 
              qtyBeli.toString(), 
              hargaJuals.toString(),);            
          }
          _getDataTrans();
          _commandAlertMessage("", "", false,"");
        });
      }else{
        setState(() {
        _commandAlertMessageResponse(values, message, true);
        });
      }
    });
  });



  }
  TextStyle _customFont() {
  return const TextStyle(color: Colors.white);
  }


  String titleText = "",funtionAlert ="";
  bool tampilAlertMessage = false;
  _commandAlertMessage(headers, titles, tampilAlertMessages,funtionAlerts){
    setState(() {
      textFormUpdateAdd = headers;
      headerText = headers;
      titleText = titles;
      tampilAlertMessage = tampilAlertMessages;
      funtionAlert = funtionAlerts;
      print(funtionAlert);
    });
  }  

  _alertMessage(){
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width* 0.8,
        height: MediaQuery.of(context).size.height* 0.3,        
        child: Card(
          color: 
            textFormUpdateAdd == ApiUrl.tambahTransBukuText || headerText == ApiUrl.tambahTransBukuText 
            ? Colors.green
            :textFormUpdateAdd == ApiUrl.editTransBukuText || headerText == ApiUrl.editTransBukuText 
            ? Colors.orange
            :textFormUpdateAdd == ApiUrl.deleteTransBukuText || headerText == ApiUrl.deleteTransBukuText
            ? Colors.red
            : Colors.blue,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0,left: 8.0,right: 8.0),
                child: Center(child: Text(
                  headerText == ApiUrl.deleteTransBukuText
                  ? "Hapus Data Transaksi Buku "
                  :funtionAlert == ApiUrl.tambahBayarText ? 
                  "Pembayaran Buku":
                  "Masukkan Ke Keranjang"
                  , style:_customFont(),textAlign: TextAlign.center,)),
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
                          _functionUploadDataTransaksi();
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
                          _commandAlertMessage(headerText, "", false,"");
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

  _formAdd(){
    return Container(
      color: Colors.black38,
      child: GestureDetector(
        onTap: (){
          _openFormAdd(idBooks,false,images,juduls,deskripsis,hargas, diskons, netHargas,potonganHargas,hargaJuals,ApiUrl.tambahTransBukuText);
        },
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height* 0.9,  
            width: MediaQuery.of(context).size.width* 0.9,  
            color: Colors.black12,
            child: Card(
              child: Card(
                    color: Colors.blue,
                    child: ListView(
                      children: [
                        Image.network(ApiUrl.viewImageBuku+images),
                        Text("Harga : $hargas",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                        Text("Diskon : $diskons % / $potonganHargas",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                        Text("Harga Setelah Diskon : $netHargas",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                        Text("Judul : $juduls",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                        Text("Deskripsi : $deskripsis",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [                          
                            Card(
                              color: Colors.white,
                              child: IconButton(onPressed: (){
                                _deductFuntion();
                              }, icon: const Icon(Icons.remove),color: Colors.black,)),
                            Text("$qtyBeli",style: const TextStyle(fontSize: 18,color: Colors.white),),
                            Card(
                              color: Colors.white,
                              child: IconButton(onPressed: (){
                                _addFuntion();
                              }, icon: const Icon(Icons.add),color: Colors.black))
                          ],
                        ),           
                        Text(CurrencyFormat.convertToIdr(jmlBayar, 2),textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),           
                        name != ""? 
                        Card(child: OutlinedButton.icon(onPressed: (){
                          _cFormAlertBuy(
                            true,
                            idBooks,
                            qtyBeli,
                            idBooks,
                            jmlBayar,
                            "",
                            idUsersApp
                            );
                        }, icon: const Icon(Icons.sell), label: const Text("Beli")))
                        :Container(),  

                        Card(child: OutlinedButton.icon(onPressed: 
                        name != ""?
                        (){
                          _commandAlertMessage(openFormText, juduls, true,ApiUrl.tambahKeranjangText);
                        }:(){
                          PageRoutes.routeToLogin(context);
                        }
                        
                        , icon: Icon(name != ""? Icons.add_shopping_cart_outlined:Icons.login), label:  Text(name != ""?"Keranjang":"Login")))
                      ],
                    ),
                  )
            ),
          ),
        ),
      ),
    );
  }

  List<PostList?> _listKeranjang = [];
  String actions = "";
  _getDataTrans() async{
    setState(() {
      _loading = true;
    });
    Service.getStockTransBuku(
      actions, idTransaksi ,qtyBeli, idBooks ,codeTransactions,stateTransaction,totalPayments,
    idUsersApp,cAlamat.text,level).then((value) async {
      setState(() {
        _listKeranjang = value;
        _loading = false;
      });
    });
  }

  bool formDataKeranjang = false;
  String judulTrans ="";
  _commandformDataKeranjang(idBuku,judulTranss,formDataKeranjangs,action){
    setState(() {
      judulTrans = judulTranss;
      formDataKeranjang = formDataKeranjangs;
      actions = action;
      if (formDataKeranjang == true) {
      _getDataTrans();
      
      }else{
        _listKeranjang.clear();
      }
    });
  }

  _dataTransBook(){
    return Center(
      child: Container(
        color: Colors.black38,
        child: Card(
          color: Colors.blue,
          child: SizedBox(
            width: MediaQuery.of(context).size.width* 0.99,
            height: MediaQuery.of(context).size.height* 0.9,   
            child: Column(
              children: [
                Card(
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(actions == ""?"List Keranjang " :"Detail Transaksi",
                        style: const TextStyle(fontSize: 18,color: Colors.white)),
                      ),
                      IconButton(onPressed: (){
                        _commandformDataKeranjang("","",false,"");
                      }, icon: const Icon(Icons.close,color: Colors.red,))
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _listKeranjang.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context,index){
                      final listDataTrans = _listKeranjang[index]; 
                      return GestureDetector(
                        onLongPress: (){
                        },
                        child: Card(
                          color: Colors.blue,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Judul : ${listDataTrans!.judul}",style: _customFont()),
                                subtitle: Text("Qty Buku : ${listDataTrans.qtyPick}",style: _customFont(),),
                                leading: Image.network(ApiUrl.viewImageBuku+listDataTrans.imageBook),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Total Bayar: ${listDataTrans.totalPayment}",style: const TextStyle(fontSize: 10,color: Colors.white),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Alamat : ${listDataTrans.alamat}",style: const TextStyle(fontSize: 10,color: Colors.white),),
                              ),    
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Status Transaksi : ${listDataTrans.stateTransaction}",style: const TextStyle(fontSize: 10,color: Colors.white),),
                              ),   
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Card(child: IconButton(onPressed: (){
                                    setState(() {
                                      idTransaksi = listDataTrans.idTransaction;
                                      openFormText = ApiUrl.deleteTransBukuText;
                                    });                                    
                                    _commandAlertMessage(openFormText, listDataTrans.judul, true,ApiUrl.tambahKeranjangText);

                                  }, icon: const Icon(Icons.delete,color: Colors.red))),       
                                  Card(child: IconButton(onPressed: (){
                                    setState(() {
                                      cAlamat.text = listDataTrans.alamat;
                                      idTransaksi = listDataTrans.idTransaction;
                                      qtyBeli = int.parse(listDataTrans.qtyPick);
                                    });
                                      _openFormEdit(
                                      listDataTrans.idBook
                                      ,true,
                                      listDataTrans.imageBook,
                                      listDataTrans.judul,
                                      listDataTrans.description,
                                      listDataTrans.price,
                                      listDataTrans.diskon,
                                      listDataTrans.netPrice,
                                      listDataTrans.potonganHarga,
                                      listDataTrans.hargaJual,
                                      ApiUrl.editTransBuku
                                      );                                    
                                  }, icon: const Icon(Icons.edit,color: Colors.orange))),                                                              
                                ],
                              )        
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController cUserId = TextEditingController();
  TextEditingController cName = TextEditingController();
  TextEditingController cUsername = TextEditingController();
  TextEditingController cPassword1= TextEditingController();
  TextEditingController cPassword2= TextEditingController();
  TextEditingController cAddress = TextEditingController();
  TextEditingController cLevel = TextEditingController();
  TextEditingController cEmail = TextEditingController();
  TextEditingController cNoTelp = TextEditingController();
  TextEditingController cToken = TextEditingController();


  bool tampilFormUpdateUser = false;
  String textFormUpdateUser = "";
  
  _commandFormUpdateUser(textFormUpdateUsers, tampilFormUpdateUsers){
    setState(() {
      if (widget.user !="") {
      textFormUpdateUser = textFormUpdateUsers;
      tampilFormUpdateUser = tampilFormUpdateUsers;   
      }      
    });
  }

  String titleTextUser = "";
  bool tampilAlertMessageUser = false;
  
  _commandAlertMessageUser(textFormUpdateUsers, titleTextUsers, tampilAlertMessageUsers){
    setState(() {
      textFormUpdateUser = textFormUpdateUsers;
      titleTextUser = titleTextUsers;
      tampilAlertMessageUser = tampilAlertMessageUsers;    
    });
  }

 _clearCtext(){
  setState(() {
    cUserId.text = "";
    cName.text = "";
    cUsername.text = "";
    cPassword1.text = "";
    cPassword2.text = "";
    cAddress.text = "";
    cLevel.text = "";
    cEmail.text = "";
    cNoTelp.text = "";
    cToken.text = "";
  });
 }

  _formUpdateUser(){
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width* 0.95,
            height: MediaQuery.of(context).size.height* 0.95,
            child: ListView(
              children:  [
                Padding(
                  padding: const EdgeInsets.only(left :12.0,right :5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(textFormUpdateUser == ApiUrl.tambahUserText ? "Register ": textFormUpdateUser),
                      IconButton(
                        color: Colors.red,
                        onPressed: (){
                          _commandFormUpdateUser("", false);
                        }, icon: const Icon(Icons.close,size: 20.0,)),
                    ],
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      enabled: true,
                      controller: cName,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Nama",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      enabled: true,
                      controller: cUsername,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Username",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ),  
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      enabled: true,
                      obscureText: true,
                      controller: cPassword1,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Password",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ), 
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      enabled: true,
                      obscureText: true,
                      controller: cPassword2,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Ketik Ulang Password",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ),                  
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      enabled: true,
                      controller: cAddress,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Alamat",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ), 
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      enabled: true,
                      controller: cEmail,
                      maxLines: 2,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Email",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ), 
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      keyboardType: TextInputType.number,                      
                      enabled: true,
                      controller: cNoTelp,
                      maxLines: 2,
                      decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                        ),
                        label: Text("Nomor Telepon",style: TextStyle(fontSize: 10,color: Colors.blue),),
                      ), 
                    ),
                  ),
                ),                     
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: Colors.green,
                          child: TextButton(
                            style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            surfaceTintColor: Colors.blue,
                            padding: const EdgeInsets.all(10.0),
                            textStyle: const TextStyle(fontSize: 12),
                            ), child: const Text('Simpan Data User',style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              textFormUpdateUser == ApiUrl.tambahUserText
                              ?_commandAlertMessageUser(ApiUrl.tambahUserText,"Pastikan Data Benar",true)
                              :textFormUpdateUser == ApiUrl.editUserText
                              ?_commandAlertMessageUser(ApiUrl.editUserText,"Apakah Data User Akan Diubah ?",true)
                              :textFormUpdateUser == ApiUrl.deleteUserText
                              ?_commandAlertMessageUser(ApiUrl.deleteUserText,"Apakah Data User Akan Dihapus ?",true)
                              :_commandAlertMessageUser("", "",false);

                            },
                          ),
                        ),                     
                      ],
                    ),
                  ),
                ),                                                                          
              ],
            ),
          ),
        ),
      ),
    );
  }

 String messageUser = "", valuesUser = "";
 List<PostList?> _messageUploadUser = [];
 _functionUploadDataUser() async{
  setState(() {
    _loading = true;
  });
  
  Service.functionUploadDataUser(
    widget.user, cUserId.text ,cName.text, cUsername.text, cPassword1.text ,cPassword2.text
    ,cAddress.text ,cLevel.text,
    cEmail.text, cNoTelp.text, idUsersApp).then((value) async {
    setState(() {
      _messageUploadUser = value;
      _loading = false;
      messageUser = _messageUploadUser[0]!.message.toString();
      valuesUser = _messageUploadUser[0]!.value.toString();   
      print("message $message");
      print("values $message");
      print(valuesUser);
      
      if (valuesUser == "1") {
        setState(() {
          _commandAlertMessageUser("","", false);
          _commandAlertMessageResponse(valuesUser, messageUser, true);
          _messageUploadUser.clear();   
          messageUser ="";
          valuesUser ="";      
         _logout();                             
        });
      }else{
        setState(() {
        _commandAlertMessageResponse(valuesUser, "Update Data Gagal ", true);
        });
      }
    });
  });
 }

  _logout() async {
    String values = "";
    String idUsersApps = "";
    String names = "";
    String usernames = "";
    String passwords = "";
    String addresss = ""; 
    String levels = ""; 
    String emails = ""; 
    String noTelps = "";
    String tokens = "";
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
          });     
      _pageRoutesLogin();              
  }
    _pageRoutesLogin(){
    PageRoutes.routeToLogin(context);
  }
  _alertMessageUser(){
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width* 0.8,
        height: MediaQuery.of(context).size.height* 0.3,        
        child: Card(
          color: 
            textFormUpdateUser == ApiUrl.tambahUserText
            ? Colors.green
            :textFormUpdateUser == ApiUrl.editUserText
            ? Colors.orange
            :textFormUpdateUser == ApiUrl.deleteUserText
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
                child: Center(child: Text(textFormUpdateUser, style:_customFont())),
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
                          _functionUploadDataUser();
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
                          _commandAlertMessageUser("","", false);
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
  
  int ee = 0;
  bool Bsearh = false;
  TextEditingController cSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(),
      body: RefreshIndicator(
        onRefresh: ()=> PageRoutes.routeToHome(context),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  toolbarHeight: 80.0,
                  backgroundColor: Colors.blue,
                  shadowColor: Colors.blue,
                  title: Card(
                    color: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Row(
                        children: [
                           Expanded( 
                            child: TextField(
                              onChanged: (e){
                                setState(() {
                                  ee = e.length;
                                  print(e);
                                });
                              },
                              controller: cSearch,
                              cursorColor: Colors.white,
                              obscureText: false,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                                ),
                                label: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    Bsearh == true && _listBukuDiskon.isNotEmpty
                                    ?"Ditemukan ${_listBukuDiskon.length} Judul Buku"
                                    :Bsearh == true && _listBukuDiskon.isEmpty
                                    ?"Data Tidak Ditemukan"
                                    :"Pencarian Judul Buku",style: TextStyle(fontSize: 10,color: Colors.white),),
                                ),
                              ),                
                            ),
                          ),
                          ee == 0
                          ? IconButton(onPressed: (){
                            setState(
                              name != ""
                              ?() {
                              _commandformDataKeranjang("","",true,"");
                             }:(){
                              PageRoutes.routeToLogin(context);
                             }
                            );
                          }, icon: Icon(name != "" ? Icons.add_shopping_cart: Icons.login))
                          :IconButton(onPressed: (){
                            setState(
                              (){
                              _getDataBukuDiskon("","",cSearch.text,"","");
                              _listBukuNoDiskon.clear();
                              Bsearh = true;
                             }
                            );
                          }, icon: const Icon(Icons.search))
                          ,
                        ],
                      ),
                    ),
                  ),
                  expandedHeight: 350,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.only(top:100.0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                  height: 400,
                                  aspectRatio: 2.0,
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: false,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.3,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason){
                                    setState(() {
                                      _current = index;
                                    });
                                  }
                              ),
                              items: _listBukuDiskon.map((index) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,                                    
                                          decoration: const BoxDecoration(
                                            color: Colors.blue
                                          ),
                                          child: 
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(child: Padding(
                                                padding: const EdgeInsets.only(top:8.0),
                                                child: CachedNetworkImage(
                                                  progressIndicatorBuilder: (context, url, progress) => Center(
                                                    child: CircularProgressIndicator(
                                                      value: progress.progress,
                                                    ),
                                                  ),
                                                  imageUrl:
                                                      ApiUrl.viewImageBuku+index!.imageBook,
                                                ),
                                              )),
                                              Align(
                                                child: Text(index.judul.toString(),textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                                              ),
                                              Align(
                                                child: Text("Diskon ${index.diskon}% ",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                                              ),
                                            ],
                                          )
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _listBukuDiskon.asMap().entries.map((entry) {
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => _controller.animateToPage(entry.key),
                                  child: Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 10.0,
                                      height: 10.0,
                                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black)
                                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                                          ),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
                SliverToBoxAdapter(
                  child: ScrollConfiguration(
                    behavior: WebCustomScrollBehavior(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200.0,
                          child: ListView.builder(
                            itemCount: _listBukuDiskon.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index)=> 
                            GestureDetector(
                              onTap: (){
                                  _openFormAdd(
                                    _listBukuDiskon[index]!.idBuku
                                    ,true,
                                    _listBukuDiskon[index]!.imageBook,
                                    _listBukuDiskon[index]!.judul,
                                    _listBukuDiskon[index]!.description,
                                    _listBukuDiskon[index]!.price,
                                    _listBukuDiskon[index]!.diskon,
                                    _listBukuDiskon[index]!.netPrice,
                                    _listBukuDiskon[index]!.potonganHarga,
                                    _listBukuDiskon[index]!.hargaJual,
                                    ApiUrl.tambahTransBukuText
                                    );                        
                              },
                              child: Card(
                                color: Colors.white,
                                child: Card(
                                  color: Colors.blue,
                                  child: Container(
                                    width: 200.0,
                                    margin: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Expanded(child: Image.network(ApiUrl.viewImageBuku+_listBukuDiskon[index]!.imageBook)),
                                          Text(_listBukuDiskon[index]!.judul.toString(),textAlign: TextAlign.center,style:const TextStyle(color: Colors.white,fontSize: 12.0)),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom:8.0),
                                            child: Text("Harga : Rp. ${_listBukuDiskon[index]!.price}",style: const TextStyle(fontSize: 10,color: Colors.white),),
                                          ), 
                                          Padding(
                                            padding: const EdgeInsets.only(bottom:8.0),
                                            child: 
                                            _listBukuDiskon[index]!.price != _listBukuDiskon[index]!.netPrice
                                            ? Text("Harga Setelah Diskon ${_listBukuDiskon[index]!.diskon}% : Rp. ${_listBukuDiskon[index]!.netPrice}",style: const TextStyle(fontSize: 10,color: Colors.white),)
                                            : const Text("Belum Ada Diskon",style: TextStyle(fontSize: 10,color: Colors.white),),
                                          ), 
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),                  
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(
                      tileColor: (index % 2 == 0) ? Colors.white : Colors.green[50],
                      title: Center(
                        child: Card(
                           color: Colors.blue,
                          child: 
                          GestureDetector(
                            onTap: (){
                              _openFormAdd(
                                _listBukuNoDiskon[index]!.idBuku
                                ,true,
                                _listBukuNoDiskon[index]!.imageBook,
                                _listBukuNoDiskon[index]!.judul,
                                _listBukuNoDiskon[index]!.description,
                                _listBukuNoDiskon[index]!.price,
                                _listBukuNoDiskon[index]!.diskon,
                                _listBukuNoDiskon[index]!.netPrice,
                                _listBukuNoDiskon[index]!.potonganHarga,
                                _listBukuNoDiskon[index]!.hargaJual,
                                ApiUrl.tambahTransBukuText
                                );
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(ApiUrl.viewImageBuku+_listBukuNoDiskon[index]!.imageBook),
                                  ),
                                  title: Text(_listBukuNoDiskon[index]!.judul.toString(),
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom:8.0),
                                  child: Text("Harga : Rp. ${_listBukuNoDiskon[index]!.price}",style: const TextStyle(fontSize: 10,color: Colors.white),),
                                ), 
                                Padding(
                                  padding: const EdgeInsets.only(bottom:8.0),
                                  child: 
                                  _listBukuNoDiskon[index]!.price != _listBukuNoDiskon[index]!.netPrice
                                  ? Text("Harga Setelah Diskon ${_listBukuNoDiskon[index]!.diskon}% : Rp. ${_listBukuNoDiskon[index]!.netPrice}",style: const TextStyle(fontSize: 10,color: Colors.white),)
                                  : const Text("Belum Ada Diskon",style: TextStyle(fontSize: 10,color: Colors.white),),
                                ),                               
                              ],
                            ),
                          ),
                        ), //Text
                      ),
                    ), 
                    childCount: _listBukuNoDiskon.length,
                  ),
                )
              ],
            ),
            _openFormAdds == true
            ?_formAdd()
            :Container(),
             cFormAlertBuy == true
            ? _formAlertBuy()
            :Container(),
            tampilAlertMessage == true
            ? _alertMessage()
            : Container(),   
            formDataKeranjang == true
            ? _dataTransBook()
            : Container(),       
            _openFormAdds == true
            ?_formAdd()
            :Container(),     
             cFormAlertBuy == true
            ? _formAlertBuy()
            :Container(),
            tampilAlertMessage == true
            ? _alertMessage()
            : Container(),  
            tampilAlertMessageResponse == true
            ? _alertMessageResponse()  
            : Container(),   
            tampilFormUpdateUser == true
            ? _formUpdateUser()  
            :  Container(),  
            tampilAlertMessageUser == true
            ? _alertMessageUser()
            :  Container(),      
            tampilAlertMessageResponse == true
            ? _alertMessageResponse()  
            : Container(),                                  
          ],
        ),
      ),
    );
  }
}