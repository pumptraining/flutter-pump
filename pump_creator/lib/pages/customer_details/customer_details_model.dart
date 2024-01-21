import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:pump_creator/models/tag_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class CustomerDetailsModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  dynamic content;
  bool reloadBack = false;

  // State field(s) for Expandable widget.
  late ExpandableController expandableController1;

  // State field(s) for Expandable widget.
  late ExpandableController expandableController2;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    expandableController1.dispose();
    expandableController2.dispose();
  }

  TagModel tagModelWithId(String tagId) {
    List<dynamic> allTags = content['allTags'];
    final tag = allTags.where((tag) => tag['id'] == tagId).first;
    return TagModel(
        title: tag['title'],
        color: Color(int.parse(tag['color'].substring(1), radix: 16)),
        isSelected: true);
  }

  dynamic filterById(String workoutId) {
    var resultado = content?['workoutWeekDetails'].firstWhere(
        (workout) => workout['workoutId'] == workoutId,
        orElse: () => null);
    return resultado;
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

  bool hasWorkoutDone() {
    if (customerIsBlocked() || customerIsPending() || customerRejectedInvite()) {
      return false;
    }
    return content?['completedWorkoutCount'] != null &&
        content?['completedWorkoutCount'] > 0;
  }

  bool hasActiveSheet() {
    if (customerIsBlocked() || customerIsPending() || customerRejectedInvite()) {
      return false;
    }
    return content?['activeSheet'] != null;
  }

  bool customerIsBlocked() {
    return content?['status'] != null && content?['status'] == 'blocked';
  }

  bool customerIsResistered() {
    return content?['registeredUser'] != null && content?['registeredUser'];
  }

  int tagsCount() {
    int count = content?['userTags'].length;
    if (customerIsBlocked()) {
      return count + 1;
    }
    return count;
  }

  double topSpacingName() {
    if (content != null && content['userTags'] != null && tagsCount() > 0) {
      return 8;
    }
    return 22;
  }

  bool customerIsPending() {
    return content['personalInvite'] != null && content['personalInvite'] == 'pending';
  }

  bool customerRejectedInvite() {
    return content['personalInvite'] != null && content['personalInvite'] == 'rejected';
  }
}
