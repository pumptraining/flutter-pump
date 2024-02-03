import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  dynamic content;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  bool hasActiveSheet() {
    return content?['activeSheet'] != null;
  }

  bool hasWorkoutDone() {
    return content?['completedWorkoutCount'] != null &&
        content?['completedWorkoutCount'] > 0;
  }

  dynamic getNextWorkout() {
    String nextWorkoutId = content?['nextWorkout'];
    return filterById(nextWorkoutId);
  }

  dynamic getActiveWorkoutSheet() {
    return content?['activeSheet'];
  }

  double getWorkoutSheetPercent() {
    return content?['programProgress'] / 100;
  }

  double getWorkoutWeekPercent() {
    return content?['weekProgress'] / 100;
  }

  bool currentWeekIsLessThan(int index) {
    int current = content?['activeSheet']['currentWeek']['index'];
    return current <= index;
  }

  bool isCurrentWeek(int index) {
    int current = content?['activeSheet']['currentWeek']['index'];
    return current == index;
  }

  bool workoutIsCompleted(String workoutId) {
    var workoutCompleted =
        content?['activeSheet']['currentWeek']['workoutCompleted'] ?? [];
    var resultado = workoutCompleted.firstWhere(
        (workout) => workout['workoutId'] == workoutId,
        orElse: () => null);
    return resultado != null;
  }

  dynamic filterById(String workoutId) {
    var resultado = content?['workoutWeekDetails'].firstWhere(
        (workout) => workout['workoutId'] == workoutId,
        orElse: () => null);
    return resultado;
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

  bool showPersonalInviteHeader() {
    return (content != null && content['personalInvite'] != null) &&
        content['personalInvite']['personalInvite'] == 'pending';
  }

  bool hasPendingPersonalAddWorkout() {
    if (content != null &&
        content['personalInvite'] != null &&
        content['personalInvite']['personalId'] != null &&
        content['personalInvite']['personalId'] != '') {
      return !hasActiveSheet();
    }
    return false;
  }
}
