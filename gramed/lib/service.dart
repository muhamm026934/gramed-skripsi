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

  static Future <List<PostList>> functionUploadDataBuku(action , filePaths, fileName, idUser) async{
    String tglInput = DateTime.now().toString();
    var map = FormData.fromMap({
        'ACTION': action,
        'id_user_input': idUser.toString(),
        'date_user_input': tglInput,
        'date_update': tglInput,        
        'files': MultipartFile.fromFileSync(filePaths.path, filename: fileName),
      });  
    var dio = Dio();
    final response = await dio.post(ApiUrl.addDataBuku, data: map);
    print(filePaths);    
    print(response.statusCode);
    List<PostList> listOwss  = parseResponse(response.data);
    return listOwss;
  }   
  
  static Future functionDataSec(action , filePaths, fileName, idUser) async{
    String tglInput = DateTime.now().toString();
    var map = FormData.fromMap({
        'ACTION': '$action',
        'id_sec': '$filePaths',
        'section': '$fileName',
        'status_sec': '$idUser',
        'input_sec_by': '$idUser',
        'input_sec_date': tglInput,
      });  
    var dio = Dio();
    final response = await dio.post(ApiUrl.addDataBuku, data: map);
    final listSec  = jsonDecode(response.data);
    return listSec;
  }  

  static List<PostList> parseResponse(String responseBody) {
    final  parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PostList>((e) => PostList.fromJsons(e)).toList();
  }  

  
}