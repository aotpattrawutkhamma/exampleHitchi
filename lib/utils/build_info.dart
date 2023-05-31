import 'package:intl/intl.dart';

class BuildInfo {
  static String getBuildDate() {
    return DateFormat('dd-MMMM-yyyy HH:mm:ss:SS').format(DateTime.now());
  }
}
