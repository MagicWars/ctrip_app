import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];
//自定义webView
class WebView extends StatefulWidget {
  String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  WebView(
      {this.url,
        this.statusBarColor,
        this.title,
        this.hideAppBar,
        this.backForbid = false}) {
    if (url != null && url.contains('ctrip.com')) {
      //fix 携程H5 http://无法打开问题
      url = url.replaceAll("http://", 'https://');
    }
  }

  @override
  _WebViewState createState() => new _WebViewState();
}

class _WebViewState extends State<WebView> {
  //使用步骤:
  //1.创建webViewPlugin实例
  final webViewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webViewReference.close();//防止页面重新打开先关闭一次
    //页面url发生变化监听
    _onUrlChanged = webViewReference.onUrlChanged.listen((String url) {

    });
    //页面导航状态发生改变
    _onStateChanged = webViewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch(state.type){
        case WebViewState.startLoad:
          if(_isToMain(state.url)){
              if(widget.backForbid  && !exiting){
                webViewReference.launch(widget.url);
              }else{
                Navigator.pop(context);
                exiting = true;//标识是否返回
              }
          }
          break;
        default:
          break;
      }
    });
    //url错误网络变化
    _onHttpError = webViewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _onHttpError.cancel();
    _onStateChanged.cancel();
    _onUrlChanged.cancel();//别忘了关闭注册监听
    webViewReference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse('0xff'+statusBarColorStr)),backButtonColor),
          Expanded(//Expanded 撑满整个页面
              child: WebviewScaffold(
                  url: widget.url,
                  withZoom: true,//是否可以缩放
                  withLocalStorage: true,//是否启用缓存
                  hidden: false,//默认状态下是否隐藏
                  initialChild: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text('loading...')
                    ),
                  ),//等待加载过程的界面
              ),
          )
        ],
      ),
    );
  }

  /**
   * backgroundColor背景色
   * backButtonColor 返回按钮颜色
   */
  _appBar(Color backgroundColor,Color backButtonColor) {
    if(widget.hideAppBar??false){
      //隐藏状态下的appBar
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    //显示状态下
    return Container(
      color:backgroundColor,
      padding: EdgeInsets.fromLTRB(0,40,0,10),
      //FractionallySizedBox 撑满屏幕宽度
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                  Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left:10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title??'',
                  style: TextStyle(color: backButtonColor,fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool _isToMain(String url) {
    bool contain = false;
    for(final value in CATCH_URLS){
      if(url?.endsWith(value)??false){ // ?.判断这个object是否存在
          contain = true;
          break;
      }
    }
    return contain;
  }
}
