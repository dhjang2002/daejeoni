import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemPush {
  int pushNtcnSn;
  String pushTitle;
  String pushContent;
  String regDt;
  String pushTarget;

  bool showMore;

  ItemPush({
    this.pushNtcnSn = 0,
    this.pushTitle="",
    this.regDt="",
    this.pushContent ="",
    this.pushTarget="",
    this.showMore = false,
  });

  static List<ItemPush> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemPush.fromJson(data);
    }).toList();
  }

  bool hasLink() {
    return pushTarget.isNotEmpty;
  }

  factory ItemPush.fromJson(Map<String, dynamic> jdata)
  {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    return ItemPush(
      pushNtcnSn:(jdata['pushNtcnSn'] != null)
          ? int.parse(jdata['pushNtcnSn'].toString().trim()) : 0,

      pushTitle: (jdata['pushTitle'] != null)
          ? jdata['pushTitle'].toString().trim() : "",

      pushContent: (jdata['pushContent'] != null)
          ? jdata['pushContent'].toString().trim() : "",

      pushTarget: (jdata['pushTarget'] != null)
          ? jdata['pushTarget'].toString().trim() : "",

      regDt: (jdata['regDt'] != null)
          ? jdata['regDt'].toString().trim() : "",
    );
  }
}
