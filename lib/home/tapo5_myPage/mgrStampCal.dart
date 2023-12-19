// ignore_for_file: file_names, non_constant_identifier_names

import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemStamp.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
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
    this.oid = "",
    this.imagePath="",
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

  String imagePath;


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

class MgrStampCal extends StatefulWidget {
  const MgrStampCal({Key? key}) : super(key: key);

  @override
  State<MgrStampCal> createState() => _MgrStampCalState();
}

class _MgrStampCalState extends State<MgrStampCal> {
  List<ItemStamp> _itemList = [];
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
        title: const Text("스탬프 조회"),
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
                    child: const Text("◼︎ 스템프 조회", style: ItemBkB16,),
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

                      //dataSource: _MeetingDataSource(_getDataSource()),
                      monthCellBuilder: (context, details) {
                        return Container(
                          padding: const EdgeInsets.all(3),
                          child: Column(
                            children: [
                              Text(details.date.day.toString(), style: ItemBkN14,),
                              Visibility(
                                  visible:_isStampDay(details.date.day),
                                  child: Container(
                                    padding:const EdgeInsets.fromLTRB(0,5,0,5),
                                    child: Image.asset(
                                        "assets/icon/visit_stamp.jpeg",
                                        fit: BoxFit.fitWidth,
                                    ),
                                  )),
                              // details.date.day == DateTime.now().day
                              //     ? Icon(Icons.people)
                              //     : SizedBox()
                            ],
                          ),
                        );
                      },

                      monthViewSettings: const MonthViewSettings(
                        showAgenda: false,
                        dayFormat: 'EEE',
                        showTrailingAndLeadingDates:false,
                        appointmentDisplayCount: 5, // 보여줄 일정 개수 설정
                        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                        monthCellStyle: MonthCellStyle(
                          // specialDatesDecoration: BoxDecoration(
                          // image: DecorationImage(
                          //   image: AssetImage('assets/your_image.png'),
                          //       fit: BoxFit.cover,
                          //   ),
                          // ),
                        ),
                        agendaStyle: AgendaStyle(
                          appointmentTextStyle: TextStyle(
                            color: Colors.white, // 일정 텍스트 스타일
                            fontSize: 12,
                              letterSpacing: -1.2
                          ),
                        ),
                      ),
                      onViewChanged:(ViewChangedDetails info) async {
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
                          _showInfoSn(details.appointments!.first.oid);
                        }
                      },
                  ),),
                ],
              ),
            )
        ),
        Positioned(
            child: Visibility(
              visible: false,//_bready && _itemList.isEmpty,
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
    List<ItemStamp> items = [];
    //ItemStamp? info;
    for (var element in _itemList) {
      if(element.bgngDt==selDay) {
        //print("${element.insttResveChildNm} : ${element.type()}");
        items.add(element);
      }
    }

    /*
    if(items.isNotEmpty) {
      showInstRegInfo(
          context: context,
          title: "예약정보",
          items: items,
          onResult: (String cmd, ItemStamp info) async {
            _doDelete(cmd, info);
          }
      );
    }
     */
  }

  void _showInfoSn(String oid) {
    /*
    List<ItemStamp> items = [];
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
          onResult: (String cmd, ItemStamp info) async {
            _doDelete(cmd, info);
          }
      );
    }
     */
  }

  // 조회
  Future <void> _reqSelect() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/stamp.do",
      params: { "searchMonth" : month },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          var content = data['data']['list'];
          if(content != null) {
            _itemList = ItemStamp.fromSnapshot(content);
          } else {
            _itemList = [];
          }
          //makeRegData();
          setState(() {});
        }
      },
    );
  }

  /*
  void makeRegData() {
    if(meetings.isNotEmpty) {
      meetings.clear();
    }

    for (var element in _itemList) {
      DateTime day = DateFormat('yyyy-MM-dd').parse(element.bgngDt);
      DateTime startTime  = DateTime(day.year, day.month, day.day, 8);
      DateTime endTime    = startTime.add(const Duration(hours: 8));

      //print(startTime.toString());

      meetings.add(
          _Meeting(
            eventName:"${element.schdulSj}",
            from:startTime,
            to:endTime,
            background:Colors.deepOrange,
            isAllDay: false,
            oid:element.schdulSn,
            imagePath: "assets/icon/stamp.png"
          )
        );
    }
  }
  */
  bool _isStampDay(int target) {
    for (var element in _itemList) {
      DateTime day = DateFormat('yyyy-MM-dd').parse(element.bgngDt);
      if(target==day.day) {
        return true;
      }
    }
    return false;
  }
}
