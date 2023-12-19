import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemContent {
  int content_oid;
  String content_title;
  String content_type;
  String address;
  String address_ext;
  String image_url;
  // String mapX;
  // String mapY;
  double longitude;
  double latitude;
  double distance;
  String tel; //전화번호
  String capacity;
  String upperInsttNm;
  String sos_code;
  String mapCtgryCd;
  String play_code;

  String mdeptGdrCnt;

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

  String rcptBgngDt;
  String rcptEndDt;
  ItemContent({
    this.rcptBgngDt="",
    this.rcptEndDt="",
    this.content_oid = 0,
    this.content_type="",
    this.content_title="",
    this.address_ext="",
    this.address ="",
    this.image_url="",
    // this.mapX ="",
    // this.mapY ="",
    this.latitude=0.0,
    this.longitude=0.0,
    this.distance=0,
    this.tel = "",
    this.capacity = "0",
    this.upperInsttNm = "",
    this.sos_code = "",
    this.mapCtgryCd = "",
    this.play_code = "",

    this.mdeptGdrCnt = "",
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
  });

  // 행사 구분
  String getPlayName() {
    switch(play_code) {
      case "1": return "놀이/힐링";
      case "2": return "교육/역사";
      case "3": return "문화/예술";
      default: return "알수없음";
    }
  }

  String receptionPeriod() {
    String info = "접수기간:";
    if(rcptBgngDt.length>=10 && rcptEndDt.length>=10) {
      info = "접수기간:${rcptBgngDt.substring(0,10)}~${rcptEndDt.substring(0,10)}";
    }
    return info;
  }

  String getEduType() {
    switch(play_code) {
      case "PROGRM001": return "프로그램";
      case "PROGRM003": return "양성과정";
      case "PROGRM004": return "손오공 돌봄체";
      case "PROGRM005": return "부모상담";
      case "PROGRM006": return "공동육아나눔터";
      case "PROGRM007": return "돌봄봉사단";
      case "PROGRM008": return "설문조사";
      default: return "알수없음";
    }
  }

  // 병원/약국/기관
  String getSosName() {
    switch(sos_code) {
      case "1": return "병원";
      case "2": return "약국";
      case "3": return "기관";
      default: return "알수없음";
    }
  }

  String addrBasic() {
    String addr = address;
    var items = address.split(",");
    if(items.isNotEmpty) {
      addr = items[0];
    }
    return addr;
  }

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

  // bool isNightHop() {
  //   return content_type=="SOS" && mdeptGdrCnt.isEmpty;
  // }
  // 상위기관
  //  10 , 9 , 1  , 2 ,  4 , 7 , 11 , 3 , 5 , 6 , 8
  String getHiName() {
    return upperInsttNm;
  }

  // 돌봄맵
  static List<ItemContent> fromMapSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemContent.fromMapJson(data);
    }).toList();
  }

  // 돌봄기관
  static List<ItemContent> fromInstSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemContent.fromInstJson(data);
    }).toList();
  }

  // 프로그램(행사)
  static List<ItemContent> fromPrgSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemContent.fromPrgJson(data);
    }).toList();
  }

  factory ItemContent.fromMapJson(Map<String, dynamic> jdata) {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    ItemContent item = ItemContent(
      content_oid:(jdata['mapSn'] != null)
          ? int.parse(jdata['mapSn'].toString().trim()) : 0,

      content_type: (jdata['mapTy'] != null)
          ? jdata['mapTy'].toString().trim() : "",

      content_title: (jdata['mapTitle'] != null)
          ? jdata['mapTitle'].toString().trim() : "",

      address: (jdata['mapAddr'] != null)
          ? jdata['mapAddr'].toString().trim() : "",

      address_ext: (jdata['mapDetailAddr'] != null)
          ? jdata['mapDetailAddr'].toString().trim() : "",

      image_url: (jdata['mapImg'] != null)
          ? jdata['mapImg'].toString().trim() : "",

      // mapX: (jdata['mapX'] != null)
      //     ? jdata['mapX'].toString().trim() : "",
      //
      // mapY: (jdata['mapY'] != null)
      //     ? jdata['mapY'].toString().trim() : "",

      longitude: (jdata['mapX'] != null && jdata['mapX'].toString().isNotEmpty)
          ? double.parse(jdata['mapX'].toString().trim()) : 0.0,

      latitude: (jdata['mapY'] != null && jdata['mapY'].toString().isNotEmpty)
          ? double.parse(jdata['mapY'].toString().trim()) : 0.0,

      distance: (jdata['myDstnc'] != null && jdata['myDstnc'].toString().isNotEmpty)
          ? double.parse(jdata['myDstnc'].toString().trim()) : 0.0,

      capacity: (jdata['capacity'] != null)
          ? jdata['capacity'].toString().trim() : "",

      tel: (jdata['mapTel'] != null)
          ? jdata['mapTel'].toString().trim() : "",

      upperInsttNm: (jdata['upperInsttNm'] != null)
          ? jdata['upperInsttNm'].toString().trim() : "",

      sos_code: (jdata['mapCtgryCd'] != null)
          ? jdata['mapCtgryCd'].toString().trim() : "",

      mapCtgryCd: (jdata['mapCtgryCd'] != null)
          ? jdata['mapCtgryCd'].toString().trim() : "",

      play_code: (jdata['mapCtgryCd'] != null)
          ? jdata['mapCtgryCd'].toString().trim() : "",

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
      mdeptGdrCnt:(jdata['mdeptGdrCnt'] != null)
          ? jdata['mdeptGdrCnt'].toString().trim() : "",
    );

    if(item.capacity.isEmpty) {
      item.capacity = "0";
    }
    if(item.image_url.contains("Id=null")) {
      item.image_url = "";
    }
    return item;
  }

  factory ItemContent.fromInstJson(Map<String, dynamic> jdata){
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    ItemContent item = ItemContent(
      content_oid:(jdata['insttSn'] != null)
          ? int.parse(jdata['insttSn'].toString().trim()) : 0,

      content_type: (jdata['mapTy'] != null)
          ? jdata['mapTy'].toString().trim() : "",

      content_title: (jdata['insttNm'] != null)
          ? jdata['insttNm'].toString().trim() : "",

      address: (jdata['insttAdres'] != null)
          ? jdata['insttAdres'].toString().trim() : "",
      address_ext: (jdata['insttAdresDetail'] != null)
          ? jdata['insttAdresDetail'].toString().trim() : "",

      image_url: (jdata['insttFile'] != null)
          ? jdata['insttFile'].toString().trim() : "",

      // mapX: (jdata['insttLongitude'] != null)
      //     ? jdata['insttLongitude'].toString().trim() : "",
      // mapY: (jdata['insttLatitude'] != null)
      //     ? jdata['insttLatitude'].toString().trim() : "",

      latitude: (jdata['insttLongitude'] != null && jdata['insttLongitude'].toString().isNotEmpty)
        ? double.parse(jdata['insttLongitude'].toString().trim()) : 0.0,

      longitude: (jdata['insttLatitude'] != null && jdata['insttLatitude'].toString().isNotEmpty)
        ? double.parse(jdata['insttLatitude'].toString().trim()) : 0.0,

      distance: (jdata['myDstnc'] != null && jdata['myDstnc'].toString().isNotEmpty)
          ? double.parse(jdata['myDstnc'].toString().trim()) : 0.0,

      capacity: (jdata['capacity'] != null)
          ? jdata['capacity'].toString().trim() : "",

      tel: (jdata['insttCoTelno'] != null)
          ? jdata['insttCoTelno'].toString().trim() : "",

      upperInsttNm: (jdata['upperInsttNm'] != null)
          ? jdata['upperInsttNm'].toString().trim() : "",

      sos_code: (jdata['mapCtgryCd'] != null)
          ? jdata['mapCtgryCd'].toString().trim() : "",
      mapCtgryCd: (jdata['mapCtgryCd'] != null)
          ? jdata['mapCtgryCd'].toString().trim() : "",


      play_code: (jdata['mapCtgryCd'] != null)
          ? jdata['mapCtgryCd'].toString().trim() : "",
    );

    if(item.capacity.isEmpty) {
      item.capacity = "0";
    }
    if(item.image_url.contains("Id=null")) {
      item.image_url = "";
    }

    return item;
  }

  factory ItemContent.fromPrgJson(Map<String, dynamic> jdata){
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    ItemContent item = ItemContent(
      content_type: "PRG",
      content_oid:(jdata['eduSn'] != null)
          ? int.parse(jdata['eduSn'].toString().trim()) : 0,

      content_title: (jdata['eduSj'] != null)
          ? jdata['eduSj'].toString().trim() : "",

      address: (jdata['insttAdres'] != null)
          ? jdata['insttAdres'].toString().trim() : "",

      address_ext: (jdata['insttAdresDetail'] != null)
          ? jdata['insttAdresDetail'].toString().trim() : "",

      image_url: (jdata['rprsThumbImage'] != null) ? jdata['rprsThumbImage'].toString().trim() : "",
      // image_url: (jdata['rprsThumbImage'] != null)
      //     ? jdata['rprsThumbImage'].toString().trim() : "",

      // mapX: (jdata['gpsY'] != null)
      //     ? jdata['gpsY'].toString().trim() : "",
      // mapY: (jdata['gpsX'] != null)
      //     ? jdata['gpsX'].toString().trim() : "",

      latitude: (jdata['gpsY'] != null && jdata['gpsY'].toString().isNotEmpty)
          ? double.parse(jdata['gpsY'].toString().trim()) : 0.0,

      longitude: (jdata['gpsX'] != null && jdata['gpsX'].toString().isNotEmpty)
          ? double.parse(jdata['gpsX'].toString().trim()) : 0.0,

      distance: (jdata['myDstnc'] != null && jdata['myDstnc'].toString().isNotEmpty)
          ? double.parse(jdata['myDstnc'].toString().trim()) : 0.0,

      capacity: (jdata['capacity'] != null)
          ? jdata['capacity'].toString().trim() : "0",

      tel: (jdata['insttCoTelno'] != null)
          ? jdata['insttCoTelno'].toString().trim() : "",

      upperInsttNm: (jdata['upperInsttNm'] != null)
          ? jdata['upperInsttNm'].toString().trim() : "",

      sos_code: (jdata['mapCtgryCd'] != null)
          ? jdata['mapCtgryCd'].toString().trim() : "",

      mapCtgryCd: (jdata['mapCtgryCd'] != null)
          ? jdata['mapCtgryCd'].toString().trim() : "",

      play_code: (jdata['eduTy'] != null)
          ? jdata['eduTy'].toString().trim() : "",

      rcptBgngDt: (jdata['rcptBgngDt'] != null)
          ? jdata['rcptBgngDt'].toString().trim() : "",
      rcptEndDt: (jdata['rcptEndDt'] != null)
          ? jdata['rcptEndDt'].toString().trim() : "",
    );

    item.content_type = "PRG";
    if(item.image_url.isNotEmpty && !item.image_url.startsWith("http")) {
      item.image_url = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${item.image_url}&fileSn=0";
    }
    // if(item.image_url.contains("Id=null")) {
    //   item.image_url = "";
    // }

    return item;
  }
}
