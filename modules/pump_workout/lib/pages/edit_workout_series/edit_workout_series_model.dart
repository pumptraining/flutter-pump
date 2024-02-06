import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';

class EditWorkoutSeriesModel extends FlutterFlowModel {
  List<dynamic> workoutSets = [];

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
      newItem['cadence'] = '3020';
      newItem['pause'] = '60';
      newItem['tempRep'] = '10';

      final set = {
        'exercises': [newItem]
       };

       workoutSets.add(set);
    }
  }
}
