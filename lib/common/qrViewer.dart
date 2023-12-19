// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:daejeoni/common/cardPhoto.dart';
import 'package:daejeoni/constant/constant.dart';

class QRViewer extends StatefulWidget {
  final String qrUrl;
  final String eventTitle;
  final bool isOwner;
  const QRViewer(
      {Key? key,
      required this.qrUrl,
      required this.eventTitle,
      required this.isOwner})
      : super(key: key);

  @override
  State<QRViewer> createState() => _QRViewerState();
}

class _QRViewerState extends State<QRViewer> {
  //String eventTitle = "[2021 핸드메이드페어 (윈터)]";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR"),
        leading: Visibility(
          visible: false,
          child: IconButton(
              icon: Image.asset(
                "assets/icon/top_back.png",
                height: app_top_size_back,
                fit: BoxFit.fitHeight,
                color: Colors.black,
              ),
              onPressed: () {}),
        ),
        actions: [
          Visibility(
            visible: true, //(curr_pageIndex_index==modeKeyword) ? true: false,
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final double qsize = MediaQuery.of(context).size.width*0.48;
    final double vsize = MediaQuery.of(context).size.width*0.85;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            //color: Colors.grey,
            height: vsize,
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: Column(
              children: [
                Container(
                  width: qsize,
                  height: qsize,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    //color: Colors.amber,
                    border: Border.all(
                      color: Colors.amber,
                      width: 1,
                    ),
                  ),
                  child: CardPhoto(photoUrl: widget.qrUrl),
                ),

                Visibility(
                  visible: widget.isOwner,
                  child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.eventTitle, style: ItemBkN16),
                              const Text(
                                " 호스트로부터",
                                style: ItemG1N16,
                              )
                            ],
                          ),
                          const Text(
                            "QR 스캔 권한을 위임받은 사용자입니다.",
                            style: ItemG1N16,
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
