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
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_widget.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
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
                  fillColor: Colors.transparent,
                  icon: Icon(
                    Icons.add_outlined,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24.0,
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
                                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: workoutList.length,
                                    itemBuilder: (context, workoutListIndex) {
                                      final workoutListItem =
                                          workoutList[workoutListIndex];

                                      List<Widget> rowAndDivider = [];

                                      CellListWorkoutWidget cell =
                                          CellListWorkoutWidget(
                                        imageUrl: workoutListItem['imageUrl'],
                                        title: workoutListItem['title'],
                                        subtitle: _model
                                            .objectiveTitle(workoutListItem),
                                        level: _model.mapSkillLevel(
                                            workoutListItem['trainingLevel']),
                                        levelColor: _model.mapSkillLevelColor(
                                            workoutListItem['trainingLevel']),
                                        workoutId: workoutListItem['_id'],
                                        time: _model
                                            .calculateTotalWorkoutTime(
                                                workoutListItem)
                                            .toString(),
                                        isPicker: _model.pickerEnabled,
                                        isSelected:
                                            _model.selectedCheckboxIndex ==
                                                workoutListIndex,
                                        titleImage: 'semanas',
                                        onTap: (p0) {
                                          if (_model.pickerEnabled) {
                                            setState(() {
                                              _model.selectedCheckboxIndex =
                                                  workoutListIndex;
                                            });
                                          } else {
                                            context.pushNamed(
                                              'WorkoutSheetDetails',
                                              queryParameters: {
                                                'workoutId': serializeParam(
                                                  workoutListItem['_id'],
                                                  ParamType.String,
                                                ),
                                                'showStartButton':
                                                    serializeParam(
                                                  false,
                                                  ParamType.bool,
                                                ),
                                                'isPersonal': serializeParam(
                                                  true,
                                                  ParamType.bool,
                                                ),
                                              },
                                            );
                                          }
                                        },
                                        onDetailTap: (p0) {
                                          context.pushNamed(
                                            'WorkoutSheetDetails',
                                            queryParameters: {
                                              'workoutId': serializeParam(
                                                workoutListItem['_id'],
                                                ParamType.String,
                                              ),
                                              'showStartButton': serializeParam(
                                                false,
                                                ParamType.bool,
                                              ),
                                              'isPersonal': serializeParam(
                                                true,
                                                ParamType.bool,
                                              ),
                                            },
                                          );
                                        },
                                      );

                                      rowAndDivider.add(cell);

                                      if (workoutListIndex <
                                          workoutList.length - 1) {
                                        rowAndDivider.add(
                                          Divider(
                                            indent: 106,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            thickness:
                                                1.0, // Espessura do divisor
                                          ),
                                        );
                                      }

                                      return Column(
                                        children: rowAndDivider,
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
