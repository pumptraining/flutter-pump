import 'package:firebase_remote_config/firebase_remote_config.dart';

class UserSettings {
  static final UserSettings _instance = UserSettings._internal();
  bool _isSubscriber = true;
  bool _canAddWorkoutSheet = true;
  String _fcmToken = '';

  factory UserSettings() {
    return _instance;
  }

  UserSettings._internal();

  void setSubscribe(bool value) {
    _isSubscriber = value;
  }

  bool isSubscriber() {
    final showSubscribe = FirebaseRemoteConfig.instance.getBool('show_subscribe_view');
    if (showSubscribe == false) {
      return true;
    }
    return _isSubscriber;
  }

  void setCanAddWorkoutSheet(bool value) {
    _canAddWorkoutSheet = value;
  }

  bool canAddWorkoutSheet() {
    return _canAddWorkoutSheet;
  }

  void setFcmToken(String? value) {
    _fcmToken = value ?? '';
  }

  String getFcmToken() {
    return _fcmToken;
  }
}
