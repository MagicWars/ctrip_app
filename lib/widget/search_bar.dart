import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {

  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
        this.enabled = true,
        this.hideLeft,
        this.searchBarType = SearchBarType.normal,
        this.hint, this.defaultText,
        this.leftButtonClick,
        this.rightButtonClick,
        this.speakClick, this.inputBoxClick, this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => new _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false; //是否显示×按钮
  final TextEditingController _controller = TextEditingController(); //动态获取输入框变化

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _genNormalSearch() : _genHomeSearch();
  }

  _genHomeSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left:5),
            child:Row(
              children: <Widget>[
                Text('上海',
                  style: TextStyle(fontSize: 14,color:_homeFontColor()),
                ),
                Icon(Icons.expand_more,size: 22,color:_homeFontColor())
              ],
            ),
          ),
          Expanded( //中间输入框
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(Container(//右边搜索
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Icon(
              Icons.comment,
              color:_homeFontColor(),
              size: 25,
            ),
          ), widget.rightButtonClick)
        ],
      ),
    );
  }

  _genNormalSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(Container(//左边按钮
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: widget?.hideLeft ?? false ? null : Icon(
                Icons.arrow_back_ios),
          ), widget.leftButtonClick),
          Expanded( //中间输入框
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(Container(//右边搜索
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(
              '搜索', style: TextStyle(color: Colors.blue, fontSize: 15),),
          ), widget.rightButtonClick)
        ],
      ),
    );
  }

  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      child: child,
    );
  }

  _inputBox() {
    Color inputBoxColor;
    if(widget.searchBarType == SearchBarType.home){
      inputBoxColor = Colors.white;//首页input背景色为白色
    }else{
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }
    return Container(
        height: 30,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color:inputBoxColor,
          borderRadius: BorderRadius.circular(widget.searchBarType == SearchBarType.normal ? 5 :15)
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.search,size:20,color:widget.searchBarType == SearchBarType.normal ? Color(0xffa9a9a9) : Colors.blue),
            Expanded(
              flex: 1,
              child: widget.searchBarType == SearchBarType.normal ?TextField(
                controller: _controller,
                onChanged: _onChanged,
                autofocus: true,//自动获取焦点(光标)
                style: TextStyle(//此样式是输入框内文本的样式
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.start,
                decoration: InputDecoration(//这个才是输入框的样式
                  contentPadding:EdgeInsets.only(left:5,top: 12,right: 5),
                  //
                  //border: InputBorder.none,
                  border: OutlineInputBorder(borderSide: BorderSide.none), //input不在container中居中的问题
                  hintText: widget.hint ?? '',
                  hintStyle: TextStyle(fontSize: 15),
                ),
              ): _wrapTap(Container(//首页假搜索框
                child: Text(
                  widget.defaultText,
                  style: TextStyle(fontSize: 13,color:Colors.grey),
                ),
              ), widget.inputBoxClick)
            ),
            !showClear?_wrapTap(
              Icon(
                Icons.mic,
                size: 20,
                color: widget.searchBarType == SearchBarType.normal ? Colors.blue:Colors.grey), widget.speakClick):
            _wrapTap(Icon(Icons.clear,size: 20,color:Colors.grey), () {
              setState(() {
                _controller.clear();
              });
              _onChanged('');
            })
          ],
        ),
    );
  }


  void _onChanged(String value) {
    if(value.length > 0){
      setState(() {
        showClear = true;
      });
    }else{
      setState(() {
        showClear = false;
      });
    }
    if(widget.onChanged != null){
      widget.onChanged(value);
    }
  }

  ///滑动的时候高亮状态下是灰色 否则就是白色
  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight ? Colors.black54 : Colors.white;
  }
}
