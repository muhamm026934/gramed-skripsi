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
  cBookPengarang ,cBookTahun ,cBookDeskripsi,filePaths, fileName, idUser) async{
    String tglInput = DateTime.now().toString();
    var map = 
    fileName !=""
    ? FormData.fromMap({
        'ACTION': action,
        'id_buku': idBuku.toString(),
        'judul': cBookJudul.toString(),
        'penerbit': cBookPenerbit.toString(),
        'pengarang': cBookPengarang.toString(),
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
    String tglInput = DateTime.now().toString();
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
    List<PostList> list  = parseResponse(response.data);
    return list;
  }  

  static List<PostList> parseResponse(String responseBody) {
    final  parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PostList>((e) => PostList.fromJsons(e)).toList();
  }  

  
}