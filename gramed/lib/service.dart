import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:gramed/api/postlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/api.dart';

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

  static Future <List<PostList>> functionUploadDataBuku(action , cBookJudul, cBookPenerbit, 
  cBookPengarang ,cBookTahun ,cBookDeskripsi,filePaths, fileName, idUser) async{
    String tglInput = DateTime.now().toString();
    var map = FormData.fromMap({
        'ACTION': action,
        'id_buku': "",
        'judul': cBookJudul.toString(),
        'penerbit': cBookPenerbit.toString(),
        'pengarang': cBookPengarang.toString(),
        'tahun': cBookTahun.toString(),
        'description': cBookDeskripsi.toString(),
        'id_user_input_buku': idUser.toString(),
        'date_user_input': tglInput,
        'date_user_input_buku': tglInput,        
        'files': MultipartFile.fromFileSync(filePaths.path, filename: fileName),
      });  
    var dio = Dio();
    final response = await dio.post(ApiUrl.addDataBuku, data: map);
    print(filePaths);    
    print(response.statusCode);
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

  static List<PostList> parseResponse(String responseBody) {
    final  parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PostList>((e) => PostList.fromJsons(e)).toList();
  }  

  
}