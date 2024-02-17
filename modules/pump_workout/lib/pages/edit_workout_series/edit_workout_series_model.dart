import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_data_table.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_model.dart';

class EditWorkoutSeriesModel extends FlutterFlowModel {
  final paginatedDataTableController =
      FlutterFlowDataTableController<dynamic>();
  List<dynamic> workoutSets = [];
  List<DropdownData> dataArray = [];
  int setIndexToAddExercise = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  void addSeriesWithExercises(dynamic exercises) {
    if (exercises is bool) {
      return;
    }
    for (var newExercise in exercises) {
      dynamic newItem = {};
      newExercise['videoUrl'] = null;
      newExercise['streamingURL'] = null;
      newExercise['personalId'] = null;
      newItem['exercise'] = newExercise;
      newItem['tempRepDescription'] = 'Repetições';
      newItem['pauseArray'] = [60, 60, 60];
      newItem['tempRepArray'] = [10, 10, 10];
      newItem['intensityArray'] = ['-', '-', '-'];

      final set = {
        'quantity': 3,
        'exercises': [newItem]
      };

      workoutSets.add(set);
    }
  }

  void addExercisesInSet(dynamic exercises) {
    if (exercises is bool) {
      return;
    }
    for (var newExercise in exercises) {
      dynamic newItem = {};
      newExercise['videoUrl'] = null;
      newExercise['streamingURL'] = null;
      newExercise['personalId'] = null;
      newItem['exercise'] = newExercise;
      newItem['tempRepDescription'] = 'Repetições';

      newItem['pauseArray'] = [60];
      newItem['tempRepArray'] = [10];
      newItem['intensityArray'] = ['-'];

      for (int i = 1; workoutSets[setIndexToAddExercise]['quantity'] > i; i++) {
        newItem['pauseArray'].add(60);
        newItem['tempRepArray'].add(10);
        newItem['intensityArray'].add('-');
      }

      workoutSets[setIndexToAddExercise]['exercises'].add(newItem);
    }
  }
}
