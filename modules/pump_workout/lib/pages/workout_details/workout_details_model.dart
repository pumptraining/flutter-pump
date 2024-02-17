import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_data_table.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_model.dart';
import 'package:pump_components/components/review_card/review_card_model.dart';

class WorkoutDetailsModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  dynamic content;
  PageController? pageViewController;
  late bool isPersonal;
  List<dynamic> workoutSets = [];
  List<DropdownData> dataArray = [];
  final paginatedDataTableController =
      FlutterFlowDataTableController<dynamic>();

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  // Model for ReviewCard component.
  late ReviewCardModel reviewCardModel1;
  // Model for ReviewCard component.
  late ReviewCardModel reviewCardModel2;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    reviewCardModel1 = createModel(context, () => ReviewCardModel());
    reviewCardModel2 = createModel(context, () => ReviewCardModel());
  }

  void dispose() {
    unfocusNode.dispose();
    reviewCardModel1.dispose();
    reviewCardModel2.dispose();
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

  String formatArrayToString(dynamic items) {
    if (items.length == 0) {
      return 'Sem equipamento';
    }
    return items.join(' · ');
  }

  String? getTechniqueName(dynamic listItem) {
    dynamic exercise = listItem;

    if (exercise['techniqueName'] != null &&
        exercise['techniqueName'].toString().isNotEmpty) {
      return exercise['techniqueName'];
    }

    return null;
  }

  String? getPersonalNote(dynamic listItem) {
    dynamic exercise = listItem;

    if (exercise['personalNote'] != null &&
        exercise['personalNote'].toString().isNotEmpty) {
      return exercise['personalNote'];
    }

    return null;
  }

  String getExerciseTitle(dynamic listItem) {
    final exercise = listItem;

    if (exercise['rep'] != null && exercise['rep'].toString().isNotEmpty) {
      return '${exercise['rep']}x ${exercise['title']}';
    }
    return '${exercise['seconds']}s ${exercise['title']}';
  }

  String getExerciseSubtitle(dynamic listItem) {
    final exercise = listItem;

    if (exercise['equipment'] != null &&
        exercise['equipment'].toString().isNotEmpty) {
      return exercise['equipment'];
    }

    return 'Sem equipamento';
  }

  String textLimit(String text, int limit) {
    if (text.length <= limit) {
      return text;
    } else {
      return text.substring(0, limit) + "... ver mais";
    }
  }

  String? getTechniqueDescription(dynamic listItem) {
    dynamic exercise = listItem;

    if (exercise['techniqueDescription'] != null &&
        exercise['techniqueDescription'].toString().isNotEmpty) {
      return exercise['techniqueDescription'];
    }

    return null;
  }

  String getFeedbackName(dynamic feedback) {
    if (feedback['name'] != null && feedback['name'].isNotEmpty) {
      return feedback['name'];
    } else if (feedback['email'] != null && feedback['email'].isNotEmpty) {
      final email = feedback['email'];
      int indexOfAtSymbol = email.indexOf('@');
      if (indexOfAtSymbol != -1) {
        String username = email.substring(0, indexOfAtSymbol);
        return username;
      }
    }
    return "Usuário";
  }

  bool showRating() {
    return content['feedbacks'] != null && content['feedbacks'].length > 0;
  }
}
