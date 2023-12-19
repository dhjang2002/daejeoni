// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:daejeoni/constant/constant.dart';

class MenuFloating extends StatefulWidget {
  final double viewHeight;
  final Widget child;
  final Widget icon;
  final List<String> items;
  final Function(int index, String value) onItemSelection;
  final Widget? title;
  final Color? btnColor;
  final bool? barrierDismissible;
  final Color? dissBackgrond;
  final Widget? homeIcon;
  final Function()? onHomeTab;
  final double? offsetX;
  final double? offsetY;
  const MenuFloating(
      {Key? key,
        required this.child,
        required this.viewHeight,
        required this.icon,
        required this.items,
        required this.onItemSelection,
        this.title,
        this.btnColor = ColorB3,
        this.barrierDismissible = true,
        this.dissBackgrond = const Color(0x1F000000),

        this.homeIcon,
        this.onHomeTab,
        this.offsetX = 15,
        this.offsetY = 20,
      })
      : super(key: key);

  @override
  State<MenuFloating> createState() => _MenuFloatingState();
}

class _MenuFloatingState extends State<MenuFloating> {
  bool _bIsOpenState = false;
  double _infoHeight = 0;
  //double _infoMaxHeight = 180;

  @override
  Widget build(BuildContext context) {
    final bool useTitle = (widget.title != null);
    final bool useHome = (widget.homeIcon != null);
    return Stack(
      children: [
        Positioned(child: widget.child),
        Positioned(
            child: GestureDetector(
              onTap: () {
                if(widget.barrierDismissible!) {
                  if (_bIsOpenState) {
                    setState(() {
                      _bIsOpenState = false;
                      _infoHeight = 0;
                    });
                  }
                }
              },
              child: Container(
              color: (_bIsOpenState) ? widget.dissBackgrond : null,
              ),
            )
        ),
        Positioned(
            right: widget.offsetX!,
            bottom: widget.offsetY!+70,
            child: SizedBox(
              width: 64,
              height: 64,
              //color: Colors.white,
              child: Center(
                child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    child: (useHome) ? widget.homeIcon : null,
                    onPressed: () {
                      if(useHome) {
                        widget.onHomeTab!();
                      }
                    }),
              ),
            )),
        Positioned(
            right: widget.offsetX!-10,
            bottom: widget.offsetY!+80,
            child: Visibility(
              visible: true,//_bIsOpenState,
              child: AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: 170,
                  height: _infoHeight,
                  decoration: (_bIsOpenState ) ? BoxDecoration(
                    border: Border.all(
                      color: //Colors.white,
                        Colors.grey.shade100,
                    ),
                    color: (useTitle) ? Colors.grey[200] : Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ) : null,
                  child: Container(
                    margin:(useTitle) ? const EdgeInsets.all(10) : const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: (useTitle),
                            child: (useTitle)?widget.title! : Container()),
                        Expanded(
                          child: ListView.builder(
                            padding: (useTitle) ? const EdgeInsets.all(0) :const EdgeInsets.all(10),
                              itemCount: widget.items.length,
                              itemBuilder: (context, index) {
                                return Material(
                                  child: InkWell(
                                    onTap: (){
                                      widget.onItemSelection(index, widget.items[index]);
                                      _closeMenu();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFFD8D8D8),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: ListTile(
                                        title: Text(widget.items[index]),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
        Positioned(
            right: widget.offsetX,
            bottom: widget.offsetY,
            child: SizedBox(
              width: 64,
              height: 64,
              //color: Colors.white,
              child: Center(
                child: FloatingActionButton(
                    backgroundColor: (_bIsOpenState)? Colors.white : widget.btnColor,
                    child: (_bIsOpenState)
                        ? const Icon(Icons.close, color: Colors.black,size: 28,)
                        : widget.icon,
                    onPressed: () {
                      setState(() {
                        _bIsOpenState = !_bIsOpenState;
                        if(_bIsOpenState) {
                          _infoHeight = widget.viewHeight;
                        } else {
                          _infoHeight = 0;
                        }
                      });
                }),
              ),
            )),
      ],
    );
  }

  void _closeMenu() {
    setState((){
      _infoHeight = 0;
      Future.microtask(() {
        setState((){
          _bIsOpenState = false;
        });
      });
    });
  }
}
