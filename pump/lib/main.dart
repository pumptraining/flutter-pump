import 'dart:async';
import 'dart:io';

import 'package:api_manager/api_manager/api_manager.dart';
import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/auth/firebase_auth/firebase_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/common/user_settings.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/internationalization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await initFirebase();

  await FlutterFlowTheme.initialize();
  Stripe.publishableKey =
      'pk_live_51MS4dVEC5sXZsfQl4DQ5sfy5gvMfTdunTRv2mAJOygVrLTRXi91LottjOIMJeS0tZsZuMz6ftq5Gzyv10wCicCeX00LIgq3ot0';

  FirebaseAuth.instance.currentUser?.reload();

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Processar mensagem recebida enquanto o app está em primeiro plano
      debugPrint("Foreground Message: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Processar mensagem ao clicar na notificação enquanto o app está em segundo plano
      debugPrint(
          "Opened App from Notification: ${message.notification?.title}");
    });

    FirebaseMessaging.instance.getToken().then((String? token) {
      debugPrint("Token FCM: $token");
      UserSettings().setFcmToken(token);

      if (token != null && currentUser != null) {
        unawaited(_updateFCMToken(token));
        FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);
        FirebaseCrashlytics.instance.setCustomKey('email', currentUserEmail);
      }
    });

    if (Platform.isIOS) {
      FirebaseMessaging.instance.getAPNSToken().then((String? apnsToken) {
        if (apnsToken != null) {
          debugPrint("APNS Token: $apnsToken");
        } else {
          debugPrint("APNS Token not available in this environment.");
        }
      });
    }
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    UserSettings().setFcmToken(fcmToken);

    if (currentUser != null) {
      unawaited(_updateFCMToken(fcmToken));
    }
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  _setupRemoteConfig();
  runApp(MyApp());
}

Future<void> _setupRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  await remoteConfig.setDefaults(const {"show_subscribe_view": true});
  await remoteConfig.setDefaults(const {"show_user_feedback": true});
  await remoteConfig.fetchAndActivate();

  remoteConfig.onConfigUpdated.listen((event) async {
    await remoteConfig.activate();
  });
}

Future<void> _updateFCMToken(String token) async {
  final result =
      await PumpGroup.updateUserFCMTokenCall.call(params: {'fcmToken': token});
  debugPrint("Result update: ${result.succeeded}");
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Processar a mensagem recebida em segundo plano
  debugPrint("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  bool logoutCalled = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [
          SystemUiOverlay.bottom,
        ]);

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = pumpCreatorFirebaseUserStream()
      ..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(seconds: 1),
      () {
        _appStateNotifier.stopShowingSplashImage();
        setThemeMode(_themeMode);
      },
    );

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null && _router.appState.loggedIn && !logoutCalled) {
        logoutCalled = true;
        authManager.signOut();
      } else if (user != null) {
        logoutCalled = false;
        ApiManager.setFirebaseUser(user);
        FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);
        debugPrint('User is signed in!');
      }
    });
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pump',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('pt', 'BR'),
      ],
      theme: ThemeData(brightness: Brightness.light, useMaterial3: false),
      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: false),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'Home';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'Home': HomeWidget(),
      'HomeWorkoutSheets': HomeWorkoutSheetsWidget(),
      'Activity': ActivityWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);
    final MediaQueryData queryData = MediaQuery.of(context);
    final double bottomSpacing = Utils.getBottomSafeArea(context) == 0.0
        ? 16
        : Utils.getBottomSafeArea(context) - 16;

    return Scaffold(
      body: MediaQuery(
          data: queryData
              .removeViewInsets(removeBottom: true)
              .removeViewPadding(removeBottom: true),
          child: _currentPage ?? tabs[_currentPageName]!),
      extendBody: true,
      bottomNavigationBar: FloatingNavbar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: Colors.white,
        selectedItemColor: FlutterFlowTheme.of(context).primaryBackground,
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        selectedBackgroundColor: Color(0x00000000),
        borderRadius: 50.0,
        itemBorderRadius: 8.0,
        margin: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, bottomSpacing),
        padding: EdgeInsets.all(8.0),
        width: double.infinity,
        elevation: 0.0,
        items: [
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  currentIndex == 0 ? Icons.home_sharp : Icons.home_sharp,
                  color: currentIndex == 0
                      ? FlutterFlowTheme.of(context).primaryBackground
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: currentIndex == 0 ? 24.0 : 24.0,
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.explore_rounded,
                  color: currentIndex == 1
                      ? FlutterFlowTheme.of(context).primaryBackground
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart_outlined,
                  color: currentIndex == 2
                      ? FlutterFlowTheme.of(context).primaryBackground
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
