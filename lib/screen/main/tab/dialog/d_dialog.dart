import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX 패키지 임포트
import 'package:table_calendar/table_calendar.dart';
class DialogFragment extends StatelessWidget {
  final TableCalendarController _controller = TableCalendarController(); // 인스턴스 생성

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<TableCalendarController>(
        init: _controller, // 컨트롤러 인스턴스 전달
        builder: (controller) {
          return TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: controller.focusedDay,
            calendarFormat: controller.calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(controller.selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              controller.onDaySelected(selectedDay, focusedDay);
            },
            onFormatChanged: (format) {
              controller.onFormatChanged(format);
            },
            onPageChanged: (focusedDay) {
              controller.onPageChanged(focusedDay);
            },
          );
        },
      ),
    );
  }
}

class TableCalendarController extends GetxController {
  Rx<CalendarFormat> _calendarFormat = Rx<CalendarFormat>(CalendarFormat.month);
  Rx<DateTime> _focusedDay = Rx<DateTime>(DateTime.now());
  Rx<DateTime?> _selectedDay = Rx<DateTime?>(null);

  CalendarFormat get calendarFormat => _calendarFormat.value;
  DateTime get focusedDay => _focusedDay.value;
  DateTime? get selectedDay => _selectedDay.value;

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay.value, selectedDay)) {
      _selectedDay.value = selectedDay;
      _focusedDay.value = focusedDay;
      update();
    }
  }

  void onFormatChanged(CalendarFormat format) {
    if (_calendarFormat.value != format) {
      _calendarFormat.value = format;
      update();
    }
  }

  void onPageChanged(DateTime focusedDay) {
    _focusedDay.value = focusedDay;
  }
}