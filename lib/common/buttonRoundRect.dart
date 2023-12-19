// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print

import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';

class ButtonRoundRect extends StatelessWidget {
  final Widget? icon;
  final String text;
  final Function() onClick;
  final bool?  visible;
  final bool?  enable;
  final Color? textColor;
  final Color? disableTextColor;
  final Color? backgroundColor;
  final Color? disableColor;
  final Color? borderColor;
  final Color? disableBorderColor;
  final double radious;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final double? iconGap;
  const ButtonRoundRect({
    Key? key,
    required this.text,
    required this.onClick,
    this.icon,
    this.visible = true,
    this.enable = true,
    this.textColor = Colors.white,
    this.disableTextColor = Colors.white,
    this.backgroundColor  = ColorB0,
    this.borderColor  = ColorB0,
    this.disableColor = Colors.grey,
    this.disableBorderColor = Colors.grey,
    this.radious = 15.0,
    this.padding = const EdgeInsets.fromLTRB(0,20,0,20),
    this.fontSize = 16,
    this.iconGap = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Color textColor = (enable!) ? Colors.white : Color(0xFFA3A2AB);
    return Visibility(
      visible: visible!,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          child: Container(
            width: double.infinity,
            padding: padding,
            child: Center(
                child:Row(
                  children: [
                    Spacer(),
                    (icon != null) ? icon! : Container(),
                    (icon != null) ? SizedBox(width: iconGap) : SizedBox(width: 0),
                    Text(
                        text,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: TextStyle(
                            color:(enable!) ? textColor : disableTextColor,
                            fontSize:fontSize,
                            fontWeight: FontWeight.normal)
                    ),
                    Spacer(),
                  ],
                )
            ),
            decoration:  BoxDecoration(
                color: (enable!) ? backgroundColor : disableColor,
                borderRadius: BorderRadius.circular(radious),
                border: Border.all(
                  width: 1,
                  color: (enable!) ? borderColor! : disableBorderColor!,
                ),
            ),
          ),
          onTap: () {
            if(enable!) {
              onClick();
            }
          },
        ),
      ),
    );
  }
}
