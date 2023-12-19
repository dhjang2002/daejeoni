// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardPhoto.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/models/itemFavoriteGps.dart';
import 'package:daejeoni/models/itemProgram.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:daejeoni/utils/Launcher.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:daejeoni/webview/WebExplorer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowProgramDetail extends StatefulWidget {
  final String eduSn;
  final ItemProgram? item;
  const ShowProgramDetail({
    Key? key,
    required this.eduSn,
    this.item,
  }) : super(key: key);

  @override
  State<ShowProgramDetail> createState() => _ShowProgramDetailState();
}

class _ShowProgramDetailState extends State<ShowProgramDetail> {
  late SessionData _session;
  bool _bready = false;
  final bool _bWaiting = false;

  ItemProgram? _info = ItemProgram();
  String eduSn = "";
  double _szRatio = 0.64;

  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    int delay = 300;
    if (Platform.isAndroid) {
      delay = 30;
    }
    Future.delayed(Duration(milliseconds: delay), () async {
      _info = widget.item;
      if(widget.item == null) {
        eduSn = widget.eduSn;
        await _reqInfo();
      } else {
        eduSn = widget.item!.eduSn;
      }

      print("eduSn=$eduSn");
      if(_info!.image_url.isNotEmpty) {
        await calculateImageDimension(_info!.image_url);
      }

      setState(() {
        _bready = true;
      });
    });
    super.initState();
  }

  Future <Size> calculateImageDimension(String imageUrl) {
    bool isOk = true;
    Completer<Size> completer = Completer();
    Image image = Image(
        image: CachedNetworkImageProvider(
            imageUrl,
            errorListener: (){
              if (kDebugMode) {
                print("calculateImageDimension()::Invalid Image url................");
              }
              isOk = false;
            }
        )
    );

    if(isOk) {
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
              (ImageInfo image, bool synchronousCall) {
            var myImage = image.image;
            Size size = Size(
                myImage.width.toDouble(), myImage.height.toDouble());
            completer.complete(size);
            _szRatio = size.aspectRatio;
            if (kDebugMode) {
              print("calculateImageDimension()::Image info: ${size.width}X ${size.height} [${size.aspectRatio}]");
            }
          },
        ),
      );
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:WillPopScope(
            onWillPop: onWillPop,
            child:GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: (_bready) ? Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: CustomScrollView(
                    slivers: [
                      _renderSliverAppbar(),
                      _renderContent(),
                      _renderShare(),
                      _renderApply(),
                    ],
                  ),
                ),
              ),

              Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Visibility(
                      visible: _bWaiting,
                      child: Container(
                        color: const Color(0x1f000000),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                  )
              ),
            ],
          ) : Container(),
        )
        )
    );
  }

  SliverAppBar _renderSliverAppbar() {
    return SliverAppBar(
      //key: _posKeyHome,
      floating: true,
      centerTitle: true,
      //pinned: true,
      title: const Text("상세보기"),
      leading: IconButton(
          icon: Image.asset(
            "assets/icon/top_back.png",
            height: app_top_size_back,
            fit: BoxFit.fitHeight,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          }
      ),
      actions: [

        Visibility(
          visible: true,
          child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.black,
                size: app_top_size_refresh,
              ),
              onPressed: () async {
                await _reqInfo();
                setState(() {});
              }),
        ),
      ],
      //expandedHeight: 60
    );
  }

  SliverToBoxAdapter _renderContent() {
    double picHeight = (MediaQuery.of(context).size.width-20)/_szRatio;
    ItemProgram item = _info!;
    String dist = "정보없음";
    if(_info != null && item.myDstnc>=0.0) {
      dist = "${(item.myDstnc * 100).truncate() / 100} Km";
    }
    return SliverToBoxAdapter(

      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text("[${item.eduTy}]", style: ItemBkB16,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text("[${item.getArea()}]",
                        style: const TextStyle(fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.orange,
                        ),
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.amber,
                      ),
                      child: Center(
                        child: Text(dist, style: const TextStyle(fontSize: 12, color: Colors.white),),
                      ),
                    ),
                  ],
                ),

                // 1. 타이틀

                Container(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/icon/calendar.png",
                        height: 16, fit: BoxFit.fitHeight,
                      ),

                      const SizedBox(width: 10,),
                      Expanded(child: Text(item.eduSj, style: ItemBkB16,))
                    ],
                  ),
                ),

                // 주최기관
                /*
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/icon/calendar.png",
                        height: 16, fit: BoxFit.fitHeight,
                      ),

                      const SizedBox(width: 10,),
                      Expanded(child: Text(item.openInstt, style: ItemBkB16,))
                    ],
                  ),
                ),
                */
                // 2. 사진
                SizedBox(
                  //width: imageWidth,
                  height: picHeight,
                  child: Center(
                    child: (_bready) ? CardPhoto(
                      photoUrl: item.image_url,
                      fit: BoxFit.fill,
                      //onZoom: () {},
                    ) : Container(),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 15),
                  child: _itemLabel("주최기관", "${item.openInstt}"),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                  child: _itemLabel("신청기간", "${item.rcptBgngDt} ~ ${item.rcptEndDt}"),
                ),

                const Divider(height: 1,),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                  child: _itemLabel("행사기간", "${item.eduBgngDt} ~ ${item.eduEndDt}"),
                ),

                // 참여대상
                Container(
                    margin: const EdgeInsets.only(top:20),
                    padding: const EdgeInsets.fromLTRB(0,15,0,15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF46BBC6),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: const Center(
                      child: Text("참여대상",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: -0.5
                        ),
                      ),
                    )
                ),
                // 참여대상
                Container(
                  padding: const EdgeInsets.fromLTRB(3, 10, 3, 10),
                  child: Text(item.partcptnTrgt, style: ItemBkN15,),
                ),

                // 참여비용/교육시간
                Container(
                  margin: const EdgeInsets.only(top:20),
                  //height: 80,
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.fromLTRB(0,15,0,15),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF59BB9C),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: const Center(
                                    child: Text("참가비용",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: -0.5
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(
                                //padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                height: 44,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                                  child: Center(
                                  child: Text(item.partcptCt,
                                    maxLines: 2,
                                    style: ItemBkN14,),
                                ),
                                )
                              ),
                            ],
                          )
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.fromLTRB(0,15,0,15),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF59BB9C),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: const Center(
                                    child: Text("접수형태",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: -0.5
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(
                                //padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                height: 44,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                                  child: Center(
                                  child: Text("${item.applyType()}",
                                    maxLines: 2,
                                    style: ItemBkN14,),
                                ),
                                )
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),

                // 정원(가족수)/접수현황
                Container(
                  margin: const EdgeInsets.only(top:20, bottom: 20),
                  //height: 80,
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.fromLTRB(0,15,0,15),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF59BB9C),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: const Center(
                                    child: Text("진행장소",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: -0.5
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(
                                //padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                height: 44,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                                  child: Center(
                                    child: Text("${item.progrsPlace}",
                                      maxLines: 2,
                                      style: ItemBkN14,),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.fromLTRB(0,15,0,15),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF59BB9C),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: const Center(
                                    child: Text("진행문의",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: -0.5
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(
                                //padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                height: 44,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                                  child: Center(
                                  child: Text("${item.progrsInqry}",
                                    maxLines: 1,
                                    style: ItemBkN14,),
                                ),
                                )
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:const EdgeInsets.fromLTRB(10,25,0,0),
                      child: const Text("행사안내", style: ItemBkB15,),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0,10,0,50),
                      child: Html(data: _info!.eduCn),
                    ),
                  ],
                ),
                // 3. 프로그램 구성
              ],
            )
        ),
      ),
    );
  }

  SliverToBoxAdapter _renderApply() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,0,10,50),
        child: Column(
          children: [
            Container(
              //margin: EdgeInsets.fromLTRB(10, 50, 10, 50),
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              //color: Colors.amber,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                      child: ButtonState(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        text: '진행문의',
                        enableColor: Colors.white,
                        borderColor: Colors.black,
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: -0.5
                        ),
                        onClick: () {
                          callPhone(_info!.progrsInqry);
                          //_doApply(widget.item);
                        },
                      )
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                      flex: 1,
                      child: ButtonState(
                        enable: _info!.isAvailable(),
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        text: '신청하기',
                        enableColor: (_info!.isAvailable() && _info!.urlAdres.isNotEmpty)
                            ? const Color(0xFF59BB9C): Colors.grey,
                        borderColor: (_info!.isAvailable() && _info!.urlAdres.isNotEmpty)
                            ? const Color(0xFF59BB9C): Colors.grey,
                        textStyle: TextStyle(
                            color: (_info!.isAvailable() && _info!.urlAdres.isNotEmpty) ? Colors.white:Colors.black,
                            fontSize: 14,
                            letterSpacing: -0.5
                        ),
                        onClick: () {
                          if(_info!.isAvailable() && _info!.urlAdres.isNotEmpty) {
                            _doApply(_info!);
                          }
                        },
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _renderShare() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0,10,0,50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                IconButton(
                  onPressed: (){},
                  icon: Image.asset(
                    "assets/icon/share_9351.png",
                    width: 36,
                    height: 36,
                    //color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(15),
              child: const Center(
                  child: Text("함께하고 싶은 행사정보를 공유하세요.", style: ItemBkN14)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemLabel(String label, String value, { String? path="assets/icon/calendar.png"}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(path!,
              height: 20, fit: BoxFit.fitHeight,
            ),

            const SizedBox(width: 10,),
            Expanded(child: Text(label, style: ItemBkN14,))
          ],
        ),
        const SizedBox(height: 10,),
        Text(value, style: ItemBkB15,)
      ],
    );
  }
  // http://10.10.10.6:8080/appService/edu_apply.do?jwtToken=로긴토큰&scrtyKey=y2EH8ynp6VaFR7CIkNjbig%3D%3D
  Future <void> _doApply(ItemProgram info) async {

    String urlString = info.urlAdres;
    print("_doApply()::$urlString");

    urlString = urlString.replaceAll("no-url", "");//.trim();
    if(info.isExternalLink()) {
      if(urlString.isNotEmpty) {
        launchUrl(Uri.parse(urlString), mode: LaunchMode.externalApplication);
      }
      // Navigator.push(
      //   context,
      //   Transition(
      //       child: WebExplorer(title: "신청하기", url: info.urlAdres,),
      //       transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
      // );
    }
    else
    {
      if(await ConfirmSigned(context, _session)) {
        String url = getUrlParam(
          website: '$SERVER/appService/edu_apply.do',
          data: {
            //"returnUrl":targetUrl,
            "jwtToken":_session.AccessToken,
            "scrtyKey":info.scrtyKey,
          },
        );

        Navigator.push(
          context,
          Transition(
              child: WebExplorer(title: "신청하기", url: url,),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
        );
      }
    }
  }

  Future <bool> onWillPop() async {
    return true;
  }
  // 서버에서 데이터를 가져온다.
  Future <void> _reqInfo() async {
    ItemFavoriteGps gps = _session.getCurrentFavoriteInfo();
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/parnts/detail.do",

      params: {"eduSn":eduSn, "gpsLcLat": gps.mapY, "gpsLcLng": gps.mapX },
      onError: (String error) {},
      onResult: (dynamic data) {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }

        var value = data['data'];
        //var content = value['list'];
        if(value != null) {
          _info = ItemProgram.fromJson(value);
        }
      },
    );
  }
}
