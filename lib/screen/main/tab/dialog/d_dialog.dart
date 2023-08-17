// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // GetX 패키지 임포트
// import 'package:gosari_app/common/common.dart';
// import 'package:table_calendar/table_calendar.dart';
// class DialogFragment extends StatelessWidget {
//   final TableCalendarController _controller = TableCalendarController(); // 인스턴스 생성
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 1,
//         backgroundColor: context.appColors.appBg,
//         centerTitle: true,
//         title: Text(
//           'GoSaRi',
//           style: TextStyle(
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//             color: context.appColors.mosttext,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 아이콘 사용
//           onPressed: () {
//             Navigator.of(context).pop(); // 현재 화면에서 뒤로가기
//           },
//         ),
//       ),
//       body: GetX<TableCalendarController>(
//         init: _controller, // 컨트롤러 인스턴스 전달
//         builder: (controller) {
//           return TableCalendar(
//               availableCalendarFormats: const {
//                 CalendarFormat.month : 'Month'
//               },
//             firstDay: DateTime.utc(2010, 10, 16),
//             lastDay: DateTime.utc(2030, 3, 14),
//             focusedDay: controller.focusedDay,
//             calendarFormat: controller.calendarFormat,
//             selectedDayPredicate: (day) {
//               return isSameDay(controller.selectedDay, day);
//             },
//             onDaySelected: (selectedDay, focusedDay) {
//               controller.onDaySelected(selectedDay, focusedDay);
//             },
//             onFormatChanged: (format) {
//               controller.onFormatChanged(format);
//             },
//             onPageChanged: (focusedDay) {
//               controller.onPageChanged(focusedDay);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class TableCalendarController extends GetxController {
//   Rx<CalendarFormat> _calendarFormat = Rx<CalendarFormat>(CalendarFormat.month);
//   Rx<DateTime> _focusedDay = Rx<DateTime>(DateTime.now());
//   Rx<DateTime?> _selectedDay = Rx<DateTime?>(null);
//
//   CalendarFormat get calendarFormat => _calendarFormat.value;
//   DateTime get focusedDay => _focusedDay.value;
//   DateTime? get selectedDay => _selectedDay.value;
//
//   void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay.value, selectedDay)) {
//       _selectedDay.value = selectedDay;
//       _focusedDay.value = focusedDay;
//       update();
//     }
//   }
//
//   void onFormatChanged(CalendarFormat format) {
//     if (_calendarFormat.value != format) {
//       _calendarFormat.value = format;
//       update();
//     }
//   }
//
//   void onPageChanged(DateTime focusedDay) {
//     _focusedDay.value = focusedDay;
//   }
// }
import 'package:flutter/material.dart';
import 'package:gosari_app/common/common.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class DialogFragment extends StatefulWidget {
  const DialogFragment({Key? key}) : super(key: key);

  @override
  State<DialogFragment> createState() => _DialogFragmentState();
}

class _DialogFragmentState extends State<DialogFragment> {
  Map<String, List<Map<String, dynamic>>> mySelectedEvents = {};

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  //Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;

    loadPreviousEvents();
  }

  loadPreviousEvents() {
    // Load your event data here
    // You can load the data from your database or any other source
    // For example:
    mySelectedEvents = {
      "2023-08-17": [
        {"dateTime": "22:15:43", "result": "가임기"},
        // More events...
      ],
      // More dates...
    };
  }

  List<Map<String, dynamic>> _listOfDayEvents(DateTime dateTime) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    List<Map<String, dynamic>>? events = mySelectedEvents[formattedDate];

    // If events is null, return an empty list
    return events ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: context.appColors.appBg,
        centerTitle: true,
        title: Text(
          'GoSaRi',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: context.appColors.mosttext,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 아이콘 사용
          onPressed: () {
            Navigator.of(context).pop(); // 현재 화면에서 뒤로가기
          },
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            availableCalendarFormats: {CalendarFormat.month: 'Month'},
            firstDay: DateTime(2022),
            lastDay: DateTime(2023, 12, 31),
            // Set the last day to a later date
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDate, selectedDay)) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            eventLoader: _listOfDayEvents,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          // ..._listOfDayEvents(_selectedDate!).map(
          //       (myEvents) => ListTile(
          //     leading: const Icon(
          //       Icons.done,
          //       color: Colors.teal,
          //     ),
          //     title: Padding(
          //       padding: const EdgeInsets.only(bottom: 8.0),
          //       child: Text('날짜:   ${myEvents['날짜']}'),
          //     ),
          //     subtitle: Text('결과:   ${myEvents['결과']}'),
          //   ),
          // ),
          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: _listOfDayEvents(_selectedDate!)
          //           .map<Widget>((myEvents) => ListTile(
          //         leading: const Icon(
          //           Icons.done,
          //           color: Colors.teal,
          //         ),
          //         title: Padding(
          //           padding: const EdgeInsets.only(bottom: 8.0),
          //           child: Text('날짜:   ${myEvents['eventTitle']}'),
          //         ),
          //         subtitle: Text('결과:   ${myEvents['eventDescp']}'),
          //       ))
          //           .toList(), // Convert the Iterable to a List
          //     ),
          //   ),
          // ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _listOfDayEvents(_selectedDate!).map<Widget>((event) {
                  return ListTile(
                    leading: const Icon(
                      Icons.done,
                      color: Colors.teal,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('시간: ${event['dateTime']}'),
                    ),
                    subtitle: Text('분석 결과: ${event['result']}'),
                  );
                }).toList(),
              ),
            ),
          ),


        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => _showAddEventDialog(),
      //   label: const Text('이멘트 추가'),
      // ),
    );
  }
}
