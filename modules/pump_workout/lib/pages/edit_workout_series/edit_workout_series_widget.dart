import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_model.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_widget.dart';
import 'edit_workout_series_model.dart';

class EditWorkoutSeriesWidget extends StatefulWidget {
  const EditWorkoutSeriesWidget(
      {Key? key, this.workout, this.showBottomButton = true})
      : super(key: key);

  final dynamic workout;
  final bool showBottomButton;

  @override
  _EditWorkoutSeriesWidgetState createState() =>
      _EditWorkoutSeriesWidgetState();
}

class _EditWorkoutSeriesWidgetState extends State<EditWorkoutSeriesWidget> {
  late EditWorkoutSeriesModel _model;
  bool addNewSet = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditWorkoutSeriesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.workout['series'] != null) {
        _model.workoutSets = widget.workout['series'];
        safeSetState(() {
          reloadContent(context);
        });
      } else {
        _goToAddExercises(context);
      }
    });
  }

  void _goToAddExercises(BuildContext context) async {
    final dynamic result =
        await context.pushNamed('ListExercises', queryParameters: {
      'showBackButton': serializeParam(true, ParamType.bool),
      'isPicker': serializeParam(true, ParamType.bool)
    });

    if (result != null && result is! bool) {
      setState(() {
        if (_model.workoutSets.isEmpty || addNewSet) {
          _model.addSeriesWithExercises(result);
          addNewSet = false;
        } else {
          _model.addExercisesInSet(result);
        }
        reloadContent(context);
      });
    } else {
      if (_model.workoutSets.isEmpty) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          onPressed: () async {
            _backCall();
          },
        ),
        title: Text(
          'Exercícios',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
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
                  HapticFeedback.mediumImpact();
                  addNewSet = true;
                  _goToAddExercises(context);
                },
              ),
            ),
          ),
        ],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(
                bottom: widget.showBottomButton ? 100 : 0),
            child: SingleChildScrollView(
              child: _model.dataArray.isEmpty
                  ? Container()
                  : EditWorkoutSeriesComponentWidget(
                      workoutSets: _model.workoutSets,
                      dataArray: _model.dataArray,
                      paginatedDataTableController:
                          _model.paginatedDataTableController,
                      onButtonAddExerciseSet: (index) {
                        _model.setIndexToAddExercise = index;
                        _goToAddExercises(context);
                      },
                      onEmptyList: () {
                        Navigator.of(context).pop();
                      },
                    ),
            ),
          ),
          widget.showBottomButton
              ? BottomButtonFixedWidget(
                  buttonTitle: 'Confirmar',
                  onPressed: () async {
                    _backCall();
                  },
                )
              : Container()
        ],
      ),
    );
  }

  void _backCall() {
    if (FocusScope.of(context).focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      return;
    }
    widget.workout['series'] = _model.workoutSets;
    Navigator.of(context).pop(widget.workout);
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

          int tempRep = int.parse(exercise['tempRep']);
          int pause = int.parse(exercise['pause']);

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
