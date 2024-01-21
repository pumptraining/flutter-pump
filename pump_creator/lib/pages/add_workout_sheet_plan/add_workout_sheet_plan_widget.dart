import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_creator/index.dart';
import 'package:flutter_flow/flutter_flow_count_controller.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:pump_components/components/edit_workout/edit_workout_widget.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'add_workout_sheet_plan_model.dart';
export 'add_workout_sheet_plan_model.dart';

class AddWorkoutSheetPlanWidget extends StatefulWidget {
  const AddWorkoutSheetPlanWidget({
    Key? key,
    this.workoutPlan,
    this.workouts,
  }) : super(key: key);

  final dynamic workoutPlan;
  final List<dynamic>? workouts;

  @override
  _AddWorkoutSheetPlanWidgetState createState() =>
      _AddWorkoutSheetPlanWidgetState();
}

class _AddWorkoutSheetPlanWidgetState extends State<AddWorkoutSheetPlanWidget> {
  late AddWorkoutSheetPlanModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddWorkoutSheetPlanModel());
    _model.setValues(widget.workoutPlan, widget.workouts);

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'AddWorkoutSheetPlan'});
    _model.yourNameController ??=
        TextEditingController(text: _model.getQuantity());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: true,
          title: Text(
            _isEditing ? 'Editar' : 'Adicionar',
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
          child: Stack(
            children: [
              Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 130),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 32.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 16.0, 16.0),
                                  child: TextFormField(
                                    focusNode: _unfocusNode,
                                    maxLength: 2,
                                    buildCounter: (context,
                                        {int? currentLength,
                                        bool? isFocused,
                                        maxLength}) {
                                      return null;
                                    },
                                    controller: _model.yourNameController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Semanas',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              20.0, 24.0, 0.0, 24.0),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    keyboardType: TextInputType.number,
                                    validator: _model
                                        .yourNameControllerValidator
                                        .asValidator(context),
                                    onChanged: (value) {
                                      setState(() {
                                        var valueString =
                                            value.isEmpty ? "0" : value;
                                        _model.workoutPlan['quantity'] =
                                            int.parse(valueString);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 20.0, 16.0),
                                child: Container(
                                  width: 150.0,
                                  height: 64.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: FlutterFlowCountController(
                                    decrementIconBuilder: (enabled) => FaIcon(
                                      FontAwesomeIcons.minus,
                                      color: enabled
                                          ? FlutterFlowTheme.of(context)
                                              .secondaryText
                                          : Color(0xFFEEEEEE),
                                      size: 20.0,
                                    ),
                                    incrementIconBuilder: (enabled) => FaIcon(
                                      FontAwesomeIcons.plus,
                                      color: enabled
                                          ? Colors.blue
                                          : Color(0xFFEEEEEE),
                                      size: 20.0,
                                    ),
                                    countBuilder: (count) => Text(
                                      count.toString(),
                                      style: GoogleFonts.getFont(
                                        'Roboto',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    count: _model.workoutPlan?['quantity'] ?? 4,
                                    updateCount: (count) {
                                      if (_model.workoutPlan == null) {
                                        _model.workoutPlan = {};
                                      }
                                      _model.workoutPlan['quantity'] = count;
                                      _model.yourNameController.text = '$count';

                                      setState(() {});

                                      logFirebaseEvent(
                                          'ADD_WORKOUT_SHEET_PLAN_CountController_0');
                                      logFirebaseEvent(
                                          'CountController_haptic_feedback');
                                      HapticFeedback.lightImpact();
                                    },
                                    stepSize: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              if (_model.workoutPlan == null ||
                                  _model.workoutPlan['workouts'] == null ||
                                  _model.workoutPlan['workouts'].isEmpty) {
                                return EmptyListWidget(
                                  title: 'Sem treinos',
                                  message:
                                      'Nenhum treino adicionado ainda. Adicione os treinos para criar o programa.',
                                  buttonTitle: 'Adicionar',
                                  onButtonPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WorkoutPickerWidget(
                                          showBackButton: true,
                                        ),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        for (var newWorkout in result) {
                                          if (_model.workoutPlan == null) {
                                            _model.workoutPlan = {};
                                          }

                                          if (_model.workoutPlan['workouts'] ==
                                              null) {
                                            _model.workoutPlan['workouts'] = [];
                                          }

                                          if (_model.workouts == null) {
                                            _model.workouts = [];
                                          }

                                          (_model.workoutPlan['workouts']
                                                  as List<dynamic>)
                                              .add(newWorkout['_id']);

                                          (_model.workouts as List<dynamic>)
                                              .add(newWorkout);
                                        }
                                      });
                                    }
                                  },
                                );
                              }
                              return ReorderableListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    _model.workoutPlan['workouts'].length,
                                onReorder: (int oldIndex, int newIndex) {
                                  setState(() {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }

                                    final item = _model.workoutPlan['workouts']
                                        .removeAt(oldIndex);
                                    _model.workoutPlan['workouts']
                                        .insert(newIndex, item);
                                  });
                                },
                                itemBuilder: (context, workoutListIndex) {
                                  final workoutListItem =
                                      _model.workoutPlan['workouts']
                                          [workoutListIndex] as String;
                                  final workoutItem =
                                      _model.filterWorkoutById(workoutListItem);

                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    key: Key(
                                        'Keyz8v_${workoutListIndex}_of_${_model.workoutPlan['workouts']}'),
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            child: EditWorkoutWidget(
                                              key: Key(
                                                  'Keyz8v_${workoutListIndex}_of_${_model.workoutPlan['workouts']}'),
                                              dto: workoutItem,
                                              index: workoutListIndex,
                                              onButtonDeletePressed: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _model
                                                        .workoutPlan['workouts']
                                                        .removeAt(value);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Visibility(
                          visible: _model.workoutPlan != null &&
                              _model.workoutPlan['workouts'] != null &&
                              _model.workoutPlan['workouts'].length > 0,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 12.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                logFirebaseEvent(
                                    'ADD_WORKOUT_SHEET_PLAN_ADICIONAR_BTN_ON_');
                                logFirebaseEvent('Button_navigate_to');

                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutPickerWidget(
                                      showBackButton: true,
                                    ),
                                  ),
                                );

                                if (result != null) {
                                  setState(() {
                                    for (var newWorkout in result) {
                                      (_model.workoutPlan['workouts']
                                              as List<dynamic>)
                                          .add(newWorkout['_id']);

                                      (_model.workouts as List<dynamic>)
                                          .add(newWorkout);
                                    }
                                  });
                                }
                              },
                              text: 'Adicionar',
                              options: FFButtonOptions(
                                width: 130,
                                height: 40,
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                iconPadding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BottomButtonFixedWidget(
                    buttonTitle: 'Salvar',
                    onPressed: () async {
                      if (_unfocusNode.hasFocus) {
                        _unfocusNode.unfocus();
                        return;
                      }

                      if (_model.workoutPlan != null) {
                        _model.workoutPlan['quantity'] =
                            int.parse(_model.yourNameController.text);
                      }
                      Navigator.of(context).pop(
                          [widget.key, _model.workoutPlan, _model.workouts]);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
