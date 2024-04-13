import 'package:facebook_app_events/facebook_app_events.dart';

class EventLogger {
  static final facebookAppEvents = FacebookAppEvents();
  static EventLogger? _instance;
  EventLogger._();
  EventLogger._initialize();

  static EventLogger get instance {
    _instance ??= EventLogger._initialize();
    return _instance!;
  }

  Future<void> setUserData(
      {required String name, required String email}) async {
    await facebookAppEvents.setUserData(
      email: email,
      firstName: name,
    );
  }

  Future<void> logEvent(String name, {dynamic parameters}) async {
    await facebookAppEvents.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> logAddToCart(
      {required String id, required String type, required double price}) async {
    await facebookAppEvents.logAddToCart(
      id: id,
      type: type,
      price: price,
      currency: 'BRL',
    );
  }

  Future<void> logPurchase() async {
    facebookAppEvents.logPurchase(amount: 1, currency: "BRL");
  }
}
