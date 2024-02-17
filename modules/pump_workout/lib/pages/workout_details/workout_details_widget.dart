import 'dart:io';
import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter_flow/transition_info.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_model.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_widget.dart';
import 'package:pump_components/components/information_bottom_sheet_text/information_bottom_sheet_text_widget.dart';
import 'package:pump_components/components/review_bottom_sheet/review_bottom_sheet_widget.dart';
import 'package:pump_components/components/review_card/review_card_widget.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'workout_details_model.dart';
export 'workout_details_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

class WorkoutDetailsWidget extends StatefulWidget {
  const WorkoutDetailsWidget(
      {Key? key,
      this.workoutId,
      this.userId,
      this.isPersonal,
      this.showMoreButton})
      : super(key: key);

  final String? workoutId;
  final String? userId;
  final bool? isPersonal;
  final bool? showMoreButton;

  @override
  // ignore: library_private_types_in_public_api
  _WorkoutDetailsWidgetState createState() => _WorkoutDetailsWidgetState();
}

class _WorkoutDetailsWidgetState extends State<WorkoutDetailsWidget>
    with TickerProviderStateMixin {
  late WorkoutDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isError = false;
  String workoutId = '';
  String userId = currentUserUid;
  late ApiCallResponse responseContent;
  Color _appBarBackgroundColor = Colors.black;
  bool showMoreButton = true;

  final ScrollController _scrollController = ScrollController();
  double leftPadding = 16.0;
  Color _titleColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutDetailsModel());
    _model.isPersonal = widget.isPersonal ?? false;

    workoutId = widget.workoutId ?? '';
    _loadContent();
    showMoreButton = widget.showMoreButton ?? true;

    if (Platform.isAndroid) {
      leftPadding = 50.0;
    } else {
      _scrollController.addListener(() {
        double old = leftPadding;
        if (_scrollController.offset < kToolbarHeight) {
          leftPadding = 16.0;
          _titleColor = FlutterFlowTheme.of(context).info;
        } else {
          leftPadding = 66.0;
          _titleColor = FlutterFlowTheme.of(context).primaryText;
        }

        if (old != leftPadding) {
          safeSetState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  Future<ApiCallResponse>? _loadContent() async {
    if (_model.content != null) {
      return responseContent;
    }

    isLoading = true;
    isError = false;

    if (workoutId.isEmpty) {
      return ApiCallResponse([], new Map<String, String>(), 0);
    }

    responseContent = await PumpGroup.workoutDetailsCall(trainingId: workoutId);

    if (responseContent.succeeded) {
      isLoading = false;
      isError = false;
      _model.content = responseContent.jsonBody;
      _model.workoutSets = _model.content['series'];
      reloadContent(context);

      setState(() {});
    } else {
      isLoading = false;
      isError = true;
    }
    return responseContent;
  }

  @override
  Widget build(BuildContext context) {
    _appBarBackgroundColor = FlutterFlowTheme.of(context).secondaryBackground;
    return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: FutureBuilder(
            future: _loadContent(),
            builder: (context, snapshot) {
              if (isLoading) {
                return NestedScrollView(
                    headerSliverBuilder: (context, _) => [buildAppBar(context)],
                    body: Scaffold(
                      backgroundColor:
                          FlutterFlowTheme.of(context).primaryBackground,
                      body: Center(
                        child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    ));
              }

              if (isError) {
                return buildErrorColumn(context);
              }

              return Stack(
                children: [
                  buildContent(context),
                  _model.isPersonal
                      ? Container()
                      : BottomButtonFixedWidget(
                          buttonTitle: 'Começar',
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            await context.pushNamed(
                              'HomePage',
                              queryParameters: {
                                'workoutId': serializeParam(
                                  _model.content['workoutId'],
                                  ParamType.String,
                                ),
                                'userId': serializeParam(
                                  userId,
                                  ParamType.String,
                                ),
                              },
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType:
                                      PageTransitionType.bottomToTop,
                                ),
                              },
                            );
                          },
                        )
                ],
              );
            }));
  }

  SliverAppBar buildAppBar(BuildContext context) {
    if (_scrollController.hasClients &&
        _scrollController.offset < kToolbarHeight) {
      _appBarBackgroundColor = FlutterFlowTheme.of(context).secondaryBackground;
    } else {
      _appBarBackgroundColor = FlutterFlowTheme.of(context).primaryBackground;
    }
    return SliverAppBar(
      leading: Container(
        padding: EdgeInsets.all(8.0),
        child: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 20.0,
          fillColor: Platform.isAndroid
              ? FlutterFlowTheme.of(context).secondaryBackground
              : FlutterFlowTheme.of(context).primaryBackground,
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 20.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
      ),
      expandedHeight: MediaQuery.sizeOf(context).height * 0.25,
      pinned: true,
      floating: false,
      snap: false,
      stretch: true,
      backgroundColor: isLoading
          ? FlutterFlowTheme.of(context).secondaryBackground
          : _appBarBackgroundColor,
      automaticallyImplyLeading: true,
      actions: [
        Visibility(
          visible: _model.isPersonal && showMoreButton,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              icon: Icon(
                Icons.edit,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 20.0,
              ),
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  builder: (BuildContext context) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.copy),
                            title: Text('Editar'),
                            onTap: () async {
                              Navigator.pop(context);

                              await context.pushNamed(
                                'AddWorkout',
                                queryParameters: {
                                  'workoutId': serializeParam(
                                    workoutId,
                                    ParamType.String,
                                  )
                                },
                              ).then((value) => safeSetState(() {
                                    if (value == true) {
                                      _model.content = null;
                                      _loadContent();
                                    }
                                  }));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.cancel),
                            title: Text('Cancelar'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.fromLTRB(leftPadding, 16, leftPadding, 16),
        title: AutoSizeText(
          (_model.content != null && _model.content['workoutName'] != null)
              ? _model.content['workoutName']
              : '',
          style: FlutterFlowTheme.of(context)
              .titleLarge
              .override(fontFamily: 'Readex Pro', color: _titleColor),
        ),
        centerTitle: false,
        background: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: (_model.content != null && _model.content['imageUrl'] != null)
              ? CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 500),
                  fadeOutDuration: Duration(milliseconds: 500),
                  imageUrl: _model.content['imageUrl'],
                  fit: BoxFit.cover,
                )
              : null,
        ),
      ),
      centerTitle: false,
      elevation: 1,
    );
  }

  CustomScrollView buildContent(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: [
        buildAppBar(context),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                0, 0, 0, _model.isPersonal ? 32 : 100),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 0.0, 0.0),
                  child: Text(
                    'Sobre',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Visibility(
                  visible: _model.content['description'] != null &&
                      !_model.content['description'].isEmpty,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                    child: Text(
                      _model.content['description'] ?? '',
                      style: FlutterFlowTheme.of(context).labelMedium,
                    ),
                  ),
                ),
                Visibility(
                  visible: !_model.isPersonal,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 2.0),
                    child: GestureDetector(
                      onTap: () {
                        // HapticFeedback.mediumImpact();
                        // context.pushNamed(
                        //   'PersonalProfile',
                        //   queryParameters: {
                        //     'forwardUri': serializeParam(
                        //       'personal/details?personalId=${_model.content['personalId']}&userId=${userId}',
                        //       ParamType.String,
                        //     ),
                        //     'userId': serializeParam(
                        //       userId,
                        //       ParamType.String,
                        //     ),
                        //   }.withoutNulls,
                        //   extra: <String, dynamic>{
                        //     kTransitionInfoKey: TransitionInfo(
                        //       hasTransition: true,
                        //       transitionType:
                        //           PageTransitionType.bottomToTop,
                        //     ),
                        //   },
                        // );
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x33000000),
                              offset: Offset(0.0, 2.0),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    // HapticFeedback.mediumImpact();
                                    // context.pushNamed(
                                    //   'PersonalProfile',
                                    //   queryParameters: {
                                    //     'forwardUri': serializeParam(
                                    //       'personal/details?personalId=${_model.content['personalId']}&userId=${userId}',
                                    //       ParamType.String,
                                    //     ),
                                    //     'userId': serializeParam(
                                    //       userId,
                                    //       ParamType.String,
                                    //     ),
                                    //   }.withoutNulls,
                                    //   extra: <String, dynamic>{
                                    //     kTransitionInfoKey:
                                    //         TransitionInfo(
                                    //       hasTransition: true,
                                    //       transitionType:
                                    //           PageTransitionType
                                    //               .bottomToTop,
                                    //     ),
                                    //   },
                                    // );
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      // HapticFeedback.mediumImpact();
                                      // context.pushNamed(
                                      //   'PersonalProfile',
                                      //   queryParameters: {
                                      //     'forwardUri': serializeParam(
                                      //       'personal/details?personalId=${_model.content['personalId']}&userId=${userId}',
                                      //       ParamType.String,
                                      //     ),
                                      //     'userId': serializeParam(
                                      //       userId,
                                      //       ParamType.String,
                                      //     ),
                                      //   }.withoutNulls,
                                      //   extra: <String, dynamic>{
                                      //     kTransitionInfoKey:
                                      //         TransitionInfo(
                                      //       hasTransition: true,
                                      //       transitionType:
                                      //           PageTransitionType
                                      //               .bottomToTop,
                                      //     ),
                                      //   },
                                      // );
                                    },
                                    child: Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x4CFFFFFF),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4.0,
                                            color: Color(0x33000000),
                                            offset: Offset(0.0, 2.0),
                                          )
                                        ],
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        ),
                                      ),
                                      child: Container(
                                        width: 40.0,
                                        height: 40.0,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: CachedNetworkImage(
                                          fadeInDuration:
                                              Duration(milliseconds: 500),
                                          fadeOutDuration:
                                              Duration(milliseconds: 500),
                                          imageUrl: _model
                                              .content['personalImageUrl'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 16.0, 8.0, 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Criado por',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _model.content['personalName'],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Padding(
                            //   padding: EdgeInsetsDirectional.fromSTEB(
                            //       0.0, 0.0, 16.0, 0.0),
                            //   child: FlutterFlowIconButton(
                            //     borderColor: Colors.transparent,
                            //     borderRadius: 30.0,
                            //     borderWidth: 1.0,
                            //     buttonSize: 40.0,
                            //     fillColor: FlutterFlowTheme.of(context)
                            //         .primaryBackground,
                            //     icon: Icon(
                            //       Icons.arrow_forward,
                            //       color: FlutterFlowTheme.of(context)
                            //           .primaryText,
                            //       size: 20.0,
                            //     ),
                            //     onPressed: () async {
                            //       // HapticFeedback.mediumImpact();
                            //       // context.pushNamed(
                            //       //   'PersonalProfile',
                            //       //   queryParameters: {
                            //       //     'forwardUri': serializeParam(
                            //       //       'personal/details?personalId=${_model.content['personalId']}&userId=${userId}',
                            //       //       ParamType.String,
                            //       //     ),
                            //       //     'userId': serializeParam(
                            //       //       userId,
                            //       //       ParamType.String,
                            //       //     ),
                            //       //   }.withoutNulls,
                            //       //   extra: <String, dynamic>{
                            //       //     kTransitionInfoKey: TransitionInfo(
                            //       //       hasTransition: true,
                            //       //       transitionType: PageTransitionType
                            //       //           .bottomToTop,
                            //       //     ),
                            //       //   },
                            //       // );
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 8.0, 16.0, 8.0),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 750.0,
                                  ),
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
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 16.0, 16.0, 4.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 12.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Icon(
                                                  Icons.timer_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 20.0,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    '${_model.content['workoutTime']}min',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 12.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Icon(
                                                  Icons.bar_chart,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 20.0,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    _model.mapSkillLevel(_model
                                                        .content['level']),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 12.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Icon(
                                                  Icons.pie_chart,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 20.0,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    _model.formatArrayToString(
                                                        _model.content[
                                                            'muscleImpact']),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 12.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Icon(
                                                  Icons.fitness_center,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 20.0,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    _model.formatArrayToString(
                                                        _model.content[
                                                            'equipments']),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: _model.showRating() &&
                                              showMoreButton,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 12.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.star_rate,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 20.0,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      '${_model.content['averageRating']}',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showMoreButton,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Avaliações',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ),
                        Visibility(
                          visible: _model.showRating() && showMoreButton,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    context.pushNamed('ReviewScreen',
                                        queryParameters: {
                                          'workoutId': serializeParam(
                                            _model.content['workoutId'],
                                            ParamType.String,
                                          ),
                                          'personalId': serializeParam(
                                            _model.content['personalId'],
                                            ParamType.String,
                                          ),
                                          'isPersonal': serializeParam(
                                            _model.isPersonal,
                                            ParamType.bool,
                                          ),
                                        });
                                  },
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 16.0, 0.0),
                                    child: Text(
                                      'Ver todas',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                ),
                !showMoreButton
                    ? Container()
                    : _model.showRating()
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 250.0,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 40.0),
                                        child: PageView(
                                          controller: _model
                                                  .pageViewController ??=
                                              PageController(initialPage: 0),
                                          scrollDirection: Axis.horizontal,
                                          children: List.generate(
                                              _model.content['feedbacks']
                                                  .length, (index) {
                                            final feedback = _model
                                                .content['feedbacks'][index];
                                            return ReviewCardWidget(
                                              name: _model
                                                  .getFeedbackName(feedback),
                                              feedback:
                                                  feedback['feedbackText'],
                                              imageUrl: feedback['imageUrl'],
                                              rating: feedback['rating'],
                                            );
                                          }),
                                        ),
                                      ),
                                      Visibility(
                                        visible: _model.content['feedbacks'] !=
                                                null &&
                                            _model.content['feedbacks'].length >
                                                1,
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.00, 1.00),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 0.0, 16.0),
                                            child: smooth_page_indicator
                                                .SmoothPageIndicator(
                                              controller:
                                                  _model.pageViewController ??=
                                                      PageController(
                                                          initialPage: 0),
                                              count: _model
                                                  .content['feedbacks'].length,
                                              axisDirection: Axis.horizontal,
                                              onDotClicked: (i) async {
                                                await _model.pageViewController!
                                                    .animateToPage(
                                                  i,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                              },
                                              effect: smooth_page_indicator
                                                  .ExpandingDotsEffect(
                                                expansionFactor: 3.0,
                                                spacing: 8.0,
                                                radius: 16.0,
                                                dotWidth: 16.0,
                                                dotHeight: 8.0,
                                                dotColor:
                                                    FlutterFlowTheme.of(context)
                                                        .accent2,
                                                activeDotColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                paintStyle: PaintingStyle.fill,
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
                          )
                        : buildEmptyRatingColumn(context),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 6.0),
                        child: Text(
                          'Exercícios',
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.normal,
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
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                        child: Builder(
                          builder: (context) {
                            return EditWorkoutSeriesComponentWidget(
                              workoutSets: _model.workoutSets,
                              dataArray: _model.dataArray,
                              paginatedDataTableController:
                                  _model.paginatedDataTableController,
                              canEdit: false,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ).animateOnPageLoad(Utils.defaultaAnimation),
          ),
        ])),
      ],
    );
  }

  NestedScrollView buildErrorColumn(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [buildAppBar(context)],
      body: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 1),
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
                            setState(() {
                              _loadContent();
                            });
                          },
                          text: 'Tentar novamente',
                          options: FFButtonOptions(
                            width: 170,
                            height: 50,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
      ),
    );
  }

  Center buildEmptyRatingColumn(BuildContext context) {
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
                    Icons.star_border,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 50,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ainda não há avaliações',
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
                    padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            _model.isPersonal
                                ? 'Nenhum aluno deixou uma avaliação para esse treino.'
                                : 'Seja o primeiro a deixar uma avaliação!',
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
                  Visibility(
                    visible: !_model.isPersonal,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 28, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: ReviewBottomSheetWidget(
                                  workoutId: workoutId,
                                  personalId: _model.content['personalId'],
                                ),
                              );
                            },
                          ).then((value) => safeSetState(() {
                                if (value == true) {
                                  _model.content = null;
                                  _loadContent();
                                }
                              }));
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 16.0,
                        ),
                        text: 'Avaliar',
                        options: FFButtonOptions(
                          // width: 170,
                          height: 50,
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Lexend Deca',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                          elevation: 2,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  void reloadContent(BuildContext context) {
    _model.dataArray = [];

    int setIndex = 0;
    _model.workoutSets.toList().forEach((set) {
      int exerciseIndex = 0;
      set['exercises'].toList().forEach((exercise) {
        int index = 0;
        int quantity = 0;

        if (exercise['tempRepArray'] == null) {
          if (set.containsKey('quantity')) {
            dynamic value = set['quantity'];
            if (value is String) {
              quantity = int.tryParse(value) ?? 0;
              set.remove('quantity');
              set['quantity'] = quantity;
            } else {
              quantity = value;
            }
          }

          int tempRep = int.tryParse(exercise['tempRep']) ?? 0;
          int pause = int.tryParse(exercise['pause']) ?? 0;

          String intensity = 'Média';
          if (exercise['intensity'] != null &&
              exercise['intensity'] != 'Moderada') {
            intensity = exercise['intensity'];
          }

          exercise['tempRepArray'] = [tempRep];
          exercise['pauseArray'] = [pause];
          exercise['intensityArray'] = [intensity];
          for (int i = 1; i < quantity; i++) {
            exercise['tempRepArray'].add(tempRep);
            exercise['pauseArray'].add(pause);
            exercise['intensityArray'].add(intensity);
          }
        }

        exercise['tempRepArray'].forEach((reps) {
          final indexCurrent = index;
          final exerciseIndexCurrent = exerciseIndex;
          final setIndexCurrent = setIndex;

          final FormFieldController<String> dropIntensityController =
              FormFieldController<String>('');
          final textRepsController = TextEditingController();
          textRepsController.text = '$reps';
          final textPauseController = TextEditingController();
          textPauseController.text = '${exercise['pauseArray'][indexCurrent]}';

          final data = DropdownData(
              setIndexCurrent,
              exerciseIndexCurrent,
              indexCurrent,
              reps,
              exercise['pauseArray'][indexCurrent],
              exercise['intensityArray'][indexCurrent],
              textPauseController,
              dropIntensityController,
              textRepsController);

          _model.dataArray.add(data);

          index++;
        });

        exerciseIndex++;
      });

      setIndex++;
    });
  }
}
