// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanBarcode extends StatefulWidget {
  final bool multiScan;
  Function(String barcode)? onClose;
  ScanBarcode({
    Key? key,
    required this.multiScan,
    this.onClose
  }) : super(key: key);

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'BARCODE');

  QRViewController? _qrvController;
  bool _flashOn = false;

  Barcode? _barCode;
  final List<String> _scanCodeList = [];

  bool bReady = false;
  @override
  void initState() {
    Future.microtask(() async {});
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
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrvController!.pauseCamera();
    } else if (Platform.isIOS) {
      _qrvController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * 0.8,
                        //margin: const EdgeInsets.all(3),
                        child: Stack(
                          children: [
                            Positioned(
                              child: Container(
                                  color: Colors.black,
                                  padding: const EdgeInsets.fromLTRB(5,44,5,5),
                                  child: _buildQrView(context)
                              ),
                            ),
                            Positioned(
                                bottom: 10,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: const [
                                      Spacer(),
                                      Text('바코드를 사각 안에 맞혀 스캔해 주세요',
                                          style: TextStyle(
                                              color: Colors.cyan,
                                              fontSize: 16)),
                                      Spacer(),
                                    ],
                                  ),
                                )
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: app_top_size_close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        _doClose();
                                      }),
                                  const Spacer(),
                                  IconButton(
                                      icon: (_flashOn)
                                          ? const Icon(
                                              Icons.flash_on,
                                              size: 20,
                                              color: Colors.yellow,
                                            )
                                          : const Icon(
                                              Icons.flash_on,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                      onPressed: () async {
                                        _doFlash();
                                      }),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                )
            )
        )
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 180.0
        : 300.0;
    //var scanArea = 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) async {
        _qrvController = controller;
        if (Platform.isAndroid) {
          await _qrvController!.resumeCamera();
          var flag = await _qrvController?.getFlashStatus();
          setState(() {
            _flashOn = (flag!);
            bReady = true;
          });
        }

        _qrvController?.scannedDataStream.listen((scanData) async {
          FlutterBeep.beep();
          _barCode = scanData;

          if (_scanCodeList.indexWhere((element) => (element == _barCode)) < 0) {
            _scanCodeList.add(_barCode!.code!);
          }

          if (!widget.multiScan) {
            await _qrvController?.pauseCamera();
            _doClose();
          } else {
            setState(() {});
            await _qrvController?.pauseCamera();
            await _qrvController?.resumeCamera();
          }
        });
      },
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 0,
          borderLength: 40,
          borderWidth: 8.0,
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
    String result = (_scanCodeList.isNotEmpty) ? _scanCodeList[0]: "";
    Navigator.pop(context, result);
    if(widget.onClose != null) {
      widget.onClose!(result);
    }
  }

  Future<void> _doFlash() async {
    await _qrvController?.toggleFlash();
    var flag = await _qrvController?.getFlashStatus();
    _flashOn = (flag!);
    setState(() {});
  }
}

Future<void> showBottomScaned({
  required BuildContext context,
  required Function(String barcode) onResult}) {
  double viewHeight = MediaQuery.of(context).size.height * 0.8;
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
          child: ScanBarcode(
            multiScan: false,
            onClose: (String barcode){
              onResult(barcode);
            },
          ),
        ),
      );
    },
  );
}
