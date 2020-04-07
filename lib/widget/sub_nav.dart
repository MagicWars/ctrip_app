import 'package:ctrip_app/model/common_model.dart';
import 'package:ctrip_app/model/grid_nav_model.dart';
import 'package:ctrip_app/widget/webview.dart';
import 'package:flutter/material.dart';

class SubNav extends StatelessWidget {

  final List<CommonModel> subNavList;

  const SubNav({Key key,@required this.subNavList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
      if(subNavList==null) return null;
      List<Widget> items = [];
      subNavList.forEach((model) {
        items.add(_item(context,model));
      });
      int separate = (subNavList.length / 2 + 0.5).toInt();
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(0, separate),
          ),
          Padding(
            padding: EdgeInsets.only(top:10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items.sublist(separate, subNavList.length),
            ),
          )
        ],
      );
  }

  Widget _item(BuildContext context, CommonModel model) {
      //GestureDetector 可点击包裹
      //Expanded 类似Android的 weight:1
      return Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>(
                WebView(url:model.url,statusBarColor: model.statusBarColor,hideAppBar: model.hideAppBar,)
            )));
          },
          child: Column(
            children: <Widget>[
              Image.network(
                model.icon,
                width: 18,
                height: 18,
              ),
              Padding(
                padding: EdgeInsets.only(top:5),
                child: Text(
                    model.title,
                    style: TextStyle(fontSize: 12)
                ),
              )

            ],
          ),
        ),
      );
  }

}
