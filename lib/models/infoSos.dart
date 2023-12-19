import 'package:daejeoni/common/cardPhotoItem.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class InfoSos {
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

  String dutyMapImg;  // 간이약도 (주변위치)

  String dutyTime1s;  // 월
  String dutyTime1c;
  String dutyTime2s;  // 화
  String dutyTime2c;
  String dutyTime3s;  // 수
  String dutyTime3c;
  String dutyTime4s;  // 목
  String dutyTime4c;
  String dutyTime5s;  // 금
  String dutyTime5c;
  String dutyTime6s;  // 토
  String dutyTime6c;
  String dutyTime7s;  // 일
  String dutyTime7c;
  String dutyTime8s;  // 공휴일
  String dutyTime8c;

  String clCdNm;          // 병원 구분
  String estbDd;          // 병원 개원일자
  String drTotCnt;        // 의사 총인원

  String mdeptGdrCnt;     // 의과 일반의 수
  String mdeptIntnCnt;    // 의과 인턴 수
  String mdeptResdntCnt;  // 의과 레지던트
  String mdeptSdrCnt;     // 의과 전문의

  String detyGdrCnt;     // 치과 일반의 수
  String detyIntnCnt;    // 치과 인턴 수
  String detyResdntCnt;  // 치과 레지던트
  String detySdrCnt;     // 치과 전문의

  String cmdcGdrCnt;     // 한방 일반의 수
  String cmdcIntnCnt;    // 한방 인턴 수
  String cmdcResdntCnt;  // 한방 레지던트
  String cmdcSdrCnt;     // 한방 전문의

  double myDstnc;
  //List<CardPhotoItem> photo_items;

  InfoSos({
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

    this.dutyTime1s = "",
    this.dutyTime1c = "",
    this.dutyTime2s = "",
    this.dutyTime2c = "",
    this.dutyTime3s = "",
    this.dutyTime3c = "",
    this.dutyTime4s = "",
    this.dutyTime4c = "",
    this.dutyTime5s = "",
    this.dutyTime5c = "",
    this.dutyTime6s = "",
    this.dutyTime6c = "",
    this.dutyTime7s = "",
    this.dutyTime7c = "",
    this.dutyTime8s = "",
    this.dutyTime8c = "",

    this.dutyMapImg = "",

    this.clCdNm = "",
    this.estbDd = "",
    this.drTotCnt="",

    this.mdeptGdrCnt="",
    this.mdeptIntnCnt="",
    this.mdeptResdntCnt="",
    this.mdeptSdrCnt="",

    this.detyGdrCnt="",
    this.detyIntnCnt="",
    this.detyResdntCnt="",
    this.detySdrCnt="",

    this.cmdcGdrCnt="",
    this.cmdcIntnCnt="",
    this.cmdcResdntCnt="",
    this.cmdcSdrCnt="",

    this.myDstnc=0.0,
    //this.photo_items = const [],
  });

  bool isHsNightOp() {
    return mdeptGdrCnt.isEmpty;
  }

  bool isPhNight() {
     // 월요일 영업종료
    if(dutyTime1c.isNotEmpty) {
      int time = int.parse(dutyTime1c);
      if(time>=2000) {
        return true;
      }
    }
    return false;
  }

  bool isPhHolyday() {
    return dutyTime8s.length==4;
  }

  String addr() {
    String addr = mapAddr;
    if(addr.isNotEmpty && mapDetailAddr.isNotEmpty) {
      addr = "$mapAddr $mapDetailAddr";
    }
    return addr;
  }

  String addrBasic() {
    String addr = mapAddr;
    var items = mapAddr.split(",");
    if(items.isNotEmpty) {
      addr = items[0];
    }
    return addr;
  }

  // 병원/약국/기관
  String getGroup() {
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

  // 행사 구분
  String title() {
    return mapTitle;
  }

  static List<InfoSos> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return InfoSos.fromJson(data);
    }).toList();
  }

  factory InfoSos.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    InfoSos info =  InfoSos(
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

      dutyTime1c: (jdata['dutyTime1c'] != null)
          ? jdata['dutyTime1c'].toString().trim() : "",
      dutyTime1s: (jdata['dutyTime1s'] != null)
          ? jdata['dutyTime1s'].toString().trim() : "",
      dutyTime2c: (jdata['dutyTime2c'] != null)
          ? jdata['dutyTime2c'].toString().trim() : "",
      dutyTime2s: (jdata['dutyTime2s'] != null)
          ? jdata['dutyTime2s'].toString().trim() : "",
      dutyTime3c: (jdata['dutyTime3c'] != null)
          ? jdata['dutyTime3c'].toString().trim() : "",
      dutyTime3s: (jdata['dutyTime3s'] != null)
          ? jdata['dutyTime3s'].toString().trim() : "",
      dutyTime4c: (jdata['dutyTime4c'] != null)
          ? jdata['dutyTime4c'].toString().trim() : "",
      dutyTime4s: (jdata['dutyTime4s'] != null)
          ? jdata['dutyTime4s'].toString().trim() : "",
      dutyTime5c: (jdata['dutyTime5c'] != null)
          ? jdata['dutyTime5c'].toString().trim() : "",
      dutyTime5s: (jdata['dutyTime5s'] != null)
          ? jdata['dutyTime5s'].toString().trim() : "",
      dutyTime6c: (jdata['dutyTime6c'] != null)
          ? jdata['dutyTime6c'].toString().trim() : "",
      dutyTime6s: (jdata['dutyTime6s'] != null)
          ? jdata['dutyTime6s'].toString().trim() : "",
      dutyTime7c: (jdata['dutyTime7c'] != null)
          ? jdata['dutyTime7c'].toString().trim() : "",
      dutyTime7s: (jdata['dutyTime7s'] != null)
          ? jdata['dutyTime7s'].toString().trim() : "",
      dutyTime8c: (jdata['dutyTime8c'] != null)
          ? jdata['dutyTime8c'].toString().trim() : "",
      dutyTime8s: (jdata['dutyTime8s'] != null)
          ? jdata['dutyTime8s'].toString().trim() : "",

      dutyMapImg: (jdata['dutyMapImg'] != null)
          ? jdata['dutyMapImg'].toString().trim() : "",

      clCdNm: (jdata['clCdNm'] != null)
          ? jdata['clCdNm'].toString().trim() : "",
      estbDd: (jdata['estbDd'] != null)
          ? jdata['estbDd'].toString().trim() : "",
      drTotCnt: (jdata['drTotCnt'] != null)
          ? jdata['drTotCnt'].toString().trim() : "",

      mdeptGdrCnt:(jdata['mdeptGdrCnt'] != null)
            ? jdata['mdeptGdrCnt'].toString().trim() : "",
      mdeptIntnCnt:(jdata['mdeptIntnCnt'] != null)
          ? jdata['mdeptIntnCnt'].toString().trim() : "",
      mdeptResdntCnt:(jdata['mdeptResdntCnt'] != null)
          ? jdata['mdeptResdntCnt'].toString().trim() : "",
      mdeptSdrCnt:(jdata['mdeptSdrCnt'] != null)
          ? jdata['mdeptSdrCnt'].toString().trim() : "",

      detyGdrCnt:(jdata['detyGdrCnt'] != null)
          ? jdata['detyGdrCnt'].toString().trim() : "",
      detyIntnCnt:(jdata['detyIntnCnt'] != null)
          ? jdata['detyIntnCnt'].toString().trim() : "",
      detyResdntCnt:(jdata['detyResdntCnt'] != null)
          ? jdata['detyResdntCnt'].toString().trim() : "",
      detySdrCnt:(jdata['detySdrCnt'] != null)
          ? jdata['detySdrCnt'].toString().trim() : "",

      cmdcGdrCnt:(jdata['cmdcGdrCnt'] != null)
          ? jdata['cmdcGdrCnt'].toString().trim() : "",
      cmdcIntnCnt:(jdata['cmdcIntnCnt'] != null)
          ? jdata['cmdcIntnCnt'].toString().trim() : "",
      cmdcResdntCnt:(jdata['cmdcResdntCnt'] != null)
          ? jdata['cmdcResdntCnt'].toString().trim() : "",
      cmdcSdrCnt:(jdata['cmdcSdrCnt'] != null)
          ? jdata['cmdcSdrCnt'].toString().trim() : "",

      myDstnc:(jdata['myDstnc'] != null)
          ? double.parse(jdata['myDstnc'].toString().trim()) : 0.0,
    );
    return info;
  }
}
