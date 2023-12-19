// ignore_for_file: file_names, non_constant_identifier_names
import 'dart:io';

import 'package:daejeoni/cache/cacheCareList.dart';
import 'package:daejeoni/cache/requestParam.dart';
import 'package:daejeoni/common/cardPhoto.dart';
import 'package:daejeoni/common/cardTabbar.dart';
import 'package:daejeoni/common/menuButtonRadio.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tap00_home/popSearchCare.dart';
import 'package:daejeoni/models/itemCare.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:daejeoni/webview/WebExplorer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';



class ShowCareList extends StatefulWidget {
  const ShowCareList({Key? key}) : super(key: key);

  @override
  State<ShowCareList> createState() => _ShowCareListState();
}

class _ShowCareListState extends State<ShowCareList> {
  final List<MenuButtonRadioItem> _careItems_type = [
    MenuButtonRadioItem(text: "전체", tag:"", select: true,),
    MenuButtonRadioItem(text: "놀이톡톡", tag:"plyMvp", select: false),
    MenuButtonRadioItem(text: "양육톡톡", tag:"brpMvp", select: false),
    MenuButtonRadioItem(text: "양육뉴스", tag:"cardNews", select: false),
    MenuButtonRadioItem(text: "기타", tag:"etc", select: false),
  ];

  final List<TabbarItem> _boardTabitems = [
    TabbarItem(name: "전체", tag: ""),
    TabbarItem(name: "놀이톡톡", tag: "plyMvp"),
    TabbarItem(name: "양육톡톡", tag: "brpMvp"),
    TabbarItem(name: "양육뉴스", tag: "cardNews"),
    TabbarItem(name: "기타", tag: "etc"),
  ];

  final GlobalKey _posKeyHome = GlobalKey();
  late RequestParam _reqParam;
  late CacheCareList _cacheData;

  late int _tabIndex;
  late SessionData _session;
  bool isDisposed = false;

  void setSelectCareType(int index) {
    for (var element in _careItems_type) { element.select = false; }
    _careItems_type[index].select = true;
  }

  int getSelectCareType() {
    int index = 0;
    for (var element in _careItems_type) {
      if(element.select) {
        break;
      }
      index++;
    }
    return index;
  }

  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    _cacheData   = Provider.of<CacheCareList>(context, listen: false);
    _cacheData.clear();

    _reqParam = RequestParam();
    _reqParam.setMapType("CAR");
    _reqParam.setPageToCount(4);
    _reqParam.setSession(_session);

    _tabIndex = 0;
    setSelectCareType(_tabIndex);
    _reqParam.searchKeyword = "";
    _reqParam.ctgryCd = _careItems_type[_tabIndex].tag;
    _reqParam.ctgryCdInfo = _careItems_type[_tabIndex].text;
    if(_reqParam.ctgryCdInfo.isEmpty || _reqParam.ctgryCdInfo=="전체") {
      _reqParam.ctgryCdInfo = "전체내용";
    }

    //initSet();

