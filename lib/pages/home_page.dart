import 'dart:convert';

import 'package:ctrip_app/dao/home_dao.dart';
import 'package:ctrip_app/model/common_model.dart';
import 'package:ctrip_app/model/grid_nav_model.dart';
import 'package:ctrip_app/model/home_model.dart';
import 'package:ctrip_app/model/sales_box_model.dart';
import 'package:ctrip_app/pages/search_page.dart';
import 'package:ctrip_app/widget/local_nav.dart';
import 'package:ctrip_app/widget/grid_nav.dart';
import 'package:ctrip_app/widget/loading_container.dart';
import 'package:ctrip_app/widget/sales_box.dart';
import 'package:ctrip_app/widget/search_bar.dart';
import 'package:ctrip_app/widget/sub_nav.dart';
import 'package:ctrip_app/widget/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


const APPBAR_SCROLL_OFFSET = 100; //滚动最大距离 当滚动大于100完全变成白色
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {

  double appBarAlpha = 0; //appBar渐变值
  String resultJson = "";
  List<CommonModel> bannerList = [];
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleRefresh();
  }

  Future<Null> _handleRefresh() async {
    //两种方式请求
    //1.类似于es6的请求方式
//     HomeDao.fetch().then((value){
//       setState(() {
//         resultJson = json.encode(value.config);
//       });
//     }).catchError((e){
//       setState(() {
//         resultJson = e.toString();
//       });
//     });

    //2. async await 异步请求
    try {
      HomeModel homeModel = await HomeDao.fetch();
      setState(() {
        //resultJson = json.encode(homeModel.config);
        localNavList = homeModel.localNavList;
        bannerList = homeModel.bannerList;
        subNavList = homeModel.subNavList;
        gridNavModel = homeModel.gridNav;
        salesBoxModel = homeModel.salesBoxModel;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body:Stack(
          children: <Widget>[
            MediaQuery.removePadding( //去掉listView与状态栏的安全距离
                removeTop: true, //去掉顶部的
                context: context,
                child: RefreshIndicator(child: NotificationListener( //监听所有列表的滚动
                    onNotification: (scrollNotification) {
                      //NotificationListener 会根据子控件一层层往下找
                      //scrollNotification.depth == 0 只监听listView(下标为0) 否则会连Swiper一块监听了
                      if (scrollNotification is ScrollUpdateNotification &&
                          scrollNotification.depth == 0) {
                        _onScroll(scrollNotification.metrics.pixels);
                      }
                      return;
                    },
                    child: _listView
                ), onRefresh: _handleRefresh)
            ),
            _appBar
          ],
        )
    );
  }

  /**
   * pixels滚动的距离
   */
  _onScroll(double pixels) {
    double alpha = pixels / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  Widget get _appBar  {
//    return Opacity(
//      opacity: appBarAlpha, //透明度
//      child: Container(
//        height: 80,
//        decoration: BoxDecoration(color: Colors.white),
//        child: Center(
//          child: Padding(
//            padding: EdgeInsets.only(top: 20),
//            child: Text("首页"),
//          ),
//        ),
//      ),
//    );
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
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
            height: appBarAlpha > 0.2 ? 0.5 : 0,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]))
      ],
    );
  }

  Widget get _banner {
    return Swiper(
      itemCount: bannerList.length,
      autoplay: true,
      //自动播放
      loop: true,
      //是否循环播放
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>
            (
                WebView(url: bannerList[index].url,
                  statusBarColor: bannerList[index].statusBarColor,
                  hideAppBar: bannerList[index].hideAppBar,)
            )));
          },
          child: Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill //适配方式 填充
          ),
        );
      },
      pagination: SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          size: 5,
          activeSize: 8,
          color:Colors.white,
          activeColor: Colors.grey,
        ),
        alignment: Alignment.bottomRight
      ),
    );
  }

  Widget get _listView {
    return ListView( //listView自带与状态栏 安全距离
      children: <Widget>[
        Container(
          height: 180, //banner高度
          child: _banner
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList,),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNav(gridNavModel: gridNavModel),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SalesBox(salesBox: salesBoxModel),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;



  void _jumpToSearch() {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return SearchPage(hint: SEARCH_BAR_DEFAULT_TEXT,hideLeft: true,);
    }));
  }

  void _jumpToSpeak() {

  }
}

