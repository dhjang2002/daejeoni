// ignore_for_file: file_names

import 'package:daejeoni/cache/cacheNoticeList.dart';
import 'package:daejeoni/cache/requestParam.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemNotice.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:daejeoni/webview/WebExplorer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';

class ShowNoticeList extends StatefulWidget {
  const ShowNoticeList({Key? key}) : super(key: key);

  @override
  State<ShowNoticeList> createState() => _ShowNoticeListState();
}

class _ShowNoticeListState extends State<ShowNoticeList> {
  final GlobalKey _posKeyHome = GlobalKey();

  late RequestParam _reqParam;
  late CacheNoticeList _cacheData;
  
  late SessionData _session;
  bool isDisposed = false;

  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    _cacheData   = Provider.of<CacheNoticeList>(context, listen: false);
    _cacheData.clear();
    _reqParam = RequestParam(mapCtgryCd:"", order: "", area:"");
    _reqParam.setMapType("");
    _reqParam.setSession(_session);
    
    Future.microtask(() async {
      await requestData();
      setState(() {
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    _cacheData   = Provider.of<CacheNoticeList>(context, listen: true);
    return Scaffold(
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Container(
                      color: ColorG6,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: CustomScrollView(
                        slivers: [
                          _renderSliverAppbar(),
                          _renderListView(),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: (_cacheData.isFirst)
                        ? Alignment.center
                        : Alignment.bottomCenter,
                    //left: 0,right: 0, bottom: 0,
                    child: Visibility(
                      visible: _cacheData.loading,
                      child: Container(
                        width: double.infinity,
                        height: 25,
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(bottom: 5),
                        child: (_cacheData.hasMore)
                            ? const Center(
                            child: SizedBox(
                                width: 25,
                                child: CircularProgressIndicator()))
                            : const Center(child: Icon(Icons.arrow_drop_up)),
                      ),
                    )
                ),
                Positioned(
                    bottom: 50, right: 5,
                    child: Visibility(
                      visible: true,
                      child: FloatingActionButton.small(
                          backgroundColor: Colors.white,
                          onPressed: (){
                            Scrollable.ensureVisible(
                                _posKeyHome.currentContext!,
                                duration: const Duration(
                                    milliseconds: moveMilisceond)
                            );
                          },
                          child: const Icon(Icons.arrow_upward,
                              color: Colors.black)
                      ),
                    )
                ),
              ]
          )
      ),
    );
  }

  SliverAppBar _renderSliverAppbar() {
    return SliverAppBar(
      key: _posKeyHome,
      floating: true,
      centerTitle: true,
      //pinned: true,
      title: const Text("공지사항"),
      leading: Visibility(
        visible: true, //(_tabIndex == 0), //(_m_isSigned && _bSearch),
        child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 26,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      actions: [
        // 새로고침
        Visibility(
          visible: true,
          child: IconButton(
              icon: const Icon(Icons.refresh_outlined, size: app_top_size_refresh,),
              onPressed: () async {
                _reqParam.page = 1;
                await requestData();
              }),
        ),
      ],
      //expandedHeight: 70
    );
  }

  SliverList _renderListView() {
    return SliverList.builder(
      itemCount: _cacheData.cache.length,
      itemBuilder: (BuildContext context, int index) {
        if (_cacheData.cache.length > 3 &&
            index+1 == _cacheData.cache.length) {
          if (!_cacheData.loading && _cacheData.hasMore) {
            Future.microtask(() {
              _requestMore();
            });
          }
        }

        //print("index-----------------> $index");
        ItemNotice item = _cacheData.cache[index];
        return _itemNotice(item);
      },
    );
  }

  Widget _itemNotice(ItemNotice item) {
    final span=TextSpan(text:item.boardCn);
    final tp =TextPainter(text:span,maxLines: 3,textDirection: TextDirection.ltr);
    tp.layout(maxWidth: MediaQuery.of(context).size.width); // equals the parent screen width

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 1,
        //     offset: const Offset(0, 0.5), // changes position of shadow
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _doShowNoticeDetail(item);
            },
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(item.regDt.substring(0,10), style: ItemG1N12,),
                      ),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.boardSj, style: ItemBkB14, maxLines: 3,
                          textAlign:TextAlign.justify,
                          overflow: TextOverflow.ellipsis,),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.only(left: 10),
                      //   child: Text(item.regDt.substring(0,10), style: ItemG1N14,),
                      // ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,5,0,0),
                    child: Text(
                        item.boardCn,
                        style: ItemBkN15, maxLines: (item.showMore) ? 44 : 3,
                        textAlign:TextAlign.justify,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),

          Visibility(
              visible: false,//tp.didExceedMaxLines,
              child:GestureDetector(
                  onTap: () {
                    setState(() {
                      item.showMore = !item.showMore;
                    });
                  },
                  child:Container(
                      alignment: Alignment.center,
                      child:Icon((!item.showMore) ? Icons.arrow_drop_down : Icons.arrow_drop_up)
                  )
              )
          ),
        ],
      ),
    );
  }

  /*
  Widget _itemNotice(ItemNotice item) {
    final span=TextSpan(text:item.boardCn);
    final tp =TextPainter(text:span,maxLines: 3,textDirection: TextDirection.ltr);
    tp.layout(maxWidth: MediaQuery.of(context).size.width); // equals the parent screen width

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _doShowNoticeDetail(item);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5,),
                Text(item.boardSj, style: ItemBkB16, maxLines: 3,
                  textAlign:TextAlign.justify,
                  overflow: TextOverflow.ellipsis,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,5,0,0),
                  child: Text(item.boardCn,
                      style: ItemBkN15, maxLines: (item.showMore) ? 44 : 3,
                      textAlign:TextAlign.justify,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Spacer(),
              Text(item.regDt, style: ItemG1N12,),
            ],
          ),
          Visibility(
              visible: tp.didExceedMaxLines,
              child:GestureDetector(
                onTap: () {
                  setState(() {
                    item.showMore = !item.showMore;
                  });
                },
                child:Container(
                  alignment: Alignment.center,
                  child:Icon((!item.showMore) ? Icons.arrow_drop_down : Icons.arrow_drop_up)
                )
              )
          ),
          const Divider(),
        ],
      ),
    );
  }
  */


  Future <void> _doShowNoticeDetail(ItemNotice info) async {
    String url = getUrlParam(
      website: '$SERVER/appService/notice_info.do',
      data: {
        //"returnUrl":targetUrl,
        "jwtToken":_session.AccessToken,
        "boardSn": info.boardSn
      },
    );

    await Navigator.push(
      context,
      Transition(
          child: WebExplorer(title: "상세보기", url: url,),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  // 서버에서 데이터를 가져온다.
  Future <void> requestData() async {
    _requestFirst();
  }

  // 서버에서 데이터를 가져온다.
  Future <void> _requestFirst() async {
    await _cacheData.requestFrom(context: context, param: _reqParam, first: true);
  }

  Future <void> _requestMore() async {
    if(isDisposed) {
      return;
    }
    await _cacheData.requestFrom(context: context, param: _reqParam, first: false);
  }

}
