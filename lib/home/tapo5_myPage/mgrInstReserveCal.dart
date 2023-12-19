// ignore_for_file: file_names, non_constant_identifier_names

import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tapo5_myPage/popInstRegInfo.dart';
import 'package:daejeoni/models/ItemInstReserve.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class _Meeting {
  /// Creates a meeting class with required details.
  _Meeting({
    required this.eventName,
    required this.from,
    required this.to,
    this.background = Colors.amber,
    this.isAllDay = false,
    this.oid = ""
  });

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  String oid;
  // From which is equivalent to start time property of [Appointment].
  DateTime from;

  // To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;

  @override
  String toString() {
    return "eventName:$eventName, [$oid]";
  }
}

class _MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  _MeetingDataSource(List<_Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _get_MeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _get_MeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _get_MeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _get_MeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _get_MeetingData(index).isAllDay;
  }

  _Meeting _get_MeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final _Meeting meetingData;
    if (meeting is _Meeting) {
      meetingData = meeting;
    }
    return meetingData;
  }

  String getOid(int index) {
    return _get_MeetingData(index).oid;
  }
}

class MgrInstReserveCal extends StatefulWidget {
  const MgrInstReserveCal({Key? key}) : super(key: key);

  @override
  State<MgrInstReserveCal> createState() => _MgrInstReserveCalState();
}

