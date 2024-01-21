import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class TrainingBottomSheetFilterModel extends FlutterFlowModel {
  ///  Local state fields for this component.

  List<String> selectedLevel = [];
  void addToSelectedLevel(String item) => selectedLevel.add(item);
  void removeFromSelectedLevel(String item) => selectedLevel.remove(item);
  void removeAtIndexFromSelectedLevel(int index) =>
      selectedLevel.removeAt(index);

  List<String> selectedCategory = [];
  void addToSelectedCategory(String item) => selectedCategory.add(item);
  void removeFromSelectedCategory(String item) => selectedCategory.remove(item);
  void removeAtIndexFromSelectedCategory(int index) =>
      selectedCategory.removeAt(index);

  ///  State fields for stateful widgets in this component.

  // State field(s) for ChoiceChips widget.
  List<String>? choiceChipsValues1;
  FormFieldController<List<String>>? choiceChipsValueController1;
  // State field(s) for ChoiceChips widget.
  List<String>? choiceChipsValues2;
  FormFieldController<List<String>>? choiceChipsValueController2;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {}

  /// Additional helper methods are added here.

}
