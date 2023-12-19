// ignore_for_file: file_names

import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final Function (String value) onChange;
  final Function (String value) onVerify;
  Function (TextEditingController controller)? onContriller;
  final bool isVerify;
  final String hintText;
  final String valueText;
  final Color? background;
  final Widget? prefixIcon;
  final String? btnText;
  final String title;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? readOnly;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final TextStyle? hintStyle;
  InputField({
    Key? key,
    required this.onChange,
    required this.onVerify,
    required this.isVerify,
    required this.hintText,
    required this.valueText,
    this.onContriller,
    this.title = "",
    this.background = Colors.white,
    this.prefixIcon,
    this.btnText = "중복검사",
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.titleStyle = const TextStyle(fontSize: 18, color: Colors.black),
    this.valueStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
    this.hintStyle = const TextStyle(fontSize: 18,  color: Color(0xffc0c0c0), fontWeight: FontWeight.normal),
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController tController = TextEditingController();

  @override
  void initState() {
    tController.text = widget.valueText;
    if(widget.onContriller != null) {
      widget.onContriller!(tController);
    }
    super.initState();
  }

  @override
  void dispose() {
    tController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Visibility(
            visible: (widget.title.isNotEmpty) ? true: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Text(widget.title, style: widget.titleStyle),
            ),
          ),
          SizedBox(
            width: double.infinity,
            //padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextField(
              controller: tController,
              readOnly: widget.readOnly!,
              obscureText:widget.obscureText!,
              maxLines: 1,
              cursorColor: Colors.black,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              style: widget.valueStyle,
              decoration: InputDecoration(
                filled: true,
                fillColor: (widget.readOnly!) ? const Color(0xFFEEEEF0): Colors.white,
                contentPadding: const EdgeInsets.fromLTRB(15,18,20,10),
                isDense: true,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle,
                prefixIcon: widget.prefixIcon,
                focusedBorder: const OutlineInputBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide(width: 1, color: Color(0xFFC9CACF)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide(width: 1, color: Color(0xFFC9CACF)),
                ),
                border: const OutlineInputBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(0)),
                ),
              ),
              onChanged: (String value){
                widget.onChange(value);
              },
            ),
          ),
          Visibility(
            visible: widget.isVerify,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: ColorB0,
                      //padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0))),
                  child: Text(
                    widget.btnText!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    widget.onVerify(tController.text.trim());
                  },
                ),
              )
          )
        ]
    );
  }
}
