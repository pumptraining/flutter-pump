import 'dart:async';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/transition_info.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pump_activity/activity/activity_widget.dart';
import 'package:pump_components/components/faq/faq_screen.dart';
import 'package:pump_components/components/subscribe_screen/subscribe_screen_widget.dart';
import 'package:pump_creator/pages/add_customer/add_customer_widget.dart';
import 'package:pump_creator/pages/customer_details/customer_details_widget.dart';
import 'package:pump_creator/pages/customer_list/customer_list_widget.dart';
import 'package:pump_creator/pages/home/home_widget.dart';
import 'package:pump_creator/pages/reset_password/reset_password_widget.dart';
import 'package:pump_workout/pages/review_screen/review_screen_widget.dart';
import 'package:pump_workout/pages/workout_completed_list/workout_completed_list_widget.dart';
import 'package:pump_workout/pages/workout_details/workout_details_widget.dart';
import 'package:pump_workout_sheet/completed_workout_sheet_list/completed_workout_sheet_list_widget.dart';
import 'package:pump_workout_sheet/workout_sheet_details/workout_sheet_details_widget.dart';
import 'package:pump_workout_sheet/workout_sheet_picker/workout_sheet_picker_widget.dart';
import '../../index.dart';
import '../../main.dart';
import 'package:flutter_flow/nav/serialization_util.dart';

