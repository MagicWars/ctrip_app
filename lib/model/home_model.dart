import 'package:ctrip_app/model/grid_nav_model.dart';
import 'package:ctrip_app/model/sales_box_model.dart';

import 'common_model.dart';
import 'config_model.dart';

class HomeModel {

  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBoxModel;

  HomeModel(
      {this.config, this.bannerList, this.localNavList, this.subNavList, this.gridNav,this.salesBoxModel});

  factory HomeModel.fromJson(Map<String,dynamic>json){
      var bannerListJson = json['bannerList'] as List;
      List<CommonModel> bannerList = bannerListJson.map((i) => CommonModel.fromJson(i)).toList();

      var localNavListJson = json['localNavList'] as List;
      List<CommonModel> localNavList = localNavListJson.map((i) => CommonModel.fromJson(i)).toList();

      var subNavListJson = json['subNavList'] as List;
      List<CommonModel> subNavList = subNavListJson.map((i) => CommonModel.fromJson(i)).toList();

      return HomeModel(
          bannerList:bannerList,
          localNavList: localNavList,
          subNavList: subNavList,
          config: ConfigModel.fromJson(json['config']),
          gridNav: GridNavModel.fromJson(json['gridNav']),
          salesBoxModel: SalesBoxModel.fromJson(json['salesBox'])
      );
  }

}