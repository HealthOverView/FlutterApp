import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gosari_app/common/common.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import '../../../../common/theme/theme_util.dart';
import '../../../../data/db/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


class DialogFragment extends StatefulWidget {
  const DialogFragment({Key? key}) : super(key: key);

  @override
  State<DialogFragment> createState() => _DialogFragmentState();
}

class _DialogFragmentState extends State<DialogFragment> {
  DatabaseHelper dbHelper = DatabaseHelper();
  Map<String, List<Map<String, dynamic>>> mySelectedEvents = {};

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate = DateTime.now();

  //Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  @override
  void initState() {

    super.initState();
    loadPreviousEvents();
    // 현재 날짜를 한번 클랙
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _selectedDate = _focusedDay;
      });
    });
  }

  // loadPreviousEvents() {
  //   // Load your event data here
  //   // You can load the data from your database or any other source
  //   // For example:
  //   mySelectedEvents = {
  //     "2023-08-17": [
  //       {"dateTime": "22:15:43", "result": "가임기"},
  //       // More events...
  //     ],
  //     // More dates...
  //   };
  // }

  Future<void> loadPreviousEvents() async {
    List<Map<String, dynamic>> events = await dbHelper.getAllEvents();


    for (var event in events) {
      int id = event['id'];
      String dateTime = event['dateTime'];
      String result = event['result'];
      String image = event['imageFileName'];

      DateTime eventDate = DateTime.parse(dateTime);
      String formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);

      mySelectedEvents.putIfAbsent(formattedDate, () => []);
      mySelectedEvents[formattedDate]!.add({
        'id' : id,
        'dateTime': DateFormat('HH:mm:ss').format(eventDate),
        'result': result,
        'imageFileName' : image
      });

    }
  }


  void loadEventsFromDatabase() async {
    List<Map<String, dynamic>> events = await dbHelper.getAllEvents();

    for (var event in events) {
      String dateTime = event['dateTime'];
      String result = event['result'];

      DateTime eventDate = DateTime.parse(dateTime);
      String formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);

      mySelectedEvents.putIfAbsent(formattedDate, () => []);
      mySelectedEvents[formattedDate]!.add({
        'dateTime': DateFormat('HH:mm:ss').format(eventDate),
        'result': result,
      });
    }
  }

  List<Map<String, dynamic>> _listOfDayEvents(DateTime dateTime) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    List<Map<String, dynamic>>? events = mySelectedEvents[formattedDate];

    // If events is null, return an empty list
    return events ?? [];
  }

  Future<void> _deleteEvent(Map<String, dynamic> event) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('분석 기록을 삭제 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('삭제'),
            ),
          ],
        );
      },
    );

    if (confirm != null && confirm) {
      // Delete the event from the database
      await dbHelper.deleteEvent(event['id']);

      // Remove the deleted event from the mySelectedEvents map
      final selectedDateString = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      mySelectedEvents[selectedDateString]?.removeWhere(
            (item) => item['id'] == event['id'],
      );

      // Refresh the UI by calling setState
      setState(() {});
    }
  }

  Future<void> _showEventDetailsDialog(Map<String, dynamic> event) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Center(child: Text('분석 기록 상세 정보', )),
              Container(width: double.infinity,
                  child: Divider(color: Colors.grey, thickness: 0.5)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 10),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Stack(
                      alignment: Alignment.bottomRight, // Align the IconButton to the bottom right corner
                      children: [
                        ClipOval(
                          child: Image.network(
                            'http://192.168.1.192:3060/image?img_name=${event['imageFileName']}',
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.33,
                            fit: BoxFit.fill,
                          ),
                        ),
                        IconButton(
                          iconSize: 50.0,
                          icon: Icon(Icons.save),
                          onPressed: () async {
                            // Save image to the gallery
                            String imageUrl = 'http://192.168.1.192:3060/image?img_name=${event['imageFileName']}';
                            ByteData byteData = await NetworkAssetBundle(Uri.parse(imageUrl)).load('');
                            Uint8List imageBytes = byteData.buffer.asUint8List();
                            final result = await ImageGallerySaver.saveImage(imageBytes);
                            if (result['isSuccess']) {
                              // Image saved successfully
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('이미지가 갤러리에 저장되었습니다.')),
                              );
                            } else {
                              // Image saving failed
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('이미지 저장에 실패했습니다.')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              Text('분석 결과: ${event['result']}',style: TextStyle(fontSize: 20),),
              SizedBox(height: 8),
              Text('시간: ${event['dateTime']}',style: TextStyle(fontSize: 15, color: Colors.grey[700])),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 닫기 버튼
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
  void _toggleTheme() {
    setState(() {
      ThemeUtil.toggleTheme(context);
    });
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
            // onDaySelected: (selectedDay, focusedDay) {
            //   if (!i(_selectedDate, selectedDay)) {
            //     setState(() {
            //       _selectedDate = selectedDay;
            //       _focusedDay = focusedDay;
            //     });
            //   }
            // },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                //_focusedDay = focusedDay;
              });
              // if (_selectedDate == null) {
              //   setState(() {
              //     _selectedDate = selectedDay;
              //     _focusedDay = focusedDay;
              //   });
              // }

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
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: _listOfDayEvents(_selectedDate!).map<Widget>((event) {
                  return ListTile(
                    //leading: Image.asset('assets/image/splash/splash.png'),
                    leading: Container(
                      width: MediaQuery.of(context).size.width*0.1, // Set the width of the container
                      height: MediaQuery.of(context).size.width*0.1, // Set the height of the container
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(1, 4),
                            blurRadius: 1,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'http://192.168.1.192:3060/image?img_name=${event['imageFileName']}',
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.33,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                    title: Text('분석 결과: ${event['result']}'),
                    subtitle: Text('시간: ${event['dateTime']}'),
                    onTap: () {
                      _showEventDetailsDialog(event);
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Add logic to delete the event
                        _deleteEvent(event);
                      },
                    ),
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


