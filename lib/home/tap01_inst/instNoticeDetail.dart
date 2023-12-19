import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:daejeoni/common/cardPhotoItem.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/infoInstNotice.dart';
import 'package:daejeoni/models/itemInstNotice.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
class InstNoticeDetail extends StatefulWidget {
  final String insttSn;
  final ItemInstNotice item;
  const InstNoticeDetail({
    Key? key,
    required this.insttSn,
    required this.item,
  }) : super(key: key);

  @override
  State<InstNoticeDetail> createState() => _InstNoticeDetailState();
}

class _InstNoticeDetailState extends State<InstNoticeDetail> {

  InfoInstNotice _info = InfoInstNotice();
  late SessionData _session;
  bool _bready = false;

  double _szRatio = 1.36;

  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    Future.microtask(() async {
      await _reqContent();
      if(_info.photo_sub_items.isNotEmpty) {
        await calculateImageDimension(_info.photo_sub_items[0].url);
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
        body:GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: (_bready) ? CustomScrollView(
              slivers: [
                _renderSliverAppbar(),
                _renderHeaderPart(),
              ],
            ) : Container(),
          )
        ),
    );
  }

  SliverAppBar _renderSliverAppbar() {
    return SliverAppBar(
      floating: true,
      centerTitle: true,
      //pinned: true,
      title: const Text("공시사항"),
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
                size: 26,
              ),
              onPressed: () async {
                await _reqContent();
                if(_info.photo_sub_items.isNotEmpty) {
                  await calculateImageDimension(_info.photo_sub_items[0].url);
                }
                setState(() {});
              }),
        ),
      ],
      //expandedHeight: 60
    );
  }
  SliverList _renderHeaderPart() {
    double picHeight = (MediaQuery.of(context).size.width-20)/_szRatio;
    //final double picHeight = MediaQuery.of(context).size.width * 0.72;
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_info.boardSj,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: ItemBkB16,),
                const SizedBox(height: 10,),
                const Divider(),
                Text("${_info.regId}  |  ${_info.regDt.substring(0,10)}  |  조회수: ${_info.boardRdcnt}", style: ItemBkN14,),
                const Divider(),
                /*
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Spacer(),
                    // 416806245012021-06-04조회수:  62
                    Text(_info.regId,style: ItemG1N14,),
                    VerticalDivider(thickness: 1, color: Colors.grey,),
                    Text(_info.regDt.substring(0,10), style: ItemG1N14,),
                    VerticalDivider(thickness: 1, color: Colors.grey,),
                    Text("조회수: ${_info.boardRdcnt}", style: ItemG1N14,),
                  ],
                ),
                */
                Visibility(
                  visible: _bready,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. photo
                        Visibility(
                          visible: _info.photo_sub_items.isNotEmpty,
                          child:Container(
                            height: picHeight,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: (_info.photo_sub_items.isNotEmpty)
                                ? CardPhotos(
                                    fit : BoxFit.fill,
                                    items: _info.photo_sub_items,
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  )
              ),


                Container(
                  margin: EdgeInsets.only(top:15),
                  //padding: EdgeInsets.all(10),
                  child: Text(_info.boardCn, style: ItemBkN14,),
                ),
              ],
            ),
          ),

        ]));
  }

  Future <void> _reqContent() async {
    //_showProgress(true);
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/instt/notice_view.do",
      params: {"insttSn":widget.insttSn, "boardSn":widget.item.boardSn },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        var content = data['data'];//['info'];
        if(content != null) {
          _info = InfoInstNotice.fromJson(content);
        } else {
          _info = InfoInstNotice();
        }
      },
    );
    //_showProgress(false);
  }

}
