import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

class UserPurchaseWorkoutSheetModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  dynamic content;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  bool canShowUserPrograms() {
    return content != null &&
        content['userTrainingSheets'] != null &&
        content['userTrainingSheets'] == true;
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
        return Color(0xFFEB7F7F).withOpacity(0.3);
      case "intermediate":
        return Color(0xFFFFD10F).withOpacity(0.3);
      case "beginner":
        return Color(0xFFC4EF19).withOpacity(0.3);
      default:
        return Colors.white.withOpacity(0.3);
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
}
