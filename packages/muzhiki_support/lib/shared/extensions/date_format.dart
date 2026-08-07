import 'package:intl/intl.dart';

extension DateFormatChange on DateTime {
  String get formatDate {
    final time = this;
    return DateFormat('dd.MM.yy HH:mm').format(time);
  }

  String get formatDateOnlyTime {
    final time = this;
    return DateFormat('HH:mm').format(time);
  }
}
