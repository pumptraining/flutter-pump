import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';

class CategoryListModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  dynamic workouts;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

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

  int compareByLevel(dynamic a, dynamic b) {
    // Valores possíveis para o nível
    final levels = ['beginner', 'intermediate', 'advanced'];

    // Obtém o índice do nível de cada workout na lista de levels
    final levelA = levels.indexOf(a['level']);
    final levelB = levels.indexOf(b['level']);

    // Compara os índices para determinar a ordem de classificação
    return levelA.compareTo(levelB);
  }
}
