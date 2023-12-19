import 'package:cached_network_image/cached_network_image.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/infoInstGallery.dart';
import 'package:daejeoni/models/itemInstGallery.dart';
import 'package:daejeoni/models/itemPhoto.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:provider/provider.dart';
class InstGalleryDetail extends StatefulWidget {
  final String insttSn;
  final ItemInstGallery item;
  const InstGalleryDetail({
    Key? key,
    required this.insttSn,
    required this.item,
  }) : super(key: key);

  @override
  State<InstGalleryDetail> createState() => _InstGalleryDetailState();
}

class _InstGalleryDetailState extends State<InstGalleryDetail> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  InfoInstGallery _info = InfoInstGallery();
  List<ItemPhoto> files = [];
  late SessionData _session;
  bool _bready = false;

  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    Future.microtask(() async {
      await _reqContent();
      setState(() {
        _bready = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("갤러리"),
        leading: Visibility(
          visible: true,
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
                  await _reqContent();
                }),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if(!_bready) {
      return Container();
    }

    final photoHeight = MediaQuery.of(context).size.width*0.99;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          // 제목, 기관번호, 등록일자, 조회수
          Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item.boardSj, style: ItemBkB18,),
                const SizedBox(height: 10,),
                const Divider(),
                Text("${_info.mberId}  |  ${_info.regDt.substring(0,10)}  |  조회수: ${_info.boardRdcnt}", style: ItemBkN14,),
                const Divider(),
              ],
            ),
          ),

          // 2. 사진
          SizedBox(
            height: photoHeight,
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageNotifier.value = index;
                  });
                },
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return _showPhoto(files[index]);
                }
            ),
          ),

          Visibility(
            visible: files.length>1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              child: CirclePageIndicator(
                itemCount: files.length,
                dotColor: Colors.grey,
                selectedDotColor: Colors.black,
                currentPageNotifier: _currentPageNotifier,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Text(widget.item.boardCn, style: ItemBkN15,),
          ),
        ],
      ),
    );
  }

  Widget _errOrEmpty() {
    final padding = MediaQuery.of(context).size.width/4;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
        //borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      padding: EdgeInsets.fromLTRB(padding,0,padding,0),
      child: Image.asset(
        "assets/icon/tk_empty_photo.png",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _showPhoto(ItemPhoto item) {
    if (item.atchFileId.isEmpty) {
      return _errOrEmpty();
    }

    String url = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${item.atchFileId}&fileSn=${item.fileSn}";
    return CachedNetworkImage(
      fit: BoxFit.fitWidth,
      imageUrl: url,
      // imageBuilder: (context, imageProvider) => Container(
      //   decoration: BoxDecoration(
      //     shape: BoxShape.rectangle,
      //     color: Colors.white,
      //     image: DecorationImage(image: imageProvider, fit: widget.fit),
      //   ),
      // ),
      placeholder: (context, url) => const Center(
          child: SizedBox(
              width: 14, height: 14, child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => _errOrEmpty(),
    );
  }

  Future <void> _reqContent() async {
    //_showProgress(true);
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/instt/gallery_view.do",
      params: {"insttSn":widget.insttSn, "boardSn":widget.item.boardSn },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }

        var content = data['data'];
        if(content != null && content['files'] != null && content['info'] != null) {
          _info = InfoInstGallery.fromJson(content['info']);
          files = ItemPhoto.fromSnapshot(content['files']);
          _bready = true;
        } else {
          _bready = false;
        }
      },
    );
    setState(() { });
    //_showProgress(false);
  }
}