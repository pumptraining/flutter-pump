import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:flutter_flow/common/user_settings.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:go_router/go_router.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pump_components/components/information_dialog/information_dialog_widget.dart';
import 'package:pump_components/components/subscribe_screen/subscribe_screen_widget.dart';
import 'package:pump_workout_sheet/workout_sheet_picker/workout_sheet_picker_model.dart';
import 'package:aligned_dialog/aligned_dialog.dart';

class WorkoutSheetPickerWidget extends StatefulWidget {
  const WorkoutSheetPickerWidget(
      {Key? key,
      this.setupExercises,
      bool? showBackButton,
      this.customerId,
      this.pickerEnabled,
      this.showConfirmAlert})
      : showBackButton = showBackButton ?? true,
        super(key: key);

  final List<dynamic>? setupExercises;
  final bool showBackButton;
  final String? customerId;
  final bool? pickerEnabled;
  final bool? showConfirmAlert;

  @override
  _WorkoutSheetPickerWidgetState createState() =>
      _WorkoutSheetPickerWidgetState();
}

class _WorkoutSheetPickerWidgetState extends State<WorkoutSheetPickerWidget>
    with TickerProviderStateMixin {
  late WorkoutSheetPickerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  final animationsMap = {
    'textOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: Offset(-60.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation1': AnimationInfo(
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
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 240.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 330.ms,
          duration: 600.ms,
          begin: Offset(0.0, 90.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  final ApiLoaderController _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutSheetPickerModel());
    _model.pickerEnabled = widget.pickerEnabled ?? true;
    _model.showConfirmAlert = widget.showConfirmAlert ?? true;

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  void showSubscribeScreen(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
            height: MediaQuery.of(context).size.height,
            child: SubscribeScreenWidget(),
          );
        }).then((value) => {
          if (value != null && value) {context.pushNamed('Home')}
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Programas',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 20.0,
                  borderWidth: 1.0,
                  buttonSize: 40.0,
                  fillColor: FlutterFlowTheme.of(context).primary,
                  icon: Icon(
                    Icons.add_outlined,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  onPressed: () async {
                    if (_model.content != null) {
                      if (!UserSettings().isSubscriber() &&
                          _model.content.length >= 2) {
                        showSubscribeScreen(context);
                      } else {
                        context.pushNamed('AddWorkoutSheet').then((value) {
                          if (value != null && value is bool && value) {
                            _apiLoaderController.reload?.call();
                          }
                        });
                      }
                    }
                  },
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
          leading: Container(
            padding: EdgeInsets.all(8.0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 20.0,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 20.0,
              ),
              onPressed: () async {
                context.pop(true);
              },
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: ApiLoaderWidget(
            apiCall: BaseGroup.personalWorkoutSheetsCall,
            controller: _apiLoaderController,
            builder: (context, snapshot) {
              if (snapshot == null) {
                return Container();
              }
              final stackPersonalWorkoutResponse = snapshot.data;
              _model.content =
                  stackPersonalWorkoutResponse?.jsonBody['workoutSheets'];
              _model.objectives =
                  stackPersonalWorkoutResponse?.jsonBody['objectives'];
              return Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, -1.01),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0,
                          _model.selectedCheckboxIndex != null ? 90.0 : 0.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 16.0),
                              child: Builder(
                                builder: (context) {
                                  var workoutList = _model.content;

                                  if (workoutList.isEmpty) {
                                    return EmptyListWidget(
                                      buttonTitle: "Adicionar",
                                      title: "Sem programas",
                                      message:
                                          "Nenhum programa encontrado.\nAdicione um novo programa.",
                                      onButtonPressed: () {
                                        if (!UserSettings().isSubscriber() &&
                                            _model.content.length >= 2) {
                                          showSubscribeScreen(context);
                                        } else {
                                          context
                                              .pushNamed('AddWorkoutSheet')
                                              .then((value) {
                                            if (value != null &&
                                                value is bool &&
                                                value) {
                                              _apiLoaderController.reload
                                                  ?.call();
                                            }
                                          });
                                        }
                                      },
                                    );
                                  }
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: workoutList.length,
                                    itemBuilder: (context, workoutListIndex) {
                                      final workoutListItem =
                                          workoutList[workoutListIndex];

                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 4.0, 16.0, 8.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (_model.pickerEnabled) {
                                                    setState(() {
                                                      _model.selectedCheckboxIndex =
                                                          workoutListIndex;
                                                    });
                                                  } else {
                                                    context.pushNamed(
                                                      'WorkoutSheetDetails',
                                                      queryParameters: {
                                                        'workoutId':
                                                            serializeParam(
                                                          workoutListItem[
                                                              '_id'],
                                                          ParamType.String,
                                                        ),
                                                        'showStartButton':
                                                            serializeParam(
                                                          false,
                                                          ParamType.bool,
                                                        ),
                                                        'isPersonal':
                                                            serializeParam(
                                                          true,
                                                          ParamType.bool,
                                                        ),
                                                      },
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 113.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 4.0,
                                                        color:
                                                            Color(0x32000000),
                                                        offset:
                                                            Offset(0.0, 2.0),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 0.0,
                                                                8.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          width: 90.0,
                                                          height: 90.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                          ),
                                                          child: Container(
                                                            width: 90.0,
                                                            height: 90.0,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: workoutListItem[
                                                                              'imageUrl'] !=
                                                                          null
                                                                      ? CachedNetworkImage(
                                                                          imageUrl:
                                                                              workoutListItem['imageUrl'],
                                                                          width:
                                                                              90.0,
                                                                          height:
                                                                              90.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : Container(
                                                                          width:
                                                                              90.0,
                                                                          height:
                                                                              90.0,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground),
                                                                ),
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child:
                                                                      Container(
                                                                    width: 90.0,
                                                                    height:
                                                                        90.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0x331A1F24),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
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
                                                                              _model.calculateTotalWorkoutTime(workoutListItem).toString(),
                                                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    lineHeight: 1.0,
                                                                                    color: Colors.white,
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
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(6, 0, 6, 0),
                                                                              child: AutoSizeText(
                                                                                'semanas',
                                                                                maxLines: 1,
                                                                                minFontSize: 8,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      lineHeight: 1.0,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
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
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            12.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              AutoSizeText(
                                                                            workoutListItem['title'],
                                                                            style:
                                                                                FlutterFlowTheme.of(context).bodyMedium,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            AutoSizeText(
                                                                          _model
                                                                              .objectiveTitle(workoutListItem),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: 'Poppins',
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          12.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              4.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              AutoSizeText(
                                                                            _model.mapSkillLevel(workoutListItem['trainingLevel']),
                                                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  color: _model.mapSkillLevelColor(workoutListItem['trainingLevel']),
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
                                                        if (widget
                                                            .showBackButton)
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        12.0,
                                                                        0.0,
                                                                        12.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Visibility(
                                                                  visible: _model
                                                                      .pickerEnabled,
                                                                  child: Theme(
                                                                    data:
                                                                        ThemeData(
                                                                      checkboxTheme:
                                                                          CheckboxThemeData(
                                                                        shape:
                                                                            CircleBorder(),
                                                                      ),
                                                                      unselectedWidgetColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .primaryBackground,
                                                                    ),
                                                                    child:
                                                                        Checkbox(
                                                                      value: _model
                                                                              .selectedCheckboxIndex ==
                                                                          workoutListIndex,
                                                                      onChanged:
                                                                          (newValue) async {
                                                                        setState(
                                                                            () {
                                                                          if (newValue != null &&
                                                                              newValue) {
                                                                            _model.selectedCheckboxIndex =
                                                                                workoutListIndex;
                                                                          } else {
                                                                            _model.selectedCheckboxIndex =
                                                                                null;
                                                                          }
                                                                        });
                                                                      },
                                                                      activeColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .primary,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible: _model
                                                                      .pickerEnabled,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            4.0,
                                                                            0.0),
                                                                    child:
                                                                        FFButtonWidget(
                                                                      onPressed:
                                                                          () {
                                                                        context
                                                                            .pushNamed(
                                                                          'WorkoutSheetDetails',
                                                                          queryParameters: {
                                                                            'workoutId':
                                                                                serializeParam(
                                                                              workoutListItem['_id'],
                                                                              ParamType.String,
                                                                            ),
                                                                            'showStartButton':
                                                                                serializeParam(
                                                                              false,
                                                                              ParamType.bool,
                                                                            ),
                                                                            'isPersonal':
                                                                                serializeParam(
                                                                              true,
                                                                              ParamType.bool,
                                                                            ),
                                                                          },
                                                                        );
                                                                      },
                                                                      text:
                                                                          'visualizar',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width:
                                                                            70.0,
                                                                        height:
                                                                            34.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              fontSize: 12,
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
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
                                              ).animateOnPageLoad(animationsMap[
                                                  'containerOnPageLoadAnimation1']!),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _model.selectedCheckboxIndex != null,
                    child: BottomButtonFixedWidget(
                      buttonTitle: 'Confirmar',
                      onPressed: () async {
                        if (_model.showConfirmAlert) {
                          await showAlignedDialog(
                            context: context,
                            isGlobal: true,
                            avoidOverflow: false,
                            targetAnchor: AlignmentDirectional(0.0, 0.0)
                                .resolve(Directionality.of(context)),
                            followerAnchor: AlignmentDirectional(0.0, 0.0)
                                .resolve(Directionality.of(context)),
                            builder: (dialogContext) {
                              return Material(
                                color: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () => FocusScope.of(context)
                                      .requestFocus(_model.unfocusNode),
                                  child: InformationDialogWidget(
                                    title: 'Atenção',
                                    message:
                                        'O programa atual será encerrado. Tem certeza que deseja adicionar o novo programa e encerrar o atual?',
                                    actionButtonTitle: 'Encerrar',
                                  ),
                                ),
                              );
                            },
                          ).then(
                            (value) async {
                              if (value == 'leave') {
                                await userStartWorkoutSheet();
                              }
                            },
                          );
                        } else {
                          await userStartWorkoutSheet();
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> userStartWorkoutSheet() async {
    final workout = _model.content[_model.selectedCheckboxIndex];
    final response = await PumpGroup.userStartedWorkoutSheetCall.call(params: {
      'trainingSheetId': workout['_id'],
      'customerId': widget.customerId
    });

    if (response.succeeded) {
      context.pop(true);
    } else {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Ooops'),
            content:
                Text('Ocorreu um erro inesperado. Por favor, tente novamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }
}
