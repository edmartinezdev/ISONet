// ignore_for_file: empty_catches

import 'package:intl/intl.dart';

import 'app_common_stuffs/app_logger.dart';

/// DEV NOTE: for more date and time formats, refer
/// https://api.flutter.dev/flutter/intl/DateFormat-class.html

class DateUtil {
  /// convert datetime to string
  /// by default [isUTC] flag is false
  /// set it to TRUE if you want to convert utc date to string
  static String dateTimeToString({
    required DateTime date,
    String requiredFormat = "yyyy-MM-dd HH:mm:ss",
    bool isUTC = false,
  }) {
    try {
      return DateFormat(requiredFormat).format(isUTC ? date.toUtc() : date);
    } catch (e) {
      throw 'Unable to convert $e';
    }
  }

  /// convert string to datetime
  /// by default [isUTC] flag is false
  ///set it to TRUE if you want to convert string to utc date
  static DateTime stringToDateTime({
    required String date,
    bool isUTC = false,
    String? dateFormat
  }) {
    try {
      if (isUTC) {
        if (!date.contains("Z")) {
          throw 'Date $date is not in UTC format';
        }
        return DateFormat(dateFormat ?? "yyyy-MM-dd HH:mm:ss").parse(date, isUTC).toLocal();
      } else {
        if (date.contains("Z")) {
          throw 'Unable to convert, set [isUTC] flag to TRUE';
        }
        return DateFormat(dateFormat ?? "yyyy-MM-dd HH:mm:ss").parse(date);
      }
    } catch (e) {
      throw 'Unable to convert $e';
    }
  }

  /// convert datetime to timestamp
  static int dateTimeToTimestamp({required DateTime date}) {
    try {
      return date.millisecondsSinceEpoch;
    } catch (e) {
      throw 'Unable to convert $e';
    }
  }

  /// convert timestamp to datetime
  static DateTime timestampToDateTime({required int timestamp}) {
    try {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      throw 'Unable to convert $e';
    }
  }

  /// returns the formatted date in [requiredFormat]
  static String getDateInRequiredFormat({
    required String date,
    required String requiredFormat,
  }) {
    try {
      return DateFormat(requiredFormat).format(DateTime.parse(date));
    } catch (e) {
      throw 'Unable to convert date $e';
    }
  }

  static String getLeftTime(String stringDate) {
    String stringResult = "";

    DateTime currentDateTime = DateTime.now();
    DateTime messageDateTime = stringToDate(stringDate, isUTCtime: true);

    int diffInMillisec = currentDateTime.millisecondsSinceEpoch - messageDateTime.millisecondsSinceEpoch;

    int elapsedYears = diffInMillisec / 1000 / 60 / 60 / 24 ~/ 365;
    int elapsedMonths = diffInMillisec / 1000 / 60 / 60 / 24 ~/ 30;
    int elapsedWeeks = diffInMillisec / 1000 / 60 / 60 / 24 ~/ 7;
    int elapsedDays = diffInMillisec / 1000 / 60 / 60 ~/ 24;
    int elapsedHours = diffInMillisec / 1000 / 60 ~/ 60;
    int elapsedMinutes = diffInMillisec / 1000 ~/ 60;
    int elapsedSeconds = diffInMillisec ~/ 1000;

    if (elapsedDays < 1) {
      if (elapsedHours > 0) {
        stringResult = (elapsedHours == 1) ? ("$elapsedHours hour ago") : ("$elapsedHours hours ago");
      } else if (elapsedMinutes > 0) {
        stringResult = (elapsedMinutes == 1) ? ("$elapsedMinutes minute ago") : ("$elapsedMinutes minutes ago");
      } else if (elapsedSeconds > 0) {
        stringResult = "$elapsedSeconds secs ago";
      } else {
        stringResult = "Just now";
      }
    } else if (elapsedDays >= 1) {
      if (elapsedDays == 1) {
        stringResult = "Yesterday";
      } else if (elapsedDays > 1 && elapsedWeeks < 1) {
        stringResult = "$elapsedDays days ago";
      } else if (elapsedWeeks >= 1 && elapsedMonths < 1) {
        stringResult = elapsedWeeks > 1 ? "$elapsedWeeks weeks ago" : "$elapsedWeeks week ago";
      } else if (elapsedMonths >= 1 && elapsedYears < 1) {
        stringResult = elapsedMonths > 1 ? "$elapsedMonths months ago" : "$elapsedMonths month ago";
      } else if (elapsedYears >= 1) {
        stringResult = elapsedYears > 1 ? "$elapsedYears years ago": "$elapsedYears year ago";
      }
    } else {
      stringResult = dateTimeToString(date: messageDateTime, requiredFormat: "hh:mma").toLowerCase();
    }
    return stringResult;
  }

