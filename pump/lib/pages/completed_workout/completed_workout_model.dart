import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class CompletedWorkoutModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for ChoiceChips widget.
  String? choiceChipsValue;
  FormFieldController<List<String>>? choiceChipsValueController;
  // State field(s) for RatingBar widget.
  double? ratingBarValue;
  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    textController?.dispose();
  }

  int? getIntensity() {
    final result = choiceChipsValue;
    switch (result) {
      case "Baixo":
        return 10;
      case "Moderado":
        return 50;
      case "Alto":
        return 100;
      default:
        return null;
    }
  }

  bool canSendFeedback() {
    return getIntensity() != null || !textController.text.isEmpty || (ratingBarValue != null && ratingBarValue != 0);
  }
}
