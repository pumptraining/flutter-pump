import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';

class EditWorkoutModel extends FlutterFlowModel {
  /// Initialization and disposal methods.

  dynamic dto;

  void initState(BuildContext context) {}

  void dispose() {}

  void setValues(dynamic dto) {
    this.dto = dto;
  }

  String mapCategories(dynamic workout) {
    Set<String> muscles = {};

    if (workout['series'] != null) {
      List<dynamic> series = workout['series'];

      for (var seriesItem in series) {
        if (seriesItem['exercises'] != null) {
          List<dynamic> exercises = seriesItem['exercises'];

          for (var exerciseItem in exercises) {
            if (exerciseItem['exercise'] != null &&
                exerciseItem['exercise']['category'] != null &&
                exerciseItem['exercise']['category']['name'] != null) {
              String muscle = exerciseItem['exercise']['category']['name'];
              muscles.add(muscle);
            }
          }
        }
      }
    }

    List<String> uniqueMuscles = muscles.toList();

    return uniqueMuscles.join(' · ');
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
}
