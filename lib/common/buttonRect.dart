// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print

import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';

class ButtonRect extends StatelessWidget {
  final String text;
  final Function() onClick;
  final bool?  visible;
  final bool?  enable;
  final Color? textColor;
  final Color? enableColor;
  final Color? disableColor;
  const ButtonRect({
    Key? key,
    required this.text,
    required this.onClick,
    this.visible = true,
    this.enable = true,
    this.textColor = Colors.white,
    this.enableColor  = ColorB0,
    this.disableColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = (enable!) ? Colors.white : Color(0xFFA3A2AB);
    return Visibility(
      visible: visible!,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          child: Container(
            width: double.infinity,
            //margin: const EdgeInsets.fromLTRB(15,0,15,0),
            padding: const EdgeInsets.fromLTRB(0,20,0,20),
            child: Center(
                child:Text(text,
                    style: TextStyle(color:(enable!) ? Colors.white : Colors.grey,
                        fontSize:18.0, fontWeight: FontWeight.bold))),
            decoration:  BoxDecoration(
                color: (enable!) ? Color(0xFF003C8B) : Color(0xFFEEEEF0),
                borderRadius: BorderRadius.circular(0.0),
                border: Border.all(
                  width: 1,
                  color: Color(0xFFC9CACF),
                ),
            ),
          ),
          onTap: (){
                  if(enable!) {
                    onClick();
                  }
          },
        ),
      ),
    );
  }
}
