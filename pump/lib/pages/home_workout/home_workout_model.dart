import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'package:pump/common/map_skill_level.dart';
import 'package:pump_components/components/card_workout_sheet_component/card_workout_sheet_component_widget.dart';

class HomeWorkoutModel extends FlutterFlowModel {
  final unfocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  dynamic homeWorkouts;
  Map filterContent = {};
  bool showFilter = false;
  Map lastFilter = {};

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    textController?.dispose();
  }

  dynamic filteredContent() {
    if (filterContent.isEmpty) {
      return null;
    }
    dynamic filtered;
    if (filterContent['filteredWorkouts'] != null) {
      filtered = [...filterContent['filteredWorkouts']];
    } else {
      if (filterContent['workouts'] != null) {
        filtered = [...filterContent['workouts']];
      } else {
        return filtered;
      }
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
    final levels = ['beginner', 'intermediate', 'advanced'];
    final levelA = levels.indexOf(a['trainingLevel']);
    final levelB = levels.indexOf(b['trainingLevel']);
    return levelA.compareTo(levelB);
  }

  List<CardWorkoutSheetDTO> getWorkoutSheetListDTO() {
    final List<dynamic> dynamicList = homeWorkouts['highlights'];
    return dynamicList.map((item) {
      final level = item['trainingLevel'];
      return CardWorkoutSheetDTO(
          id: item['_id'] as String,
          title: item['namePortuguese'] as String,
          imageUrl: item['trainingImageUrl'] as String,
          circleImageUrl: '',
          tagTitle: WorkoutMap.mapSkillLevel(level),
          tagColor: WorkoutMap.mapSkillLevelColor(level),
          subtitle: WorkoutMap.formatArrayToString(item['muscleImpact']));
    }).toList();
  }

  void mergeFilterContent(Map source) {
    filterContent.addEntries(source.entries);
  }
}
