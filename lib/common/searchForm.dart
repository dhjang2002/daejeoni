// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SearchForm extends StatefulWidget {
  final Function(String value) onChange;
  final Function(String value) onSummit;
  final Function(TextEditingController controller) onCreated;
  final String? hintText;
  final String? valueText;
  final Color? background;
  final String? title;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? readOnly;
  final bool? suffixAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  const SearchForm({
    Key? key,
    required this.onSummit,
    required this.onChange,
    required this.onCreated,
    this.hintText = "",
    this.valueText = "",
    this.suffixAction,
    this.title = "",
    this.background = Colors.white,
    this.prefixIcon = const Icon(Icons.search_outlined),
    this.suffixIcon,
    this.textInputAction = TextInputAction.search,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,

  }) : super(key: key);

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  TextEditingController tController = TextEditingController();

  @override
  void initState() {
    tController.text = widget.valueText!;
    widget.onCreated(tController);

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
        children: [
          Visibility(
            visible: (widget.title!.isNotEmpty) ? true : false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Text(widget.title!,
                  style: const TextStyle(fontSize: 20, color: Colors.black)),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: tController,
              readOnly: widget.readOnly!,
              obscureText: widget.obscureText!,
              maxLines: 1,
              cursorColor: Colors.black,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: (widget.readOnly!) ? const Color(0xFFFEFEFE) : Colors.white,
                contentPadding: const EdgeInsets.fromLTRB(15, 18, 10, 10),
                isDense: true,
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                    fontSize: 18,
                    color: Color(0xffc0c0c0),
                    fontWeight: FontWeight.normal),
                prefixIcon: widget.prefixIcon,

                // suffixIcon: (widget.suffixAction!)
                //     ? IconButton(
                //         onPressed: () => widget.onMenu(tController),
                //         icon: const Icon(Icons.arrow_forward_ios,
                //             size: 20, color: Colors.grey))
                //     : Container(
                //   padding: const EdgeInsets.only(top:12),
                //         child:widget.suffixIcon),

                //suffixIconColor: Colors.black,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 1, color: Color(0xFFC9CACF)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 1, color: Color(0xFFC9CACF)),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              onChanged: (String value) {
                  widget.onChange(value);
              },
              onSubmitted: (String value) {
                widget.onSummit(value);
              }
            ),
          ),
    ]);
  }
}