  static String serverDateTimeFormat1 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  static String serverDateTimeFormat2 = "yyyy-MM-dd HH:mm:ss";
  static String serverDateTimeFormat3 = "yyyy-MM-dd'T'HH:mm:ss'Z'";

  static DateTime _stringToDate(String string, {String? format, bool isUTCtime = false}) {
    DateFormat formatter = DateFormat(format);
    if (string.isNotEmpty) {
      try {
        var convertedDate = formatter.parse(string);
        if (isUTCtime) {
          convertedDate = convertedDate.add(DateTime.now().timeZoneOffset);
        }
        return convertedDate;
      } catch (e) {}
    }
    return DateTime.now();
  }

  static DateTime stringToDate(String string, {String format = "", bool isUTCtime = false, bool isReuireNullIfDateNotParse = false}) {
    List<String> arrServerDateFormat = <String>[];
    if (format.isNotEmpty) {
      arrServerDateFormat.add(format);
    } else {
      arrServerDateFormat.add(serverDateTimeFormat1);
      arrServerDateFormat.add(serverDateTimeFormat2);
      arrServerDateFormat.add(serverDateTimeFormat3);
    }

    DateTime? convertedDateTime;
    for (String str in arrServerDateFormat) {
      convertedDateTime = _stringToDate(string, format: str, isUTCtime: isUTCtime);
      return convertedDateTime;
    }

    if (convertedDateTime == null) {
      Logger().v('Error parsing date: $string for Format: $arrServerDateFormat');
    }

    if (isReuireNullIfDateNotParse) {
      return DateTime.now();
    }
    return DateTime.now();
  }

  /* 
    consider a date for eg.: 2022-05-20 10:23:17.461
    results of flag:
    1 -> 2022-05-20
    2 -> 20-05-2022
    3 -> 2022/05/20
    4 -> 20/05/2022
    5 -> 20
    6 -> 05
    7 -> 2022
    8 -> May
    default -> 20 May 2022
  */
  static String getFormattedDate({required String date, int flag = 0}) {
    try {
      switch (flag) {
        case 1:
          return DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
        case 2:
          return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
        case 3:
          return DateFormat("yyyy/MM/dd").format(DateTime.parse(date));
        case 4:
          return DateFormat("dd/MM/yyyy").format(DateTime.parse(date));
        case 5:
          return DateFormat("d").format(DateTime.parse(date));
        case 6:
          return DateFormat("MM").format(DateTime.parse(date));
        case 7:
          return DateFormat("yyyy").format(DateTime.parse(date));
        case 8:
          return DateFormat("MMM").format(DateTime.parse(date));
        default:
          return DateFormat("d MMM yyyy").format(DateTime.parse(date));
      }
    } catch (e) {
      throw 'Unable to convert date $e';
    }
  }

  /* 
  consider a date for eg.: 2022-05-20 10:23:17.461
  results of flag:
  1 -> 10:23:17 AM
  2 -> 10
  3 -> 23
  4 -> 10:23
  default -> 10:23 AM
  */
  static String getFormattedTime({required String date, int flag = 0}) {
    try {
      switch (flag) {
        case 1:
          return DateFormat("hh:mm:ss a").format(DateTime.parse(date));
        case 2:
          return DateFormat("h").format(DateTime.parse(date));
        case 3:
          return DateFormat("m").format(DateTime.parse(date));
        case 4:
          return DateFormat("hh:mm").format(DateTime.parse(date));
        default:
          return DateFormat("hh:mm a").format(DateTime.parse(date));
      }
    } catch (e) {
      throw 'Unable to convert date $e';
    }
  }
}
