import 'package:intl/intl.dart';

class SDateUtils {
  SDateUtils._internal();
  factory SDateUtils() => _instance;
  static final SDateUtils _instance = SDateUtils._internal();

  static String formatDate(String? date, {String pattern = "yyyy-MM-dd"}) {
    date ??= DateTime.now().toString();
    DateTime dateTime = DateTime.tryParse(date)!;
    return DateFormat(pattern).format(dateTime);
  }

  static String formatDateByInt(int millisecondsSinceEpoch,
      {String pattern = "yyyy-MM-dd HH:mm"}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch,
        isUtc: true);

    return DateFormat(pattern).format(dateTime);
  }
}
