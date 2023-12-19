// ignore_for_file: non_constant_identifier_names
import 'dart:math';

import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:table_calendar/table_calendar.dart';

class _ContentView extends StatefulWidget {
  final String title;
  final DateTime date;
  final bool useDay;
  final Function(DateTime date) onClose;
  const _ContentView({
    Key? key,
    required this.title,
    required this.date,
    required this.useDay,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {
  List<String> yearList = [];
  List<String> monthList = [];

  final CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime? _focusedDay;
  DateTime? _selectedDay;
  DateTime? _firstDay;
  DateTime? _lastDay;

  late int year;
  late int month;
  @override
  void initState() {
    year  = widget.date.year;
    month = widget.date.month;
    _firstDay = DateTime.utc(widget.date.year, widget.date.month, 1);
    _lastDay = DateTime.utc(widget.date.year, widget.date.month, 31);

    _selectedDay = widget.date;
    _focusedDay = widget.date;

    int currYear = DateTime.now().year;
    for (int y = currYear - 100; y <= currYear; y++) {
      yearList.add(toZeroString(y));
    }

    for (int m = 1; m <= 12; m++) {
      if (m < 10) {
        monthList.add(toZeroString(m));
      } else {
        monthList.add(toZeroString(m));
      }
    }

    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
                icon: const Icon(Icons.close, size: app_top_size_close,),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
      body: GestureDetector(
          onTap: () async { FocusScope.of(context).unfocus();},
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        //color: Colors.amber,
                        child: Column(
                          children: [
                            // header
                            Container(
                              margin: EdgeInsets.only(bottom:10),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 120,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          isExpanded: false,
                                          items: yearList
                                              .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                              .toList(),
                                          value: toZeroString(year),
                                          buttonStyleData: ButtonStyleData(
                                            height: 40,
                                            width: 100,
                                            padding:
                                            const EdgeInsets.only(left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              color: Colors.white,
                                            ),
                                            elevation: 0,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 320,
                                            width: 140,
                                            padding: null,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.white,
                                            ),
                                            elevation: 8,
                                            offset: const Offset(0, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness:
                                              MaterialStateProperty.all<double>(6),
                                              thumbVisibility:
                                              MaterialStateProperty.all<bool>(true),
                                            ),
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(left: 14, right: 14),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              year = int.parse(value.toString());
                                              _firstDay = DateTime.utc(year, month, 1);
                                              _lastDay = DateTime(year, month + 1, 1).subtract(Duration(days: 1));
                                              _selectedDay = _firstDay;
                                              _focusedDay  = _firstDay;
                                            });
                                          },
                                        ),
                                      )),
                                  Container(
                                    padding: const EdgeInsets.only(left:10, right: 10),
                                    child: const Text("-", style: ItemBkB18,),
                                  ),
                                  SizedBox(
                                      width: 100,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          isExpanded: false,
                                          items: monthList
                                              .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                              .toList(),
                                          value: toZeroString(month),
                                          buttonStyleData: ButtonStyleData(
                                            height: 40,
                                            width: 100,
                                            padding:
                                            const EdgeInsets.only(left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              color: Colors.white,
                                            ),
                                            elevation: 0,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 320,
                                            width: 140,
                                            padding: null,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.white,
                                            ),
                                            elevation: 8,
                                            offset: const Offset(0, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness:
                                              MaterialStateProperty.all<double>(6),
                                              thumbVisibility:
                                              MaterialStateProperty.all<bool>(true),
                                            ),
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(left: 14, right: 14),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              month = int.parse(value.toString());
                                              _firstDay = DateTime.utc(year, month, 1);
                                              _lastDay = DateTime(year, month + 1, 1).subtract(Duration(days: 1));
                                              _selectedDay = _firstDay;
                                              _focusedDay  = _firstDay;
                                            });
                                          },
                                        ),
                                      )),
                                ],
                              ),
                            ),

                            //SizedBox(height: 200,),
                            // calendar
                            Container(
                              child: Stack(
                                children: [
                                  Positioned(
                                      child: Opacity(
                                        opacity: (widget.useDay) ? 1.0 : 0.2,
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(5,10,5,10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child: TableCalendar(
                                            locale: 'ko-KR',
                                            headerVisible: true,
                                            rowHeight: 32,
                                            firstDay: _firstDay!,
                                            lastDay: _lastDay!,
                                            focusedDay: _focusedDay!,
                                            calendarFormat: _calendarFormat,
                                            calendarStyle: CalendarStyle(
                                              defaultTextStyle: ItemBkB15,
                                              outsideDaysVisible: false,
                                              weekendTextStyle: ItemR1B15,
                                              holidayTextStyle: const TextStyle()
                                                  .copyWith(color: Colors.blue[800]),
                                              selectedDecoration: const BoxDecoration(
                                                  color: Color(0xFF1A4C97),
                                                  shape: BoxShape.circle),
                                              todayTextStyle: ItemBkB15,
                                            ),
                                            headerStyle: const HeaderStyle(
                                              titleCentered: true,
                                              formatButtonVisible: false,
                                              leftChevronIcon: Icon(Icons.arrow_left),
                                              rightChevronIcon: Icon(Icons.arrow_right),
                                              titleTextStyle: TextStyle(fontSize: 18.0),
                                            ),
                                            selectedDayPredicate: (day) {
                                              return isSameDay(_selectedDay, day);
                                            },
                                            onDaySelected: (selectedDay, focusedDay) {
                                              setState(() {
                                                _selectedDay = selectedDay;
                                                _focusedDay = focusedDay;
                                              });
                                              //_validate();
                                            },
                                            onPageChanged: (DateTime focusedDay) {
                                              // year  = widget.date.year;
                                              // month = widget.date.month;
                                              // setState(() {});
                                            },
                                          ),
                                        ),
                                      )
                                  ),

                                  Positioned(
                                      child: Visibility(
                                        visible: !widget.useDay,
                                        child: Container(
                                          width: double.infinity,
                                          height: 300, //double.infinity,
                                          color: Colors.transparent,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    )
                ),
                ButtonSingle(
                    visible: true,
                    isBottomPading: false,
                    text: "확인",
                    enable: true,
                    onClick: () {
                      widget.onClose(_selectedDay!);
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
      ),
    );
  }
}

Future<void> showSelectMonth(
    {required BuildContext context,
    required String title,
    required DateTime date,
    required bool useDay,
    required Function(DateTime date) onResult}) {
  double viewHeight = max(450.0, MediaQuery.of(context).size.height * 0.65);
  //double viewWidth  = viewHeight/2;
  //450;//MediaQuery.of(context).size.height * 0.75;
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
          //width: viewWidth,
          height: viewHeight,
          child: _ContentView(
            title: title,
            date: date,
            useDay: useDay,
            onClose: (date) {
              onResult(date);
            },
          ),
        ),
      );
    },
  );
}