import '../../pages/customer_payments/customer_payments_widget.dart';
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
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    if (notifyOnAuthChange) {
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
          name: 'ListExercises',
          path: '/listExercises',
          builder: (context, params) => ListExercisesWidget(
            showBackButton: params.getParam('showBackButton', ParamType.bool),
            selectedCategories: params.getParam<String>(
                'selectedCategories', ParamType.String, true),
            personalExercises: params.getParam<dynamic>(
                'personalExercises', ParamType.JSON, true),
            isPicker: params.getParam('isPicker', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'AddExercise',
          path: '/addExercise',
          builder: (context, params) => AddExerciseWidget(
            exercise: params.getParam('exercise', ParamType.JSON),
            categories:
                params.getParam<dynamic>('categories', ParamType.JSON, true),
            equipment:
                params.getParam<dynamic>('equipment', ParamType.JSON, true),
            isUpdate: params.getParam('isUpdate', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'AddWorkoutSheet',
          path: '/addWorkoutSheet',
          builder: (context, params) => AddWorkoutSheetWidget(
            workoutSheet: params.getParam('workoutSheet', ParamType.JSON),
            workoutId: params.getParam('workoutId', ParamType.String),
            isUpdate: params.getParam('isUpdate', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'ListWorkout',
          path: '/listWorkout',
          builder: (context, params) => ListWorkoutWidget(
            showBackButton: params.getParam('showBackButton', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'AddWorkout',
          path: '/addWorkout',
          builder: (context, params) => AddWorkoutWidget(
            workout: params.getParam('workout', ParamType.JSON, false),
            workoutId: params.getParam('workoutId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'AddWorkoutSets',
          path: '/addWorkoutSets',
          builder: (context, params) => AddWorkoutSetsWidget(
            sets: params.getParam('sets', ParamType.JSON),
            techniques:
                params.getParam<dynamic>('techniques', ParamType.JSON, true),
          ),
        ),
        FFRoute(
          name: 'Profile',
          path: '/profile',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Profile')
              : ProfileWidget(),
        ),
        FFRoute(
          name: 'EditProfile',
          path: '/editProfile',
          builder: (context, params) => EditProfileWidget(
            showBackButton: params.getParam('showBackButton', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'Login',
          path: '/login',
          builder: (context, params) => LoginWidget(),
        ),
        FFRoute(
          name: 'WorkoutPicker',
          path: '/workoutPicker',
          builder: (context, params) => WorkoutPickerWidget(
            setupExercises: params.getParam<dynamic>(
                'setupExercises', ParamType.JSON, true),
            showBackButton: params.getParam('showBackButton', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'AddWorkoutSheetPlan',
          path: '/addWorkoutSheetPlan',
          builder: (context, params) => AddWorkoutSheetPlanWidget(
            workoutPlan: params.getParam('workoutPlan', ParamType.JSON),
            workouts: params.getParam('workouts', ParamType.JSON),
          ),
        ),
        FFRoute(
          name: 'SignIn',
          path: '/signIn',
          builder: (context, params) => SignInWidget(),
        ),
        FFRoute(
          name: 'ResetPassword',
          path: '/resetPassword',
          builder: (context, params) => ResetPasswordWidget(),
        ),
        FFRoute(
            name: 'Home',
            path: '/home',
            builder: (context, params) {
              return params.isEmpty
                  ? NavBarPage(initialPage: 'Home')
                  : HomeWidget(
                      showProfile:
                          params.getParam('showProfile', ParamType.bool),
                    );
            }),
        FFRoute(
          name: 'AddCustomer',
          path: '/addCustomer',
          builder: (context, params) => AddCustomerWidget(
            isEdit: params.getParam('isEdit', ParamType.bool),
            selectedTags: params.getParam('selectedTags', ParamType.JSON, true),
            email: params.getParam('email', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'CustomerList',
          path: '/customerList',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Alunos')
              : CustomerListWidget(),
        ),
        FFRoute(
          name: 'CustomerDetails',
          path: '/customerDetails',
          builder: (context, params) => CustomerDetailsWidget(
            customerId: params.getParam('customerId', ParamType.String),
            email: params.getParam('email', ParamType.String),
            reloadBack: params.getParam('reloadBack', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'ActivityWidget',
          path: '/activityWidget',
          builder: (context, params) => ActivityWidget(
            customerId: params.getParam('customerId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'WorkoutDetails',
          path: '/workoutDetails',
          builder: (context, params) => WorkoutDetailsWidget(
            workoutId: params.getParam('workoutId', ParamType.String),
            userId: params.getParam('userId', ParamType.String),
            isPersonal: params.getParam('isPersonal', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'ReviewScreen',
          path: '/reviewScreen',
          builder: (context, params) => ReviewScreenWidget(
            workoutId: params.getParam('workoutId', ParamType.String),
            personalId: params.getParam('personalId', ParamType.String),
            isPersonal: params.getParam('isPersonal', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'WorkoutSheetDetails',
          path: '/workoutSheetDetails',
          builder: (context, params) => WorkoutSheetDetailsWidget(
            workoutId: params.getParam('workoutId', ParamType.String),
            showStartButton: params.getParam('showStartButton', ParamType.bool),
            isPersonal: params.getParam('isPersonal', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'CompletedWorkoutSheetList',
          path: '/CompletedWorkoutSheetList',
          builder: (context, params) => CompletedWorkoutSheetListWidget(
            customerId: params.getParam('customerId', ParamType.String),
            isPersonal: params.getParam('isPersonal', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'WorkoutCompletedList',
          path: '/workoutCompletedList',
          builder: (context, params) => WorkoutCompletedListWidget(
            userId: params.getParam('userId', ParamType.String),
            isPersonal: params.getParam('isPersonal', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'WorkoutSheetPickerWidget',
          path: '/workoutSheetPickerWidget',
          builder: (context, params) => WorkoutSheetPickerWidget(
            customerId: params.getParam('customerId', ParamType.String),
            pickerEnabled: params.getParam('pickerEnabled', ParamType.bool),
            showConfirmAlert:
                params.getParam('showConfirmAlert', ParamType.bool),
          ),
        ),
        FFRoute(
          name: 'CustomerPaymentsWidget',
          path: '/customerPaymentsWidget',
          builder: (context, params) => CustomerPaymentsWidget(
            customerId: params.getParam('customerId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'SubscribeScreenWidget',
          path: '/subscribeScreenWidget',
          builder: (context, params) => SubscribeScreenWidget(),
        ),
        FFRoute(
          name: 'FaqScreenWidget',
          path: '/FaqScreenWidget',
          builder: (context, params) => FaqScreenWidget(
            questions: params.getParam('questions', ParamType.JSON, true),
          ),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
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
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

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
