import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pump/common/map_skill_level.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomePageModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  FlutterTts flutterTts = FlutterTts();
  List<dynamic> originalFormatSets = [];
  List<dynamic> copyOriginalFormatSets = [];
  List<dynamic> sets = [];
  List<dynamic> copySets = [];
  int currentSetIndex = 0;
  int currentExerciseIndex = 0;
  bool isTimerEnded = false;
  bool personalNoteSelected = false;
  bool doneSelected = true;
  dynamic workout;

  StopWatchTimer timerController =
      StopWatchTimer(mode: StopWatchMode.countDown);

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    sets = [];
    copySets = [];
  }

  void setWorkout(dynamic workoutResponse, BuildContext context) {
    if (sets.isEmpty) {
      originalFormatSets = workoutResponse;
      copyOriginalFormatSets = deepCopy(originalFormatSets);
      sets = modifyJson(workoutResponse);
      copySets = deepCopy(sets);
      currentSetIndex = findNextUndoneSetIndex(sets);
      currentExerciseIndex = getCurrentExerciseIndex();

      if (timerValue() != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(seconds: 1));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Prepare-se',
              style: TextStyle(
                fontSize: 24,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ));

          await Future.delayed(Duration(seconds: 5));
          timerController.onExecute.add(StopWatchExecute.start);
        });
      }
    }
  }

  List<dynamic> deepCopy(List<dynamic> source) {
    return source.map((e) => deepCopyMap(e)).toList();
  }

  dynamic deepCopyMap(Map<String, dynamic> source) {
    final Map<String, dynamic> copy = {};

    source.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        copy[key] = deepCopyMap(value);
      } else if (value is List<dynamic>) {
        copy[key] = deepCopyList(value);
      } else {
        copy[key] = value;
      }
    });

    return copy;
  }

  List<dynamic> deepCopyList(List<dynamic> source) {
    return source.map((e) {
      if (e is Map<String, dynamic>) {
        return deepCopyMap(e);
      } else if (e is List<dynamic>) {
        return deepCopyList(e);
      } else {
        return e;
      }
    }).toList();
  }

  List<dynamic> modifyJson(dynamic originalJson) {
    List<Map<String, dynamic>> modifiedSets = [];

    for (var set in originalJson) {
      int count = set['count'];
      String? personalNote = set['personalNote'];
      List<Map<String, dynamic>> modifiedExercises = [];

      List<dynamic> exercises = set['exercises'];
      int exerciseCount = exercises.length;

      for (var i = 0; i < count; i++) {
        for (var j = 0; j < exerciseCount; j++) {
          var exercise = exercises[j];

          String intensity = '';
          if (exercise['intensityArray'] != null) {
            intensity = exercise['intensityArray'][i];
          }

          int reps = 0;
          int seconds = 0;
          if (exercise['tempRepArray'] != null) {
            reps = exercise['tempRepArray'][i];
            seconds = exercise['tempRepArray'][i];
          } else {
            reps = exercise['rep'];
            seconds = exercise['seconds'];
          }

          int pause = 0;
          if (exercise['pauseArray'] != null) {
            pause = exercise['pauseArray'][i];
          } else {
            pause = exercise['pause'];
          }

          modifiedExercises.add({
            'intensity': intensity,
            'category': exercise['category'],
            'rep': reps,
            'repDescription': exercise['repDescription'],
            'seconds': seconds,
            'pause': pause,
            'weightType': exercise['weightType'],
            'imageUrl': exercise['imageUrl'],
            'videoUrl': exercise['videoUrl'],
            'oldVideoUrl': exercise['oldVideoUrl'],
            'personalNote': exercise['personalNote'],
            'title': exercise['title'],
            'isDone': exercise['isDone'] ?? false,
            'techniqueName': exercise['techniqueName'],
            'techniqueDescription': exercise['techniqueDescription'],
            'cadence': exercise['cadence'],
            'equipment': exercise['equipment'],
          });
        }
      }

      modifiedSets.add({
        'count': count,
        'personalNote': personalNote,
        'exercises': modifiedExercises,
        'index': modifiedSets.length,
        'isDone': set['isDone'] ?? false,
      });
    }

    return modifiedSets;
  }

  String getCurrentExercisePause() {
    final exercise = getCurrentExercise();
    if (exercise['pause'] != null) {
      return '${exercise['pause']}s de descanso';
    }
    return 'sem descanso';
  }

  dynamic getCurrentExercise() {
    if (sets.isEmpty) {
      return null;
    }
    dynamic currentSet = sets[currentSetIndex];

    final index = getCurrentExerciseIndex();
    if (index != -1) {
      dynamic currentExercise = currentSet['exercises'][index];
      return currentExercise;
    }

    currentSetIndex = findNextUndoneSetIndex(sets);
    currentSet = sets[currentSetIndex];
    var exercises = currentSet['exercises'];
    for (var exercise in exercises) {
      if ((exercise['isDone'] ?? false) == false) {
        return exercise;
      }
    }

    return null;
  }

  String getExerciseTitle() {
    final exercise = getCurrentExercise();
    if (exercise == null) {
      return '';
    }

    if (exercise['rep'] != null && exercise['rep'].toString().isNotEmpty) {
      return '${exercise['rep']}x ${exercise['title']}';
    }
    return '${exercise['seconds']}s ${exercise['title']}';
  }

  String getSpeakerExercise() {
    final exercise = getCurrentExercise();

    if (exercise == null) {
      return '';
    }

    if (exercise['rep'] != null && exercise['rep'].toString().isNotEmpty) {
      return '${exercise['rep']} repetições ${exercise['title']}';
    }
    return '${exercise['seconds']} segundos ${exercise['title']}';
  }

  bool showRestInNext() {
    return false;
  }

  bool showRest() {
    final exercise = getCurrentExercise();

    if (exercise == null) {
      return false;
    }

    int value = 0;
    if (exercise['pause'] != null) {
      value = exercise['pause'];
    }
    return value != 0;
  }

  String getNextExerciseTitle() {
    final exercise = getNextExercise();

    if (exercise == null) {
      return 'Conclusão';
    }

    if (showRestInNext()) {
      final current = getCurrentExercise();
      return '${current['pause']}s';
    }

    if (exercise['rep'] != null && exercise['rep'].toString().isNotEmpty) {
      return '${exercise['rep']}x ${exercise['title']}';
    }
    return '${exercise['seconds']}s ${exercise['title']}';
  }

  String getNextExerciseSubtitle() {
    return 'próximo';
  }

  dynamic getNextExercise() {
    if (sets.isEmpty) {
      return null;
    }

    int currentExercise = getCurrentExerciseIndex();
    int nextExerciseIndex = currentExercise + 1;
    int nextSetIndex = currentSetIndex;

    var currentSet = sets[currentSetIndex];

    bool allExercisesInSetDone = false;
    int exerciseCount = currentSet['exercises'].length;
    for (var i = 0; i < exerciseCount - 1; i++) {
      var exercise = currentSet['exercises'][i];
      if (exercise['isDone']) {
        allExercisesInSetDone = true;
      } else {
        allExercisesInSetDone = false;
      }
    }

    if (allExercisesInSetDone) {
      int nextUndoneIndex = findNextUndoneSetIndexDifferentCurrent(sets);
      if (nextUndoneIndex != -1) {
        nextExerciseIndex = 0;
        nextSetIndex = nextUndoneIndex;
      } else {
        print('Todos os elementos estão concluídos');
        return null;
      }
    }

    var nextSet = sets[nextSetIndex];

    if (nextSet['exercises'].length == 1) {
      nextExerciseIndex = 0;
    }

    var nextExercise = nextSet['exercises'][nextExerciseIndex];
    return nextExercise;
  }

  int findNextUndoneSetIndexDifferentCurrent(List<dynamic> sets) {
    for (int i = 0; i < sets.length; i++) {
      if (sets[i]['isDone'] == false && i != currentSetIndex) {
        return i;
      }
    }
    return -1;
  }

  String calculateCompletionPercentage() {
    int totalExercises = 0;
    int completedExercises = 0;

    for (var set in sets) {
      for (var exercise in set['exercises']) {
        totalExercises++;
        if (exercise['isDone']) {
          completedExercises++;
        }
      }
    }

    double completionPercentage = (completedExercises / totalExercises) * 100;
    return '${completionPercentage.toStringAsFixed(0)}%';
  }

  double calculateCompletionValue() {
    int totalExercises = 0;
    int completedExercises = 0;

    for (var set in sets) {
      for (var exercise in set['exercises']) {
        totalExercises++;
        if (exercise['isDone']) {
          completedExercises++;
        }
      }
    }

    double completionPercentage = (completedExercises / totalExercises);
    return completionPercentage;
  }

  void completeExercise() {
    personalNoteSelected = false;
    int currentExercise = getCurrentExerciseIndex();

    var set = sets[currentSetIndex];
    dynamic exercise;

    if (currentExercise != -1) {
      exercise = set['exercises'][currentExercise];
      exercise['isDone'] = true;
    }

    int originalCurrentIndex = getOriginalCurrentExerciseIndex();
    originalFormatSets[currentSetIndex]['exercises'][originalCurrentIndex]
        ['isDone'] = true;

    bool allExercisesOriginalInSetDone = true;
    for (var exercise in originalFormatSets[currentSetIndex]['exercises']) {
      if (!(exercise['isDone'] ?? false)) {
        allExercisesOriginalInSetDone = false;
        break;
      }
    }

    if (allExercisesOriginalInSetDone) {
      if (originalFormatSets[currentSetIndex]['completedSets'] == null) {
        originalFormatSets[currentSetIndex]['completedSets'] = 0;
      }
      originalFormatSets[currentSetIndex]['completedSets']++;
      if (originalFormatSets[currentSetIndex]['completedSets'] <
          originalFormatSets[currentSetIndex]['count']) {
        for (var exercise in originalFormatSets[currentSetIndex]['exercises']) {
          exercise['isDone'] = false;
        }
      }
    }

    bool allExercisesInSetDone = true;
    for (var exercise in set['exercises']) {
      if (!exercise['isDone']) {
        allExercisesInSetDone = false;
        break;
      }
    }

    if (allExercisesInSetDone) {
      sets[currentSetIndex]['isDone'] = true;
      originalFormatSets[currentSetIndex]['isDone'] = true;
      int nextUndoneIndex = findNextUndoneSetIndex(sets);

      if (nextUndoneIndex != -1) {
        currentExercise = 0;
        currentSetIndex = nextUndoneIndex;
      } else {
        print('Todos os elementos estão concluídos');
      }
    } else {
      currentExercise++;
    }

    currentExerciseIndex = currentExercise;
  }

  int findNextUndoneSetIndex(List<dynamic> sets) {
    for (int i = 0; i < sets.length; i++) {
      if (sets[i]['isDone'] == false) {
        return i;
      }
    }
    return -1;
  }

  int getCurrentExerciseIndex() {
    if (sets.isEmpty) {
      return 0;
    }

    List<dynamic> exercises = sets[currentSetIndex]['exercises'];
    for (int i = 0; i < exercises.length; i++) {
      if (exercises[i]['isDone'] == false) {
        return i;
      }
    }
    return -1;
  }

  int getOriginalCurrentExerciseIndex() {
    List<dynamic> exercises = originalFormatSets[currentSetIndex]['exercises'];
    for (int i = 0; i < exercises.length; i++) {
      if ((exercises[i]['isDone'] ?? false) == false) {
        return i;
      }
    }
    return -1;
  }

  int? timerValue() {
    final exercise = getCurrentExercise();

    if (exercise == null) {
      return null;
    }

    if (exercise['rep'] != null && exercise['rep'].toString().isNotEmpty) {
      return null;
    }

    return exercise['seconds'];
  }

  String? getTechniqueName() {
    dynamic exercise = getCurrentExercise();

    if (exercise['techniqueName'] != null &&
        exercise['techniqueName'].toString().isNotEmpty) {
      return exercise['techniqueName'];
    }

    return null;
  }

  String? getTechniqueDescription() {
    dynamic exercise = getCurrentExercise();

    if (exercise['techniqueDescription'] != null &&
        exercise['techniqueDescription'].toString().isNotEmpty) {
      return exercise['techniqueDescription'];
    }

    return null;
  }

  String? getIntensity() {
    dynamic exercise = getCurrentExercise();

    if (exercise['intensity'] != null &&
        exercise['intensity'].toString().isNotEmpty &&
        exercise['intensity'] != '-') {
      return 'Carga ${exercise['intensity']}';
    }

    return null;
  }

  String getCadenceDescription() {
    return "O método consiste em quatro números, que indicam o tempo em segundos para cada fase do exercício. O primeiro número se refere ao tempo que você deve levar para fazer a fase excêntrica ou negativa do movimento. O segundo número indica o tempo que você deve manter a posição baixa ou neutra do exercício. O terceiro número se refere ao tempo que você deve levar para fazer a fase concêntrica ou positiva do movimento. O último número indica o tempo que você deve manter a posição alta ou neutra do exercício antes de iniciar a próxima repetição. Essa técnica pode ser aplicada a todos os exercícios do treino, para melhorar o desempenho e estimular o músculo de forma mais eficaz.";
  }

  String? getEquipment() {
    dynamic exercise = getCurrentExercise();

    if (exercise['equipment'] != null &&
        exercise['equipment'].toString().isNotEmpty) {
      return exercise['equipment'];
    }

    return null;
  }

  bool hasPersonalNote() {
    dynamic exercise = getCurrentExercise();

    if (exercise['personalNote'] != null &&
        exercise['personalNote'].toString().isNotEmpty) {
      return true;
    }
    return false;
  }

  void completeLastExercise() {
    personalNoteSelected = false;

    int currentExercise = getCurrentExerciseIndex();

    var set = copySets[currentSetIndex];
    dynamic exercise;

    if (currentExercise != -1) {
      exercise = set['exercises'][currentExercise];
      exercise['isDone'] = true;
    }

    int originalCurrentIndex = getOriginalCurrentExerciseIndex();
    copyOriginalFormatSets[currentSetIndex]['exercises'][originalCurrentIndex]
        ['isDone'] = true;

    bool allExercisesOriginalInSetDone = true;
    for (var exercise in copyOriginalFormatSets[currentSetIndex]['exercises']) {
      if (!(exercise['isDone'] ?? false)) {
        allExercisesOriginalInSetDone = false;
        break;
      }
    }

    if (allExercisesOriginalInSetDone) {
      if (copyOriginalFormatSets[currentSetIndex]['completedSets'] == null) {
        copyOriginalFormatSets[currentSetIndex]['completedSets'] = 0;
      }
      copyOriginalFormatSets[currentSetIndex]['completedSets']++;
      if (copyOriginalFormatSets[currentSetIndex]['completedSets'] <
          copyOriginalFormatSets[currentSetIndex]['count']) {
        for (var exercise in copyOriginalFormatSets[currentSetIndex]
            ['exercises']) {
          exercise['isDone'] = false;
        }
      }
    }

    bool allExercisesInSetDone = true;
    for (var exercise in set['exercises']) {
      if (!exercise['isDone']) {
        allExercisesInSetDone = false;
        break;
      }
    }

    if (allExercisesInSetDone) {
      copySets[currentSetIndex]['isDone'] = true;
      copyOriginalFormatSets[currentSetIndex]['isDone'] = true;
    }
  }

  String getWorkoutLevel() {
    final level = workout['level'];
    return WorkoutMap.mapSkillLevel(level);
  }
}
