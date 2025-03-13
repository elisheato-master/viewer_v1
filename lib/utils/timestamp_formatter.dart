import 'package:intl/intl.dart';

class TimestampFormatter {
  static String format(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    
    try {
      if (timestamp is DateTime) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);
      } else if (timestamp is int) {
        return DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
      } else {
        return timestamp.toString();
      }
    } catch (e) {
      return 'Invalid timestamp';
    }
  }
}
