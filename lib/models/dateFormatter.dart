import 'package:intl/intl.dart';

class DateFormatter{
  getdatetimgformatted(bool isTitle, String myDate,
      {dateFormat = "MMMd yyyy", String? locale}) {
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(myDate);
    String formattedDate = DateFormat(dateFormat, locale).format(inputDate);
    return formattedDate;
  }
}