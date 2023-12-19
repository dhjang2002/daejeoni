// ignore_for_file: file_names
import 'package:daejeoni/cache/cacheSpaceList.dart';
import 'package:daejeoni/cache/requestParam.dart';
import 'package:daejeoni/common/cardPhoto.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tap00_home/showSpaceDetail.dart';
import 'package:daejeoni/models/itemSpace.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';

class ShowSpaceList extends StatefulWidget {
  const ShowSpaceList({Key? key}) : super(key: key);

  @override
  State<ShowSpaceList> createState() => _ShowSpaceListState();
}

class _ShowSpaceListState extends State<ShowSpaceList> {
  final GlobalKey _posKeyHome = GlobalKey();
  late RequestParam _reqParam;
  late CacheSpaceList _cacheData;
  
  late SessionData _session;
  bool isDisposed = false;

  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    _cacheData   = Provider.of<CacheSpaceList>(context, listen: false);
    _cacheData.clear();
    _reqParam = RequestParam();
    _reqParam.setMapType("SPA");
    _reqParam.setPageToCount(4);

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
    _cacheData   = Provider.of<CacheSpaceList>(context, listen: true);
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
                          _renderEmptyData(),
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
      title: const Text("공간대여"),
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
          visible: false,
          child: IconButton(
              icon: const Icon(Icons.search, size: 26,),
              onPressed: () async {
                //_doSearch();
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
        ItemSpace item = _cacheData.cache[index];
        return Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            children: [
              _itemCardSpaceTile(item),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  /*
  Widget _itemCardSpaceTile2(ItemSpace item) {
    final double imageWidth  = MediaQuery.of(context).size.width*0.3;
    final double imageHeight = imageWidth*0.8;
    return GestureDetector(
      onTap: () {
        _doShowSpaceDetail(item);
      },
      child: Container(
          //height: itemHeight,
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: imageWidth,
                    height: imageHeight,
                    child: CardPhoto(
                      photoUrl: item.spceFile,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.spceNm, style: ItemBkB15,),
                            const SizedBox(height: 5,),
                            Text("공간면적 : ${item.spceAr}", style: ItemBkN14,),
                            Text("수용인원 : ${item.spcePerson}", style: ItemBkN14,),
                            Text("전화번호 : ${item.spceTelno}", style: ItemBkN14,),
                          ],
                        )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              const Divider(height: 1,),
            ],
          )
      ),
    );
  }
  */

  Widget _itemCardSpaceTile(ItemSpace item) {
    final double imageHeight = MediaQuery.of(context).size.width*4/6;
    return GestureDetector(
      onTap: () {
        _doShowSpaceDetail(item);
      },
      child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: imageHeight,
                child: CardPhoto(
                  photoUrl: item.spceFile,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.spceNm, style: ItemBkB16,),
                            const SizedBox(height: 5,),
                            Text("공간면적: ${item.spceAr}, 수용인원: ${item.spcePerson}, 연략처: ${item.spceTelno}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: ItemBkN14,),
                            // Text("수용인원 : ${item.spcePerson}", style: ItemBkN14,),
                            // Text("전화번호 : ${item.spceTelno}", style: ItemBkN14,),
                          ],
                        )
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 5,),
              // const Divider(height: 1,),
            ],
          )
      ),
    );
  }

  /*
  void _doSearch() {
    showSearchProgram(context: context, title: '상세검색',
        onResult: (bool bOK, String keyword, String strState, String strType, String strDateBegin, String strDateEnd) async {
          if(bOK) {
            _reqParam.searchKeyword = keyword;
            _reqParam.strState = strState;
            _reqParam.strType = strType;
            _reqParam.strDateBegin = strDateBegin;
            _reqParam.strDateEnd = strDateEnd;

          }
          // _reqParam.insttAgeType  = agString;
          // _reqParam.insttSgg      = arString;
          // _reqParam.upperInsttSn1 = tdString;
          // _reqParam.upperInsttSn2 = tdString;
          await _requestFirst();
        }
    );
  }
  */
  Future<void> _doShowSpaceDetail(ItemSpace item) async {
    Navigator.push(
      context,
      Transition(
          child: ShowSpaceDetail(
            item:item,
          ),
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
