import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class AddWorkoutSheetPlanModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for yourName widget.
  TextEditingController? yourNameController;
  String? Function(BuildContext, String?)? yourNameControllerValidator;
  // State field(s) for CountController widget.
  int? countControllerValue;

  dynamic workoutPlan;
  List<dynamic>? workouts;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    yourNameController?.dispose();
  }

  void setValues(dynamic workoutPlan, List<dynamic>? workouts) {
    if (workoutPlan == null || workoutPlan['workouts'] == null) {
      workoutPlan = {};
      workoutPlan['workouts'] = [];
      workoutPlan['quantity'] = 4;
      this.workouts = [];
    } else {
      this.workoutPlan = jsonDecode(jsonEncode(workoutPlan));
      this.workouts = jsonDecode(jsonEncode(workouts));
    }
  }

  String getQuantity() {
    return workoutPlan != null ? '${workoutPlan['quantity']}' : '4';
  }

  dynamic filterWorkoutById(String id) {
    dynamic filtered = workouts?.firstWhere((jsonObject) {
      String workoutId = jsonObject['_id'];
      return workoutId == id;
    }, orElse: () => null);
    return filtered;
  }
}
