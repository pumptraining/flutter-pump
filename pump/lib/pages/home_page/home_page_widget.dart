import 'package:api_manager/common/loader_state.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter_flow/transition_info.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:pump/flutter_flow/nav/nav.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_flow/flutter_flow_timer.dart';
import 'package:wakelock/wakelock.dart';
import 'package:api_manager/api_requests/pump_api_calls.dart';
import '/components/information_bottom_sheet_widget.dart';
import 'package:pump_components/components/information_dialog/information_dialog_widget.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_video_player.dart';
import 'package:badges/badges.dart' as badges;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'home_page_model.dart';
import 'package:pump_components/components/information_bottom_sheet_text/information_bottom_sheet_text_widget.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key, this.workoutId, this.userId})
      : super(key: key);

  final String? workoutId;
  final String? userId;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  double topValue = 0.0;
  String trainingId = '';
  String userId = currentUserUid;
  FlutterTts flutterTts = FlutterTts();
  String personalImageUrl = '';
  String personalId = '';
  String imageUrl = '';
  final stopwatch = Stopwatch();
  bool _volumeOn = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    trainingId = widget.workoutId ?? '';
    userId = widget.userId ?? currentUserUid;

    Wakelock.enable();
    startWorkout(stopwatch);
  }

  void startWorkout(Stopwatch stopwatch) {
    stopwatch.start();
  }

  void stopWorkout(Stopwatch stopwatch) {
    stopwatch.stop();
  }

  Future<void> speakText(String text) async {
    if (_volumeOn) {
      await flutterTts.stop();
      await flutterTts.setLanguage('pt-BR');
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient,
          [IosTextToSpeechAudioCategoryOptions.mixWithOthers]);
      await flutterTts.speak(text);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _model.timerController.dispose();
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    if (_model.sets.isEmpty || trainingId.isEmpty) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
        child: ApiLoaderWidget(
          apiCall: PumpGroup.workoutDetailsCall,
          params: {'trainingId': trainingId},
          builder: (context, snapshot) {
            _model.workout = snapshot?.data!.jsonBody;
            _model.setWorkout(
                PumpGroup.workoutDetailsCall.sets(snapshot?.data!.jsonBody),
                context);
            personalImageUrl = PumpGroup.workoutDetailsCall
                .personalImageUrl(snapshot?.data?.jsonBody);

            personalId = PumpGroup.workoutDetailsCall
                    .personalId(snapshot?.data!.jsonBody) ??
                '';

            imageUrl = PumpGroup.workoutDetailsCall
                    .imageUrl(snapshot?.data!.jsonBody) ??
                '';

            if (_model.doneSelected) {
              _model.doneSelected = false;
              speakText(_model.getSpeakerExercise());
            }

            return buildContent(context);
          },
        ),
      );
    } else {
      return buildContent(context);
    }
  }

  Scaffold buildContent(BuildContext context) {
    topValue = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 200.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1.0,
                              height: MediaQuery.of(context).size.height - 300,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                300,
                                            child: FlutterFlowVideoPlayer(
                                              path: _model.getCurrentExercise()[
                                                  'oldVideoUrl'],
                                              videoType: VideoType.network,
                                              autoPlay:
                                                  _model.timerValue() != null,
                                              looping: true,
                                              showControls: true,
                                              allowFullScreen: true,
                                              allowPlaybackSpeedMenu: false,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Generated code for this Column Widget...
                                    Align(
                                      alignment: AlignmentDirectional(0, 1),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0, 1),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 12),
                                              child: Visibility(
                                                visible:
                                                    _model.hasPersonalNote(),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(16, 0,
                                                                    0, 0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            HapticFeedback
                                                                .mediumImpact();
                                                            _model.personalNoteSelected =
                                                                true;
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () => FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          _model
                                                                              .unfocusNode),
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets,
                                                                    child:
                                                                        InformationBottomSheetWidget(
                                                                      personalNote:
                                                                          _model
                                                                              .getCurrentExercise()['personalNote'],
                                                                      personalImageUrl:
                                                                          personalImageUrl,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                setState(
                                                                    () {}));
                                                          },
                                                          child: Container(
                                                            width: 40,
                                                            height: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0x4CFFFFFF),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  blurRadius: 4,
                                                                  color: Color(
                                                                      0x33000000),
                                                                  offset:
                                                                      Offset(
                                                                          0, 2),
                                                                )
                                                              ],
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      1, -1),
                                                              child: Stack(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            1,
                                                                            -1),
                                                                    child: badges
                                                                        .Badge(
                                                                      badgeContent:
                                                                          Text(
                                                                        '1',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              fontFamily: 'Readex Pro',
                                                                              color: Colors.white,
                                                                              fontSize: 8,
                                                                            ),
                                                                      ),
                                                                      showBadge:
                                                                          !_model
                                                                              .personalNoteSelected,
                                                                      shape: badges
                                                                          .BadgeShape
                                                                          .circle,
                                                                      badgeColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .error,
                                                                      elevation:
                                                                          4,
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              8,
                                                                              8,
                                                                              8,
                                                                              8),
                                                                      position:
                                                                          badges.BadgePosition
                                                                              .topEnd(),
                                                                      animationType: badges
                                                                          .BadgeAnimationType
                                                                          .scale,
                                                                      toAnimate:
                                                                          true,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            40,
                                                                        height:
                                                                            40,
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl:
                                                                              personalImageUrl,
                                                                          fit: BoxFit
                                                                              .cover,
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                _model.getTechniqueName() !=
                                                    null,
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(-1, 1),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 0.0, 12.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    HapticFeedback
                                                        .mediumImpact();
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () => FocusScope
                                                                  .of(context)
                                                              .requestFocus(_model
                                                                  .unfocusNode),
                                                          child: Padding(
                                                            padding:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets,
                                                            child:
                                                                InformationBottomSheetTextWidget(
                                                              personalNote: _model
                                                                  .getTechniqueDescription(),
                                                              title: _model
                                                                  .getTechniqueName(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        setState(() {}));
                                                  },
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent2,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 4.0,
                                                            color: Color(
                                                                0x32171717),
                                                            offset: Offset(
                                                                0.0, 2.0),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8.0,
                                                                    0.0,
                                                                    8.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .info_outline_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 16.0,
                                                            ),
                                                            SizedBox(
                                                                width: 8.0),
                                                            Flexible(
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Text(
                                                                  _model.getTechniqueName() ??
                                                                      '',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Lexend Deca',
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
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
                                          Visibility(
                                            visible:
                                                _model.getIntensity() != null,
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(-1, 1),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 0.0, 12.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {},
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent2,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 4.0,
                                                            color: Color(
                                                                0x32171717),
                                                            offset: Offset(
                                                                0.0, 2.0),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8.0,
                                                                    0.0,
                                                                    8.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.bar_chart,
                                                              color:
                                                                  Colors.white,
                                                              size: 16.0,
                                                            ),
                                                            SizedBox(
                                                                width: 8.0),
                                                            Flexible(
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Text(
                                                                  _model.getIntensity() ??
                                                                      '',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Lexend Deca',
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
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
                                          Visibility(
                                            visible:
                                                _model.getEquipment() != null,
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(-1, 1),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 0.0, 12.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent2,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 4.0,
                                                            color: Color(
                                                                0x32171717),
                                                            offset: Offset(
                                                                0.0, 2.0),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8.0,
                                                                    0.0,
                                                                    8.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .fitness_center,
                                                              color:
                                                                  Colors.white,
                                                              size: 16.0,
                                                            ),
                                                            SizedBox(
                                                                width: 8.0),
                                                            Flexible(
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Text(
                                                                  _model.getEquipment() ??
                                                                      '',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Lexend Deca',
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
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
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, topValue, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    1.0, -1.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 16.0, 0.0),
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 4.0,
                                                          color:
                                                              Color(0x33000000),
                                                          offset:
                                                              Offset(0.0, 2.0),
                                                        )
                                                      ],
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Builder(
                                                        builder: (context) =>
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          icon: Icon(
                                                            _volumeOn
                                                                ? Icons
                                                                    .volume_up
                                                                : Icons
                                                                    .volume_off,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            HapticFeedback
                                                                .mediumImpact();
                                                            safeSetState(() {
                                                              _volumeOn =
                                                                  !_volumeOn;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  1.0, -1.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 16.0, 0.0),
                                                child: Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 4.0,
                                                        color:
                                                            Color(0x33000000),
                                                        offset:
                                                            Offset(0.0, 2.0),
                                                      )
                                                    ],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Builder(
                                                      builder: (context) =>
                                                          FlutterFlowIconButton(
                                                        borderColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryBackground,
                                                        borderRadius: 20.0,
                                                        borderWidth: 1.0,
                                                        buttonSize: 40.0,
                                                        fillColor: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        icon: Icon(
                                                          Icons.close,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 20.0,
                                                        ),
                                                        onPressed: () async {
                                                          HapticFeedback
                                                              .mediumImpact();
                                                          await showAlignedDialog(
                                                            context: context,
                                                            isGlobal: true,
                                                            avoidOverflow:
                                                                false,
                                                            targetAnchor:
                                                                AlignmentDirectional(
                                                                        0.0,
                                                                        0.0)
                                                                    .resolve(
                                                                        Directionality.of(
                                                                            context)),
                                                            followerAnchor:
                                                                AlignmentDirectional(
                                                                        0.0,
                                                                        0.0)
                                                                    .resolve(
                                                                        Directionality.of(
                                                                            context)),
                                                            builder:
                                                                (dialogContext) {
                                                              return Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () => FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          _model
                                                                              .unfocusNode),
                                                                  child:
                                                                      InformationDialogWidget(
                                                                    title:
                                                                        'Atenção',
                                                                    message:
                                                                        'O progresso do treino não será salvo. Tem certeza que deseja sair do treino?',
                                                                    actionButtonTitle:
                                                                        'Sair do treino',
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then(
                                                            (value) {
                                                              setState(() {
                                                                if (value ==
                                                                    'leave') {
                                                                  Wakelock
                                                                      .disable();
                                                                  context
                                                                      .safePop();
                                                                }
                                                              });
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 1.0,
                height: 300,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    Divider(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      height: 1,
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      _model.getExerciseTitle().toUpperCase(),
                                      maxLines: 2,
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                              fontFamily: 'Montserrat',
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        AutoSizeText(
                                          _model.getCurrentExercisePause(),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Montserrat',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 16.0, 0.0),
                            child: CircularPercentIndicator(
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: _model.calculateCompletionValue(),
                              radius: 25.0,
                              lineWidth: 5.0,
                              animation: true,
                              progressColor:
                                  FlutterFlowTheme.of(context).primary,
                              backgroundColor:
                                  FlutterFlowTheme.of(context).accent4,
                              center: Text(
                                _model.calculateCompletionPercentage(),
                                style: FlutterFlowTheme.of(context).labelMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            child: Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(16),
                                shape: BoxShape.rectangle,
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();

                                  final result = await context.pushNamed(
                                    'WorkoutList',
                                    queryParameters: {
                                      'workout': serializeParam(
                                        _model.originalFormatSets,
                                        ParamType.JSON,
                                        true,
                                      ),
                                      'personalImageUrl': serializeParam(
                                        personalImageUrl,
                                        ParamType.String,
                                      ),
                                      'changedWorkout': serializeParam(
                                        _model.sets,
                                        ParamType.JSON,
                                        true,
                                      ),
                                    }.withoutNulls,
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: TransitionInfo(
                                        hasTransition: true,
                                        transitionType:
                                            PageTransitionType.bottomToTop,
                                      ),
                                    },
                                  );

                                  if (result != null) {
                                    final resultValue =
                                        int.parse(result.toString());

                                    if (resultValue != _model.currentSetIndex) {
                                      _model.doneSelected = true;
                                      _model.timerController.dispose();
                                    }

                                    setState(() {
                                      if (resultValue !=
                                          _model.currentSetIndex) {
                                        _model.currentSetIndex =
                                            int.parse(result.toString());
                                        speakText(_model.getSpeakerExercise());
                                      } else {
                                        return;
                                      }

                                      if (_model.timerValue() != null) {
                                        _model.timerController = StopWatchTimer(
                                            mode: StopWatchMode.countDown);
                                        _model.timerController.setPresetTime(
                                            mSec: _model.timerValue()! * 1000,
                                            add: false);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            'Prepare-se',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 5000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ));

                                        _model.isTimerEnded = false;

                                        if (_model.timerValue() != null) {
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) async {
                                            await Future.delayed(
                                                Duration(seconds: 5));
                                            if (_model.timerValue() != null) {
                                              _model.timerController.onExecute
                                                  .add(StopWatchExecute.start);
                                            }
                                          });
                                        }
                                      }
                                    });
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.zero,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: _model
                                                            .getNextExercise() ==
                                                        null
                                                    ? Icon(
                                                        Icons.flag_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        size: 24,
                                                      )
                                                    : _model.showRestInNext()
                                                        ? Icon(
                                                            Icons
                                                                .timer_outlined,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            size: 24,
                                                          )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: _model
                                                                      .getNextExercise()[
                                                                  'imageUrl'],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(12, 2, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 12,
                                                                    0, 6),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  AutoSizeText(
                                                                _model
                                                                    .getNextExerciseTitle(),
                                                                maxLines: 1,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            _model
                                                                .getNextExerciseSubtitle(),
                                                            maxLines: 1,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            FlutterFlowIconButton(
                                              borderColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius: 20,
                                              borderWidth: 1,
                                              buttonSize: 40,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              icon: Icon(
                                                Icons.list,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 16,
                                              ),
                                              onPressed: () async {
                                                ScaffoldMessenger.of(context)
                                                    .removeCurrentSnackBar();

                                                final result =
                                                    await context.pushNamed(
                                                  'WorkoutList',
                                                  queryParameters: {
                                                    'workout': serializeParam(
                                                      _model.originalFormatSets,
                                                      ParamType.JSON,
                                                      true,
                                                    ),
                                                    'personalImageUrl':
                                                        serializeParam(
                                                      personalImageUrl,
                                                      ParamType.String,
                                                    ),
                                                    'changedWorkout':
                                                        serializeParam(
                                                      _model.sets,
                                                      ParamType.JSON,
                                                      true,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey:
                                                        TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType:
                                                          PageTransitionType
                                                              .bottomToTop,
                                                    ),
                                                  },
                                                );

                                                if (result != null) {
                                                  final resultValue = int.parse(
                                                      result.toString());

                                                  setState(() {
                                                    if (resultValue !=
                                                        _model
                                                            .currentSetIndex) {
                                                      _model.doneSelected =
                                                          true;
                                                      _model.timerController
                                                          .dispose();
                                                      _model.currentSetIndex =
                                                          int.parse(result
                                                              .toString());
                                                      speakText(_model
                                                          .getSpeakerExercise());
                                                    } else {
                                                      return;
                                                    }
                                                  });

                                                  if (_model.timerValue() !=
                                                          null &&
                                                      resultValue !=
                                                          _model
                                                              .currentSetIndex) {
                                                    _model.timerController =
                                                        StopWatchTimer(
                                                            mode: StopWatchMode
                                                                .countDown);
                                                    _model.timerController
                                                        .setPresetTime(
                                                            mSec: _model
                                                                    .timerValue()! *
                                                                1000,
                                                            add: false);

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                        'Prepare-se',
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 5000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ));

                                                    _model.isTimerEnded = false;

                                                    if (_model.timerValue() !=
                                                        null) {
                                                      SchedulerBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) async {
                                                        await Future.delayed(
                                                            Duration(
                                                                seconds: 5));
                                                        if (_model
                                                                .timerValue() !=
                                                            null) {
                                                          _model.timerController
                                                              .onExecute
                                                              .add(
                                                                  StopWatchExecute
                                                                      .start);
                                                        }
                                                      });
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Divider(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      height: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: Padding(
                                  padding: EdgeInsetsDirectional.zero,
                                  child: _model.timerValue() == null
                                      ? BottomButtonFixedWidget(
                                          buttonTitle:
                                              _model.getNextExercise() == null
                                                  ? 'Finalizar'
                                                  : (_model.showRest()
                                                      ? 'Intervalo'
                                                      : 'Próximo'),
                                          icon: Icon(
                                            _model.getNextExercise() == null
                                                ? Icons.arrow_forward_rounded
                                                : _model.showRest()
                                                    ? Icons.timer_outlined
                                                    : Icons
                                                        .arrow_forward_rounded,
                                            size: 22,
                                          ),
                                          onPressed: () async {
                                            HapticFeedback.mediumImpact();
                                            _model.completeLastExercise();

                                            final nextExercise =
                                                _model.getNextExercise();

                                            if (nextExercise == null) {
                                              stopWorkout(stopwatch);
                                              context.pushNamed(
                                                'CompletedWorkout',
                                                queryParameters: {
                                                  'workoutId': serializeParam(
                                                    trainingId,
                                                    ParamType.String,
                                                  ),
                                                  'userId': serializeParam(
                                                    userId,
                                                    ParamType.String,
                                                  ),
                                                  'imageUrl': serializeParam(
                                                    imageUrl,
                                                    ParamType.String,
                                                  ),
                                                  'personalImageUrl':
                                                      serializeParam(
                                                    personalImageUrl,
                                                    ParamType.String,
                                                  ),
                                                  'totalSecondsTime':
                                                      serializeParam(
                                                    stopwatch.elapsed.inSeconds,
                                                    ParamType.int,
                                                  ),
                                                  'timeString': serializeParam(
                                                    _formatTotalTimeString(),
                                                    ParamType.String,
                                                  ),
                                                  'personalId': serializeParam(
                                                    personalId,
                                                    ParamType.String,
                                                  ),
                                                  'level': serializeParam(
                                                    _model.getWorkoutLevel(),
                                                    ParamType.String,
                                                  ),
                                                }.withoutNulls,
                                                extra: <String, dynamic>{
                                                  kTransitionInfoKey:
                                                      TransitionInfo(
                                                    hasTransition: true,
                                                    transitionType:
                                                        PageTransitionType.fade,
                                                  ),
                                                },
                                              );
                                              return;
                                            }

                                            Object? result;

                                            if (_model.showRest()) {
                                              speakText('Faça uma pausa.');
                                              result = await context.pushNamed(
                                                'RestScreen',
                                                queryParameters: {
                                                  'nextExercise':
                                                      serializeParam(
                                                    nextExercise,
                                                    ParamType.JSON,
                                                  ),
                                                  'personalImageUrl':
                                                      serializeParam(
                                                    personalImageUrl,
                                                    ParamType.String,
                                                  ),
                                                  'workout': serializeParam(
                                                    _model
                                                        .copyOriginalFormatSets,
                                                    ParamType.JSON,
                                                    true,
                                                  ),
                                                  'restTime': serializeParam(
                                                    _model.getCurrentExercise()[
                                                        'pause'],
                                                    ParamType.int,
                                                  ),
                                                  'changedWorkout':
                                                      serializeParam(
                                                    _model.copySets,
                                                    ParamType.JSON,
                                                    true,
                                                  ),
                                                  'currentSetIndex':
                                                      serializeParam(
                                                    _model.currentSetIndex,
                                                    ParamType.int,
                                                  ),
                                                }.withoutNulls,
                                                extra: <String, dynamic>{
                                                  kTransitionInfoKey:
                                                      TransitionInfo(
                                                    hasTransition: true,
                                                    transitionType:
                                                        PageTransitionType.fade,
                                                  ),
                                                },
                                              );
                                            }

                                            setState(() {
                                              _model.doneSelected = true;
                                              _model.completeExercise();

                                              if (result != null) {
                                                _model.currentSetIndex =
                                                    int.parse(
                                                        result.toString());
                                              }

                                              speakText(
                                                  _model.getSpeakerExercise());

                                              if (_model.timerValue() != null) {
                                                _model.timerController =
                                                    StopWatchTimer(
                                                        mode: StopWatchMode
                                                            .countDown);

                                                _model.timerController
                                                    .setPresetTime(
                                                        mSec: _model
                                                                .timerValue()! *
                                                            1000,
                                                        add: false);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    'Prepare-se',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 5000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                ));
                                                speakText('Prepare-se');

                                                _model.isTimerEnded = false;

                                                if (_model.timerValue() !=
                                                    null) {
                                                  SchedulerBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) async {
                                                    await Future.delayed(
                                                        Duration(seconds: 5));
                                                    speakText('Comece');
                                                    if (_model.timerValue() !=
                                                        null) {
                                                      _model.timerController
                                                          .onExecute
                                                          .add(StopWatchExecute
                                                              .start);
                                                    }
                                                  });
                                                }
                                              }
                                            });
                                          })
                                      // ? FFButtonWidget(
                                      //     onPressed: () async {
                                      // HapticFeedback.mediumImpact();
                                      // _model.completeLastExercise();

                                      // final nextExercise =
                                      //     _model.getNextExercise();

                                      // if (nextExercise == null) {
                                      //   stopWorkout(stopwatch);
                                      //   context.pushNamed(
                                      //     'CompletedWorkout',
                                      //     queryParameters: {
                                      //       'workoutId': serializeParam(
                                      //         trainingId,
                                      //         ParamType.String,
                                      //       ),
                                      //       'userId': serializeParam(
                                      //         userId,
                                      //         ParamType.String,
                                      //       ),
                                      //       'imageUrl': serializeParam(
                                      //         imageUrl,
                                      //         ParamType.String,
                                      //       ),
                                      //       'personalImageUrl':
                                      //           serializeParam(
                                      //         personalImageUrl,
                                      //         ParamType.String,
                                      //       ),
                                      //       'totalSecondsTime':
                                      //           serializeParam(
                                      //         stopwatch.elapsed.inSeconds,
                                      //         ParamType.int,
                                      //       ),
                                      //       'timeString': serializeParam(
                                      //         _formatTotalTimeString(),
                                      //         ParamType.String,
                                      //       ),
                                      //       'personalId': serializeParam(
                                      //         personalId,
                                      //         ParamType.String,
                                      //       ),
                                      //     }.withoutNulls,
                                      //     extra: <String, dynamic>{
                                      //       kTransitionInfoKey:
                                      //           TransitionInfo(
                                      //         hasTransition: true,
                                      //         transitionType:
                                      //             PageTransitionType.fade,
                                      //       ),
                                      //     },
                                      //   );
                                      //   return;
                                      // }

                                      // Object? result;

                                      // if (_model.showRestInNext()) {
                                      //   speakText('Faça uma pausa.');
                                      //   result = await context.pushNamed(
                                      //     'RestScreen',
                                      //     queryParameters: {
                                      //       'nextExercise':
                                      //           serializeParam(
                                      //         nextExercise,
                                      //         ParamType.JSON,
                                      //       ),
                                      //       'personalImageUrl':
                                      //           serializeParam(
                                      //         personalImageUrl,
                                      //         ParamType.String,
                                      //       ),
                                      //       'workout': serializeParam(
                                      //         _model
                                      //             .copyOriginalFormatSets,
                                      //         ParamType.JSON,
                                      //         true,
                                      //       ),
                                      //       'restTime': serializeParam(
                                      //         _model.getCurrentExercise()[
                                      //             'pause'],
                                      //         ParamType.int,
                                      //       ),
                                      //       'changedWorkout':
                                      //           serializeParam(
                                      //         _model.copySets,
                                      //         ParamType.JSON,
                                      //         true,
                                      //       ),
                                      //       'currentSetIndex':
                                      //           serializeParam(
                                      //         _model.currentSetIndex,
                                      //         ParamType.int,
                                      //       ),
                                      //     }.withoutNulls,
                                      //     extra: <String, dynamic>{
                                      //       kTransitionInfoKey:
                                      //           TransitionInfo(
                                      //         hasTransition: true,
                                      //         transitionType:
                                      //             PageTransitionType.fade,
                                      //       ),
                                      //     },
                                      //   );
                                      // }

                                      // setState(() {
                                      //   _model.doneSelected = true;
                                      //   _model.completeExercise();

                                      //   if (result != null) {
                                      //     _model.currentSetIndex =
                                      //         int.parse(
                                      //             result.toString());
                                      //   }

                                      //   speakText(
                                      //       _model.getSpeakerExercise());

                                      //   if (_model.timerValue() != null) {
                                      //     _model.timerController =
                                      //         StopWatchTimer(
                                      //             mode: StopWatchMode
                                      //                 .countDown);

                                      //     _model.timerController
                                      //         .setPresetTime(
                                      //             mSec: _model
                                      //                     .timerValue()! *
                                      //                 1000,
                                      //             add: false);

                                      //     ScaffoldMessenger.of(context)
                                      //         .showSnackBar(SnackBar(
                                      //       content: Text(
                                      //         'Prepare-se',
                                      //         style: TextStyle(
                                      //           fontSize: 24,
                                      //           color:
                                      //               FlutterFlowTheme.of(
                                      //                       context)
                                      //                   .primaryText,
                                      //         ),
                                      //       ),
                                      //       duration: Duration(
                                      //           milliseconds: 5000),
                                      //       backgroundColor:
                                      //           FlutterFlowTheme.of(
                                      //                   context)
                                      //               .secondary,
                                      //     ));
                                      //     speakText('Prepare-se');

                                      //     _model.isTimerEnded = false;

                                      //     if (_model.timerValue() !=
                                      //         null) {
                                      //       SchedulerBinding.instance
                                      //           .addPostFrameCallback(
                                      //               (_) async {
                                      //         await Future.delayed(
                                      //             Duration(seconds: 5));
                                      //         speakText('Comece');
                                      //         if (_model.timerValue() !=
                                      //             null) {
                                      //           _model.timerController
                                      //               .onExecute
                                      //               .add(StopWatchExecute
                                      //                   .start);
                                      //         }
                                      //       });
                                      //     }
                                      //   }
                                      // });
                                      //     },
                                      //     text: 'Concluído',
                                      //     options: FFButtonOptions(
                                      //       width: 390.0,
                                      //       height: 60.0,
                                      //       padding:
                                      //           EdgeInsetsDirectional.fromSTEB(
                                      //               0.0, 0.0, 0.0, 0.0),
                                      //       iconPadding:
                                      //           EdgeInsetsDirectional.fromSTEB(
                                      //               0.0, 0.0, 0.0, 0.0),
                                      //       color: FlutterFlowTheme.of(context)
                                      //           .primary,
                                      //       textStyle:
                                      //           FlutterFlowTheme.of(context)
                                      //               .titleSmall
                                      //               .override(
                                      //                 fontFamily: 'Readex Pro',
                                      //                 color: Colors.white,
                                      //               ),
                                      //       elevation: 3.0,
                                      //       borderSide: BorderSide(
                                      //         color: Colors.transparent,
                                      //         width: 1.0,
                                      //       ),
                                      //       borderRadius:
                                      //           BorderRadius.circular(30.0),
                                      //     ),
                                      //   )
                                      : Align(
                                          alignment: Alignment.center,
                                          child: FlutterFlowTimer(
                                            initialTime:
                                                _model.timerValue()! * 1000,
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
                                              final nextExercise =
                                                  _model.getNextExercise();

                                              if (nextExercise == null) {
                                                stopWorkout(stopwatch);
                                                context.pushNamed(
                                                  'CompletedWorkout',
                                                  queryParameters: {
                                                    'workoutId': serializeParam(
                                                      trainingId,
                                                      ParamType.String,
                                                    ),
                                                    'userId': serializeParam(
                                                      userId,
                                                      ParamType.String,
                                                    ),
                                                    'imageUrl': serializeParam(
                                                      imageUrl,
                                                      ParamType.String,
                                                    ),
                                                    'personalImageUrl':
                                                        serializeParam(
                                                      personalImageUrl,
                                                      ParamType.String,
                                                    ),
                                                    'totalSecondsTime':
                                                        serializeParam(
                                                      stopwatch
                                                          .elapsed.inSeconds,
                                                      ParamType.int,
                                                    ),
                                                    'timeString':
                                                        serializeParam(
                                                      _formatTotalTimeString(),
                                                      ParamType.String,
                                                    ),
                                                    'personalId':
                                                        serializeParam(
                                                      personalId,
                                                      ParamType.String,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey:
                                                        TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType:
                                                          PageTransitionType
                                                              .fade,
                                                    ),
                                                  },
                                                );
                                                return;
                                              }

                                              if (!_model.isTimerEnded &&
                                                  _model.showRestInNext()) {
                                                _model.isTimerEnded = true;
                                                speakText('Faça uma pausa.');
                                                final result =
                                                    await context.pushNamed(
                                                  'RestScreen',
                                                  queryParameters: {
                                                    'nextExercise':
                                                        serializeParam(
                                                      nextExercise,
                                                      ParamType.JSON,
                                                    ),
                                                    'personalImageUrl':
                                                        serializeParam(
                                                      personalImageUrl,
                                                      ParamType.String,
                                                    ),
                                                    'workout': serializeParam(
                                                      _model.sets,
                                                      ParamType.JSON,
                                                      true,
                                                    ),
                                                    'restTime': serializeParam(
                                                      _model.getCurrentExercise()[
                                                          'pause'],
                                                      ParamType.int,
                                                    ),
                                                    'changedWorkout':
                                                        serializeParam(
                                                      _model.sets,
                                                      ParamType.JSON,
                                                      true,
                                                    ),
                                                    'currentSetIndex':
                                                        serializeParam(
                                                      _model.currentSetIndex,
                                                      ParamType.int,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey:
                                                        TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType:
                                                          PageTransitionType
                                                              .fade,
                                                    ),
                                                  },
                                                );

                                                setState(() {
                                                  _model.doneSelected = true;
                                                  _model.completeExercise();

                                                  if (result != null) {
                                                    _model.currentSetIndex =
                                                        int.parse(
                                                            result.toString());
                                                  }

                                                  speakText(_model
                                                      .getSpeakerExercise());

                                                  final timerValue =
                                                      _model.timerValue();

                                                  if (timerValue != null) {
                                                    _model.timerController
                                                        .setPresetTime(
                                                            mSec: timerValue *
                                                                1000,
                                                            add: true);

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                        'Prepare-se',
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 5000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ));

                                                    speakText('Prepare-se');

                                                    SchedulerBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) async {
                                                      await Future.delayed(
                                                          Duration(seconds: 5));
                                                      speakText('Comece');
                                                      _model.isTimerEnded =
                                                          false;
                                                      _model.timerController
                                                          .onExecute
                                                          .add(StopWatchExecute
                                                              .start);
                                                    });
                                                  }
                                                });
                                              } else {
                                                setState(() {
                                                  _model.completeExercise();
                                                });
                                              }
                                            },
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .displayLarge
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: _model.timerController
                                                          .isRunning
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  fontSize: 42,
                                                ),
                                          ),
                                        )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTotalTimeString() {
    final elapsedTime = stopwatch.elapsed;
    final hours = elapsedTime.inHours;
    final minutes = elapsedTime.inMinutes.remainder(60);
    final seconds = elapsedTime.inSeconds.remainder(60);

    final formattedTime =
        '$hours:${_formatTwoDigits(minutes)}:${_formatTwoDigits(seconds)}';
    return formattedTime;
  }

  String _formatTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }
}
