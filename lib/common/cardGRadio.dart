// ignore_for_file: non_constant_identifier_names, must_be_immutable, file_names, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';

class GRadioItem {
  String tag;
  String label;
  bool bSelect;

  GRadioItem({
    this.tag = "",
    this.label="",
    this.bSelect=false
  });

  static List<GRadioItem> fromMenuList(List<String> list) {
    int id = 1;
    List<GRadioItem> itemList = [];
    for (var element in list) {
      itemList.add(GRadioItem(label: element, tag:"${id++}"));
    }
    return itemList;
  }

  factory GRadioItem.fromText(String label, String tag) {
    return GRadioItem(label: label, tag: tag, bSelect: false);
  }

  static List<GRadioItem> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return GRadioItem.fromJson(data);
    }).toList();
  }

  factory GRadioItem.fromJson(Map<String, dynamic> jdata)
  {
    GRadioItem item = GRadioItem(
      label: (jdata['label'] != null)
          ? jdata['label'].toString().trim() : "",
      tag: (jdata['tag'] != null)
          ? jdata['tag'].toString().trim() : "",
    );
    return item;
  }
}

class CardGRadio extends StatefulWidget {
  final List<GRadioItem> aList;
  final String initValue;
  final String tag;
  final bool isVertical;
  final bool isUseCode;
  final Function(String tag, String answerTag, String answerText) onSubmit;
  CardGRadio({
    Key? key,
    required this.aList,
    required this.initValue,
    required this.onSubmit,
    required this.tag,
    required this.isVertical,
    required this.isUseCode,
  }) : super(key: key);

  @override
  _QSelSCardState createState() => _QSelSCardState();
}

class _QSelSCardState extends State<CardGRadio> {
  String answerText = "";
  String answerTag = "";
  int    iSelect = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      iSelect = _getInitIndex();
      if(iSelect>=0) {
        answerTag  = widget.aList[iSelect].tag;
        answerText = widget.aList[iSelect].label;
      }
    });
  }

  int _getInitIndex() {
    for (int n = 0; n < widget.aList.length; n++) {
      if (widget.aList[n].label == widget.initValue ||
          widget.aList[n].tag == widget.initValue) {
        return n;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      //width: 400,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: (widget.isVertical) ? Axis.vertical : Axis.horizontal,
        itemCount: widget.aList.length,
        itemBuilder: (BuildContext context, int index) {
          String value  = widget.aList[index].label;
          return GestureDetector(
            onTap: () {
              iSelect = index;
              answerText = widget.aList[index].label;
              answerTag = widget.aList[index].tag;
              widget.onSubmit(widget.tag, answerTag, answerText);
              setState(() {});
            },
              child: Container(
                width: (widget.isVertical) ? double.infinity : 80,
                margin: (widget.isVertical)
                  ? const EdgeInsets.fromLTRB(0,5,0,5)
                  : const EdgeInsets.fromLTRB(0,0,5,0),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon((iSelect==index)
                        ? Icons.radio_button_checked : Icons.radio_button_off_outlined,
                      color: (iSelect==index) ? Colors.blueAccent : Colors.black,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                      Expanded(
                          child: Text(value,
                            maxLines: 20,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            letterSpacing: -1.5,
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
