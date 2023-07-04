import 'package:flutter/material.dart';
import 'package:gramed/api/api.dart';
import 'package:gramed/api/postlist.dart';
import 'package:gramed/service.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {

  void initState() {
    super.initState();
    _getPref();
    _getDataUser("","","","","","");
    _loading;
  }

  List<PostList?> _listUser = [];
  List<PostList?> _allListUser = [];
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

  _getDataUser(action,idUsers,names,usernames,levels,noTelps) async{
    setState(() {
      _loading = true;
    });
    Service.getDataUser(action,idUsers,names,usernames,levels,noTelps).then((value) async {
      setState(() {
        _listUser = value;
        _allListUser = value;
        _loading = false;
      });
    });
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

  bool tampilFormUpdateAdd = false;
  String textFormUpdateAdd = "", headerText = "";

  _commandFormUpdateAdd(textFormUpdateAdds, tampilFormUpdateAdds){
    setState(() {
      textFormUpdateAdd = textFormUpdateAdds;
      tampilFormUpdateAdd = tampilFormUpdateAdds;
      headerText = textFormUpdateAdds;
    });
  }
 String message = "", values = "";
 List<PostList?> _messageUpload = [];
 _functionUploadDataUser() async{
  setState(() {
    _loading = true;
  });
  
  Service.functionUploadDataUser(
    headerText, cUserId.text ,cName.text, cUsername.text, cPassword1.text ,cPassword2.text
    ,cAddress.text ,cLevel.text,
    cEmail.text, cNoTelp.text, idUsersApp).then((value) async {
    setState(() {
      _messageUpload = value;
      _loading = false;
      message = _messageUpload[0]!.message.toString();
      values = _messageUpload[0]!.value.toString();   
      print("message $message");
      print(values);    
      
      if (values == "1") {
        setState(() {
          _messageUpload.clear();
          message ="";
          values ="";
          _clearCtext();
          _commandFormUpdateAdd("", false);
          _getDataUser("","","","","","");
        });
      }else{
        setState(() {
        
        });
      }
    });
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

  _editDataUser(cUserIds,cNames,cUsernames,cPassword1s,cPassword2s,cAddresss,cLevels,cEmails,cNoTelps,cTokens,headers){
    setState(() {
        cUserId.text = cUserIds;
        cName.text = cNames;
        cUsername.text = cUsernames;
        cPassword1.text = cPassword1s;
        cPassword2.text = cPassword2s;
        cAddress.text = cAddresss;
        cLevel.text = cLevels;
        cEmail.text = cEmails;
        cNoTelp.text = cNoTelps;
        cToken.text = cTokens;
        _commandFormUpdateAdd(headers, true);
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
                            ), child: const Text('Simpan Data',style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              _functionUploadDataUser();
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
              label: Text("Pencarian User",style: TextStyle(fontSize: 10,color: Colors.white),),
            ),                
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: _listUser.length,
            itemBuilder: (context,index){
              final listDataUser = _listUser[index]; 
              return Card(
                color: Colors.blue,
                child: ListTile(
                  title: Text(listDataUser!.name),
                  subtitle: Text(listDataUser.username),
                  leading: IconButton(onPressed: (){
                    
                  }, icon: const Icon(Icons.delete,color: Colors.white,)),
                  trailing: IconButton(onPressed: (){
                    _editDataUser(
                      listDataUser.idUser,
                      listDataUser.name,
                      listDataUser.username,
                      listDataUser.password,
                      listDataUser.password,
                      listDataUser.address,
                      listDataUser.level,
                      listDataUser.email,
                      listDataUser.noTelp,
                      listDataUser.token,
                      ApiUrl.editUserText);
                  }, icon: const Icon(Icons.edit,color: Colors.white)),
                ),
              );
            }
          ),
            tampilFormUpdateAdd == true
            ? _formUpdateAdd()
            : Container()          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _commandFormUpdateAdd(ApiUrl.tambahUserText, true);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),      
    );
  }
}