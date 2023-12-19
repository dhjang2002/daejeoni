import 'package:daejeoni/common/cardPhotoItem.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class InfoMap {
  int mapSn;
  String mapTy;
  String mapDataType;
  String mapAddr;
  String mapDetailAddr;
  String mapImg;
  String mapTel;      //전화번호
  String mapHomepageUrl;
  String mapTitle;
  String mapCtgryCd;
  double longitude;
  double latitude;
  String mapCn;
  String mapRegId;
  String mapMdfcnId;
  String atchFileId;
  double myDstnc;
  List<CardPhotoItem> photo_items;

  InfoMap({
    this.mapSn = 0,
    this.mapTy="",
    this.mapTitle="",
    this.mapDetailAddr="",
    this.mapAddr ="",
    this.mapImg="",
    this.atchFileId ="",
    this.mapDataType ="",
    this.latitude=0.0,
    this.longitude=0.0,
    this.mapTel = "",
    this.mapCn = "",
    this.mapHomepageUrl = "",
    this.mapRegId = "",
    this.mapCtgryCd = "",
    this.mapMdfcnId = "",
    this.myDstnc=0.0,
    this.photo_items = const [],
  });

  String addr() {
    String addr = mapAddr;
    if(addr.isNotEmpty && mapDetailAddr.isNotEmpty) {
      addr = "$mapAddr $mapDetailAddr";
    }
    return addr;
  }
  // 병원/약국/기관
  String getGroup() {
    if(mapTy=="SOS") {
      switch (mapCtgryCd) {
        case "1":
          return "병원";
        case "2":
          return "약국";
        case "3":
          return "기관";
        default:
          return "알수없음";
      }
    }
    else {
      switch(mapCtgryCd) {
        case "1": return "놀이/힐링";
        case "2": return "교육/역사";
        case "3": return "문화/예술";
        default: return "알수없음";
      }
    }
  }

  // 행사 구분
  String getPlayName() {
    return mapTitle;
    // switch(mapCtgryCd) {
    //   case "1": return "놀이/힐링";
    //   case "2": return "교육/역사";
    //   case "3": return "문화/예술";
    //   default: return "알수없음";
    // }
  }

  static List<InfoMap> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return InfoMap.fromJson(data);
    }).toList();
  }

  factory InfoMap.fromJson(Map<String, dynamic> jdata){
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    InfoMap info =  InfoMap(
      mapSn:(jdata['mapSn'] != null)
          ? int.parse(jdata['mapSn'].toString().trim()) : 0,

      mapTy: (jdata['mapTy'] != null)
          ? jdata['mapTy'].toString().trim() : "",

      mapTitle: (jdata['mapTitle'] != null)
          ? jdata['mapTitle'].toString().trim() : "",

      mapAddr: (jdata['mapAddr'] != null)
          ? jdata['mapAddr'].toString().trim() : "",
      mapDetailAddr: (jdata['mapDetailAddr'] != null)
          ? jdata['mapDetailAddr'].toString().trim() : "",

      mapImg: (jdata['mapImg'] != null)
          ? jdata['mapImg'].toString().trim() : "",

      latitude: (jdata['mapY'] != null && jdata['mapY'].toString().isNotEmpty)
          ? double.parse(jdata['mapY'].toString().trim()) : 0.0,
      longitude: (jdata['mapX'] != null && jdata['mapX'].toString().isNotEmpty)
          ? double.parse(jdata['mapX'].toString().trim()) : 0.0,
      mapCn: (jdata['mapCn'] != null)
          ? jdata['mapCn'].toString().trim() : "",
      mapTel: (jdata['mapTel'] != null)
          ? jdata['mapTel'].toString().trim() : "",
      mapHomepageUrl: (jdata['mapHomepageUrl'] != null)
          ? jdata['mapHomepageUrl'].toString().trim() : "",
      mapRegId: (jdata['mapRegId'] != null)
          ? jdata['mapRegId'].toString().trim() : "",
      mapCtgryCd: (jdata['mapCtgryCd'] != null)
          ? jdata['mapCtgryCd'].toString().trim() : "",
      mapMdfcnId: (jdata['mapMdfcnId'] != null)
          ? jdata['mapMdfcnId'].toString().trim() : "",
      atchFileId: (jdata['atchFileId'] != null)
          ? jdata['atchFileId'].toString().trim() : "",
      mapDataType: (jdata['sponsor1'] != null)
          ? jdata['sponsor1'].toString().trim() : "",
      myDstnc: (jdata['myDstnc'] != null)
          ? double.parse(jdata['myDstnc'].toString().trim()) : 0.0,
    );

    info.setPhotoItems();
    return info;
  }

  void setPhotoItems() {
    if(mapImg.isNotEmpty) {
      photo_items = [CardPhotoItem(url: mapImg, type: 'p',)];
    } else if(atchFileId.isNotEmpty) {
      photo_items = [CardPhotoItem(url: "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${atchFileId}&fileSn=0", type: 'p',)];
    }
  }
}
