// ignore_for_file: non_constant_identifier_names, must_be_immutable, file_names, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';

class GCheckItem {
  String tag;
  String label;
  bool bSelect;

  GCheckItem({
    this.tag = "",
    this.label="",
    this.bSelect=false
  });

  static List<GCheckItem> fromMenuList(List<String> list) {
    int id = 1;
    List<GCheckItem> itemList = [];
    for (var element in list) {
      itemList.add(GCheckItem(label: element, tag:"${id++}"));
    }
    return itemList;
  }

  factory GCheckItem.fromText(String label, String tag) {
    return GCheckItem(label: label, tag: tag, bSelect: false);
  }

  static List<GCheckItem> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return GCheckItem.fromJson(data);
    }).toList();
  }

  factory GCheckItem.fromJson(Map<String, dynamic> jdata)
  {
    GCheckItem item = GCheckItem(
      label: (jdata['label'] != null)
          ? jdata['label'].toString().trim() : "",
      tag: (jdata['tag'] != null)
          ? jdata['tag'].toString().trim() : "",
    );
    return item;
  }
}

class CardGCheck extends StatefulWidget {
  final List<GCheckItem> aList;
  final String initValue;
  final String tag;
  final bool isVertical;
  final bool isUseCode;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final Function(String tag, String answerTag, String answerText) onSubmit;
  CardGCheck({
    Key? key,
    required this.aList,
    required this.initValue,
    required this.onSubmit,
    required this.tag,
    required this.isVertical,
    required this.isUseCode,
    this.decoration,
    this.padding,
  }) : super(key: key);

  @override
  _QSelSCardState createState() => _QSelSCardState();
}

class _QSelSCardState extends State<CardGCheck> {
  String answerText = "";
  String answerTag = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _setSelect(widget.initValue);
    });
  }

  void _setSelect(String itemString) {
    if(itemString.isNotEmpty) {
      List<String> items = itemString.split(",");
      for (var element in widget.aList) {
        if (itemString.contains(element.tag)) {
          element.bSelect = true;
        } else {
          element.bSelect = false;
        }
      }
    }
  }

  void _getSelect() {
    answerTag = "";
    answerText = "";
    for (var element in widget.aList) {
      if (element.bSelect) {
        if(answerTag.isNotEmpty) {
          answerTag += ",";
        }
        answerTag += element.tag;

        if(answerText.isNotEmpty) {
          answerText += ",";
        }
        answerText += element.label;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.transparent,
      decoration:  widget.decoration,
      //width: 400,
      padding: widget.padding,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: (widget.isVertical) ? Axis.vertical : Axis.horizontal,
        itemCount: widget.aList.length,
        itemBuilder: (BuildContext context, int index) {
          GCheckItem item  = widget.aList[index];
          return GestureDetector(
            onTap: () {
              item.bSelect = !item.bSelect;
              _getSelect();
              widget.onSubmit(widget.tag, answerTag, answerText);
              setState(() {});
            },
              child: Container(
                width: (widget.isVertical) ? double.infinity : 80,
                margin: (widget.isVertical)
                  ? const EdgeInsets.fromLTRB(0,0,0,10)
                  : const EdgeInsets.fromLTRB(5,0,0,0),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon((item.bSelect)
                        ? Icons.check_box : Icons.check_box_outline_blank_outlined,
                      color: (item.bSelect) ? Colors.green : Colors.black,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                      Expanded(
                          child: Text(item.label,
                            maxLines: 20,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            letterSpacing: -1.4,
                            fontSize: 14.0),
                      )),

                  ],
                ),
              )
          );
        },
      ),
    );
  }
}
