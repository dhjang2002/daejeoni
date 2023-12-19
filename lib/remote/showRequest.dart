// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ShowRequest extends StatefulWidget {
  final String message;
  final String request;
  final String response;

  const ShowRequest({
    Key? key,
    required this.message,
    required this.request,
    required this.response
  }) : super(key: key);

  @override
  State<ShowRequest> createState() => _ShowRequestState();
}

class _ShowRequestState extends State<ShowRequest> {
  TextEditingController reqController = TextEditingController();
  TextEditingController repController = TextEditingController();

  @override
  void initState() {
    reqController.text = widget.request;
    repController.text = widget.response;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    reqController.dispose();
    repController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("메시지 뷰어"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top:10, bottom: 5),
              child: Text(widget.message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),

            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
                child: TextField(
                  controller: reqController,
                  readOnly:true,
                  autofocus: false,
                  maxLength: null,
                  maxLines: null,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10,bottom: 5),
              child: const Text("Response", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: TextField(
                  controller: repController,
                  readOnly:true,
                  autofocus: false,
                  maxLength: null,
                  maxLines: null,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
