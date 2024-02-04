import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_model.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_widget.dart';
import 'package:pump_components/components/training_bottom_sheet_filter/training_bottom_sheet_filter_widget.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'workout_picker_model.dart';
export 'workout_picker_model.dart';

class WorkoutPickerWidget extends StatefulWidget {
  const WorkoutPickerWidget({
    Key? key,
    bool? isPumpList,
    bool? showBackButton,
  })  : this.showBackButton = showBackButton ?? true,
        this.isPumpList = isPumpList ?? false,
        super(key: key);

  final bool isPumpList;
  final bool showBackButton;

  @override
  _WorkoutPickerWidgetState createState() => _WorkoutPickerWidgetState();
}

class _WorkoutPickerWidgetState extends State<WorkoutPickerWidget>
    with TickerProviderStateMixin {
  late WorkoutPickerModel _model;

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

  late String personalId;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutPickerModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'WorkoutPicker'});
    _model.textController ??= TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    personalId =
        widget.isPumpList ? 'Cq3RNV2Qvueil8hbRRrLbd82c0p2' : currentUserUid;
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _unfocusNode.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            !widget.isPumpList ? 'Treinos' : 'Modelos',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                ),
          ),
          actions: [
            Visibility(
              visible: !widget.isPumpList,
              child: Padding(
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
                      context.pushNamed('AddWorkout');
                    },
                  ),
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
                context.pop();
              },
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: FutureBuilder<ApiCallResponse>(
            future: BaseGroup.personalWorkoutCall
                .call(params: {'personalId': personalId}),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
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
              final stackPersonalWorkoutResponse = snapshot.data!;
              return Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, -1.01),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 90.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 32.0, 16.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      focusNode: _unfocusNode,
                                      controller: _model.textController,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.textController',
                                        Duration(milliseconds: 1000),
                                        () => setState(() {}),
                                      ),
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Buscar treino...',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        suffixIcon: _model
                                                .textController!.text.isNotEmpty
                                            ? InkWell(
                                                onTap: () async {
                                                  _model.textController
                                                      ?.clear();
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
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      validator: _model.textControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 0.0, 0.0),
                                    child: FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 30.0,
                                      borderWidth: 1.0,
                                      buttonSize: 44.0,
                                      icon: Icon(
                                        Icons.filter_list,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 24.0,
                                      ),
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'LIST_EXERCISES_filter_list_ICN_ON_TAP');
                                        logFirebaseEvent(
                                            'IconButton_bottom_sheet');
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (bottomSheetContext) {
                                            return GestureDetector(
                                              onTap: () => FocusScope.of(
                                                      context)
                                                  .requestFocus(_unfocusNode),
                                              child: Padding(
                                                padding: MediaQuery.of(
                                                        bottomSheetContext)
                                                    .viewInsets,
                                                child:
                                                    TrainingBottomSheetFilterWidget(),
                                              ),
                                            );
                                          },
                                        ).then((value) {
                                          setState(() {
                                            _model.selectedFilter = value;
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 16.0, 0.0, 16.0),
                              child: Builder(
                                builder: (context) {
                                  var workoutList = getJsonField(
                                    stackPersonalWorkoutResponse.jsonBody,
                                    r'''$''',
                                  ).toList();

                                  _model.workouts = workoutList;

                                  workoutList =
                                      _model.filterTrainings(workoutList);

                                  if (_model.textController.text.isNotEmpty) {
                                    workoutList.retainWhere((exercise) {
                                      return (exercise['namePortuguese']
                                              as String)
                                          .toLowerCase()
                                          .contains(_model.textController.text);
                                    });
                                  }

                                  if (workoutList.isEmpty) {
                                    return EmptyListWidget(
                                      buttonTitle: "Adicionar",
                                      title: "Sem treinos",
                                      message:
                                          "Nenhum treino encontrado.\nAdicione um novo treino.",
                                      onButtonPressed: () {
                                        context.pushNamed('AddWorkout');
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

                                      List<Widget> rowAndDivider = [];

                                      CellListWorkoutWidget cell =
                                          CellListWorkoutWidget(
                                        imageUrl:
                                            workoutListItem['trainingImageUrl'],
                                        title:
                                            workoutListItem['namePortuguese'],
                                        subtitle: _model
                                            .mapCategories(workoutListItem),
                                        level: _model.mapSkillLevel(
                                            workoutListItem['trainingLevel']),
                                        levelColor: _model.mapSkillLevelColor(
                                            workoutListItem['trainingLevel']),
                                        workoutId:
                                            workoutListItem?['_id'] ?? '',
                                        time: _model
                                            .calculateTotalWorkoutTime(
                                                workoutListItem)
                                            .toString(),
                                        isPicker: true,
                                        isSelected: _model.checkboxValueMap[
                                                workoutListItem['_id']] ==
                                            true,
                                        titleImage: 'min',
                                        isSingleSelection: widget.isPumpList,
                                        onTap: (p0) {
                                          if (widget.isPumpList) {
                                            _model.checkboxValueMap = {};
                                          }

                                          final selected =
                                              _model.checkboxValueMap[
                                                      workoutListItem['_id']] ??
                                                  false;

                                          setState(() {
                                            _model.checkboxValueMap[
                                                    workoutListItem['_id']] =
                                                !selected;
                                          });
                                        },
                                        onDetailTap: (p0) {
                                          context.pushNamed(
                                            'WorkoutDetails',
                                            queryParameters: {
                                              'workoutId': serializeParam(
                                                workoutListItem['_id'],
                                                ParamType.String,
                                              ),
                                              'isPersonal': serializeParam(
                                                true,
                                                ParamType.bool,
                                              ),
                                              'showMoreButton': serializeParam(
                                                  !widget.isPumpList,
                                                  ParamType.bool),
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
                                            thickness: 1.0,
                                          ),
                                        );
                                      }

                                      return Column(
                                        children: rowAndDivider,
                                      );
                                    },
                                  ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation1']!);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BottomButtonFixedWidget(
                    buttonTitle: 'Confirmar',
                    onPressed: () async {
                      if (_unfocusNode.hasFocus) {
                        _unfocusNode.unfocus();
                        return;
                      }
                      List<dynamic> checkedItems = [];
                      _model.checkboxCheckedItems.forEach((index) {
                        var workout = _model.workouts.firstWhere(
                          (workout) => workout['_id'] == index,
                          orElse: () => null,
                        );

                        if (workout != null) {
                          checkedItems.add(workout);
                        }
                      });
                      Navigator.pop(context, checkedItems);
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
