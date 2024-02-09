import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_model.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_widget.dart';
import 'edit_workout_series_model.dart';

class EditWorkoutSeriesWidget extends StatefulWidget {
  const EditWorkoutSeriesWidget({Key? key, this.workout}) : super(key: key);

  final dynamic workout;

  @override
  _EditWorkoutSeriesWidgetState createState() =>
      _EditWorkoutSeriesWidgetState();
}

class _EditWorkoutSeriesWidgetState extends State<EditWorkoutSeriesWidget> {
  late EditWorkoutSeriesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditWorkoutSeriesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.workout['sets'] != null) {
        _model.workoutSets = widget.workout['sets'];
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

    if (result != null) {
      setState(() {
        if (_model.workoutSets.isEmpty) {
          _model.addSeriesWithExercises(result);
        }  else {
          _model.addExercisesInSet(result);
        }
        reloadContent(context);
      });
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
            Navigator.of(context).pop();
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
        actions: [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
          child: EditWorkoutSeriesComponentWidget(
        workoutSets: _model.workoutSets,
        dataArray: _model.dataArray,
        paginatedDataTableController: _model.paginatedDataTableController,
        onButtonAddExerciseSet: (index) {
          _model.setIndexToAddExercise = index;
          _goToAddExercises(context);
        },
        onEmptyList: () {
          Navigator.of(context).pop();
        },
      )),
    );
  }

  void reloadContent(BuildContext context) {
    _model.dataArray = [];

    int setIndex = 0;
    _model.workoutSets.toList().forEach((set) {
      int exerciseIndex = 0;
      set['exercises'].toList().forEach((exercise) {
        int index = 0;
        exercise['tempRepArray'].forEach((reps) {
          final indexCurrent = index;
          final exerciseIndexCurrent = exerciseIndex;
          final setIndexCurrent = setIndex;

          final FormFieldController<String> dropPauseController =
              FormFieldController<String>('');
          final FormFieldController<String> dropIntensityController =
              FormFieldController<String>('');
          final textRepsController = TextEditingController();
          textRepsController.text = '$reps';

          final data = DropdownData(
              setIndexCurrent,
              exerciseIndexCurrent,
              indexCurrent,
              reps,
              exercise['pauseArray'][indexCurrent],
              exercise['intensityArray'][indexCurrent],
              dropPauseController,
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
