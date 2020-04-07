import 'package:ctrip_app/navigator/tab_navigator.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '携程旅行',
      theme: ThemeData(
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,//水波纹颜色 改成透明色
        highlightColor: Colors.transparent//设置点击后的颜色 也改成透明 可以是bottomBar点击无水波纹效果
      ),
      home: TabNavigator(),
    );
  }
}
