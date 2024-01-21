import 'package:api_manager/api_manager/api_manager.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/model/uploaded_file.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddWorkoutSheetModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for SwitchListTile widget.
  bool? switchListTileValue;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController1;
  String? Function(BuildContext, String?)? yourNameController1Validator;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController2;
  String? Function(BuildContext, String?)? yourNameController2Validator;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController3;
  String? Function(BuildContext, String?)? yourNameController3Validator;
  // State field(s) for state widget.
  String? stateValue1;
  FormFieldController<String>? stateValueController1;
  // State field(s) for state widget.
  String? stateValue2;
  FormFieldController<String>? stateValueController2;
  // State field(s) for state widget.
  String? stateValue3;
  FormFieldController<String>? stateValueController3;

  bool selectedImage = false;
  String? imagePath;
  dynamic workoutSheet;
  bool isUpdate = false;
  dynamic contentResponse;
  dynamic workouts;
  List<Map<String, dynamic>> workoutPlan = [];

  ApiCallResponse? apiResultl1o;
  // Stores action output result for [Backend Call - API (CreateExercise)] action in Button widget.
  ApiCallResponse? createWorkoutSheetResult;

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

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    yourNameController1?.dispose();
    yourNameController2?.dispose();
    yourNameController3?.dispose();
  }

  void prepareObjectives() {
    if (objectiveTags.isEmpty) {
      final objectives = getObjectives();
      objectives.forEach((e) => objectiveTags.add({'title': e, 'isSelected': false}));
    }
  }

  List<String> getLevelOptions() {
    return ["Iniciante", "Intermediário", "Avançado"];
  }

  List<String> getLocalOptions() {
    return ["Em casa", "Na academia"];
  }

  String getCurrentLocal() {
    if (workoutSheet == null || workoutSheet['local'] == null) {
      return "";
    }
    switch (workoutSheet['local']) {
      case "home":
        return "Em casa";
      case "gym":
        return "Na academia";
      default:
        return "";
    }
  }

  List<String> getObjectives() {
    if (contentResponse['objectives'] == null) {
      return [''];
    }
    List<dynamic> objectives = contentResponse['objectives'];

    List<String> namePortugueseArray = [];
    for (var objective in objectives) {
      String namePortuguese = objective['namePortuguese'];
      namePortugueseArray.add(namePortuguese);
    }
    return namePortugueseArray;
  }

  String getWorkoutSheetId() {
    if (workoutSheet == null || workoutSheet['_id'] == null) {
      return "";
    }
    return workoutSheet['_id'];
  }

  String getSelectedObjective() {
    var id = "";
    if (workoutSheet == null ||
        workoutSheet['trainingObjectiveId'] == null ||
        contentResponse['objectives'] == null) {
      return "";
    } else {
      id = workoutSheet['trainingObjectiveId'];
    }

    List<dynamic> filteredArray =
        contentResponse['objectives'].where((jsonObject) {
      String objectiveId = jsonObject['_id'];
      return objectiveId == id;
    }).toList();

    if (filteredArray.isEmpty) {
      return "";
    }

    return filteredArray.first['namePortuguese'] ?? "";
  }

  String getLevel() {
    if (workoutSheet == null || workoutSheet['trainingLevel'] == null) {
      return "";
    }
    return mapSkillLevel(workoutSheet['trainingLevel']);
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

  void setValues(dynamic workout) {
    if (workout != null) {
      isUpdate = true;
      workoutSheet = workout;
      workoutPlan = findDuplicateWorkouts(workoutSheet['weeks']);
    } else {
      workoutSheet = {};
      workoutSheet['imageUrl'] = 'https://res.cloudinary.com/hssoaq6x7/image/upload/v1704734551/IconAppPump-removebg-preview-4_sxmknd.png';
    }

    yourNameController1.text = workoutSheet['title'] ?? "";
    yourNameController2.text = workoutSheet['amount'] != null
        ? NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
            .format(workoutSheet['amount'])
        : "";

    yourNameController3.text = workoutSheet['shortDescription'] ?? "";
    workoutSheet['personalId'] = currentUserUid;
  }

  List<Map<String, dynamic>> findDuplicateWorkouts(List<dynamic> weeks) {
    List<List<dynamic>> workoutsList =
        weeks.map((week) => List<dynamic>.from(week['workouts'])).toList();
    List<Map<String, dynamic>> result = [];

    var count = 1;

    for (int i = 0; i < workoutsList.length; i++) {
      List<dynamic> workouts = workoutsList[i];
      bool isDuplicate = false;

      for (int j = i + 1; j < workoutsList.length; j++) {
        List<dynamic> nextWorkouts = workoutsList[j];

        if (workouts.length == nextWorkouts.length &&
            workouts.every((w) => nextWorkouts.contains(w))) {
          isDuplicate = true;
          count += 1;
          break;
        }
      }

      if (!isDuplicate) {
        result.add({'workouts': workouts, 'quantity': count});
        count = 1;
      }
    }

    return result;
  }

  List<Map<String, dynamic>> expandArray(
      List<Map<String, dynamic>> originalArray) {
    List<Map<String, dynamic>> newArray = [];

    var count = -1;
    for (int i = 0; i < originalArray.length; i++) {
      int quantity = originalArray[i]['quantity'];
      List<String> workouts = List<String>.from(originalArray[i]['workouts']);

      for (int j = 0; j < quantity; j++) {
        count += 1;

        newArray.add({
          'index': count,
          'workouts': workouts,
        });
      }
    }
    return newArray;
  }

  dynamic filterWorkoutById(String id) {
    dynamic filtered = workouts?.firstWhere((jsonObject) {
      String workoutId = jsonObject['_id'];
      return workoutId == id;
    }, orElse: () => null);
    return filtered;
  }

  String mapCategories(dynamic workout) {
    Set<String> muscles = {};

    if (workout != null && workout['series'] != null) {
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

  String getNextSectionIndex() {
    return '${workoutPlan.length}';
  }

  void setMediaNull() {
    if (workoutSheet != null && workoutSheet['imageUrl'] != null) {
      workoutSheet['imageUrl'] = null;
    }
  }

  String? validateErrorMessage() {
    if (workoutSheet == null ||
        workoutSheet['weeks'] == null ||
        workoutSheet['weeks'].length == 0) {
      return "Adicione os treinos para criar o programa.";
    } else {
      for (dynamic weeks in workoutSheet['weeks']) {
        if (weeks['workouts'] == null || weeks['workouts'].length == 0) {
          return "Adicione os treinos para criar o programa.";
        }
      }
    }

    if ((workoutSheet['imageUrl'] == null || workoutSheet['imageUrl'] == '') &&
        selectedImage == false) {
      return "Adicione uma imagem de capa para o programa.";
    }

    if (workoutSheet['trainingObjectiveId'] == null) {
      return "Selecione o objetivo do programa.";
    }

    if (workoutSheet['trainingLevel'] == null ||
        workoutSheet['trainingLevel'] == '') {
      return "Selecione o nível do programa.";
    }

    if (workoutSheet['title'] == null || workoutSheet['title'] == '') {
      return "Adicione um nome para o programa.";
    }

    return null;
  }

  bool needUploadImage() {
    if (workoutSheet != null && workoutSheet['imageUrl'] != null) {
      return false;
    }
    return true;
  }

  void setMedia(dynamic response) {
    workoutSheet['imageUrl'] = response['response']['imageUrl'];
  }

  void setWeeks() {
    if (workoutSheet == null) {
      workoutSheet = {};
    }
    workoutSheet['weeks'] = expandArray(workoutPlan);
  }

  void setToggle(bool toggle) {
    if (workoutSheet == null) {
      workoutSheet = {};
    }
    workoutSheet['isVisible'] = toggle;
  }

  bool getToggleValue() {
    if (workoutSheet == null || workoutSheet['isVisible'] == null) {
      return false;
    }
    return workoutSheet['isVisible'];
  }

  void setObjectives(String value) {
    if (workoutSheet == null) {
      workoutSheet = {};
    }

    dynamic filtered = contentResponse['objectives']
        .where((jsonObject) {
          String objective = jsonObject['namePortuguese'];
          return objective == value;
        })
        .toList()
        .first;

    workoutSheet['trainingObjectiveId'] = filtered['_id'];
  }

  void setLevel(String level) {
    if (workoutSheet == null) {
      workoutSheet = {};
    }
    switch (level) {
      case "Avançado":
        workoutSheet['trainingLevel'] = "advanced";
        break;
      case "Intermediário":
        workoutSheet['trainingLevel'] = "intermediate";
        break;
      case "Iniciante":
        workoutSheet['trainingLevel'] = "beginner";
        break;
      default:
        break;
    }
  }

  void setTitle(String title) {
    if (workoutSheet == null) {
      workoutSheet = {};
    }
    workoutSheet['title'] = title;
  }

  void setDescription(String title) {
    if (workoutSheet == null) {
      workoutSheet = {};
    }
    workoutSheet['shortDescription'] = title;
  }

  void setAmount(String amount) {
    if (workoutSheet == null) {
      workoutSheet = {};
    }
    String sanitizedAmount = amount.replaceAll(RegExp(r'[^0-9.]'), '');
    if (sanitizedAmount.isEmpty) {
      sanitizedAmount = "0";
    }
    double parsedAmount = double.parse(sanitizedAmount) / 100;
    workoutSheet['amount'] = parsedAmount;
  }

  void setCopyName() {
    yourNameController1.text = '${workoutSheet['title']} - Cópia';
    workoutSheet['title'] = '${workoutSheet['title']} - Cópia';
  }

  bool levelIsSelected(dynamic level) {
    if (workoutSheet['trainingLevel'] == null) {
      return false;
    }
    final selected = getLevel();
    return selected == level['title'];
  }

  bool objectiveIsSelected(dynamic element) {
    if (workoutSheet['trainingObjectiveId'] == null) {
      return false;
    }
    return getSelectedObjective() == element['title'];
  }
}
