import 'package:flutter/material.dart';

class Pagenation {
  int totalRecordCount;
  int currentPageNo;
  int recordCountPerPage;
  Pagenation({
    this.totalRecordCount = 0,
    this.currentPageNo=0,
    this.recordCountPerPage = 0,
  });
}

abstract class CacheBase with ChangeNotifier {
  var  cache = [];
  bool isFirst = true;
  bool loading = false;
  bool hasMore = true;
  bool isEmpty = false;
  String tag = "";
  Pagenation page = Pagenation();
  CacheBase();

  void setTag(String tag) {
    this.tag = tag;
  }
  void clear() {
    isFirst = true;
    loading = false;
    hasMore = true;
    isEmpty = false;
    tag = "";
    page = Pagenation();
    if(cache.isNotEmpty) {
      cache.clear();
    }
  }
}