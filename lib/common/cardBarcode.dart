import 'dart:io';
import 'dart:typed_data';
import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardBarcode extends StatefulWidget {
  final Uint8List? barcodeData;
  const CardBarcode({
    Key? key,
    required this.barcodeData,
  }) : super(key: key);

  @override
  State<CardBarcode> createState() => _CardBarcodeState();
}

class _CardBarcodeState extends State<CardBarcode> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.barcodeData==null) {
      return Container();
    }
    return Container(
      child: SvgPicture.memory(widget.barcodeData!,
      fit: BoxFit.fitHeight,),
    );
  }
}

Uint8List? createBarcodeData(String sBarcode) {
  Uint8List? barcodeData;
  barcodeData = convertStringToUint8List(
      makeBarcodeData(
        Barcode.code128(),
        sBarcode,)
  );
  return barcodeData;
}

String createBarcodeFile(
    Barcode bc,
    String data, {
      String? filename,
      double? width,
      double? height,
      double? fontHeight,
    }) {

  final svg = bc.toSvg(
    data,
    width: width ?? 200,
    height: height ?? 80,
    fontHeight: fontHeight,
  );

  // Save the image
  filename ??= bc.name.replaceAll(RegExp(r'\s'), '-').toLowerCase();
  File file = File('$filename.svg');
  file.writeAsStringSync(svg);
  return file.path;
}

String makeBarcodeData(
    Barcode bc,
    String data, {
      String? filename,
      double? width,
      double? height,
      double? fontHeight,
    }) {

  /// Create the Barcode
  String svgBarcode = bc.toSvgBytes(
      convertStringToUint8List(data)
  );
  return svgBarcode;
}

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);
  return unit8List;
}