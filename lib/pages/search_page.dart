import 'package:ctrip_app/dao/search_dao.dart';
import 'package:ctrip_app/model/search_model.dart';
import 'package:ctrip_app/widget/search_bar.dart';
import 'package:ctrip_app/widget/webview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //将相应内容转化为一个json map
const URL =
    'https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=';
const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];
class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;
  const SearchPage({Key key, this.hideLeft, this.searchUrl = URL, this.keyword, this.hint}) : super(key: key);
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        resizeToAvoidBottomPadding: false,//软键盘遮挡listView
        body: Column(
          children: <Widget>[
            _appBar(),
            MediaQuery.removePadding(
                removeTop: true,
                context: context, 
                child: Expanded(
                    flex:1,
                    child: ListView.builder(
                        itemCount: searchModel?.data?.length ?? 0,
                        itemBuilder: (BuildContext context,int position){
                  return _item(position);
                }))
            )
          ],
        ),
      )
    );
  }

  _appBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
              padding: EdgeInsets.only(top: 25),
              height: 80,
              decoration: BoxDecoration(color: Colors.white),
              child: SearchBar(
                hideLeft: widget.hideLeft,
                defaultText: widget.keyword,
                hint: widget.hint,
                speakClick: _jumpToSpeak,
                rightButtonClick: (){
                  //FocusScope.of(context).requestFocus(FocusNode());
                },
                leftButtonClick: () {
                  //FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(context);
                },
                onChanged: _onTextChange,
              )),
        )
      ],
    );
  }

  void _onTextChange(String value){
    keyword = value;
    if(value.length == 0){
      setState(() {
          searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl + value;
    SearchDao.fetch(url, value).then((SearchModel model){
      //只有当当前输入的内容和服务端返回的内容一致时才渲染，优化网络请求延迟造成加载顺序不同
      if(model.keyword == keyword){
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e){
      print(e);
    });
  }


  void _jumpToSpeak() {

  }

  Widget _item(int position) {
    if(searchModel == null || searchModel.data == null) return null;
    SearchItem data = searchModel.data[position];
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>
        (
            WebView(url: data.url,title: data.word,)
        )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3,color: Colors.grey))
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                width: 24,
                height: 24,
                image: AssetImage(_typeImage(data.type)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(data),
                ),
                Container(
                  width: 300,
                  child: _subTitle(data),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String _typeImage(String type) {
    if(type == null) return 'images/type_travelgroup.png';
    String path = "travelgroup";
    for(final val in TYPES){
      if(type.contains(val)){
        path = val;
        break;
      }
    }
    return 'images/type_$path.png';
  }

  _title(SearchItem data) {
    if(data == null) return null;
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(data.word, searchModel.keyword));
    spans.add(TextSpan(
        text: ' ' + (data.districtname ?? '') + ' ' + (data.zonename ?? ''),
        style: TextStyle(fontSize: 16, color: Colors.grey))
    );
    return RichText(text: TextSpan(children: spans));
  }

  _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) return spans;
    //搜索关键字高亮忽略大小写
    String wordL = word.toLowerCase(), keywordL = keyword.toLowerCase();
    List<String> arr = wordL.split(keywordL);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    //'wordwoc'.split('w') -> [, ord, oc] @https://www.tutorialspoint.com/tpcg.php?p=wcpcUA
    int preIndex = 0;
    for (int i = 0; i < arr.length; i++) {
      if (i != 0) {
        //搜索关键字高亮忽略大小写
        preIndex = wordL.indexOf(keywordL, preIndex);
        spans.add(TextSpan(
            text: word.substring(preIndex, preIndex + keyword.length),
            style: keywordStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }

  _subTitle(SearchItem data) {
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
          text: data.price ?? '',
          style: TextStyle(fontSize: 16, color: Colors.orange),
        ),
        TextSpan(
          text: ' ' + (data.star ?? ''),
          style: TextStyle(fontSize: 12, color: Colors.grey),
        )
      ]),
    );
  }
}

