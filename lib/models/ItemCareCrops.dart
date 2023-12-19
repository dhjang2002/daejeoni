// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemCareCrops {
  String aplcntSn;
  String aplcntPsitn;             // 소속(회사/학교)
  String aplcntSubjct;            // 학과
  String aplcnt1365Id;            // 1365ID
  String srvcTimeWeek;            // 봉사시간(주)
  String srvcTimeCnt;             // 봉사시간(횟수)
  String srvcTimeDay;             // 봉사일 (월요일,수요일,금요일)
  String srvcStrTime;             // 봉사 시작시간
  String srvcEndTime;             // 봉사 종료시간
  String srvcTimeDtlCn;           // 희망봉사시간-상세내용
  String srvcPartcptnSync;        // 참여동기
  String aplcntEmrgTelno;         // 긴급연락처
  String srvcId;                  // 봉사ID
  String regDt;                  // 신청일
  String aprvYn;                  // 승인여부
  bool bSelect;

  ItemCareCrops({
    this.aplcntPsitn="",
    this.aplcntSn="",
    this.aplcnt1365Id="",
    this.aplcntSubjct ="",
    this.srvcTimeWeek="일주일",
    this.srvcTimeCnt ="",
    this.srvcTimeDay ="",
    this.srvcEndTime="18:00",
    this.srvcStrTime="08:00",
    this.srvcTimeDtlCn="",
    this.srvcPartcptnSync="",
    this.aplcntEmrgTelno="",
    this.srvcId="",
    this.regDt="",
    this.aprvYn="",
    this.bSelect = false,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "aplcntSn":aplcntSn,
      "aplcntPsitn":aplcntPsitn,
      "aplcntSubjct":aplcntSubjct,
      "aplcntEmrgTelno":aplcntEmrgTelno,
      "aplcnt1365Id":aplcnt1365Id,
      "srvcTimeWeek":srvcTimeWeek,
      "srvcTimeCnt":srvcTimeCnt,
      "srvcTimeDay":srvcTimeDay,
      "srvcStrTime":srvcStrTime,
      "srvcEndTime":srvcEndTime,
      "srvcTimeDtlCn":srvcTimeDtlCn,
      "srvcPartcptnSync":srvcPartcptnSync,
      //"srvcId":srvcId,
    };
    return map;
  }

  static List<ItemCareCrops> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemCareCrops.fromJson(data);
    }).toList();
  }

  factory ItemCareCrops.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    ItemCareCrops item = ItemCareCrops(
      aplcntSn: (jdata['aplcntSn'] != null)
          ? jdata['aplcntSn'].toString().trim() : "",

      aplcntPsitn: (jdata['aplcntPsitn'] != null)
          ? jdata['aplcntPsitn'].toString().trim() : "",

      aplcntSubjct: (jdata['aplcntSubjct'] != null)
          ? jdata['aplcntSubjct'].toString().trim() : "",

      aplcnt1365Id: (jdata['aplcnt1365Id'] != null)
          ? jdata['aplcnt1365Id'].toString().trim() : "",

      srvcTimeWeek: (jdata['srvcTimeWeek'] != null)
          ? jdata['srvcTimeWeek'].toString().trim() : "일주일",

      srvcTimeCnt: (jdata['srvcTimeCnt'] != null)
          ? jdata['srvcTimeCnt'].toString().trim() : "",

      srvcTimeDay: (jdata['srvcTimeDay'] != null)
          ? jdata['srvcTimeDay'].toString().trim() : "",

      srvcStrTime: (jdata['srvcStrTime'] != null)
          ? jdata['srvcStrTime'].toString().trim() : "08:00",

      srvcEndTime: (jdata['srvcEndTime'] != null)
          ? jdata['srvcEndTime'].toString().trim() : "18:00",

      srvcTimeDtlCn: (jdata['srvcTimeDtlCn'] != null)
          ? jdata['srvcTimeDtlCn'].toString().trim() : "",

      srvcPartcptnSync: (jdata['srvcPartcptnSync'] != null)
          ? jdata['srvcPartcptnSync'].toString().trim() : "",
      aplcntEmrgTelno: (jdata['aplcntEmrgTelno'] != null)
          ? jdata['aplcntEmrgTelno'].toString().trim() : "",
      srvcId: (jdata['srvcId'] != null)
          ? jdata['srvcId'].toString().trim() : "",
      regDt: (jdata['regDt'] != null)
          ? jdata['regDt'].toString().trim() : "",
      aprvYn: (jdata['aprvYn'] != null)
          ? jdata['aprvYn'].toString().trim() : "",
    );

    if(item.regDt.length>10) {
      item.regDt = item.regDt.substring(0,10);
    }
    return item;
  }

}
