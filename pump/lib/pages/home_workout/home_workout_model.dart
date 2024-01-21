import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

class HomeWorkoutModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  dynamic homeWorkouts;
  dynamic filterContent;
  bool showFilter = false;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    textController?.dispose();
  }

  String formatArrayToString(dynamic items) {
    if (items.length == 0) {
      return '';
    }
    return items.join(' · ');
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

  dynamic filteredContent() {
    if (filterContent == null) {
      return null;
    }
    dynamic filtered;
    if (filterContent['filteredWorkouts'] != null) {
      filtered = [...filterContent['filteredWorkouts']];
    } else {
      filtered = [...filterContent['workouts']];
    }

    if (textController != null && textController!.text.isNotEmpty) {
      filtered.retainWhere((workout) {
        return (workout['namePortuguese'] as String)
            .toLowerCase()
            .contains(textController!.text.toLowerCase());
      });
    }

    filtered.sort(compareByLevel);

    return filtered;
  }

  int compareByLevel(dynamic a, dynamic b) {
    // Valores possíveis para o nível
    final levels = ['beginner', 'intermediate', 'advanced'];

    // Obtém o índice do nível de cada workout na lista de levels
    final levelA = levels.indexOf(a['trainingLevel']);
    final levelB = levels.indexOf(b['trainingLevel']);

    // Compara os índices para determinar a ordem de classificação
    return levelA.compareTo(levelB);
  }
}
