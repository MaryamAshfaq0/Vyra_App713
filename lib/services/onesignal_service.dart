import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static void setUser(String userId) {
    OneSignal.login(userId);
  }

  static void setEmail(String email) {
    OneSignal.User.addEmail(email);
  }
}
