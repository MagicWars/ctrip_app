import 'package:ctrip_app/widget/loading_container.dart';
import 'package:ctrip_app/widget/webview.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ctrip_app/dao/travel_dao.dart';
import 'package:ctrip_app/model/travel_model.dart';
import 'package:flutter/material.dart';

const PAGE_SIZE = 10;
const _TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';
class TravelTabPage extends StatefulWidget {
  final String travelUrl;
  final Map params;
  final String groupChannelCode;

  const TravelTabPage({Key key, this.travelUrl, this.groupChannelCode, this.params}) : super(key: key);
  @override
  _TravelTabPageState createState() => new _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage> with AutomaticKeepAliveClientMixin{
  List<TravelItem> travelItems = [];
  int pageIndex = 1;
  bool _loading = true;

  ScrollController _scrollController = ScrollController();//监听页面滚动位置达成加载更多

  @override
  void initState() {
    _loadData();
    _scrollController.addListener(() {
      //如果滚动像素位置等于最大滚动区域(底部就加载更多)
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        _loadData(loadMore: true);
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingContainer(
        isLoading:_loading,
        child: RefreshIndicator(child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: StaggeredGridView.countBuilder(
              controller: _scrollController,
              crossAxisCount: 4, //4/2=2每行显示两个
              itemCount: travelItems?.length ?? 0,
              itemBuilder: (BuildContext context, int index) => _TravelItem(
                index: index,
                item: travelItems[index],
              ),
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
            )
        ), onRefresh: _handlerRefresh),
      ),
    );
  }

  void _loadData({loadMore  = false}) {
    if(loadMore){
      pageIndex++;
    }else{
      pageIndex=1;
    }
    TravelDao.fetch(widget.travelUrl??_TRAVEL_URL, widget.params,widget.groupChannelCode, pageIndex, PAGE_SIZE)
        .then((TravelItemModel model){
      _loading = false;
      setState(() {
        List<TravelItem> items = _filerItems(model.resultList);
        if(travelItems!=null){
          travelItems.addAll(items);
        }else{
          travelItems = items;
        }
      });
    }).catchError((e){
      _loading = false;
      print(e);
    });
  }

  List<TravelItem> _filerItems(List<TravelItem> resultList) {
    //去掉空的数据
    if(resultList == null){
      return [];
    }
    List<TravelItem> items = [];
    resultList.forEach((item) {
      if(item.article!=null){
        items.add(item);
      }
    });
    return items;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;  //让内容进行饱和 切换时不重新加载 数据过多不建议使用可能会造成内存泄露

  Future<Null> _handlerRefresh() async{
    _loadData();
    return null;
  }
}
class _TravelItem extends StatelessWidget {
  final TravelItem item;
  final int index;

  const _TravelItem({Key key, this.item, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          if(item.article.urls!=null && item.article.urls.length>0){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>
            (
                WebView(url: item.article.urls[0].h5Url,title: '详情',)
            )));
          }
      },
      child: Card(
        child: PhysicalModel(//裁切成圆角
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,//抗锯齿你懂得
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _itemImage(),
                Container(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    item.article.articleTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87
                    ),
                  ),
                ),
                _infoText(),
              ],
            ),
        ),
      ),
    );
  }

  _itemImage() {
    return Stack(
      children: <Widget>[
        Image.network(item.article.images[0]?.dynamicUrl),
        Positioned(
          left: 8,
          bottom: 5,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: BoxDecoration(
              color:Colors.black54,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                LimitedBox(
                  maxWidth: 130,//最大宽度使其文字省略号
                  child: Text(
                      _poiName(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,//尾部省略号
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  String _poiName() {
    return item.article.pois == null || item.article.pois.length == 0
        ? '未知'
        : item.article.pois[0]?.poiName ?? '未知';
  }

  _infoText() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              PhysicalModel(
                color:Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(item.article.author?.coverImage?.dynamicUrl,width: 24,height: 24,),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  item.article.author?.nickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.thumb_up,size: 14,color: Colors.grey,),
              Padding(
                padding: EdgeInsets.only(left:3),
                child: Text(
                  item.article.likeCount.toString(),
                  style: TextStyle(
                    fontSize: 10
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

