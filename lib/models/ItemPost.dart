import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemPost {
  String insttReplySn;      // 키이
  String insttReplyType;    // 종류
  String insttReplyText;    // 후기문구
  String mberId;            // 삭제버튼 표시할때 체크
  double insttReplyGrade;   // 평점
  String regDt;             // 작성일자
  bool   isMe;

  ItemPost({
    this.insttReplyType="",
    this.insttReplySn="",
    this.mberId="",
    this.insttReplyText ="",
    this.insttReplyGrade = 0.0,
    this.regDt ="",
    this.isMe = false,
  });

  static List<ItemPost> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemPost.fromJson(data);
    }).toList();
  }


  factory ItemPost.fromJson(Map<String, dynamic> jdata){
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    return ItemPost(
      insttReplyType: (jdata['insttReplyType'] != null)
          ? jdata['insttReplyType'].toString().trim() : "",

      insttReplySn: (jdata['insttReplySn'] != null)
          ? jdata['insttReplySn'].toString().trim() : "",

      insttReplyText: (jdata['insttReplyText'] != null)
          ? jdata['insttReplyText'].toString().trim() : "",

      mberId: (jdata['mberId'] != null)
          ? jdata['mberId'].toString().trim() : "",

      insttReplyGrade: (jdata['insttReplyGrade'] != null)
          ? double.parse(jdata['insttReplyGrade'].toString().trim()) : 0.0,

      regDt: (jdata['regDt'] != null)
          ? jdata['regDt'].toString().trim() : "",
    );
  }
}
