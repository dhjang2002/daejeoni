import 'package:flutter/material.dart';

class MenuButtonRadioItem {
  String text;
  String tag;
  bool select;

  MenuButtonRadioItem({
    this.text = "",
    this.tag = "",
    this.select = false,
  });
}

class MenuButtonRadio extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final List<MenuButtonRadioItem> items;
  final Function(List<MenuButtonRadioItem> items) onChange;
  Function(MenuButtonRadioItem item)? onSelect;
  final Color? textSelColor;
  final Color? textNormColor;
  final Color? btnColor;
  final Color? borderColor;
  final double? borderWidth;
  int? crossAxisCount;
  double? childAspectRatio;
  double? borderRadius;
  double? crossAxisSpacing;

  double? fontSize;
  MenuButtonRadio({
    Key? key,
    required this.items,
    required this.onChange,
    this.onSelect,
    this.textSelColor = Colors.black,
    this.textNormColor = Colors.black,
    this.btnColor = Colors.white,
    this.borderColor = Colors.green,
    this.borderWidth = 1.0,
    this.margin = const EdgeInsets.all(5),
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.7,
    this.borderRadius = 5.0,
    this.crossAxisSpacing=5.0,
    this.fontSize=12.0,
  }) : super(key: key);

  @override
  State<MenuButtonRadio> createState() => _MenuButtonRadioState();
}

class _MenuButtonRadioState extends State<MenuButtonRadio> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.builder(
          padding: widget.margin,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount!,
            childAspectRatio: widget.childAspectRatio!,
            mainAxisSpacing: 5,
            crossAxisSpacing: widget.crossAxisSpacing!,
          ),
          itemCount: widget.items.length,
          itemBuilder: (context, int index) {
            MenuButtonRadioItem item = widget.items[index];
            return SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: GestureDetector(
                  child: Container(
                      decoration:  BoxDecoration(
                        color: (item.select) ? widget.btnColor : Colors.white,
                        borderRadius: BorderRadius.circular(widget.borderRadius!),
                        border: Border.all(
                          width: widget.borderWidth!,
                          color: (item.select) ? widget.borderColor! : const Color(0xFFC9CACF),
                        ),

                      ),
                      alignment: Alignment.center,
                      child: Center(
                          child: Text(
                            item.text,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: (item.select) ? widget.textSelColor! : widget.textNormColor!,
                              fontSize: widget.fontSize!,
                              letterSpacing: -0.8,
                            ),
                          )
                      )
                  ),
                  onTap: () {
                    for (var element in widget.items) {
                      element.select = false;
                    }
                    setState(() {
                        item.select = true;
                    });
                    if(widget.onSelect != null) {
                      widget.onSelect!(item);
                    }
                    widget.onChange(widget.items);
                  },
                )
            );
          }),
    );
  }
}
