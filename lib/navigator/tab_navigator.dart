import 'package:ctrip_app/pages/home_page.dart';
import 'package:ctrip_app/pages/my_page.dart';
import 'package:ctrip_app/pages/search_page.dart';
import 'package:ctrip_app/pages/travel_page.dart';
import 'package:flutter/material.dart';

//2020年2月19日17:11:49底部导航
class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => new _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  final PageController _controller = new PageController(
      //初始page 页面打开默认显示的页面
      initialPage: 0
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
//        onPageChanged: (index){
//          //手势滑动的同时改变_currentIndex使其bottomNavigationBar也进行改变
//          setState(() {
//            _currentIndex = index;
//          });
//        },
        controller: _controller,
        children: <Widget>[
            HomePage(),
            SearchPage(hideLeft: true,),
            TravelPage(),
            MyPage()
        ],
        physics: NeverScrollableScrollPhysics(),//禁止滑动
        pageSnapping: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index){
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          unselectedFontSize: 12,//未选中文字大小
          selectedFontSize: 12,//选中文字大小
          type: BottomNavigationBarType.fixed,
          items: [
            _tabItem(0,"首页",Icons.home,_defaultColor,_activeColor),
            _tabItem(1,"搜索",Icons.search,_defaultColor,_activeColor),
            _tabItem(2,"旅拍",Icons.camera_alt,_defaultColor,_activeColor),
            _tabItem(3,"我的",Icons.account_circle,_defaultColor,_activeColor),
//            BottomNavigationBarItem(
//                icon: Icon(
//                    Icons.home,
//                    color: _defaultColor,
//                ),
//                activeIcon: Icon(
//                    Icons.home,
//                    color:_activeColor
//                ),
//                title: Text("首页",
//                    style: TextStyle(color: _currentIndex !=0 ? _defaultColor:_activeColor))
//            ),
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.search,
//                  color: _defaultColor,
//                ),
//                activeIcon: Icon(
//                    Icons.search,
//                    color:_activeColor
//                ),
//                title: Text("搜索",
//                    style: TextStyle(color: _currentIndex !=1 ? _defaultColor:_activeColor))
//            ),
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.camera_alt,
//                  color: _defaultColor,
//                ),
//                activeIcon: Icon(
//                    Icons.camera_alt,
//                    color:_activeColor
//                ),
//                title: Text("旅拍",
//                    style: TextStyle(color: _currentIndex !=2 ? _defaultColor:_activeColor))
//            ),
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.account_circle,
//                  color: _defaultColor,
//                ),
//                activeIcon: Icon(
//                    Icons.account_circle,
//                    color:_activeColor
//                ),
//                title: Text("我的",
//                    style: TextStyle(color: _currentIndex !=3 ? _defaultColor:_activeColor))
//            )
          ]
      ),
    );
  }

  _tabItem(int index,String s, IconData icon, MaterialColor defaultColor, MaterialColor activeColor) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: defaultColor,
        ),
        activeIcon: Icon(
            icon,
            color:activeColor
        ),
        title: Text(s,
            style: TextStyle(color: _currentIndex !=index ? defaultColor:activeColor))
    );
  }

}
