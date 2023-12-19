
// ignore_for_file: file_names, must_be_immutable
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  String title;
  Event(this.title);
  @override
  String toString() => title;
}

class CalendarDaySelect extends StatefulWidget {
  final String seletedDay;
  const CalendarDaySelect({
    Key? key,
    required this.seletedDay,
  }) : super(key: key);

  @override
  State<CalendarDaySelect> createState() => _CalendarDaySelectState();
}

class _CalendarDaySelectState extends State<CalendarDaySelect> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _today = DateTime.now();
  DateTime  _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _bDirty = false;
  bool _btnEnable = false;
  String _dateText = "";

  @override
  void initState() {
    if(widget.seletedDay.isNotEmpty) {
      String dateString = widget.seletedDay;
      if(widget.seletedDay.length==8) {
        dateString = "${widget.seletedDay.substring(0,4)}"
            "-${widget.seletedDay.substring(4,6)}"
            "-${widget.seletedDay.substring(6,8)}";
      }
      _selectedDay = DateFormat('yyyy-MM-dd').parse(dateString);
      //print("------->${_selectedDay.toString()}");
      _focusedDay = _selectedDay!;
    } else {
      _selectedDay = _today;
    }
    setState((){});
    // Future.microtask(() {
    // });
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
        title: const Text("날짜 선택"),
        automaticallyImplyLeading: false,
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: app_top_size_close,
                ),
                onPressed: () async {
                  _doClose();
                }),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: Stack(
        children: [
          // content
          Positioned(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left:0, right: 0, top: 0),
                    child: TableCalendar(
                      locale: 'ko-KR',
                      rowHeight:55,
                      firstDay: DateTime.utc(
                          _today.year-80,
                          _today.month,
                          _today.day),
                      lastDay: _today,
                      focusedDay: _focusedDay,
                      headerVisible: true,
                      calendarFormat: _calendarFormat,
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: ItemBkB24,
                        outsideDaysVisible: false,
                        weekendTextStyle: ItemBkB24,
                        holidayTextStyle: const TextStyle().copyWith(
                            color: Colors.blue[800]),
                        selectedDecoration : const BoxDecoration(
                            color: Color(0xFF1A4C97),
                            shape: BoxShape.circle),
                        todayTextStyle: ItemBkB18,
                      ),

                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        leftChevronIcon: Icon(Icons.arrow_left),
                        rightChevronIcon:Icon(Icons.arrow_right),
                        titleTextStyle: TextStyle(fontSize: 18.0),
                      ),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _bDirty = true;
                          _selectedDay = selectedDay;
                          _focusedDay  = focusedDay;
                          _dateText = DateFormat('yyyy-MM-dd').format(_selectedDay!);
                        });
                        _validate();
                      },
                      onPageChanged: (DateTime focusedDay) {
                        _focusedDay = focusedDay;
                        //print("onPageChanged()>>>>> ${focusedDay.toString()}");
                      },
                      enabledDayPredicate: _getEnableDay,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ButtonSingle(
                    text: '확인',
                    enable: _btnEnable,
                    visible: true,
                    isBottomPading: true,
                    //isBottomSide: true,
                    onClick: () {
                      Navigator.pop(context, _dateText);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _validate() {
    setState((){
      _btnEnable = (_bDirty && _dateText.isNotEmpty);
    });
  }

  bool _getEnableDay(DateTime day) {
    return true;
  }

  void _doClose() {
    Navigator.pop(context, "");
  }
}
