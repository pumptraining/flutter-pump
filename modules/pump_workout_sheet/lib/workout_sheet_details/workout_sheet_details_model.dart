import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

class WorkoutSheetDetailsModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  dynamic content;
  late bool isPersonal;

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
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

  Color mapSkillLevelBorderColor(String level) {
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

  String formatArrayToString(dynamic items) {
    if (items.length == 0) {
      return '';
    }
    return items.join(' · ');
  }
}
