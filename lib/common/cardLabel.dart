// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:daejeoni/constant/constant.dart';

class CardLabel extends StatelessWidget {
  final String value;
  String? imagePath;
  double? iconSize;
  TextStyle? valueStyle;
  EdgeInsetsGeometry? padding;
  CardLabel({
    Key? key,
    required this.value,
    this.imagePath = "",
    this.iconSize   = CardItemIconSize,
    this.valueStyle = ItemBkN15,
    this.padding = const EdgeInsets.fromLTRB(0, 5, 10, 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double? interval = iconSize!/2;
    return Container(
      padding: padding,
      child: Row(
        children: [
          Visibility(
            visible: (imagePath!.isNotEmpty),
            child: Image.asset(imagePath!,
                width: iconSize,
                height: iconSize,
                color: Colors.black),
          ),
          Visibility(
              visible: (imagePath!.isNotEmpty),
              child: SizedBox(width:interval)),
          Expanded(
            child: Text(value,
              style: valueStyle,
              overflow: TextOverflow.ellipsis, maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
