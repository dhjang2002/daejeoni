// ignore_for_file: non_constant_identifier_names, file_names

import 'package:daejeoni/common/cardPhotoItem.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemPhoto.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class InfoInstNotice {
  String boardSn; // id
  String boardSj;     // 타이틀
  String boardCn;     // 내용
  String boardRdcnt;  // 조회 카운트
  String atchFileId;
  String regId;
  String regDt;       // 등록일자
  bool   showMore;
  List<CardPhotoItem> photo_sub_items;

  InfoInstNotice({
    this.photo_sub_items = const[],
    this.boardSn = "",
    this.regDt = "",
    this.boardSj = "",
    this.boardCn = "",
    this.atchFileId="",
    this.boardRdcnt="",
    this.regId="",
    this.showMore = false,
  });

  static List<InfoInstNotice> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return InfoInstNotice.fromJson(data);
    }).toList();
  }

  factory InfoInstNotice.fromJson(Map<String, dynamic> content)
  {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }



    var jdata = content['info'];

    InfoInstNotice item = InfoInstNotice(
      boardSn: (jdata['boardSn'] != null) ? jdata['boardSn'].toString().trim() : "",
      boardSj: (jdata['boardSj'] != null) ? jdata['boardSj'].toString().trim() : "",
      boardCn: (jdata['boardCn'] != null) ? jdata['boardCn'].toString().trim() : "",
      atchFileId:(jdata['atchFileId'] != null) ? jdata['atchFileId'].toString().trim() : "",
      regDt: (jdata['regDt'] != null) ? jdata['regDt'].toString().trim() : "",
      regId: (jdata['regId'] != null) ? jdata['regId'].toString().trim() : "",
      boardRdcnt: (jdata['boardRdcnt'] != null) ? jdata['boardRdcnt'].toString().trim() : "",
    );

    if(content['files'] != null) {
      var list = ItemPhoto.fromSnapshot(content['files']);
      item.setPhotoList(list);
    }
    return item;
  }

  void setPhotoList(List<ItemPhoto> list) {
    photo_sub_items = [];
    for (var element in list) {
      String url = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${element.atchFileId}&fileSn=${element.fileSn}";
      photo_sub_items.add(CardPhotoItem(url: url, type: "p"));
    }

    if(photo_sub_items.isEmpty) {
      if(atchFileId.isNotEmpty) {
        if(!atchFileId.startsWith("http")) {
          String url = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${atchFileId}&fileSn=0";
          photo_sub_items.add(CardPhotoItem(url: url, type: "p"));
        }
        else {
          photo_sub_items.add(CardPhotoItem(url: atchFileId, type: "p"));
        }
      }
    }
  }
}