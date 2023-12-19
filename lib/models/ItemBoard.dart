import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemBoard {
  int content_oid;
  String content_title;
  String content_type;
  String address;
  String address_ext;
  String image_url;
  String mapX;
  String mapY;
  double longitude;
  double latitude;
  double distance;
  String tel; //전화번호
  String capacity;
  String upperInsttNm;
  String sos_code;
  String mapCtgryCd;
  String play_code;

  ItemBoard.ItemBoard({
    this.content_oid = 0,
    this.content_type="",
    this.content_title="",
    this.address_ext="",
    this.address ="",
    this.image_url="",
    this.mapX ="",
    this.mapY ="",
    this.latitude=0.0,
    this.longitude=0.0,
    this.distance=0,
    this.tel = "",
    this.capacity = "",
    this.upperInsttNm = "",
    this.sos_code = "",
    this.mapCtgryCd = "",
    this.play_code = "",
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

  // 병원/약국/기관
  String getSosName() {
    switch(sos_code) {
      case "1": return "병원";
      case "2": return "약국";
      case "3": return "기관";
      default: return "알수없음";
    }
  }

  // 상위기관
  //  10 , 9 , 1  , 2 ,  4 , 7 , 11 , 3 , 5 , 6 , 8
  String getHiName() {
    return upperInsttNm;
    /*
    switch(mapCtgryCd) {
      case "1": return "다함께돌봄센터";
      case "2": return "공동육아나눔터";
      case "3": return "초등돌봄교실";
      case "4": return "청소년방과후아카데미";
      case "5": return "아이돌봄서비스";
      case "6": return "육아종합지원센터";
      case "8": return "기타장애아동기관";
      case "9": return "지역아동센터";
      case "10": return "거점온돌방";
      case "11": return "기타";
      default: return "알수없음";
    }
     */
  }

  static List<ItemBoard> fromMapSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemBoard.fromMapJson(data);
    }).toList();
  }

  static List<ItemBoard> fromInstSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemBoard.fromInstJson(data);
    }).toList();
  }

  factory ItemBoard.fromMapJson(Map<String, dynamic> jdata){
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    return ItemBoard.ItemBoard(
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

      mapX: (jdata['mapX'] != null)
          ? jdata['mapX'].toString().trim() : "",

      mapY: (jdata['mapY'] != null)
          ? jdata['mapY'].toString().trim() : "",

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
    );
  }

  factory ItemBoard.fromInstJson(Map<String, dynamic> jdata){
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    return ItemBoard.ItemBoard(
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

      mapX: (jdata['insttLongitude'] != null)
          ? jdata['insttLongitude'].toString().trim() : "",
      mapY: (jdata['insttLatitude'] != null)
          ? jdata['insttLatitude'].toString().trim() : "",

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
  }
}
