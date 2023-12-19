// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemSShare {
  String aplcntSn;            // 키
  String sonogongCmmntyJoin;  // 손오공 커뮤니티 가입여부
  String strngPlygrUse;       // 별난놀이터 이용여부
  String psitnCmmnty;         // 소속된 커뮤니티 유무
  String psitnCmmntyNm;       // 소속된 커뮤니티 명
  String aprvYn;              // 승인여부
  String aprvDt;              // 승인일시
  String regDt;               // 신청일시
  String sonogongId;          // 손오공돌봄공동체 발급키
  String cmmntyFrndCd;        // 커뮤니티 친구 코드
  String cmmntyTyCd;          // 커뮤니티 유형
  String cmmntyTyEtc;         // 커뮤니티 기타
  String actTimeCd;           // 활동가능시간
  String actCycleCd;          // 활동가능주기
  String parntsHobby;         // 신청인 취미
  String chldrnHobby;         // 자녀의 취미
  String newsRcptnYn;         // 소식 수신 여부
  bool bSelect;

  ItemSShare({
    this.sonogongCmmntyJoin="",
    this.aplcntSn="",
    this.psitnCmmnty="",
    this.strngPlygrUse ="",
    this.psitnCmmntyNm="",
    this.aprvYn ="",
    this.aprvDt ="",
    this.sonogongId="",
    this.regDt="",
    this.cmmntyTyCd="",
    this.cmmntyTyEtc="",
    this.cmmntyFrndCd="",
    this.newsRcptnYn="",
    this.actTimeCd="",
    this.actCycleCd="",
    this.parntsHobby="",
    this.chldrnHobby="",
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

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "newsRcptnYn":newsRcptnYn,
      "sonogongCmmntyJoin":sonogongCmmntyJoin,
      "strngPlygrUse":strngPlygrUse,
      "aprvDt":aprvDt,
      "psitnCmmnty":psitnCmmnty,
      "psitnCmmntyNm":psitnCmmntyNm,
      "actTimeCd": actTimeCd,
      "parntsHobby":parntsHobby,
      "chldrnHobby":chldrnHobby,
      //"regDt":regDt,
      //"sonogongId":sonogongId,
      "cmmntyTyCd":cmmntyTyCd,
      "cmmntyTyEtc":cmmntyTyEtc,
      "actCycleCd":actCycleCd,
      "cmmntyFrndCd":cmmntyFrndCd,
    };

    if(aplcntSn.isNotEmpty) {
      map.addAll({"aplcntSn":aplcntSn});
    }
    return map;
  }

  static List<ItemSShare> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemSShare.fromJson(data);
    }).toList();
  }

  factory ItemSShare.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    ItemSShare item = ItemSShare(
      aplcntSn: (jdata['aplcntSn'] != null)
          ? jdata['aplcntSn'].toString().trim() : "",

      sonogongCmmntyJoin: (jdata['sonogongCmmntyJoin'] != null)
          ? jdata['sonogongCmmntyJoin'].toString().trim() : "",

      strngPlygrUse: (jdata['strngPlygrUse'] != null)
          ? jdata['strngPlygrUse'].toString().trim() : "",

      psitnCmmnty: (jdata['psitnCmmnty'] != null)
          ? jdata['psitnCmmnty'].toString().trim() : "",

      psitnCmmntyNm: (jdata['psitnCmmntyNm'] != null)
          ? jdata['psitnCmmntyNm'].toString().trim() : "",

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
      cmmntyTyCd: (jdata['cmmntyTyCd'] != null)
          ? jdata['cmmntyTyCd'].toString().trim() : "",
      cmmntyTyEtc: (jdata['cmmntyTyEtc'] != null)
          ? jdata['cmmntyTyEtc'].toString().trim() : "",

      actCycleCd:(jdata['actCycleCd'] != null)
          ? jdata['actCycleCd'].toString().trim() : "",
      actTimeCd: (jdata['actTimeCd'] != null)
            ? jdata['actTimeCd'].toString().trim() : "",
      parntsHobby: (jdata['parntsHobby'] != null)
          ? jdata['parntsHobby'].toString().trim() : "",
      chldrnHobby: (jdata['chldrnHobby'] != null)
          ? jdata['chldrnHobby'].toString().trim() : "",
      newsRcptnYn:(jdata['newsRcptnYn'] != null)
            ? jdata['newsRcptnYn'].toString().trim() : "",
    );

    if(item.regDt.length>10) {
      item.regDt = item.regDt.substring(0,10);
    }
    return item;
  }

}
