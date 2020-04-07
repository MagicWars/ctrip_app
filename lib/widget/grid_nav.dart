import 'package:ctrip_app/model/common_model.dart';
import 'package:ctrip_app/model/grid_nav_model.dart';
import 'package:ctrip_app/widget/webview.dart';
import 'package:flutter/material.dart';

//网格卡片
//实现思路 分为上中下三个部分
//每一个部分又分为 左边主item 中间item和右边item
class GridNav extends StatelessWidget {

  //@required标记为必传参数
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color:Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  //最外层上中下item实现方法
  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) return items;
    if (gridNavModel.hotel != null) { //如果model 酒店不为空的话创建上的item
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) { //如果model 机票不为空的话创建中间的item
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) { //如果model 旅游不为空的话创建下的item
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  //左中右三个部分
  //first 是否是第一个
  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool first) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));

    //对应海外酒店 特价酒店
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));

    //对应团购 民宿客栈
    //合并三个item使其水平铺满
    List<Widget> expandedItem = [];
    items.forEach((item) {
      expandedItem.add(Expanded(child: item, flex: 1));
    });
    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));
    return Container(
      height: 88,
      margin: first ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          //线性渐变色
          gradient: LinearGradient(colors: [startColor, endColor])
      ),
      child: Row(
        children: expandedItem,
      ),
    );
  }

  //左边大的部分
  _mainItem(BuildContext context, CommonModel commonModel) {
    return _warpGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Image.network(
              commonModel.icon, fit: BoxFit.contain, height: 88, width: 121,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            Container(
              margin: EdgeInsets.only(top:11),
              child: Text(commonModel.title,
                style: TextStyle(color: Colors.white, fontSize: 14)
              ),
            )
          ],
        ), commonModel);
  }

  //生成上下排列的两个小item  @isCenterItem是否是中间的item
  _doubleItem(BuildContext context, CommonModel topItem,
      CommonModel bottomItem) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _item(context, topItem, true),
        ),
        Expanded(
          child: _item(context, bottomItem, false),
        )
      ],
    );
  }

  _item(BuildContext context, CommonModel item, bool first) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      widthFactor: 1,

      //宽度撑满父布局宽度
      child: Container(
        decoration: BoxDecoration(
            border: Border(
              left: borderSide,
              right: borderSide,
              bottom: first ? borderSide : BorderSide.none,

              //只有第一个上边第一个item菜设置bottom的分割线
            )
        ),
        child: _warpGesture(context, Center(
          child: Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ), item),
      ),
    );
  }

  _warpGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      child: widget,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
        (
            WebView(
              url: model.url,
              title: model.title,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppBar,
            )
        )));
      },
    );
  }
}
