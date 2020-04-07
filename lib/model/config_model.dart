class ConfigModel{

  final String searchUrl;
  //构造方法{}包括让它成为可选参数
  ConfigModel({this.searchUrl});

  factory ConfigModel.fromJson(Map<String,dynamic> json){
    return ConfigModel(searchUrl: json['searchUrl']);
  }

  Map<String,dynamic> toJson(){
    return {searchUrl:searchUrl};
  }

}