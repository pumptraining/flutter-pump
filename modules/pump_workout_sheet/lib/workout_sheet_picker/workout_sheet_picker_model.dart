import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

class WorkoutSheetPickerModel extends FlutterFlowModel {
  
  late dynamic content;
  late dynamic objectives;
  late bool pickerEnabled;
  late bool showConfirmAlert;

  int? selectedCheckboxIndex;
  Map<dynamic, bool> checkboxValueMap = {};
  List<dynamic> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  FocusNode? get unfocusNode => null;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
  }

  String mapSkillLevel(String level) {
    switch (level) {
      case "advanced":
        return "Avançado";
      case "intermediate":
        return "Intermediário";
      case "beginner":
        return "Iniciante";
      default:
        return "";
    }
  }

  Color mapSkillLevelColor(String level) {
    switch (level) {
      case "advanced":
        return Color(0xFFEB7F7F);
      case "intermediate":
        return Color(0xFFFFD10F);
      case "beginner":
        return Color(0xFFC4EF19);
      default:
        return Colors.white;
    }
  }

  int calculateTotalWorkoutTime(dynamic workout) {
    if (workout['weeks'] == null) {
      return 0;
    }
    return workout['weeks'].length;
  }

  String objectiveTitle(dynamic workout) {
    final filtered = objectives.where((objective) => objective['_id'] == workout['trainingObjectiveId']).first;
    return filtered['namePortuguese'];
  }
}