    Future.microtask(() async {
      await requestData();
      setState(() {});
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
    _cacheData   = Provider.of<CacheCareList>(context, listen: true);
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
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: CustomScrollView(
                        slivers: [
                          _renderSliverAppbar(),
                          _renderWellcome(),
                          _renderTapMenu(),
                          _renderListHeader(),
                          _renderListView(),
                          _renderEmptyData(),
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

  SliverList _renderEmptyData() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
              visible: _cacheData.isEmpty,
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                height: MediaQuery.of(context).size.width*0.6,
                child: Image.asset("assets/error/error_req03.png", fit: BoxFit.fitHeight,),
              )
          ),
          Visibility(
              visible: _cacheData.isEmpty,
              child:Container(
                margin: const EdgeInsets.only(top:20),
                alignment: Alignment.center,
                child: const Text("데이터가 없습니다.", style: ItemG1N15,),
              )
          )
        ])
    );
  }

  SliverAppBar _renderSliverAppbar() {
    return SliverAppBar(
      key: _posKeyHome,
      floating: true,
      centerTitle: true,
      //pinned: true,
      title: const Text("양육정보"),
      leading: Visibility(
        visible: true, //(_tabIndex == 0), //(_m_isSigned && _bSearch),
        child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 26,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      actions: [
        Visibility(
          visible: true,
          child: IconButton(
              icon: const Icon(Icons.search, size: 26,),
              onPressed: () async {
                _doSearch();
              }),
        ),

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
  SliverList _renderWellcome() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: const Column(
              children: [
                Row(
                  children: [
                    Text("대전아이와 함께하는", style: ItemBkN20,),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text("전체 양육정보", style: ItemGrTitle,),
                  ],
                ),
              ],
            ),
          )
        ]));
  }

  SliverList _renderTapMenu() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: CardTabbar(
            items: _boardTabitems,
            itemWidth: MediaQuery.of(context).size.width/5.2,
            textSize: 14,
            index: _tabIndex,
            selectColor: Colors.green,
            normalColor: Colors.grey,
            selectBarColor: Colors.green,
            normalBarColor: Colors.grey[100],
            onChange: (index, item) async {
              setSelectCareType(index);
              _reqParam.ctgryCd = _careItems_type[index].tag;
              _reqParam.ctgryCdInfo = _careItems_type[index].text;
              if(_reqParam.ctgryCdInfo.isEmpty || _reqParam.ctgryCdInfo=="전체") {
                _reqParam.ctgryCdInfo = "전체내용";
              }
              setState(() {
                _tabIndex = index;
              });

              await _requestFirst();
            },
          ),
        ),
      ]),
    );
  }

  SliverList _renderListHeader() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
              visible: true,
              child: Container(
                margin: const EdgeInsets.only(top:10, bottom: 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${_reqParam.orderValue} (${_cacheData.page.totalRecordCount})", style: ItemBkB14),
                            Text(_reqParam.getInfo(), style: ItemBkN12),
                          ],
                        ),
                        const Spacer(),
                        /*
                        PopupMenuButton<String>(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_reqParam.orderValue, style: ItemBkB14,),
                              Icon(Icons.arrow_drop_down, size: 18,),
                            ],
                          ),
                          onSelected: (String value) {
                            FocusScope.of(context).unfocus();
                            if(value != _reqParam.orderValue) {
                              _reqParam.setOrder(value);
                              _requestFirst();
                            }
                          },
                          itemBuilder: (BuildContext context) => _reqParam.orderList.map((value) => PopupMenuItem(
                            value: value,
                            child: Text(value, style: ItemBkN14,),
                          ))
                              .toList(),
                        ),
                        const SizedBox(width: 20,),
                        SizedBox(
                          height: 36,
                          width: 90,
                          //margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: ButtonRoundRect(
                            radious:5,
                            icon: const Icon(Icons.maps_home_work_outlined,
                              size: 12, color: Colors.white,),
                            iconGap: 5,
                            text: '지도보기',
                            fontSize: 12,
                            backgroundColor:Colors.green,
                            padding: const EdgeInsets.fromLTRB(0,0,0,0),
                            onClick: () async {
                              _showMap();
                            },
                          ),
                        ),
                        const SizedBox(width: 5,),
                         */
                      ],
                    ),
                    //const Divider(height: 1,),
                  ],
                ),
              )
          ),
        ]));
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
        ItemCare item = _cacheData.cache[index];
        return _itemCardCareTile(item);
      },
    );
  }

  Widget _itemCardCareTile(ItemCare item) {
    final double imageHeight = MediaQuery.of(context).size.width*0.88*4/6;
    return GestureDetector(
      onTap: () {
        _doShowCareDetail(item);
      },
      child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: imageHeight,
                child: CardPhoto(
                  photoUrl: item.image_url,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  Expanded(
                    child: Text(item.boardSj,
                      maxLines:2,
                      overflow: TextOverflow.ellipsis,
                      style: ItemBkB15,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Text("[${item.getCategory()}]",
                    maxLines:1,
                    overflow: TextOverflow.ellipsis,
                    style: ItemBkB15,
                  )

                ],
              ),
              Text(item.regDt,
                maxLines:1,
                overflow: TextOverflow.ellipsis,
                style: ItemBkN14,),
              const SizedBox(height: 10,),
              const Divider(height: 10,),
            ],
          )
      ),
    );
  }

  void _doSearch() {
    showSearchCare(
        context: context,
        title: '상세검색',
        items_type:_careItems_type,
        onResult: (bool bOK,
            String keyword,
            String strState,
            String strType,
            String strDateBegin,
            String strDateEnd) async {
          if(bOK) {
            _reqParam.searchKeyword = keyword;
            int index = getSelectCareType();
            _reqParam.ctgryCd = _careItems_type[index].tag;
            _reqParam.ctgryCdInfo = _careItems_type[_tabIndex].text;
            if(_reqParam.ctgryCdInfo.isEmpty || _reqParam.ctgryCdInfo=="전체") {
              _reqParam.ctgryCdInfo = "전체내용";
            }
            setState(() {
              _tabIndex = index;
            });
          }
          await _requestFirst();
        }
    );
  }

  Future<void> _doShowCareDetail(ItemCare item) async {
    String url = getUrlParam(
      website: '$SERVER/appService/talk_info.do',
      data: {
        "jwtToken":_session.AccessToken,
        "boardSn": item.boardSn
      },
    );

    if (Platform.isAndroid) {
      // var webViewConfig = WebViewConfiguration();
      // webViewConfig.setUserAgentString("Your UserAgent String");
      launchUrl(
          Uri.parse(url),
          webViewConfiguration: const WebViewConfiguration(
              headers: {'UserAgent': USER_AGENT}
            //headers: {'userAgent': USER_AGENT}

          ),
          //mode: LaunchMode.inAppWebView
          mode: LaunchMode.externalApplication
      );
    }
    else
    {
      Navigator.push(
        context,
        Transition(
            child: WebExplorer(title: "상세보기", url: url,),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
      );
    }

  }

  // 서버에서 데이터를 가져온다.
  Future <void> requestData() async {
    _requestFirst();
  }

  // 서버에서 데이터를 가져온다.
  Future <void> _requestFirst() async {
    await _cacheData.requestFrom(context: context, param: _reqParam, first: true);
    //_boardTabitems[_tabIndex].cText = _cacheData.page.totalRecordCount.toString();
  }

  Future <void> _requestMore() async {
    if(isDisposed) {
      return;
    }
    await _cacheData.requestFrom(context: context, param: _reqParam, first: false);
  }

}
