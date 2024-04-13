import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter_flow/transition_info.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/flutter_flow/nav/nav.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_widget.dart';
import '/components/information_bottom_sheet_widget.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_timer.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:badges/badges.dart' as badges;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'rest_screen_model.dart';
export 'rest_screen_model.dart';

class RestScreenWidget extends StatefulWidget {
  const RestScreenWidget({
    Key? key,
    this.nextExercise,
    this.personalImageUrl,
    this.workout,
    this.restTime,
    this.changedWorkout,
    this.currentSetIndex,
  }) : super(key: key);

  final dynamic nextExercise;
  final String? personalImageUrl;
  final List<dynamic>? workout;
  final int? restTime;
  final List<dynamic>? changedWorkout;
  final int? currentSetIndex;

  @override
  _RestScreenWidgetState createState() => _RestScreenWidgetState();
}

class _RestScreenWidgetState extends State<RestScreenWidget>
    with TickerProviderStateMixin {
  late RestScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  double topValue = 0.0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 100),
          end: Offset(0, 0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RestScreenModel());

    _model.nextExercise = widget.nextExercise;
    _model.personalImageUrl = widget.personalImageUrl;
    _model.workout = widget.workout;
    _model.restTime = widget.restTime;
    _model.changedWorkout = widget.changedWorkout;
    _model.currentSetIndex = widget.currentSetIndex ?? 0;

    initializeNotification();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.timerController.onExecute.add(StopWatchExecute.start);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void initializeNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher-playstore');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await showDelayedNotification();
  }

  Future<void> showDelayedNotification() async {
    tz.initializeTimeZones();
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default',
      'android.support.customtabs.trusted.CHANNEL_NAME',
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final duration = Duration(seconds: _model.restTime!);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Próximo exercício',
      _model.getNextExerciseTitle(),
      tz.TZDateTime.now(tz.local).add(duration),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    topValue = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, topValue, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 44, 0, 0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Relaxe,',
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Montserrat',
                                      color: FlutterFlowTheme.of(context).info,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              TextSpan(
                                text: '\nrespire fundo',
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).info,
                                ),
                              )
                            ],
                            style: FlutterFlowTheme.of(context).displaySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: FlutterFlowTimer(
                                            initialTime:
                                                _model.restTime! * 1000,
                                            getDisplayTime: (value) =>
                                                StopWatchTimer.getDisplayTime(
                                              value,
                                              hours: false,
                                              minute: true,
                                              milliSecond: false,
                                            ),
                                            timer: _model.timerController,
                                            updateStateInterval:
                                                Duration(milliseconds: 1000),
                                            onChanged: (value, displayTime,
                                                shouldUpdate) {
                                              if (shouldUpdate) setState(() {});
                                            },
                                            onEnded: () async {
                                              Navigator.pop(context,
                                                  _model.currentSetIndex);
                                            },
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .displayLarge
                                                .override(
                                                  fontFamily: 'Montserrat',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  fontSize: 74,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(1, -1),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: AlignmentDirectional(1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                            child: Visibility(
                              visible:
                                  _model.getNextExercisePersonalNote() != null,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  HapticFeedback.mediumImpact();
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(_model.unfocusNode);
                                        },
                                        child: Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: InformationBottomSheetWidget(
                                            personalNote: _model
                                                .getNextExercisePersonalNote(),
                                            personalImageUrl:
                                                _model.personalImageUrl,
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) => setState(() {
                                        _model.selectedPersonalNote = true;
                                      }));
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0x4CFFFFFF),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x33000000),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(1, -1),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1, -1),
                                          child: badges.Badge(
                                            badgeContent: Text(
                                              '1',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                      ),
                                            ),
                                            showBadge:
                                                !_model.selectedPersonalNote,
                                            shape: badges.BadgeShape.circle,
                                            badgeColor:
                                                FlutterFlowTheme.of(context)
                                                    .error,
                                            elevation: 4,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8, 8, 8, 8),
                                            position:
                                                badges.BadgePosition.topEnd(),
                                            animationType:
                                                badges.BadgeAnimationType.scale,
                                            toAnimate: true,
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    _model.personalImageUrl!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: CellListWorkoutWidget(
                        workoutId: '',
                        title: _model.getNextExerciseTitle(),
                        subtitle: _model.getNextExerciseSubtitle(),
                        imageUrl: _model.getNextExerciseImageUrl(),
                        level: 'próximo',
                        levelColor: FlutterFlowTheme.of(context).secondaryText,
                        time: '',
                        titleImage: '',
                        onTap: (p0) async {
                          final result = await context.pushNamed(
                            'WorkoutList',
                            queryParameters: {
                              'workout': serializeParam(
                                _model.workout,
                                ParamType.JSON,
                                true,
                              ),
                              'personalImageUrl': serializeParam(
                                _model.personalImageUrl,
                                ParamType.String,
                              ),
                              'changedWorkout': serializeParam(
                                _model.changedWorkout,
                                ParamType.JSON,
                                true,
                              ),
                            }.withoutNulls,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.bottomToTop,
                              ),
                            },
                          );

                          if (result != null) {
                            setState(() {
                              _model.changeSet = true;
                              _model.currentSetIndex =
                                  int.parse(result.toString());
                              _model.selectedPersonalNote = false;

                              if (!_model.timerController.isRunning) {
                                Navigator.pop(context, _model.currentSetIndex);
                              }
                            });
                          }
                        },
                        onDetailTap: (p0) {})),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 114),
                  child: Divider(
                    indent: 78,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    height: 1,
                    endIndent: 16,
                  ),
                ),
              ],
            ),
            BottomButtonFixedWidget(
                buttonTitle: 'Próximo',
                icon: FaIcon(
                  Icons.arrow_forward_rounded,
                  size: 22,
                ),
                onPressed: () async {
                  await flutterLocalNotificationsPlugin.cancel(0);
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context, _model.currentSetIndex);
                }),
          ],
        ),
      ),
    );
  }
}
