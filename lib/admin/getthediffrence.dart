import 'package:intl/intl.dart';

class time {
  hour({thestart, theend}) {
    var format = DateFormat("hh:mm");
    var one = format.parse("$thestart");
    var tow = format.parse("$theend");
    return "${tow.difference(one).toString().split(':00.0')[0]}";
  }
}