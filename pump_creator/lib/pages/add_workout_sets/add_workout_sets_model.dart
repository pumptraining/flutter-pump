import 'package:flutter_flow/flutter_flow_model.dart';

import 'package:pump_components/components/edit_exercise/edit_exercise_widget.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class AddWorkoutSetsModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for yourName widget.
  TextEditingController? yourNameController1;
  String? Function(BuildContext, String?)? yourNameController1Validator;
  // State field(s) for CountController widget.
  int? countControllerValue;
  // State field(s) for state widget.
  String? stateValue;
  FormFieldController<String>? stateValueController;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController2;
  String? Function(BuildContext, String?)? yourNameController2Validator;
  // Models for EditExercise dynamic component.
  late FlutterFlowDynamicModels<EditExerciseModel> editExerciseModels;

  dynamic sets;
  List<dynamic>? techniques;

  void initState(BuildContext context) {
    editExerciseModels = FlutterFlowDynamicModels(() => EditExerciseModel());
  }

  void dispose() {
    yourNameController1?.dispose();
    yourNameController2?.dispose();
    editExerciseModels.dispose();
  }

  String setsCountString() {
    if (sets != null) {
      return sets['quantity'];
    }
    return "3";
  }

  List<String> extractStringsFromTechniques() {
    final techniqueArray =
        techniques!.map((jsonObject) => jsonObject['name'] as String).toList();
    techniqueArray.insert(0, 'Sem técnica');
    return techniqueArray;
  }

  String getSelectedTechniqueName() {
    List<dynamic> filteredArray = techniques!.where((jsonObject) {
      String techniqueId = jsonObject['_id'];
      return techniqueId == sets['techniqueId'];
    }).toList();

    if (filteredArray.isEmpty) {
      return "";
    }

    return filteredArray.first['name'] ?? "";
  }

  void setTechniqueBy(String name) {
    if (name == 'Sem técnica') {
      sets['techniqueId'] = "";
    } else {
      dynamic filtered = techniques!
          .where((jsonObject) {
            String techniqueName = jsonObject['name'];
            return techniqueName == name;
          })
          .toList()
          .first;
      sets['techniqueId'] = filtered['_id'];
    }
  }
}
