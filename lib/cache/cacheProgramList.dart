
import 'package:daejeoni/models/itemProgram.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/cache/cacheBase.dart';
import 'package:daejeoni/cache/requestParam.dart';
import 'package:daejeoni/remote/remote.dart';

class CacheProgramList extends CacheBase{
  CacheProgramList() : super();

  Future <void> requestFrom({
    required BuildContext context,
    required bool first,
    required final RequestParam param,
    }) async {

    isFirst = first;
    if(isFirst) {
      param.page = 1;
      hasMore = true;
      if(cache.isNotEmpty) {
        cache.clear();
      }
    }
    else
    {
      param.page = param.page+1;
    }

    // if (kDebugMode) {
    //   print( "requestFrom: param -> ${param.toString()}");
    // }

    loading = true;
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

  Future <List<ItemProgram>> geItems(BuildContext context, RequestParam param) async {
    List<ItemProgram> items = [];
    await Remote.apiPost(
        context: context,
        session: param.session,
        method: "appService/parnts/edu_list.do",
        params: param.getPrgParam(),
        onError: (String error) {},
        onResult: (dynamic data) {
          // if (kDebugMode) {
          //   var logger = Logger();
          //   logger.d(data);
          // }
          if (data['status'].toString() == "200")
          {
            var value = data['data'];
            var pagination = value['pagination'];
            if(isFirst && pagination != null) {
              page.totalRecordCount = (pagination['totalRecordCount']!=null) ? int.parse(pagination['totalRecordCount'].toString()) : 0;
              page.currentPageNo = (pagination['currentPageNo']!=null) ? int.parse(pagination['currentPageNo'].toString()) : 0;
              page.recordCountPerPage = (pagination['recordCountPerPage']!=null) ? int.parse(pagination['recordCountPerPage'].toString()) : 0;
            }

            var content = value['list'];
            if(content != null) {
              items = ItemProgram.fromSnapshot(content);
            }
            else {
              items = [];
            }

            if (kDebugMode) {
              print(">>>>>>>>>>>>>> total:[${cache.length+items.length}] "
                  "page = ${param.page}, result = ${items.length} ==> hasMore[$hasMore]");
            }
          }
        },
    );
    return items;
  }

}