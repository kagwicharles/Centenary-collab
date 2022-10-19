import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rafiki/src/ui/home/dashboard.dart';
import 'package:rafiki/src/utils/common_libs.dart';

class AppUtils {
  final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(seconds: 4),
      invalidateSessionForUserInactiviity: const Duration(seconds: 4));

  appSessionConfiguration(context) {
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        CommonLibs.navigateToRoute(context: context, widget: const DashBoard());
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        CommonLibs.navigateToRoute(context: context, widget: const DashBoard());
      }
    });
  }
}
