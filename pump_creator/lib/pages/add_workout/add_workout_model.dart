import 'dart:async';
import 'package:api_manager/api_manager/api_manager.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/model/uploaded_file.dart';
import 'package:flutter_flow/flutter_flow_data_table.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_model.dart';

class AddWorkoutModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for yourName widget.
  TextEditingController? yourNameController1;
  String? Function(BuildContext, String?)? yourNameController1Validator;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController2;
  String? Function(BuildContext, String?)? yourNameController2Validator;
  // State field(s) for state widget.
  String? stateValue1;
  FormFieldController<String>? stateValueController1;
  // State field(s) for state widget.
  String? stateValue2;
  FormFieldController<String>? stateValueController2;

  ApiCallResponse? apiResultl1o;
  // Stores action output result for [Backend Call - API (CreateExercise)] action in Button widget.
  ApiCallResponse? createExerciseResult;
  Completer<ApiCallResponse>? apiRequestCompleter;

  dynamic workout;
  dynamic contentResponse;
  bool selectedImage = false;
  String? imagePath;
  bool isUpdate = false;

  List<dynamic> levelTags = [
    {
      'title': 'Iniciante',
      'isSelected': false,
    },
    {
      'title': 'Intermediário',
      'isSelected': false,
    },
    {
      'title': 'Avançado',
      'isSelected': false,
    }
  ];

  List<dynamic> objectiveTags = [];

  void initState(BuildContext context) {}

  void dispose() {
    yourNameController1?.dispose();
    yourNameController2?.dispose();
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

  void prepareObjectives() {
    if (objectiveTags.isEmpty) {
      final objectives = getObjectives();
      objectives.forEach((e) => objectiveTags.add({'title': e, 'isSelected': false}));
    }
  }

  void setValues() {
    if (workout != null) {
      yourNameController1.text = workout['namePortuguese'] ?? "";
      yourNameController2.text = workout['description'] ?? "";
      // isUpdate = true;
    } else {
      workout = {};
      workout['trainingImageUrl'] = 'https://res.cloudinary.com/hssoaq6x7/image/upload/v1704734551/IconAppPump-removebg-preview-4_sxmknd.png';
    }

    workout['personalId'] = currentUserUid;
  }

  List<String> getObjectives() {
    List<dynamic> objectives = contentResponse['objectives'];

    List<String> namePortugueseArray = [];
    for (var objective in objectives) {
      String namePortuguese = objective['namePortuguese'];
      namePortugueseArray.add(namePortuguese);
    }
    return namePortugueseArray;
  }

  List<String> getLevelOptions() {
    return ["Iniciante", "Intermediário", "Avançado"];
  }

  String getLevel() {
    if (workout == null || workout['trainingLevel'] == null) {
      return "";
    }
    return mapSkillLevel(workout['trainingLevel']);
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

  String getTechniqueNameBy(String id) {
    List<dynamic> filteredArray =
        contentResponse['techniques'].where((jsonObject) {
      String techniqueId = jsonObject['_id'];
      return techniqueId == id;
    }).toList();

    if (filteredArray.isEmpty) {
      return "";
    }

    return filteredArray.first['name'] ?? "";
  }

  String textLimit(String? text, int limit) {
    if (text == null) {
      return "";
    }
    if (text.length <= limit) {
      return text;
    } else {
      return text.substring(0, limit) + "... ver mais";
    }
  }

  String getExerciseSubtitle(dynamic exercise) {
    if (exercise == null) {
      return "";
    }
    final subtitle =
        '${(exercise["tempRep"])} ${(exercise["tempRepDescription"])} · ${(exercise["pause"])}s Pausa';
    var cadence = "";
    if (exercise["cadence"] != null) {
      if (exercise["cadence"].isNotEmpty) {
        cadence = " · Cadência ${(exercise["cadence"])}";
      }
    }
    var intensity = "";
    if (exercise["intensity"] != null) {
      intensity = " · ${(exercise["intensity"])}";
    }
    return subtitle + cadence + intensity;
  }

  String? validateErrorMessage() {
    if (workout == null ||
        workout['series'] == null ||
        workout['series'].length == 0) {
      return "Adicione as séries para criar o treino.";
    } else {
      for (dynamic series in workout['series']) {
        if (series['exercises'] == null || series['exercises'].length == 0) {
          return "Adicione os exercícios nas séries para criar o treino.";
        }
        for (dynamic exercise in series['exercises']) {
          if ((exercise['tempRep'] == null || exercise['tempRep'] == '') && exercise['tempRepArray'] == null) {
            return "Preencha as repetições ou segundos do exercício.";
          }
        }
        if (series['quantity'] == null || series['quantity'] == '') {
          return "Adicione a quantidade de séries.";
        }
      }
    }

    if ((workout['trainingImageUrl'] == null ||
            workout['trainingImageUrl'] == '') &&
        selectedImage == false) {
      return "Adicione uma foto para o treino.";
    }

    if (workout['trainingObjective'] == null) {
      return "Selecione o objetivo do treino.";
    }

    if (workout['trainingLevel'] == null || workout['trainingLevel'] == '') {
      return "Selecione o nível do treino.";
    }

    if (workout['namePortuguese'] == null || workout['namePortuguese'] == '') {
      return "Adicione um nome para o treino.";
    }

    return null;
  }

  bool needUploadImage() {
    if (workout != null && workout['trainingImageUrl'] != null) {
      return false;
    }
    return true;
  }

  void setMediaNull() {
    if (workout != null && workout['trainingImageUrl'] != null) {
      workout['trainingImageUrl'] = null;
    }
  }

  void setMedia(dynamic response) {
    workout['trainingImageUrl'] = response['response']['imageUrl'];
  }

  void setObjective(String value) {
    dynamic filtered = contentResponse['objectives']
        .where((jsonObject) {
          String objective = jsonObject['namePortuguese'];
          return objective == value;
        })
        .toList()
        .first;

    if (workout['trainingObjective'] == null) {
      workout['trainingObjective'] = {};
    }
    workout['trainingObjective'] = filtered;
  }

  void setLevel(String level) {
    if (workout == null) {
      workout = {};
    }
    switch (level) {
      case "Avançado":
        workout['trainingLevel'] = "advanced";
        break;
      case "Intermediário":
        workout['trainingLevel'] = "intermediate";
        break;
      case "Iniciante":
        workout['trainingLevel'] = "beginner";
        break;
      default:
        break;
    }
  }

  void setCopyName() {
    yourNameController1.text = '${workout['namePortuguese']} - Cópia';
    workout['namePortuguese'] = '${workout['namePortuguese']} - Cópia';
  }

  bool levelIsSelected(dynamic level) {
    if (workout['trainingLevel'] == null) {
      return false;
    }
    final selected = getLevel();
    return selected == level['title'];
  }

  bool objectiveIsSelected(dynamic element) {
    if (workout['trainingObjective'] == null) {
      return false;
    }
    String name = workout['trainingObjective']['namePortuguese'];
    if (workout['trainingObjective']['namePortuguese'] == 'Resistencia') {
      name = 'Resistência';
    }
    return name == element['title'];
  }

  final paginatedDataTableController =
      FlutterFlowDataTableController<dynamic>();
  List<dynamic> workoutSets = [];
  List<DropdownData> dataArray = [];
  int setIndexToAddExercise = 0;

  void addSeriesWithExercises(dynamic exercises) {
    if (exercises is bool) {
      return;
    }
    for (var newExercise in exercises) {
      dynamic newItem = {};
      newExercise['videoUrl'] = null;
      newExercise['streamingURL'] = null;
      newExercise['personalId'] = null;
      newItem['exercise'] = newExercise;
      newItem['tempRepDescription'] = 'Repetições';
      newItem['pauseArray'] = [60, 60, 60];
      newItem['tempRepArray'] = [10, 10, 10];
      newItem['intensityArray'] = ['-', '-', '-'];

      final set = {
        'quantity': 3,
        'exercises': [newItem]
      };

      workout['series'].add(set);
    }
  }

  void addExercisesInSet(dynamic exercises) {
    if (exercises is bool) {
      return;
    }
    for (var newExercise in exercises) {
      dynamic newItem = {};
      newExercise['videoUrl'] = null;
      newExercise['streamingURL'] = null;
      newExercise['personalId'] = null;
      newItem['exercise'] = newExercise;
      newItem['tempRepDescription'] = 'Repetições';

      newItem['pauseArray'] = [60];
      newItem['tempRepArray'] = [10];
      newItem['intensityArray'] = ['-'];

      for (int i = 1; workout['series'][setIndexToAddExercise]['quantity'] > i; i++) {
        newItem['pauseArray'].add(60);
        newItem['tempRepArray'].add(10);
        newItem['intensityArray'].add('-');
      }

      workout['series'][setIndexToAddExercise]['exercises'].add(newItem);
    }
  }
}
