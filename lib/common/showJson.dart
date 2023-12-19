// ignore_for_file: file_names

import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';

class ShowJson extends StatelessWidget {
  final dynamic json;
  const ShowJson({Key? key, this.json}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String jText = "";
    if(json != null) {
      jText = json.toString();
      jText = jText.replaceAll(",", "\n");
      //jText = jText.replaceAll("{", "{\n");
      jText = jText.replaceAll(": {", ":{\n");
      jText = jText.replaceAll("[", "{\n");
      jText = jText.replaceAll("]", "\n]");
      jText = jText.replaceAll("}", "\n}");
    }

    return Visibility(
        visible: (jText.length>3),
        child: Container(
          height: 400,
          color: Colors.grey[100],
          padding: const EdgeInsets.fromLTRB(10,10,10,20),
          child: SingleChildScrollView(
            child: Text(jText, style: ItemBkN20),
          ),
        )
    );
  }
}

class ShowJsonEdit extends StatefulWidget {
  final dynamic json;
  const ShowJsonEdit({
    Key? key,
    required this.json
  }) : super(key: key);

  @override
  State<ShowJsonEdit> createState() => _ShowJsonEditState();
}
class _ShowJsonEditState extends State<ShowJsonEdit> {
  TextEditingController reqController = TextEditingController();

  @override
  void initState() {
    String jText = "";
    if(widget.json != null) {
      jText = widget.json.toString();
      jText = jText.replaceAll(",", "\n");
      jText = jText.replaceAll("{", "{\n");
      jText = jText.replaceAll("[", "{\n");
      jText = jText.replaceAll("]", "\n]");
      jText = jText.replaceAll("}", "\n}");
    }

    reqController.text = jText;
    super.initState();
  }

  @override
  void dispose() {
    reqController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (widget.json != null),
      child: Container(
        height: 400,
        color: Colors.amber,
        margin: const EdgeInsets.fromLTRB(10,0,10,0),
        child: SingleChildScrollView(
            child: TextField(
              controller: reqController,
              readOnly:true,
              autofocus: false,
              maxLength: null,
              maxLines: null,
              style: ItemBkN20,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
              ),
            ),
        ),
      )
    );
  }
}
