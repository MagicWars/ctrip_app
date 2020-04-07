import 'dart:async';
import 'dart:convert';
import 'package:ctrip_app/model/home_model.dart';
import 'package:ctrip_app/model/search_model.dart';
import 'package:http/http.dart' as http;
//搜索大接口
class SearchDao{

  static Future<SearchModel> fetch(String url,String keyword) async{
     final response = await http.get(url);
     if(response.statusCode == 200){
       Utf8Decoder utf8decoder = Utf8Decoder();//解析中文乱码
       var result = json.decode(utf8decoder.convert(response.bodyBytes));
       SearchModel model = SearchModel.fromJson(result);
       model.keyword = keyword;
       return model;
     }else{
       throw Exception('Failed to load home_page.json');
     }
  }

}