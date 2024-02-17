import 'dart:async';
import 'package:api_manager/api_manager/api_manager.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class ListWorkoutModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for ChoiceChips widget.
  String? choiceChipsValue;
  FormFieldController<List<String>>? choiceChipsValueController;
  // State field(s) for Checkbox widget.
  final unfocusNode = FocusNode();

  Map<String, List<String>?>? selectedFilter;

  Completer<ApiCallResponse>? apiRequestCompleter;

  Map<dynamic, bool> checkboxValueMap = {};
  List<dynamic> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    textController?.dispose();
  }

  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
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

  int calculateTotalWorkoutTime(dynamic workout) {
    int totalSeconds = ((workout['series'] as List<dynamic>).fold<int>(0,
            (partialResult, currentSeries) {
          int seriesTime = calculateSeriesTotalTime(currentSeries);
          return partialResult += seriesTime;
        }) ??
        0);
    final total = totalSeconds ~/ 60;
    return total;
  }

  int calculateSeriesTotalTime(dynamic currentSeries) {
    int setsCount =
        int.tryParse(currentSeries['quantity']?.toString() ?? '1') ?? 1;

    return ((currentSeries['exercises'] as List<dynamic>).fold<int>(0,
            (partialResult, currentExercise) {
          if (currentExercise['pauseArray'] != null) {
            bool isReps = currentExercise['tempRepDescription']
                    .toString()
                    .toLowerCase() ==
                "repetições";
            List<int> pauseArray = currentExercise['pauseArray'].cast<int>();
            List<int> tempRepArray =
                currentExercise['tempRepArray'].cast<int>();
            final time = Utils.calculateTotalTime(
                pauseArray, tempRepArray, isReps ? 4 : 1);
            return partialResult + time;
          } else {
            if (currentExercise['tempRepDescription']
                    .toString()
                    .toLowerCase() ==
                "repetições") {
              int tempRep =
                  int.tryParse(currentExercise['tempRep']?.toString() ?? '0') ??
                      0;
              int pause =
                  int.tryParse(currentExercise['pause']?.toString() ?? '0') ??
                      0;

              if (tempRep >= 0 && tempRep < 12) {
                return ((partialResult ?? 0) + 30 + pause) * setsCount;
              } else if (tempRep >= 12 && tempRep < 15) {
                return ((partialResult ?? 0) + 40 + pause) * setsCount;
              } else if (tempRep >= 15 && tempRep <= 21) {
                return ((partialResult ?? 0) + 50 + pause) * setsCount;
              } else if (tempRep >= 21) {
                return ((partialResult ?? 0) + 90 + pause) * setsCount;
              } else {
                return ((partialResult ?? 0) + pause) * setsCount;
              }
            } else {
              int tempRep =
                  int.tryParse(currentExercise['tempRep']?.toString() ?? '0') ??
                      0;
              int pause =
                  int.tryParse(currentExercise['pause']?.toString() ?? '0') ??
                      0;
              return ((partialResult ?? 0) + tempRep + pause) * setsCount;
            }
          }
        }) ??
        0);
  }

  List<dynamic> filterTrainings(List<dynamic> trainings) {
    if (selectedFilter == null || selectedFilter!.isEmpty) {
      return trainings;
    }

    List<String>? selectedCategories = selectedFilter!['categories'];
    List<String>? selectedLevels = selectedFilter!['level'];

    return trainings.where((training) {
      bool hasMatchingCategory = selectedCategories == null ||
          selectedCategories.isEmpty ||
          selectedCategories.contains(
            training['series']?[0]['exercises']?[0]['exercise']?['category']
                ?['name'],
          );

      bool hasMatchingTrainingLevel = selectedLevels == null ||
          selectedLevels.isEmpty ||
          selectedLevels.contains(mapSkillLevel(training['trainingLevel']));

      return hasMatchingCategory && hasMatchingTrainingLevel;
    }).toList();
  }
}
