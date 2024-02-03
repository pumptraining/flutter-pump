import 'dart:async';
import 'dart:io';
import 'package:api_manager/api_manager/api_manager.dart';
import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/auth/firebase_auth/firebase_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/common/user_settings.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'backend/firebase/firebase_config.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/internationalization.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await initFirebase();

  await FlutterFlowTheme.initialize();

  Stripe.publishableKey =
      'pk_live_51MS4dVEC5sXZsfQl4DQ5sfy5gvMfTdunTRv2mAJOygVrLTRXi91LottjOIMJeS0tZsZuMz6ftq5Gzyv10wCicCeX00LIgq3ot0';

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    await _setupRemoteConfig();
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

  FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      authManager.signOut();
    } else {
      ApiManager.setFirebaseUser(user);
      debugPrint('User is signed in!');
    }
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

Future<void> _setupRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  final toggle = FirebaseRemoteConfig.instance.getBool('apple_signin_button_enabled');

  await remoteConfig.setDefaults(const {"apple_signin_button_enabled": false});
  await remoteConfig.setDefaults(const {"google_signin_button_enabled": false});
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

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = pumpCreatorFirebaseUserStream()
      ..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
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
        // Locale('en', ''),
        Locale('pt', 'BR')
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(),
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: ScrollbarThemeData(),
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

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
      'HomeWorkout': HomeWorkoutWidget(),
      'Activity': ActivityWidget(),
      'Profile': ProfileWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: GNav(
        selectedIndex: currentIndex,
        onTabChange: (i) => setState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        color: FlutterFlowTheme.of(context).secondaryText,
        activeColor: FlutterFlowTheme.of(context).info,
        tabBackgroundColor: FlutterFlowTheme.of(context).primary,
        tabBorderRadius: 100.0,
        tabMargin: EdgeInsetsDirectional.fromSTEB(
            8.0,
            12.0,
            8.0,
            Utils.getBottomSafeArea(context) != 0
                ? Utils.getBottomSafeArea(context)
                : 12),
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
        gap: 8.0,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        duration: Duration(milliseconds: 500),
        haptic: true,
        tabs: [
          GButton(
            icon: currentIndex == 0 ? Icons.home_sharp : Icons.home_sharp,
            text: 'Home',
            iconSize: 24.0,
          ),
          GButton(
            icon: Icons.featured_play_list_rounded,
            text: 'Programas',
            iconSize: 24.0,
          ),
          GButton(
            icon: Icons.fitness_center,
            text: 'Treinos',
            iconSize: 24.0,
          ),
          GButton(
            icon: Icons.bar_chart_outlined,
            text: 'Atividades',
            iconSize: 24.0,
          ),
          GButton(
            icon: Icons.person,
            text: 'Perfil',
            iconSize: 24.0,
          )
        ],
      ),
    );
  }
}
