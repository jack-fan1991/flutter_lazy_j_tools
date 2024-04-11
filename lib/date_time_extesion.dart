import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

extension DateUtilsExtensions on DateTime {
  /// returns the number of days in the month of this date
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  /// returns a list of [DateTime]s for each day in the month of this date
  /// if [start] is provided, the list will only contain dates after [start]
  List<DateTime> getDaysInMonthList({DateTime? min, DateTime? max}) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(
      daysInMonth,
      (index) => DateTime(year, month, index + 1),
    ).where((date) {
      final minDate = min != null ? min.prevDay : DateTime(1912, 1, 1);
      final maxDate = max != null ? max.nextDay : DateTime(9999, 1, 1);
      // print("$date $minDate ~ $maxDate");
      return date.isAfter(minDate) && date.isBefore(maxDate);
    }).toList();
  }

  DateTime get prevDay => DateTime(year, month, day - 1);
  DateTime get nextDay => DateTime(year, month, day + 1);
  DateTime get prevMonth =>
      DateTime(year, month - 1, DateTime(year, month - 1).lastDateOfMonth.day);
  DateTime get nextMonth =>
      DateTime(year, month + 1, DateTime(year, month + 1).lastDateOfMonth.day);

  bool isSameDayOrAfter(DateTime other) => isAfter(other) || isSameDay(other);

  bool isSameDayOrBefore(DateTime other) => isBefore(other) || isSameDay(other);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  DateTime removeTime() => DateTime(year, month, day);

  bool isSameMonth(DateTime other) =>
      other.year == year && other.month == month;

  DateTime get lastDateOfMonth => DateTime(year, month + 1, 0);
  DateTime get firstDateOfMonth => DateTime(year, month, 1);

  String parse({String formatString = 'yyyy/MM/dd'}) {
    return DateFormat(formatString).format(this);
  }

  DateTime addDays(int daysToAdd) {
    return DateTime(
      year,
      month,
      day + daysToAdd,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );

    // }

    // List<int> daysPerMonth(int year) => <int>[
    //       31,
    //       _isLeapYear(year) ? 29 : 28,
    //       31,
    //       30,
    //       31,
    //       30,
    //       31,
    //       31,
    //       30,
    //       31,
    //       30,
    //       31,
    //     ];

    // bool _isLeapYear(int year) {
    //   return (year & 3) == 0 && ((year % 25) != 0 || (year & 15) == 0);
  }

  Future<DateTime> toNtpNow({bool debug = false}) async {
    DateTime? ntpTime;
    final address = [
      'time.google.com',
      'time.facebook.com',
      'time.euro.apple.com',
      'pool.ntp.org',
    ];
    for (final addr in address) {
      ntpTime = await _checkTime(this, addr);
      if (ntpTime != null) {
        break;
      }
    }
    return ntpTime ?? this;
  }

  Future<DateTime?> _checkTime(DateTime _myTime, String lookupAddress,
      {bool debug = false}) async {
    try {
      DateTime _ntpTime;

      /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
      // _myTime = DateTime.now();

      /// Or get NTP offset (in milliseconds) and add it yourself
      final int offset = await NTP.getNtpOffset(
          localTime: _myTime, lookUpAddress: lookupAddress);

      _ntpTime = _myTime.add(Duration(milliseconds: offset));
      if (debug) {
        debugPrint('\n==== $lookupAddress ====');
        debugPrint('My time: $_myTime');
        debugPrint('NTP time: $_ntpTime');
        debugPrint(
            'Difference: ${_myTime.difference(_ntpTime).inMilliseconds}ms');
      }
      return _ntpTime;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
