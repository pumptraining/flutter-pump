import 'package:flutter_flow/flutter_flow_choice_chips.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/form_field_controller.dart';

class WorkoutListModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<dynamic>? workout;
  List<dynamic>? changedWorkout;
  String personalImageUrl = '';
  List<FormFieldController<List<String>>> listChoiceChipsValueController = [];

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  void setChoises() {
    listChoiceChipsValueController = [];
    for (int i = 0; i < workout!.length; i++) {
      listChoiceChipsValueController.add(FormFieldController<List<String>>(
        getChoiceChipsValues(i),
      ));
    }
  }

  List<ChipData> getSetChoices(dynamic listItem) {
    int count = listItem['count'];
    List<ChipData> choices = [];

    for (int i = 1; i <= count; i++) {
      choices.add(ChipData('$i x'));
    }

    return choices;
  }

  String? getTechniqueName(dynamic listItem) {
    dynamic exercise = listItem;

    if (exercise['techniqueName'] != null &&
        exercise['techniqueName'].toString().isNotEmpty) {
      return exercise['techniqueName'];
    }

    return null;
  }

  String? getTechniqueDescription(dynamic listItem) {
    dynamic exercise = listItem;

    if (exercise['techniqueDescription'] != null &&
        exercise['techniqueDescription'].toString().isNotEmpty) {
      return exercise['techniqueDescription'];
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

  String? getPersonalNote(dynamic listItem) {
    dynamic exercise = listItem;

    if (exercise['personalNote'] != null &&
        exercise['personalNote'].toString().isNotEmpty) {
      return exercise['personalNote'];
    }

    return null;
  }

  List<String>? getChoiceChipsValues(int index) {
    List<String> choices = [];

    int completedSets = workout![index]['completedSets'] ?? 0;

    for (int i = 1; i <= completedSets; i++) {
      choices.add('$i x');
    }

    return choices.isNotEmpty ? choices : null;
  }

  void choiseSelectedValue(int index, List<String>? selectedValues) {
    int maxValue = 0;

    if (selectedValues != null) {
      for (String value in selectedValues) {
        int intValue = int.tryParse(value.split(' ')[0]) ?? 0;
        if (intValue > maxValue) {
          maxValue = intValue;
        }
      }
    }

    if (workout![index]['completedSets'] == null) {
      workout![index]['completedSets'] = 0;
    }

    workout![index]['completedSets'] = maxValue;
  }

  bool setIsCompleted(int index) {
    return workout![index]['isDone'] ?? false;
  }
}
