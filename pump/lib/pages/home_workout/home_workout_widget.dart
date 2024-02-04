import 'package:api_manager/api_manager/api_manager.dart';
import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter_flow/transition_info.dart';
import 'package:pump/flutter_flow/nav/nav.dart';
import '/components/workout_filter_widget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_workout_model.dart';
export 'home_workout_model.dart';

class HomeWorkoutWidget extends StatefulWidget {
  const HomeWorkoutWidget({Key? key}) : super(key: key);

  @override
  _HomeWorkoutWidgetState createState() => _HomeWorkoutWidgetState();
}

class _HomeWorkoutWidgetState extends State<HomeWorkoutWidget>
    with TickerProviderStateMixin {
  late HomeWorkoutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFilterLoading = false;
  bool isFilterError = false;
  dynamic filteredListContent;
  String userId = currentUserUid;

  late bool isLoading;
  late bool isError;
  late ApiCallResponse? _apiResponse;

  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, -70.0),
          end: Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 50.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(50.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation4': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 50.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeWorkoutModel());

    _model.textController ??= TextEditingController();

    isLoading = true;
    isError = false;
    _loadContent();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _loadContent() async {
    ApiCallResponse response = await PumpGroup.homeWorkoutsCall.call();

    if (mounted) {
      setState(() {
        _apiResponse = response;
        isLoading = false;
        isError = !response.succeeded;
        _model.homeWorkouts = response.jsonBody;
      });
    }
  }

  Future<ApiCallResponse>? _loadFilterContent() async {
    isFilterLoading = true;
    isFilterError = false;

    ApiCallResponse response = await PumpGroup.homeWorkoutFilterCall.call();

    if (response.succeeded) {
      isFilterLoading = false;
      isFilterError = false;
    } else {
      isFilterLoading = false;
      isFilterError = true;
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_model.textFieldFocusNode.hasFocus) {
          FocusScope.of(context).requestFocus(_model.unfocusNode);
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Treinos',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                )
              : isError
                  ? buildErrorColumn(context)
                  : _apiResponse != null
                      ? buildContent(context)
                      : Center(
                          child: Text('Nenhum dado disponível.'),
                        ),
        ),
      ),
    );
  }

  Scaffold buildErrorColumn(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 90,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ooops!',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Não foi possível carregar as informações.\nPor favor, tente novamente.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 16,
                                    decoration: TextDecoration.none,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 28, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          HapticFeedback.lightImpact();

                          if (isError) {
                            setState(() {
                              _loadContent();
                            });
                          }

                          if (isFilterError) {
                            setState(() {
                              _loadFilterContent();
                            });
                          }
                        },
                        text: 'Tentar novamente',
                        options: FFButtonOptions(
                          width: 170,
                          height: 50,
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Lexend Deca',
                                    color: FlutterFlowTheme.of(context).info,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                          elevation: 2,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  Center buildEmptyColumn(BuildContext context) {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 32, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 90,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ooops!',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Parece que não encontramos nenhum treino com esses critérios de busca.',
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Outfit',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  SingleChildScrollView buildContent(BuildContext context) {
    dynamic filtered = _model.filteredContent();

    double minHeight = 300;
    double desiredHeight = MediaQuery.of(context).size.height * 0.4;
    double highlightHeight = desiredHeight.clamp(minHeight, double.infinity);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Container(
                  width: 100.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 2.0),
                      )
                    ],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 8.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextFormField(
                            focusNode: _model.textFieldFocusNode,
                            controller: _model.textController,
                            onChanged: (_) => EasyDebounce.debounce(
                                '_model.textController',
                                Duration(milliseconds: 2000), () {
                              setState(() {
                                _model.showFilter = true;
                              });
                            }),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Buscar treino...',
                              labelStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              suffixIcon: _model.textController!.text.isNotEmpty
                                  ? InkWell(
                                      onTap: () async {
                                        _model.textController?.clear();

                                        if (_model
                                                .filterContent['filterCount'] ==
                                            null) {
                                          _model.filterContent = null;
                                        }

                                        if (_model.filterContent == null) {
                                          _model.showFilter = false;
                                        }

                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: Color(0xFF757575),
                                        size: 22.0,
                                      ),
                                    )
                                  : null,
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            validator: _model.textControllerValidator
                                .asValidator(context),
                          ),
                        ),
                        badges.Badge(
                          badgeContent: Text(
                            _model.filterContent == null
                                ? ''
                                : '${_model.filterContent['filterCount']}',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                          ),
                          showBadge: _model.filterContent != null &&
                              _model.filterContent['filterCount'] != null,
                          shape: badges.BadgeShape.circle,
                          badgeColor: FlutterFlowTheme.of(context).error,
                          elevation: 4.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 6.0, 6.0, 6.0),
                          position: badges.BadgePosition.topEnd(),
                          animationType: badges.BadgeAnimationType.scale,
                          toAnimate: true,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 30.0,
                              borderWidth: 1.0,
                              buttonSize: 44.0,
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              icon: Icon(
                                Icons.filter_list,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                              .viewInsets
                                              .top),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.93,
                                      child: WorkoutFilterWidget(
                                        selectedFilter: _model.filterContent,
                                      ),
                                    );
                                  },
                                ).then((value) {
                                  if (value != null) {
                                    if (value['filterCount'] == 0) {
                                      value = null;
                                      _model.showFilter = false;
                                    } else {
                                      _model.showFilter = true;
                                    }

                                    _model.filterContent = value;

                                    setState(() {
                                      _model.textController?.clear();
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          Visibility(
            visible: filtered != null ||
                (_model.textController != null &&
                    _model.textController!.text.isNotEmpty),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
              child: _model.filterContent?['workouts'] != null
                  ? buildFilterList(context)
                  : FutureBuilder<ApiCallResponse>(
                      future: _loadFilterContent(),
                      builder: (context, snapshot) {
                        if (isFilterLoading) {
                          return Center(
                            child: SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          );
                        }

                        if (isFilterError) {
                          return buildErrorColumn(context);
                        }

                        if (_model.filterContent == null) {
                          _model.filterContent = snapshot.data!.jsonBody;
                        }

                        return buildFilterList(context);
                      },
                    ),
            ),
          ),
          Visibility(
            visible: !_model.showFilter,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Text(
                        'Destaques 🔥',
                        style: FlutterFlowTheme.of(context).headlineMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !_model.showFilter,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: highlightHeight,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: ListView(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                  scrollDirection: Axis.horizontal,
                  children:
                      List.generate(_model.homeWorkouts['highlights'].length,
                          (highlightIndex) {
                    dynamic highlight =
                        _model.homeWorkouts['highlights'][highlightIndex];

                    return GestureDetector(
                      onTap: () async {
                        await context.pushNamed(
                          'WorkoutDetails',
                          queryParameters: {
                            'workoutId': serializeParam(
                              highlight['_id'],
                              ParamType.String,
                            ),
                            'userId': serializeParam(
                              userId,
                              ParamType.String,
                            ),
                          },
                        );
                      },
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 8.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x520E151B),
                                offset: Offset(0.0, 2.0),
                              )
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 12.0, 12.0, 12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 1.0,
                                    height:
                                        MediaQuery.sizeOf(context).height * 1.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 2.0),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: CachedNetworkImage(
                                            fadeInDuration:
                                                Duration(milliseconds: 500),
                                            fadeOutDuration:
                                                Duration(milliseconds: 500),
                                            imageUrl:
                                                highlight['trainingImageUrl'],
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                1.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          width: 366.0,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              1.0,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(50, 0, 0, 0),
                                                Color.fromARGB(100, 0, 0, 0)
                                              ],
                                              stops: [0.0, 1.0],
                                              begin: AlignmentDirectional(
                                                  0.0, -1.0),
                                              end: AlignmentDirectional(0, 1.0),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 8.0, 16.0, 16.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    buildLevelTag(highlight[
                                                        'trainingLevel']),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 90.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 6.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1.0, 0.0),
                                                    child: AutoSizeText(
                                                      highlight[
                                                          'namePortuguese'],
                                                      maxLines: 2,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          1.0, 0.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Icon(
                                                            Icons.star_rounded,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .warning,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        6.0,
                                                                        0.0,
                                                                        6.0,
                                                                        0.0),
                                                            child: Text(
                                                              '${(highlight['rating']).toStringAsFixed(1)}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge,
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
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  '${_model.formatArrayToString(highlight['muscleImpact'])} · ${highlight['time']} min',
                                                  maxLines: 2,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
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
                              ],
                            ),
                          ),
                        ),
                      ).animateOnPageLoad(
                          animationsMap['containerOnPageLoadAnimation3']!),
                    );
                  }),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !_model.showFilter,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Text(
                        'Nossos Treinos 🏋️',
                        style: FlutterFlowTheme.of(context).headlineMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !_model.showFilter,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
              child: ListView(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children:
                      List.generate(_model.homeWorkouts['categories'].length,
                          (categoryIndex) {
                    dynamic category =
                        _model.homeWorkouts['categories'][categoryIndex];

                    return Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                      child: Container(
                        width: 170.0,
                        height: 170.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x33000000),
                              offset: Offset(0.0, 2.0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children: [
                            Hero(
                              tag: 'detail',
                              transitionOnUserGestures: true,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 500),
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  imageUrl: category['imageUrl'],
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await context.pushNamed(
                                  'CategoryList',
                                  queryParameters: {
                                    'forwardUri': serializeParam(
                                      category['forwardUri'],
                                      ParamType.String,
                                    ),
                                    'imageUrl': serializeParam(
                                      category['imageUrl'],
                                      ParamType.String,
                                    ),
                                    'categoryName': serializeParam(
                                      category['title'],
                                      ParamType.String,
                                    ),
                                    'userId': serializeParam(
                                      userId,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                    ),
                                  },
                                );
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height: 170.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0x4C1D2428),
                                      Color(0xB1000000)
                                    ],
                                    stops: [0.0, 1.0],
                                    begin: AlignmentDirectional(0.0, -1.0),
                                    end: AlignmentDirectional(0, 1.0),
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 24.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 8.0, 0.0),
                                              child: Text(
                                                category['title'],
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: Colors.white,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 16.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: 24.0,
                                              height: 24.0,
                                              decoration: BoxDecoration(
                                                color: Color(0x66FFFFFF),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 4.0,
                                                    color: Color(0x33000000),
                                                    offset: Offset(0.0, 2.0),
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Icon(
                                                Icons.fitness_center_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .warning,
                                                size: 16.0,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(6.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                '${category['count']} treinos',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleMedium
                                                    .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info),
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
                          ],
                        ),
                      ).animateOnPageLoad(
                          animationsMap['containerOnPageLoadAnimation4']!),
                    );
                  })),
            ),
          ),
        ],
      ),
    );
  }

  ListView buildFilterList(BuildContext context) {
    filteredListContent = null;
    filteredListContent = _model.filteredContent();

    if (filteredListContent.length == 0) {
      return ListView(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [buildEmptyColumn(context)]);
    }

    return ListView(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: filteredListContent == null
          ? []
          : List.generate(filteredListContent.length, (workoutIndex) {
              dynamic workout = filteredListContent[workoutIndex];

              return GestureDetector(
                onTap: () async {
                  await context.pushNamed(
                    'WorkoutDetails',
                    queryParameters: {
                      'workoutId': serializeParam(
                        workout['_id'],
                        ParamType.String,
                      ),
                      'userId': serializeParam(
                        userId,
                        ParamType.String,
                      ),
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            height: 113.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x32000000),
                                  offset: Offset(0.0, 2.0),
                                )
                              ],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 0.0, 0.0),
                                  child: Container(
                                    width: 90.0,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Container(
                                      width: 90.0,
                                      height: 90.0,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              fadeInDuration:
                                                  Duration(milliseconds: 500),
                                              fadeOutDuration:
                                                  Duration(milliseconds: 500),
                                              imageUrl:
                                                  workout['trainingImageUrl'],
                                              width: 90.0,
                                              height: 90.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            width: 90.0,
                                            height: 90.0,
                                            decoration: BoxDecoration(
                                              color: Color(0x331A1F24),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${workout['time']}',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                                lineHeight: 1.0,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'min',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            fontFamily:
                                                                'Readex Pro',
                                                            lineHeight: 1.0,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 12.0, 12.0, 12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  workout['namePortuguese'],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
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
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                child: AutoSizeText(
                                                  _model.mapSkillLevel(
                                                      workout['trainingLevel']),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        color: _model
                                                            .mapSkillLevelBorderColor(
                                                                workout[
                                                                    'trainingLevel']),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 4.0, 0.0, 6.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 4.0, 0.0, 0.0),
                                                  child: AutoSizeText(
                                                    _model.formatArrayToString(
                                                        workout[
                                                            'muscleImpact']),
                                                    maxLines: 2,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
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
                              ],
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation2']!),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
    );
  }

  IntrinsicWidth buildLevelTag(String? level) {
    return IntrinsicWidth(
      child: Container(
        height: 32,
        constraints: BoxConstraints(
          maxHeight: 32,
        ),
        decoration: BoxDecoration(
          color: _model.mapSkillLevelColor(level ?? ''),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x32171717),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _model.mapSkillLevelBorderColor(level ?? ''),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                color: Colors.white,
                size: 20,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                  child: Text(
                    _model.mapSkillLevel(level ?? ''),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Lexend Deca',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
