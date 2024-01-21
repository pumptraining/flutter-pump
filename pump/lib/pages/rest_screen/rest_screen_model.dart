import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';

class RestScreenModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for Timer widget.
  StopWatchTimer timerController =
      StopWatchTimer(mode: StopWatchMode.countDown);

  dynamic nextExercise;
  String? personalImageUrl;
  List<dynamic>? workout;
  int? restTime;
  bool selectedPersonalNote = false;
  List<dynamic>? changedWorkout;
  int currentSetIndex = 0;
  bool changeSet = false;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    timerController.dispose();
  }

  String getNextExerciseTitle() {
    final exercise = getNextExercise();

    if (exercise['rep'] != null && exercise['rep'].toString().isNotEmpty) {
      return '${exercise['rep']}x ${exercise['title']}';
    }
    return '${exercise['seconds']}s ${exercise['title']}';
  }

  String getNextExerciseSubtitle() {
    final exercise = getNextExercise();

    if (exercise['equipment'] != null &&
        exercise['equipment'].toString().isNotEmpty) {
      return exercise['equipment'];
    }

    return 'Sem equipamento';
  }

  String getNextExerciseImageUrl() {
    final exercise = getNextExercise();

    if (exercise['imageUrl'] != null &&
        exercise['imageUrl'].toString().isNotEmpty) {
      return exercise['imageUrl'];
    }

    return '';
  }

  String? getNextExercisePersonalNote() {
    final exercise = getNextExercise();

    if (exercise['personalNote'] != null &&
        exercise['personalNote'].toString().isNotEmpty) {
      return exercise['personalNote'];
    }

    return null;
  }

  dynamic getNextExercise() {
    if (changeSet) {
      var exercises = changedWorkout![currentSetIndex]['exercises'];
      for (var exercise in exercises) {
        if ((exercise['isDone'] ?? false) == false) {
          return exercise;
        }
      }
    }
    return nextExercise;
  }
}
