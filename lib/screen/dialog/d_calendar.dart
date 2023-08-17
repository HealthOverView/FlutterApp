// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:gosari_app/common/common.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
//
// import '../../data/db/http.dart';
//
// class EventCalendarScreen extends StatefulWidget {
//   EventCalendarScreen({Key? key}) : super(key: key);
//   final DatabaseHelper _databaseHelper = DatabaseHelper();
//
//
//   @override
//   State<EventCalendarScreen> createState() => _EventCalendarScreenState();
// }
//
// class _EventCalendarScreenState extends State<EventCalendarScreen> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDate;
//
//   Map<String, List> mySelectedEvents = {};
//
//   final titleController = TextEditingController();
//   final descpController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initDatabase();
//     _selectedDate = _focusedDay;
//     loadPreviousEvents();
//     widget._databaseHelper.initDatabase();
//   }
//
//   Future<void> _initDatabase() async {
//     await widget._databaseHelper.initDatabase();
//   }
//
//
//   loadPreviousEvents() {
//     mySelectedEvents = {
//       "2022-09-13": [
//         {"eventDescp": "11", "eventTitle": "111"},
//         {"eventDescp": "22", "eventTitle": "22"}
//       ],
//       "2022-09-30": [
//         {"eventDescp": "22", "eventTitle": "22"}
//       ],
//       "2022-09-20": [
//         {"eventTitle": "ss", "eventDescp": "ss"}
//       ]
//     };
//   }
//
//   List _listOfDayEvents(DateTime dateTime) {
//     if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
//       return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
//     } else {
//       return [];
//     }
//   }
//
//   // _showAddEventDialog() async {
//   //   await showDialog(
//   //
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: const Text(
//   //         'Add New Event',
//   //         textAlign: TextAlign.center,
//   //       ),
//   //       content: Column(
//   //         crossAxisAlignment: CrossAxisAlignment.stretch,
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           TextField(
//   //             controller: titleController,
//   //             textCapitalization: TextCapitalization.words,
//   //             decoration: const InputDecoration(
//   //               labelText: 'Title',
//   //             ),
//   //           ),
//   //           TextField(
//   //             controller: descpController,
//   //             textCapitalization: TextCapitalization.words,
//   //             decoration: const InputDecoration(labelText: 'Description'),
//   //           ),
//   //         ],
//   //       ),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           child: const Text('Cancel'),
//   //         ),
//   //         TextButton(
//   //           child: const Text('Add Event'),
//   //           onPressed: () {
//   //             if (titleController.text.isEmpty &&
//   //                 descpController.text.isEmpty) {
//   //               ScaffoldMessenger.of(context).showSnackBar(
//   //                 const SnackBar(
//   //                   content: Text('Required title and description'),
//   //                   duration: Duration(seconds: 2),
//   //                 ),
//   //               );
//   //               return;
//   //             } else {
//   //               setState(() {
//   //                 if (mySelectedEvents[
//   //                         DateFormat('yyyy-MM-dd').format(_selectedDate!)] !=
//   //                     null) {
//   //                   mySelectedEvents[
//   //                           DateFormat('yyyy-MM-dd').format(_selectedDate!)]!
//   //                       .add({
//   //                     "eventTitle": titleController.text,
//   //                     "eventDescp": descpController.text,
//   //                   });
//   //                 } else {
//   //                   mySelectedEvents[
//   //                       DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
//   //                     {
//   //                       "eventTitle": titleController.text,
//   //                       "eventDescp": descpController.text,
//   //                     }
//   //                   ];
//   //                 }
//   //               });
//   //
//   //               print(
//   //                   "New Event for backend developer ${json.encode(mySelectedEvents)}");
//   //               titleController.clear();
//   //               descpController.clear();
//   //               Navigator.pop(context);
//   //             }
//   //           },
//   //         )
//   //       ],
//   //     ),
//   //   );
//   // }\
//   _showAddEventDialog(DatabaseHelper databaseHelper) async {
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//           title: const Text(
//             'Add New Event',
//             textAlign: TextAlign.center,
//           ),
//           // ... (rest of the code)
//
//           content : Column(
//             children: [
//               TextButton(
//                 child: const Text('Add Event'),
//                 onPressed: () async {
//                   if (titleController.text.isEmpty && descpController.text.isEmpty) {
//                     // ... (snackbar code)
//                   } else {
//                     final newEvent = {
//                       "eventTitle": titleController.text,
//                       "eventDescp": descpController.text,
//                     };
//
//                     final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
//
//                     setState(() {
//                       if (mySelectedEvents[formattedDate] != null) {
//                         mySelectedEvents[formattedDate]!.add(newEvent);
//                       } else {
//                         mySelectedEvents[formattedDate] = [newEvent];
//                       }
//                     });
//
//                     await databaseHelper.insertEvent({
//                       'date': formattedDate,
//                       'eventTitle': newEvent['eventTitle'],
//                       'eventDescp': newEvent['eventDescp'],
//                     });
//
//                     print("New Event for backend developer ${json.encode(mySelectedEvents)}");
//                     titleController.clear();
//                     descpController.clear();
//                     Navigator.pop(context);
//                   }
//                 },
//               ),
//       ]
//           )
//       ),
//     );
//   }
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
//       body: Column(
//         children: [
//           TableCalendar(
//             availableCalendarFormats: {CalendarFormat.month: 'Month'},
//             firstDay: DateTime(2022),
//             lastDay: DateTime(2023, 12, 31),
//             // Set the last day to a later date
//             focusedDay: _focusedDay,
//             calendarFormat: _calendarFormat,
//             onDaySelected: (selectedDay, focusedDay) {
//               if (!isSameDay(_selectedDate, selectedDay)) {
//                 setState(() {
//                   _selectedDate = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               }
//             },
//             selectedDayPredicate: (day) {
//               return isSameDay(_selectedDate, day);
//             },
//             onFormatChanged: (format) {
//               if (_calendarFormat != format) {
//                 setState(() {
//                   _calendarFormat = format;
//                 });
//               }
//             },
//             onPageChanged: (focusedDay) {
//               _focusedDay = focusedDay;
//             },
//             eventLoader: _listOfDayEvents,
//           ),
//           // ..._listOfDayEvents(_selectedDate!).map(
//           //       (myEvents) => ListTile(
//           //     leading: const Icon(
//           //       Icons.done,
//           //       color: Colors.teal,
//           //     ),
//           //     title: Padding(
//           //       padding: const EdgeInsets.only(bottom: 8.0),
//           //       child: Text('날짜:   ${myEvents['날짜']}'),
//           //     ),
//           //     subtitle: Text('결과:   ${myEvents['결과']}'),
//           //   ),
//           // ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: _listOfDayEvents(_selectedDate!)
//                     .map<Widget>((myEvents) => ListTile(
//                   leading: const Icon(
//                     Icons.done,
//                     color: Colors.teal,
//                   ),
//                   title: Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Text('날짜:   ${myEvents['날짜']}'),
//                   ),
//                   subtitle: Text('결과:   ${myEvents['결과']}'),
//                 ))
//                     .toList(), // Convert the Iterable to a List
//               ),
//             ),
//           ),
//
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _showAddEventDialog(widget._databaseHelper),
//         label: const Text('Add Event'),
//       ),
//     );
//   }
// }
