import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class EditExerciseModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for ChoiceChips widget.
  String? choiceChipsValue;
  FormFieldController<List<String>>? choiceChipsValueController;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController1;
  String? Function(BuildContext, String?)? yourNameController1Validator;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController2;
  String? Function(BuildContext, String?)? yourNameController2Validator;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController3;
  String? Function(BuildContext, String?)? yourNameController3Validator;

  List<String> secOrRepsTags = [
    'Repetições',
    'Segundos',
  ];

  List<String> intensityTags = [
    'Leve',
    'Moderada',
    'Alta',
  ];

  void initState(BuildContext context) {}

  void dispose() {
    yourNameController1?.dispose();
    yourNameController2?.dispose();
    yourNameController3?.dispose();
  }

  String getPlaceholderText() {
    if (choiceChipsValue != null) {
      return choiceChipsValue!;
    }
    return "Repetições";
  }
}