class _MgrInstReserveCalState extends State<MgrInstReserveCal> {
  List<ItemInstReserve> _itemList = [];
  late SessionData _session;
  bool _bready = false;
  DateTime today = DateTime.now();
  String   month = "";

  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    Future.microtask(() async {
      month = DateFormat('yyyy-MM').format(today);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("기관 신청현황"),
        leading: Visibility(
          visible: true,
          child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 26,),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        actions: [
          // 새로고침
          Visibility(
            visible: true,
            child: IconButton(
                icon: const Icon(Icons.refresh_outlined, size: app_top_size_refresh,),
                onPressed: () async {
                  await _reqSelect();
                }),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Positioned(
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 20),
                    child: const Text("◼︎ 기관예약 신청현황", style: ItemBkB16,),
                  ),
                  Expanded(
                    child: SfCalendar(
                      view: CalendarView.month,
                      showDatePickerButton:true,
                      //todayHighlightColor: kPrimaryColor,
                      allowDragAndDrop: false,
                      showNavigationArrow:true,
                      //allowViewNavigation: true,
                      //initialSelectedDate:null,
                      viewNavigationMode: ViewNavigationMode.none,
                        blackoutDates: const <DateTime>[
                          // DateTime.now().add(Duration(days: 2)),
                          // DateTime.now().add(Duration(days: 3)),
                          // DateTime.now().add(Duration(days: 6)),
                          // DateTime.now().add(Duration(days: 7))
                        ],

                      blackoutDatesTextStyle: const TextStyle(
                        //fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.pink
                      ),

                      dataSource: _MeetingDataSource(_getDataSource()),
                      monthViewSettings: const MonthViewSettings(
                        showAgenda: true,
                        dayFormat: 'EEE',
                        showTrailingAndLeadingDates:false,
                        appointmentDisplayCount: 5, // 보여줄 일정 개수 설정
                        appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                        agendaStyle: AgendaStyle(
                          appointmentTextStyle: TextStyle(
                            color: Colors.white, // 일정 텍스트 스타일
                            fontSize: 12,
                              letterSpacing: -1.2
                          ),
                        ),
                      ),
                      // onSelectionChanged:(CalendarSelectionDetails data) {
                      //   //print("onSelectionChanged()::${data.date.toString()}");
                      //   _showInfo(data.date!);
                      // },
                      onViewChanged:(ViewChangedDetails info) async {
                        //print(info.visibleDates.toString());
                        month = DateFormat('yyyy-MM').format(info.visibleDates[0]);
                        await _reqSelect();
                        setState(() {
                          _bready = true;
                        });
                      },
                      onTap: (CalendarTapDetails details) {
                        if (details.targetElement == CalendarElement.appointment
                            //|| details.targetElement == CalendarElement.calendarCell
                        ) {
                          //_showInfo(details.date!);
                          // _Meeting meet = details.appointments!.first;
                          // print(details.appointments.toString());
                          // print(meet.oid);
                          _showInfoSn(details.appointments!.first.oid);
                          // handleAgendaViewTap(details); // AgendaView의 터치 이벤트 처리
                        }
                      },

                      onLongPress: (data) {},
                      // onTap: (CalendarTapDetails data) {
                      //   //print("onSelectionChanged()::${data.date.toString()}");
                      //   _showInfo(data.date!);
                      // },
                  ),),
                ],
              ),
            )
        ),
        Positioned(
            child: Visibility(
              visible: _bready && _itemList.isEmpty,
              child: Center(
                child: Container(
                  //margin: EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  width: 340,
                  height: 140,
                  color: Colors.amber,
                  alignment: Alignment.center,
                  child: const Text("신청 내역이 없습니다.", style: ItemBkN16,),
                ),
              ),
            )
        ),
      ],
    );
  }

  final List<_Meeting> meetings = <_Meeting>[];
  List<_Meeting> _getDataSource() {
    return meetings;
  }

  void _showInfoDay(DateTime day) {
    String selDay = day.toString().substring(0,10);
    List<ItemInstReserve> items = [];
    //ItemInstReserve? info;
    for (var element in _itemList) {
      if(element.insttResveDt==selDay) {
        //print("${element.insttResveChildNm} : ${element.type()}");
        items.add(element);
      }
    }

    if(items.isNotEmpty) {
      showInstRegInfo(
          context: context,
          title: "예약정보",
          items: items,
          onResult: (String cmd, ItemInstReserve info) async {
            _doDelete(cmd, info);
          }
      );
    }
  }

  void _showInfoSn(String oid) {
    List<ItemInstReserve> items = [];
    for (var element in _itemList) {
      if(element.insttResveSn==oid) {
        //print("${element.insttResveChildNm} : ${element.type()}");
        items.add(element);
      }
    }

    if(items.isNotEmpty) {
      showInstRegInfo(
          context: context,
          title: "예약정보",
          items: items,
          onResult: (String cmd, ItemInstReserve info) async {
            _doDelete(cmd, info);
          }
      );
    }
  }

  Future <void> _doDelete(String cmd, ItemInstReserve info) async {
    bool flag = await _reqDel(cmd, info);
    if(flag) {
      await _reqSelect();
      setState(() {});
      showToastMessage("처리되었습니다.");
    }

    // showYesNoDialogBox(
    //     context: context,
    //     height: 240,
    //     title: "확인",
    //     message: "예약 정보를 삭제하시겠습니까?\n",
    //     onResult: (bYes) async {
    //       if(bYes) {
    //         bool flag = await _reqDel(cmd, info);
    //         if(flag) {
    //           await _reqSelect();
    //           setState(() {});
    //           showToastMessage("처리되었습니다.");
    //         }
    //       }
    //     }
    // );
  }

  // 삭제
  Future <bool> _reqDel(String cmd, ItemInstReserve info) async {
    // 여러개 삭제 : { "insttResveSn" : "123213, 123214", "insttOperGroupKey": "" } ,
    // 그룹 삭제  : {  "insttResveSn": "", "insttOperGroupKey": "EV7LP6OQ5GT4QQ8Q"}
    bool flag = false;

    Map<String, dynamic> params = {};
    if(cmd=="DELETE_GRP") {
      params.addAll({"insttResveSn": "", "insttOperGroupKey": info.insttOperGroupKey});
    } else {
      params.addAll({ "insttResveSn": info.insttResveSn, "insttOperGroupKey":"" });
    }
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "/appService/member/instt_cancel.do",
      params: params,
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        if(data['status'].toString()=="200") {
          flag = true;
        } else {
          showToastMessage(data['message']);
        }
      },
    );
    return flag;
  }

  // 조회
  Future <void> _reqSelect() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/instt.do",
      params: { "searchDt" : month },
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        if(data['status'].toString()=="200") {
          var content = data['data']['list'];
          if(content != null) {
            _itemList = ItemInstReserve.fromSnapshot(content);
          } else {
            _itemList = [];
          }
          makeRegData();
          setState(() {});
        }
      },
    );
  }

  void makeRegData() {
    if(meetings.isNotEmpty) {
      meetings.clear();
    }

    for (var element in _itemList) {
      DateTime day = DateFormat('yyyy-MM-dd').parse(element.insttResveDt);
      DateTime startTime  = DateTime(day.year, day.month, day.day, 8);
      DateTime endTime    = startTime.add(const Duration(hours: 8));

      //print(startTime.toString());

      meetings.add(
          _Meeting(
              //element.insttResveChildNm,
            eventName:"[${element.type()}] ${element.insttResveChildNm}, ${element.insttNm}",
            from:startTime,
            to:endTime,
            background:(element.type()=="상시") ? Colors.green : Colors.deepOrange,
            isAllDay: false,
            oid:element.insttResveSn,
          )
        );
    }
  }
}
