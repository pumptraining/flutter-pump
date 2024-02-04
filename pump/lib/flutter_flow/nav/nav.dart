import 'dart:async';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter_flow/transition_info.dart';
import 'package:pump_workout/pages/workout_completed_list/workout_completed_list_widget.dart';
import 'package:pump_workout_sheet/completed_workout_sheet_list/completed_workout_sheet_list_widget.dart';
import 'package:pump/pages/edit_profile/edit_profile_widget.dart';
import 'package:pump/pages/login/login_widget.dart';
import 'package:pump/pages/personal_profile/profile14_other_user_widget.dart';
import 'package:pump/pages/reset_password/reset_password_widget.dart';
import 'package:pump/pages/sign_in/sign_in_widget.dart';
import 'package:pump_workout/pages/review_screen/review_screen_widget.dart';
import 'package:pump_workout_sheet/workout_sheet_details/workout_sheet_details_widget.dart';
import '../../pages/user_purchase_workout_sheet/user_purchase_workout_sheet_widget.dart';
import '/index.dart';
import '/main.dart';
import 'nav.dart';
export 'package:go_router/go_router.dart';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? NavBarPage() : LoginWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) =>
              appStateNotifier.loggedIn ? NavBarPage() : LoginWidget(),
        ),
        FFRoute(
          name: 'PersonalProfile',
          path: '/personalProfile',
          builder: (context, params) => Profile14OtherUserWidget(
            forwardUri: params.getParam('forwardUri', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'ResetPassword',
          path: '/resetPassword',
          builder: (context, params) => ResetPasswordWidget(),
        ),
        FFRoute(
          name: 'HomePage',
          path: '/homePage',
          builder: (context, params) => HomePageWidget(
            workoutId: params.getParam('workoutId', ParamType.String),
            userId: params.getParam('userId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'WorkoutList',
          path: '/workoutList',
          builder: (context, params) => WorkoutListWidget(
            workout: params.getParam<dynamic>('workout', ParamType.JSON, true),
            personalImageUrl: params.getParam('personalImageUrl', ParamType.String),
            changedWorkout: params.getParam<dynamic>('changedWorkout', ParamType.JSON, true),
          ),
        ),
        FFRoute(
          name: 'RestScreen',
          path: '/restScreen',
          builder: (context, params) => RestScreenWidget(
            nextExercise: params.getParam<dynamic>('nextExercise', ParamType.JSON),
            personalImageUrl: params.getParam('personalImageUrl', ParamType.String),
            workout: params.getParam<dynamic>('workout', ParamType.JSON, true),
            restTime: params.getParam('restTime', ParamType.int),
            changedWorkout: params.getParam<dynamic>('changedWorkout', ParamType.JSON, true),
            currentSetIndex: params.getParam('currentSetIndex', ParamType.int),
          ),
        ),
        FFRoute(
          name: 'Login',
          path: '/login',
          builder: (context, params) => LoginWidget(),
        ),
        FFRoute(
          name: 'SignIn',
          path: '/signIn',
          builder: (context, params) => SignInWidget(),
        ),
        FFRoute(
          name: 'CompletedWorkout',
          path: '/completedWorkout',
          builder: (context, params) => CompletedWorkoutWidget(
            workoutId: params.getParam('workoutId', ParamType.String),
            userId: params.getParam('userId', ParamType.String),
            totalSecondsTime: params.getParam('totalSecondsTime', ParamType.int),
            timeString: params.getParam('timeString', ParamType.String),
            imageUrl: params.getParam('imageUrl', ParamType.String),
            personalId: params.getParam('personalId', ParamType.String),
            personalImageUrl: params.getParam('personalImageUrl', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'Activity',
          path: '/activity',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Activity')
              : ActivityWidget(),
        ),
        FFRoute(
          name: 'WorkoutCompletedList',
          path: '/workoutCompletedList',
          builder: (context, params) => WorkoutCompletedListWidget(
            userId: params.getParam('userId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'WorkoutDetails',
          path: '/workoutDetails',
          builder: (context, params) => WorkoutDetailsWidget(
            workoutId: params.getParam('workoutId', ParamType.String),
            userId: params.getParam('userId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'HomeWorkout',
          path: '/homeWorkout',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'HomeWorkout')
              : HomeWorkoutWidget(),
        ),
        FFRoute(
          name: 'Home',
          path: '/home',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Home')
              : HomeWidget(),
        ),
        FFRoute(
          name: 'Profile',
          path: '/profile',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Profile')
              : ProfileWidget(),
        ),
        FFRoute(
          name: 'HomeWorkoutSheets',
          path: '/homeWorkoutSheets',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'HomeWorkoutSheets')
              : HomeWorkoutSheetsWidget(),
        ),
        FFRoute(
          name: 'WorkoutSheetDetails',
          path: '/workoutSheetDetails',
          builder: (context, params) => WorkoutSheetDetailsWidget(
            workoutId: params.getParam('workoutId', ParamType.String),
            showStartButton: params.getParam('showStartButton', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'CategoryList',
          path: '/categoryList',
          builder: (context, params) => CategoryListWidget(
            forwardUri: params.getParam<dynamic>('forwardUri', ParamType.String),
            imageUrl: params.getParam('imageUrl', ParamType.String),
            categoryName: params.getParam('categoryName', ParamType.String),
            userId: params.getParam('userId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'EditProfile',
          path: '/editProfile',
          builder: (context, params) => EditProfileWidget(
            showBackButton: params.getParam('showBackButton', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'CompletedWorkoutSheetList',
          path: '/CompletedWorkoutSheetList',
          builder: (context, params) => CompletedWorkoutSheetListWidget(),
        ),
        FFRoute(
          name: 'ReviewScreen',
          path: '/reviewScreen',
          builder: (context, params) => ReviewScreenWidget(
            workoutId: params.getParam('workoutId', ParamType.String),
            personalId: params.getParam('personalId', ParamType.String),
          ),
        ),
         FFRoute(
          name: 'UserPurchaseWorkoutSheet',
          path: '/userPurchaseWorkoutSheet',
          builder: (context, params) => UserPurchaseWorkoutSheetWidget(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
      observers: [routeObserver],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.location);
            return '/profile';
          }
          return null;
        },
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Center(
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: CircularProgressIndicator(strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}