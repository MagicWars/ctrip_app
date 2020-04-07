import 'package:ctrip_app/widget/webview.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        url: 'https://m.ctrip.com/webapp/myctrip/',
        hideAppBar: true,
        backForbid: true,
        statusBarColor: '4c5bca',
      ),
    );
  }
}

