// ignore_for_file: non_constant_identifier_names

import 'package:daejeoni/common/dateForm.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ItemActDeliveryTarget {
  String childChartr;    // 특성
  String childName;      // 이름
  String childAge;       // 나이
  String childSexdstn;   // 성별
  String childRm;        // 비고
  bool bSelect;

  ItemActDeliveryTarget({
    this.childName="",
    this.childChartr="",
    this.childSexdstn="",
    this.childAge ="",
    this.childRm ="",
    this.bSelect = false,
  });


  String title() {
    String sex = (childSexdstn=="F") ? "여" : "남";
    String desc = "${childName} ($sex), $childAge세";
    return desc;
  }

  String desc() {
    String desc = "";
    if(childRm.isNotEmpty) {
      desc = "${childChartr} ($childRm)";
    } else {
      desc = "${childChartr}";
    }
    return desc;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
    };
    return map;
  }

  static List<ItemActDeliveryTarget> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemActDeliveryTarget.fromJson(data);
    }).toList();
  }

  factory ItemActDeliveryTarget.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    return ItemActDeliveryTarget(
      childChartr: (jdata['childChartr'] != null)
          ? jdata['childChartr'].toString().trim() : "",

      childName: (jdata['childName'] != null)
          ? jdata['childName'].toString().trim() : "",

      childAge: (jdata['childAge'] != null)
          ? jdata['childAge'].toString().trim() : "",

      childSexdstn: (jdata['childSexdstn'] != null)
          ? jdata['childSexdstn'].toString().trim() : "",

      childRm: (jdata['childRm'] != null)
          ? jdata['childRm'].toString().trim() : "",
    );
  }
}
