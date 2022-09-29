import 'package:logger/logger.dart';

class AppLogger {
  static Logger logger = Logger();

  static appLog({required tag, required message}) {
    logger.i("$tag: $message");
  }
}
