import 'package:ctrip_app/dao/travel_tab_dao.dart';
import 'package:ctrip_app/model/travel_tab_model.dart';
import 'package:ctrip_app/pages/travel_tab_page.dart';
import 'package:flutter/material.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => new _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin{

  TabController _controller;//tabView控制器
  List<TravelTab> tabs = [];
  TravelTabModel travelTabModel;

  @override
  void initState() {
    _controller = TabController(length: 0, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model){
        _controller = TabController(length: model.tabs.length, vsync: this);//解决tab bar空白问题
      setState(() {
        tabs = model.tabs;
        travelTabModel = model;
      });
    }).catchError((e){
      print('出错了');
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color:Colors.white,
          padding: EdgeInsets.only(top:30),
          child: TabBar(
              controller: _controller,
              isScrollable: true,//横向滑动
              labelColor: Colors.black,//文字选中颜色
              labelPadding: EdgeInsets.fromLTRB(10, 0, 10, 5),
              indicatorSize: TabBarIndicatorSize.label,//指示器宽度跟文字等宽
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.blue
                  ),
                insets: EdgeInsets.only(bottom: 10)
              ),
              tabs: tabs.map<Tab>((TravelTab tab){
                return Tab(
                  text:tab.labelName
                );
              }).toList()
          ),
        ),
        Flexible(
          child:TabBarView(
              controller: _controller,
              children: tabs.map((TravelTab tab){
                  return TravelTabPage(
                      travelUrl: travelTabModel.url,
                      groupChannelCode: tab.groupChannelCode,
                      params: travelTabModel.params,
                  );
              }).toList()) ,
        )
      ],
    );
  }
}

