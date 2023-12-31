import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:gramed/api/postlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/api.dart';

class Service {
    static Future writeSR(
    String value,
    String idUsersApp,
    String name,
    String username,
    String password,
    String address,
    String level,
    String email,
    String noTelp,
    String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
     
  static Future getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static Future logins(username,password) async{
    var map = FormData.fromMap({
        'ACTION': 'LOGIN',
        'username': username,
        'password': password,
      });  
    var dio = Dio();
    final response = await dio.post(ApiUrl.login, data: map);

    final listUser  = jsonDecode(response.data);
    print(listUser);
    return listUser;
  } 


  static Future <List<PostList>> functionUploadDataBuku(action , idBuku,cBookJudul, cBookPenerbit, 
  cBookPengarang ,cPrices,cDiskons,cBookTahun ,cBookDeskripsi,filePaths, fileName, idUser) async{
    String tglInput = DateTime.now().toString();
    var map = 
    fileName !=""
    ? FormData.fromMap({
        'ACTION': action,
        'id_buku': idBuku.toString(),
        'judul': cBookJudul.toString(),
        'penerbit': cBookPenerbit.toString(),
        'pengarang': cBookPengarang.toString(),
        'price': cPrices.toString(),
        'diskon': cDiskons.toString(),
        'tahun': cBookTahun.toString(),
        'description': cBookDeskripsi.toString(),
        'id_user_input_buku': idUser.toString(),
        'date_user_input_buku': tglInput,      
        'files': MultipartFile.fromFileSync(filePaths.path, filename: fileName),
      })
      :FormData.fromMap({
        'ACTION': action,
        'id_buku': idBuku.toString(),
        'judul': cBookJudul.toString(),
        'penerbit': cBookPenerbit.toString(),
        'pengarang': cBookPengarang.toString(),
        'price': cPrices.toString(),
        'diskon': cDiskons.toString(),
        'tahun': cBookTahun.toString(),
        'description': cBookDeskripsi.toString(),
        'id_user_input_buku': idUser.toString(),
        'date_user_input_buku': tglInput,        
      });
    var dio = Dio();
    final response = 
    action == ApiUrl.tambahBukuText
    ? await dio.post(ApiUrl.addDataBuku, data: map)
    : action == ApiUrl.deleteBukuText
    ? await dio.post(ApiUrl.deleteDataBuku, data: map)
    : action == ApiUrl.editBukuText
    ? await dio.post(ApiUrl.editDataBuku, data: map)
    : await dio.post(ApiUrl.buku, data: map);
    print(action);   
    print(filePaths);    
    print(response.statusCode);
    print("idBuku $idBuku"); 
    List<PostList> list  = parseResponse(response.data);
    return list;
  }   
  
  static Future<List<PostList>> getDataBuku(action,idBuku,judulBuku,penerbit,tahun,idUser) async{
    var map = FormData.fromMap({
        'ACTION': action,
        'id_buku': idBuku,
        'judul': judulBuku,
        'penerbit': penerbit,
        'tahun': tahun,
        'id_user_input_buku': idUser,
      });  
    var dio = Dio();
    final response = await dio.post(ApiUrl.viewDataBuku, data: map);

    List<PostList> listTeam  = parseResponse(response.data);
    return listTeam;
  }

  static Future <List<PostList>> functionUploadDataStockBuku(
    action, cStockBookId ,idBook, cStockBookGrDate ,cStockBookNoNota,cStockBookGrQty,
    idUsersApp) async{
    String tglInput = DateTime.now().toString();
    var map = 
    FormData.fromMap({
        'ACTION': action,
        'id_stock': cStockBookId.toString(),
        'id_book': idBook.toString(),
        'qty_gr': cStockBookGrQty.toString(),
        'date_gr': cStockBookGrDate.toString(),
        'no_note': cStockBookNoNota.toString(),
        'id_user_input_stock': idUsersApp.toString(),
        'date_user_input_stock': tglInput,        
      });
    var dio = Dio();
    final response = 
    action == ApiUrl.tambahStockBukuText
    ? await dio.post(ApiUrl.addDataStockBuku, data: map)
    : action == ApiUrl.deleteStockBukuText
    ? await dio.post(ApiUrl.deleteDataStockBuku, data: map)
    : action == ApiUrl.editStockBukuText
    ? await dio.post(ApiUrl.editDataStockBuku, data: map)
    : await dio.post(ApiUrl.stockBook, data: map);
    print(action);    
    print(response.statusCode); 
    List<PostList> list  = parseResponse(response.data);
    return list;
  }   

  static Future<List<PostList>> getStockTransBuku(action, idTransaksi ,qtyPick, idBook ,codeTransaction,stateTransaction,totalPayment,
    idUsersApp,alamat,level) async{
    var map = FormData.fromMap({
        'ACTION': action,
        'id_transaction': idTransaksi.toString(),
        'qty_pick': qtyPick.toString(),
        'id_book': idBook.toString(),
        'code_transaction': codeTransaction.toString(),
        'total_payment': totalPayment.toString(),
        'state_transaction': stateTransaction,        
        'id_user': idUsersApp.toString(),  
        'alamat': alamat.toString(),  
        'level': level.toString()
      });  
    var dio = Dio();
    final response = await dio.post(ApiUrl.viewTransBuku, data: map);

    List<PostList> listTeam  = parseResponse(response.data);
    print(listTeam);
    return listTeam;
    
  }

  static Future <List<PostList>> functionUploadDataTransaksi(
    action, idTransaksi ,qtyPick, idBook ,codeTransaction,stateTransaction,totalPayment,
    idUsersApp,alamat) async{
    String tglInput = DateTime.now().toString();
    var map = 
    FormData.fromMap({
        'ACTION': action,
        'id_transaction': idTransaksi.toString(),
        'qty_pick': qtyPick.toString(),
        'id_book': idBook.toString(),
        'code_transaction': codeTransaction.toString(),
        'date_transaction': tglInput.toString(),
        'total_payment': totalPayment.toString(),
        'state_transaction': stateTransaction,        
        'id_user': idUsersApp.toString(),        
        'alamat': alamat.toString(),  
      });
    var dio = Dio();
    final response = 
    action == ApiUrl.tambahTransBukuText
    ? await dio.post(ApiUrl.addTransBuku, data: map)
    : action == ApiUrl.deleteTransBukuText
    ? await dio.post(ApiUrl.deleteTransBuku, data: map)
    : action == ApiUrl.editTransBuku
    ? await dio.post(ApiUrl.editTransBuku, data: map)
    : await dio.post(ApiUrl.transaksiBuku, data: map);
    print(action);    
    print(response.statusCode); 
    List<PostList> list  = parseResponse(response.data);
    return list;
  }

  static Future<List<PostList>> getStockDataBuku(action,idStock,idBuku,tglGr,noNota,idUsersApp) async{
    var map = FormData.fromMap({
        'ACTION': action,
        'id_stock': idStock,
        'id_book': idBuku,
        'date_gr': tglGr,
        'no_note': noNota,
        'id_user_input_stock': idUsersApp,
      });  
    var dio = Dio();
    final response = await dio.post(ApiUrl.viewDataStockBuku, data: map);

    List<PostList> listTeam  = parseResponse(response.data);
    return listTeam;
  }

  static Future<List<PostList>> getDataUser(action,idUser,name,username,level,noTelp) async{
    var map = FormData.fromMap({
        'ACTION': action,
        'id_user': idUser,
        'name': name,
        'username': username,
        'level': level,
        'no_telp': noTelp,
      });  
    var dio = Dio();
    final response = await dio.post(ApiUrl.viewDataUser, data: map);

    List<PostList> listUser  = parseResponse(response.data);
    return listUser;
  }

  static Future <List<PostList>> functionUploadDataUser(action , cUserId ,cName, cUsername, cPassword1 , cPassword2,
  cAddress ,cLevel,cEmail, cNoTelp, idUsersApp) async{
    var map = FormData.fromMap({
        'ACTION': action,
        'id_user': cUserId.toString(),
        'name': cName.toString(),
        'username': cUsername.toString(),
        'password1': cPassword1.toString(),
        'password2': cPassword2.toString(),
        'address': cAddress.toString(),
        'level': cLevel.toString(),
        'email': cEmail.toString(),
        'no_telp': cNoTelp.toString(),       
      });
    var dio = Dio();
    final response = 
    action == ApiUrl.tambahUserText
    ? await dio.post(ApiUrl.addDataUser, data: map)
    : action == ApiUrl.deleteUserText
    ? await dio.post(ApiUrl.deleteDataUser, data: map)
    : action == ApiUrl.editUserText
    ? await dio.post(ApiUrl.editDataUser, data: map)
    : await dio.post(ApiUrl.user, data: map);
    print(action);      
    print(response.statusCode);
    print("cUserId $cUserId");
    print(ApiUrl.editDataUser);
    List<PostList> list  = parseResponse(response.data);
    return list;
  }  

  static List<PostList> parseResponse(String responseBody) {
    final  parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PostList>((e) => PostList.fromJsons(e)).toList();
  }  

  
}