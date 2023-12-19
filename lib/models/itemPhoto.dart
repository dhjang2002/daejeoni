// ignore_for_file: file_names, non_constant_identifier_names

// https://www.daejeoni.or.kr/cmm/fms/getImage.do?atchFileId=FILE_000000000008931&fileSn=0

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemPhoto {
  String atchFileId;  // FILE_000000000008943
  String streFileNm;  // INSTT_202207151110101231
  String fileSn;      // "1".
  ItemPhoto({
    this.atchFileId = "",
    this.streFileNm = "",
    this.fileSn="",
  });

  @override
  String toString(){
    return 'ItemPhoto {'
        'atchFileId:$atchFileId, '
        'fileSn:$fileSn, '
        'streFileNm:$streFileNm'
        ' }';
  }

  static List<ItemPhoto> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemPhoto.fromJson(data);
    }).toList();
  }

  factory ItemPhoto.fromJson(Map<String, dynamic> jdata)
  {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    return ItemPhoto(
      atchFileId: (jdata['atchFileId'] != null ) ? jdata['atchFileId'] : "",
      streFileNm: (jdata['streFileNm'] != null ) ? jdata['streFileNm'] : "",
      fileSn: (jdata['fileSn'] != null ) ? jdata['fileSn'] : "",
    );
  }

  Map<String, dynamic> toMap() =>
  {
    'atchFileId': atchFileId,
    'streFileNm': streFileNm,
    'fileSn': fileSn,
  };
}