import 'package:intl/intl.dart';

class DateFormatter{
  getdatetimgformatted(bool isTitle, String myDate,{dateFormat = "MMMd yyyy"}) {
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(myDate);
    String formattedDate = DateFormat(dateFormat).format(inputDate);
    return formattedDate;
  }
}