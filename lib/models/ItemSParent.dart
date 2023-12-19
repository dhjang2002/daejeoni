// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemSParent {
  String aplcntSn;            // 키

  String newsRcptnYn;         // 1. 소식 수신여부
  String cmmntyTyCd;          // 2. 커뮤니티 타입
  String cmmntyTyEtc;         // 2-1. 기타 커뮤니티
  String actCycleCd;          // 3. 활동주기
  String cmmntyFrndCd;        // 4. 희망 커뮤티티 친구
  String srvcPartcptnSync;    // 5. 참여동기

  String sonogongId;          // 손오공돌봄공동체 발급키
  String aprvYn;              // 승인여부
  String aprvDt;              // 승인일시
  String regDt;               // 신청일시



  bool bSelect;

  ItemSParent({
    this.actCycleCd="",
    this.aplcntSn="",
    this.cmmntyTyCd="",
    this.srvcPartcptnSync ="",
    this.cmmntyTyEtc="",
    this.aprvYn ="",
    this.aprvDt ="",
    this.sonogongId="",
    this.regDt="",
    this.cmmntyFrndCd="",
    this.newsRcptnYn="",
    this.bSelect = false,
  });

  String geFriendType() {
    switch(cmmntyFrndCd) {
      case "Frnd0001": return "가까운 지역";
      case "Frnd0002": return "아이들 나이 및 학습수준";
      case "Frnd0003": return "엄마들 성격 및 호감도";
      default: return "알수없음($cmmntyFrndCd)";
    }
  }

  String getCycle() {
    switch(actCycleCd) {
      case "CYCLE0001": return "매일";
      case "CYCLE0002": return "주2~3회";
      case "CYCLE0003": return "주1회";
      case "CYCLE0004": return "월1~3회";
      default: return "알수없음($actCycleCd)";
    }
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "newsRcptnYn":newsRcptnYn,
      "cmmntyTyCd":cmmntyTyCd,
      "cmmntyTyEtc":cmmntyTyEtc,
      "actCycleCd":actCycleCd,
      "cmmntyFrndCd":cmmntyFrndCd,
      "srvcPartcptnSync":srvcPartcptnSync,
      // "sonogongId":sonogongId,
      // "cmmntyFrndCd":cmmntyFrndCd
    };

    if(aplcntSn.isNotEmpty) {
      map.addAll({"aplcntSn":aplcntSn});
    }
    return map;
  }

  static List<ItemSParent> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemSParent.fromJson(data);
    }).toList();
  }

  factory ItemSParent.fromJson(Map<String, dynamic> jdata){
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    ItemSParent item = ItemSParent(
      aplcntSn: (jdata['aplcntSn'] != null)
          ? jdata['aplcntSn'].toString().trim() : "",

      actCycleCd: (jdata['actCycleCd'] != null)
          ? jdata['actCycleCd'].toString().trim() : "",

      srvcPartcptnSync: (jdata['srvcPartcptnSync'] != null)
          ? jdata['srvcPartcptnSync'].toString().trim() : "",

      cmmntyTyCd: (jdata['cmmntyTyCd'] != null)
          ? jdata['cmmntyTyCd'].toString().trim() : "",

      cmmntyTyEtc: (jdata['cmmntyTyEtc'] != null)
          ? jdata['cmmntyTyEtc'].toString().trim() : "",

      aprvYn: (jdata['aprvYn'] != null)
          ? jdata['aprvYn'].toString().trim() : "",

      aprvDt: (jdata['aprvDt'] != null)
          ? jdata['aprvDt'].toString().trim() : "",

      regDt: (jdata['regDt'] != null)
          ? jdata['regDt'].toString().trim() : "",

      sonogongId: (jdata['sonogongId'] != null)
          ? jdata['sonogongId'].toString().trim() : "",

      cmmntyFrndCd: (jdata['cmmntyFrndCd'] != null)
          ? jdata['cmmntyFrndCd'].toString().trim() : "",
      newsRcptnYn:(jdata['newsRcptnYn'] != null)
          ? jdata['newsRcptnYn'].toString().trim() : "",
    );

    if(item.regDt.length>10) {
      item.regDt = item.regDt.substring(0,10);
    }
    return item;
  }
}
