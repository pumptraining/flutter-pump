import 'package:flutter/material.dart';

class WorkoutMap {
  static String mapSkillLevel(String level) {
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

  static Color mapSkillLevelColor(String level) {
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

  static Color mapSkillLevelBorderColor(String level) {
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

  static String getSubtitle(dynamic workout) {
    return '${WorkoutMap.mapSkillLevel(workout['level'])} · ${workout['objective']}';
  }

  static String mapStatus(String status) {
    switch (status) {
      case "active":
        return "Ativo";
      case "canceledByUser":
        return "Cancelado";
      default:
        return "Concluído";
    }
  }

  static Color mapStatusColor(String status) {
    switch (status) {
      case "active":
        return Color(0xFF39D2C0);
      case "canceledByUser":
        return Color(0xFFFF5963);
      default:
        return Color(0xFF1AD155);
    }
  }

  static String formatArrayToString(dynamic items) {
    if (items.length == 0) {
      return '';
    }
    return items.join(' · ');
  }
}
