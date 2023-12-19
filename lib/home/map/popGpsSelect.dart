// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardGpsTile.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/map/selectLocation.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:daejeoni/models/itemFavoriteGps.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';

class _ContentView extends StatefulWidget {
  final String title;
  final double viewHeight;
  final bool? isPopup;
  final Function(bool bDirty, ItemFavoriteGps item) onClose;
  const _ContentView({
    Key? key,
    required this.title,
    required this.viewHeight,
    required this.onClose,
    this.isPopup = false,
  }) : super(key: key);

  @override
  State<_ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {
  int iSelect = -1;
  late SessionData _session;
  List<ItemFavoriteGps> _gpsList = [];
  //ItemFavoriteGps? selItem;
  bool _bEdit = false;
  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    _gpsList = _session.favoriteGpsList!;
    _gpsList.forEach((element) {
      element.bSelect = false;
    });
    iSelect = _session.favoriteIndex;
    _gpsList[iSelect].bSelect = true;
    setState(() {});
    Future.microtask(() async {
    });
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
        title: Text(widget.title),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Visibility(
          visible: !widget.isPopup!,
          child: IconButton(
              icon: const Icon(
                Icons.close,
                size: app_top_size_close,
              ),
              onPressed: () async {
                Navigator.pop(context);
              }),
        ),
        actions: [
          Visibility(
            visible: !widget.isPopup!,
            child: IconButton(
                icon: const Icon(
                  Icons.edit_note_outlined,
                  size: 28,
                ),
                onPressed: () async {
                  setState(() {
                    _bEdit = !_bEdit;
                  });
                }),
          ),
        ],
      ),

      body: Container(
          color: Colors.white,
          child:Column(
            children: [
              Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: SingleChildScrollView(
                        child:ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _gpsList.length,
                          itemBuilder: (context, index) {
                            if(index<_gpsList.length) {
                              ItemFavoriteGps item = _gpsList[index];
                              return Column(
                                children: [
                                  Container(
                                      child: CardGpsTile(
                                        tileHeight: 60,
                                        item: _gpsList[index],
                                        modeEdit: _bEdit,
                                        bSelect: (_bEdit) ? false : item.bSelect,
                                        onTab: (i) {
                                          if (!_bEdit) {
                                            for (var element in _gpsList) {
                                              element.bSelect = false;
                                            }
                                            setState(() {
                                              iSelect = index;
                                              item.bSelect = true;
                                            });

                                            Future.delayed(Duration(milliseconds: 300), () {
                                              _session.favoriteIndex = iSelect;
                                              _session.setNotify();
                                              widget.onClose(true, _gpsList[iSelect]);
                                              Navigator.pop(context);
                                            });
                                          }
                                        },

                                        onAction: (item) async {
                                          showYesNoDialogBox(
                                              height: 240,
                                              context: context,
                                              title: "확인",
                                              message: "즐겨찾기 항목을 삭제하시겠습니까?",
                                              onResult: (bOK) async {
                                                if (bOK) {
                                                  await _reqDelete(item);
                                                  for (var element in _gpsList) {
                                                    element.bSelect = false;
                                                  }

                                                  iSelect = index - 1;
                                                  _gpsList[iSelect].bSelect = true;
                                                  setState(() {});
                                                }
                                              });
                                        },
                                      )
                                  ),
                                  //Text(item.mapTitle),
                                  const Divider(height: 1),
                                ],
                              );
                            }
                          },
                        )
                    ),
                  )
              ),

              Visibility(
                  visible: _gpsList.length<5,//_bEdit && _gpsList.length<5,
                  child: Container(
                    //margin: const EdgeInsets.only(top:10),
                    child: ButtonSingle(
                        visible: true,
                        isBottomPading: false,
                        text: "즐겨찾기 추가",
                        enable: true,
                        enableColor: Colors.green,
                        onClick: () async {
                          // if(!_bEdit) {
                          //   _session.favoriteIndex = iSelect;
                          //   _session.setNotify();
                          //   widget.onClose(true, _gpsList[iSelect]);
                          //   Navigator.pop(context);
                          // } else
                          {
                            var result = await Navigator.push(
                              context,
                              Transition(
                                  child: SelectLocation(),
                                  transitionEffect: TransitionEffect
                                      .RIGHT_TO_LEFT),
                            );
                            if (result == true) {
                              await _session.updateFavoriteGpsList(context);
                              setState(() {
                                _gpsList = [];
                                _gpsList = _session.favoriteGpsList!;
                              });
                            }
                          }
                        }
                    ),
                  ),
              ),
            ],
          ),
      ),
    );
  }

  Future <void> _reqDelete(ItemFavoriteGps item) async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/mberMap/delete.do",
      params: { "mapSn": item.mapSn },
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        showToastMessage(data['message']);
      },
    );
    await _session.updateFavoriteGpsList(context);
    setState(() {
      _gpsList = [];
      _gpsList = _session.favoriteGpsList!;
    });
  }
}

Future<void> BottomGpsSelect({
  required BuildContext context,
  required String title,
  required Function(bool bDirty, ItemFavoriteGps item) onResult}) {
  double viewHeight = MediaQuery.of(context).size.height * 0.55;
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
            title: title,
            viewHeight:viewHeight,
            onClose: (bDirty, items){
              onResult(bDirty, items);
            },
          ),
        ),
      );
    },
  );
}

void DlgGpsSelect({
  required BuildContext context,
  required String title,
  required Function(bool bDirty, ItemFavoriteGps item) onResult,
  //String? btnText = "확인",
  double? height,
  EdgeInsets? margin = const EdgeInsets.fromLTRB(5,5,5,0),
  }) {

  double sz_height = MediaQuery.of(context).size.height*0.5;
  if(height != null) {
    sz_height = height;
  }
  showDialog(
    context: context,
    barrierDismissible: true, //다이얼로그 바깥을 터치 시에 닫히도록 하는지 여부 (true: 닫힘, false: 닫히지않음)
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            insetPadding: margin!,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(0,0,0,0),
            content: Container(
              width: MediaQuery.of(context).size.width*0.94,//double.minPositive,
              height: sz_height,
              // decoration: const BoxDecoration(
              //     color: Colors.white,
              //     borderRadius:BorderRadius.only(
              //         topLeft: Radius.circular(15),
              //         topRight: Radius.circular(15)
              //     )
              // ),
              child: _ContentView(
                title: title,
                viewHeight:sz_height,
                onClose: (bDirty, items){
                  onResult(bDirty, items);
                },
              ),
            )
          )
      );
    },
  );
}