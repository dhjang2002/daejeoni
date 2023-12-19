// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/inputForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemPost.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class _ContentView extends StatefulWidget {
  final String insttSn;
  final Function(bool bDirty, ItemPost info) onClose;
  const _ContentView({
    Key? key,
    required this.insttSn,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {
  bool _bEnable = false;
  final ItemPost _info = ItemPost();
  late SessionData _session;


  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    _validate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("이용후기"),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: app_top_size_close,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
      body: GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
          },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ratingView(),
                        const Divider(height: 20,),
                        _reviewView(),
                      ],
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: true,
                child:ButtonSingle(
                    visible: true,
                    isBottomPading: false,
                    text: "등록하기",
                    enable: _bEnable,
                    onClick: () async {
                      bool flag = await _addPost();
                      widget.onClose(flag, _info);
                      Navigator.pop(context);
                    }
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _reviewView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "이용 후기를 작성해주세요.",
            style: ItemBkN16,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            color: Colors.white,
            child: InputForm(
              onlyDigit: false,
              maxLines: 15,
              minLines: 6,
              hintText: '다양한 의견이 서로 존중될 수 있도록 다른 사람에게 불쾌감을 주는 욕설,혐오,비하의 표현이나 타인의 권리를 침해하는 내용은 주의하세요. 모든 작성자는 작성한 게시글에 대해 법적 책임을 갖는다는점 유의하시기 바랍니다.',
              valueText: _info.insttReplyText,
              onChange: (value) {
                _info.insttReplyText = value;
                _validate();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "이용 만족도는 어떤가요?",
            style: ItemBkN16,
          ),
          RatingStars(
            value: _info.insttReplyGrade,
            onValueChanged: (v) {
              setState(() {
                _info.insttReplyGrade = v;
              });
              _validate();
            },
            starBuilder: (index, color) => Icon(Icons.star, color: color,),
            starCount: 5,
            starSize: 48,
            maxValue: 5,
            starSpacing: 0.0,
            maxValueVisibility: false,
            valueLabelVisibility: false,
            starOffColor: Colors.grey,
            starColor: Colors.amber,
          ),
        ],
      ),
    );
  }

  void _validate() {
    setState(() {
     _bEnable = _info.insttReplyText.isNotEmpty
                 && _info.insttReplyGrade > 0.0;
    });
  }

  Future <bool> _addPost() async {
    bool flag = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/instt/reply/regist.do",
      params: {
        "insttSn": widget.insttSn,
        "insttReplyGrade": _info.insttReplyGrade.toInt().toString(),
        "insttReplyText":  _info.insttReplyText },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        // var content = data['data']['list'];
        // if(content != null) {
        //   _postList = ItemPost.fromSnapshot(content);
        // } else {
        //   _postList = [];
        // }
        if(data['status'].toString()=="200") {
          flag = true;
        }
      },
    );
    return flag;
  }

}

Future<void> showWritePost({
  required BuildContext context,
  required String insttSn,
  required Function(bool bDirty, ItemPost item) onResult}) {
  double viewHeight = MediaQuery.of(context).size.height * 0.85;
  return showModalBottomSheet(
    context: context,
    enableDrag: false,
    isScrollControlled: true,
    useRootNavigator: false,
    isDismissible: true,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => true,
        child: SizedBox(
          height: viewHeight,
          child: _ContentView(
            insttSn: insttSn,
            onClose: (bDirty, info) {
              onResult(bDirty, info);
            },
          ),
        ),
      );
    },
  );
}