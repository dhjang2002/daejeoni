// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:daejeoni/common/InputForm.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';

const Color _colorGrayBack = Color(0xFFF4F4F4);

class EditViewItem {
  String tag;
  String value;
  bool isSelect;
  EditViewItem({
    this.tag = "",
    this.value = "",
    this.isSelect = false,
  });

  static List<EditViewItem> fromStoreSnapshot(List snapshot) {
    return snapshot.map((data) {
      return EditViewItem.fromStoreJson(data);
    }).toList();
  }

  factory EditViewItem.fromStoreJson(Map<String, dynamic> jdata)
  {
    return EditViewItem(
      tag: (jdata['lStoreId'] != null)
          ? jdata['lStoreId'].toString().trim() : "",
      value: (jdata['sName'] != null)
          ? jdata['sName'].toString().trim() : "",
    );
  }
}

class _EditView extends StatefulWidget {
  final String title;
  final String tag;
  final String value;
  final String? ext;
  final List<EditViewItem>? items;
  final Axis? axis;
  final Function(bool bDirty, EditViewItem item, String value, String ext) onClose;
  const _EditView({
    Key? key,
    required this.title,
    required this.tag,
    required this.value,
    required this.onClose,
    this.ext,
    this.items = const [],
    this.axis = Axis.horizontal,
  }) : super(key: key);

  @override
  State<_EditView> createState() => __EditViewState();
}

class __EditViewState extends State<_EditView> {
  bool _bDirty = false;
  String _result = "";
  String _ext = "";
  int iSelect = -1;

  late TextEditingController _controller;
  late SessionData _session;
  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);

    int index = 0;
    for (var element in widget.items!) {
      if(widget.value==element.value) {
        iSelect = index;
        break;
      }
      index++;
    }

    setState(() {

    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final szWidht = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
      backgroundColor: _colorGrayBack,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: _colorGrayBack,
        title: Text(widget.title),
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
              child:Stack(
                children: [
                  Positioned(
                    top: 0, left: 0, right: 0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 80),
                        width: 400,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible:widget.items!.isEmpty,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: InputForm(
                                        readOnly: (widget.tag=="sAddress") ? true : false,
                                        disable: false,
                                        maxLines: 1,
                                        suffixAction: (widget.tag=="sAddress") ? true : false,
                                        suffixIcon: const Icon(Icons.search),
                                        onControl: (contriller){
                                          _controller = contriller;
                                        },
                                        /*
                                        onMenu: (widget.tag=="sAddress") ? (controller) async {
                                          //print("onMenu():...............");
                                          await Navigator.push(context,
                                            Transition(
                                                child: DaumAddress(
                                                  callback: (KAddress address) {
                                                    _controller.text = address.addr;
                                                    setState(() {
                                                      _bDirty = true;
                                                    });
                                                  },
                                                ),
                                                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
                                          );
                                        }
                                        : null,
                                      */
                                        keyboardType: TextInputType.text,
                                        valueText: widget.value,
                                        hintText: widget.title,
                                        onChange: (String value) {
                                          _result = value.trim();
                                          setState((){
                                            _bDirty = true;
                                          });
                                        }, onlyDigit: false,),
                                  )
                              ),

                              Visibility(
                                  visible:widget.ext!=null,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10,5,10,10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(" 상세주소:", style: ItemG2N14,),
                                        const SizedBox(height: 5,),
                                        InputForm(
                                            maxLines: 1,
                                            keyboardType: TextInputType.text,
                                            valueText: _ext,
                                            hintText: '상세주소',
                                            onChange: (String value) {
                                              _ext = value.trim();
                                              setState(() {
                                                _bDirty = true;
                                              });
                                            }, onlyDigit: false,),
                                      ],
                                    )
                                  )
                              ),

                              Visibility(
                                visible: widget.items!.isNotEmpty,
                                child:ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  //scrollDirection: widget.axis!,
                                  itemCount: widget.items!.length,
                                  itemBuilder: (context, index){
                                    String value  = widget.items![index].value;
                                    return GestureDetector(
                                        onTap: (){
                                          setState((){
                                            _bDirty = true;
                                            iSelect = index;
                                          });
                                        },
                                        child: Container(
                                          width:szWidht,
                                          // width: (widget.axis! != Axis.horizontal)
                                          //     ? double.infinity : szWidht,
                                          padding: const EdgeInsets.fromLTRB(20,25,20,10),
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Icon((iSelect==index)
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_off_outlined,
                                                color: (iSelect==index)
                                                    ? Colors.blueAccent
                                                    : Colors.black,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                  child: Text(value,
                                                    maxLines: 3,
                                                    style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 16.0),
                                              )),
                                            ],
                                          ),
                                        )
                                    );
                                  },
                                )
                              ),
                            ],
                        )
                    ),
                  ),

                  Positioned(
                      bottom: 0,left: 0, right: 0,
                      child: Visibility(
                          visible: true,
                          child:ButtonSingle(
                              visible: true,
                              isBottomPading: true,
                              text: "저장하기",
                              enable: _bDirty,
                              onClick: () {
                                EditViewItem item = EditViewItem();
                                if(iSelect>=0) {
                                  item = widget.items![iSelect];
                                }
                                widget.onClose(true, item, _result, _ext);
                                Navigator.pop(context);
                              }
                          ),
                      )
                  ),
                ],
              )
          )
      ),
    );
  }
}

Future<void> showEditItem({
  required BuildContext context,
  required String title,
  required String tag,
  required String value,
  required String? ext,
  required List<EditViewItem>? items,
  required Function(bool bDirty, EditViewItem item, String value, String ext) onResult}) {
  double viewHeight = MediaQuery.of(context).size.height * 0.75;
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
          child: _EditView(
            title: title,
            tag: tag,
            value: value,
            ext:ext,
            items: items,
            onClose: (bDirty, item, value, ext) {
              onResult(bDirty, item, value, ext);
            },
          ),
        ),
      );
    },
  );
}