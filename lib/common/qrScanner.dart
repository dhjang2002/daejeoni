import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');


  QRViewController? _qrvController;
  Barcode? _barCode;
  String _scanCode = "";

  bool bReady = false;
  @override
  void initState() {

    Future.microtask(() async {

    });

    super.initState();
  }

  @override
  void dispose() {
    _qrvController?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrvController!.pauseCamera();
    }
    _qrvController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("QR 스캐너"),
        leading: Visibility(
          visible: false, //(curr_page_index!=modeKeyword) ? true:false,
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
            visible: true, //(curr_page_index==modeKeyword) ? true: false,
            child: IconButton(
                icon: const Icon(Icons.close, size: app_top_size_close,),
                onPressed: () async {
                  _doClose();
                }),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width*0.8,
                      //margin: EdgeInsets.only(top:10),
                      child: _buildQrView(context)
                  ),

                  Container(
                    //margin: EdgeInsets.only(top:10),
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: Text(_scanCode, style: ItemBkN16,),
                  ),
                ],
              )
          ),

          // tool bar
          /*
          Positioned(
              top:0, left:0, right: 0,
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white,),
                    onPressed: () async {
                    await _qrvController?.toggleFlash();
                    setState(() {

                    });
                  }),

                  IconButton(
                      icon: const Icon(
                        Icons.play_arrow_sharp, color: Colors.white,),
                      onPressed: () async {
                        await _qrvController?.resumeCamera();
                        setState(() {
                          _scanCode = "";
                        });
                  }),

                  IconButton(
                      icon: const Icon(Icons.pause, color: Colors.white,),
                      onPressed: () async {
                        await _qrvController?.pauseCamera();
                        setState(() {

                        });
                  }),
                ],
              )
          ),
          */
          // bottom button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ButtonSingle(
                    text: '다시 스캔',
                    enable: _scanCode.isNotEmpty,
                    visible: true,
                    enableTextColor: Colors.black,
                    disableTextColor: const Color(0xFFA9A9B1),
                    enableColor: const Color(0xFFF6C443),
                    disableColor: const Color(0xFFEEEEF0),
                    onClick: () async {
                      setState(() {
                        _scanCode = "";
                      });
                      await _qrvController?.resumeCamera();
                    },
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ButtonSingle(
                    text: '확인',
                    enable: _scanCode.isNotEmpty,
                    visible: true,
                    enableTextColor: Colors.white,
                    disableTextColor: const Color(0xFFA9A9B1),
                    enableColor: const Color(0xFF124C97),
                    disableColor: const Color(0xFFEEEEF0),
                    onClick: () {
                      _doClose();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
        ? 160.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) async {
        _qrvController = controller;
        await _qrvController?.resumeCamera();
        setState((){
          bReady = true;
        });
        _qrvController?.scannedDataStream.listen((scanData) async {

          // QR code인 경우에만 스캔중지
          if(scanData.format==BarcodeFormat.qrcode) {
            _barCode  = scanData;
            await _qrvController?.pauseCamera();
            FlutterBeep.beep();
            setState(() {
              _scanCode = _barCode!.code!;
            });
          }
        });
      },
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 0,
          borderLength: 50,
          borderWidth: 4,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void _doClose() {
    Navigator.pop(context, _scanCode);
  }

}
