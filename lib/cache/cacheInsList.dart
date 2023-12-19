import 'package:daejeoni/models/ItemContent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/cache/cacheBase.dart';
import 'package:daejeoni/cache/requestParam.dart';
import 'package:daejeoni/remote/remote.dart';

class CacheInsList extends CacheBase{
  CacheInsList() : super();

  Future <void> requestFrom({
    required BuildContext context,
    required bool first,
    required RequestParam param,
    }) async {

    isFirst = first;
    if(isFirst) {
      hasMore = true;
      param.page = 1;
    }
    else
    {
      param.page = param.page+1;
    }

    loading = true;
    if(isFirst && cache.isNotEmpty) {
      cache.clear();
    }

    notifyListeners();
    var items = await geItems(context, param);

    if(items.isNotEmpty) {
      cache = [
        ...cache,
        ...items,
      ];

      if(items.length<param.countPerPage) {
        hasMore = false;
      }
    }
    else {
      hasMore = false;
    }

    loading = false;
    if(first && items.isEmpty) {
      isEmpty = true;
    } else {
      isEmpty = false;
    }
    notifyListeners();
  }

  Future<List<ItemContent>> geItems(BuildContext context, RequestParam param) async {
    List<ItemContent> items = [];
    await Remote.apiPost(
        context: context,
        session: param.session,
        method: "appService/instt/list.do",
        params: param.getMapParam(),
        onError: (String error) {},
        onResult: (dynamic data) {
          // if (kDebugMode) {
          //   var logger = Logger();
          //   logger.d(data);
          // }
          if (data['status'].toString() == "200") {
            var value = data['data'];
            var pagination = value['pagination'];
            if(isFirst && pagination != null) {
              page.totalRecordCount = (pagination['totalRecordCount']!=null) ? int.parse(pagination['totalRecordCount'].toString()) : 0;
              page.currentPageNo = (pagination['currentPageNo']!=null) ? int.parse(pagination['currentPageNo'].toString()) : 0;
              page.recordCountPerPage = (pagination['recordCountPerPage']!=null) ? int.parse(pagination['recordCountPerPage'].toString()) : 0;
            }
            var content = value['list'];
            if(content!=null) {
              items = ItemContent.fromInstSnapshot(content);
            } else {
              items = [];
            }
            if (kDebugMode) {
              print(">>>>>>>>>>>>>> total:[${cache.length+items.length}] "
                  "page = ${param.page}, result = ${items.length}");
            }
          }
        },
    );
    return items;
  }

}