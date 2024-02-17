import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_data_table.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/form_field_controller.dart';

class DropdownData {
  TextEditingController? textPauseController;
  FormFieldController<String>? intensityDropdownController;
  TextEditingController? textRepsController;
  int setIndexCurrent;
  int exercisesIndex;
  int index;
  int reps;
  int pause;
  String intensity;

  DropdownData(
      this.setIndexCurrent,
      this.exercisesIndex,
      this.index,
      this.reps,
      this.pause,
      this.intensity,
      this.textPauseController,
      this.intensityDropdownController,
      this.textRepsController);

  void updateIndex(int newIndex) {
    index = newIndex;
  }

  void updatePause(int newPause) {
    pause = newPause;
  }

  void updateIntensity(String newIntensity) {
    intensity = newIntensity;
  }

  void updateReps(int newReps) {
    reps = newReps;
  }
}

class EditWorkoutSeriesComponentModel extends FlutterFlowModel {
  late FlutterFlowDataTableController<dynamic> paginatedDataTableController;

  FormFieldController<String>? dropDownIntensityController;
  FormFieldController<String>? dropDownIntervalController;
  final maxRowsPerPage = 5;
  int _currentPageIndex = 0;
  dynamic isEditingSet;
  String choiceChipsValue = 'Repetições';

  List<String> secOrRepsTags = [
    'Repetições',
    'Segundos',
  ];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  void dataTablePageChanged(int index) {
    _currentPageIndex = index;
  }

  int numberOfRows(List<dynamic> exercise) {
    final setsCount = exercise.length;
    if (setsCount <= maxRowsPerPage) {
      return setsCount;
    }
    if (_currentPageIndex == 0) {
      return maxRowsPerPage;
    }
    final rows = setsCount - _currentPageIndex;
    if (rows > maxRowsPerPage) {
      return maxRowsPerPage;
    }
    return setsCount - _currentPageIndex;
  }

  bool setIsEditing(int setIndex, int exerciseIndex) {
    if (isEditingSet != null &&
        isEditingSet['setIndex'] == setIndex &&
        isEditingSet['exerciseIndex'] == exerciseIndex &&
        isEditingSet['editing'] == true) {
      return true;
    }
    return false;
  }

  String getExerciseTitle(dynamic exercise) {
    final reps = exercise['tempRepArray'];
    final name = exercise['exercise']['name'];
    final type = exercise['tempRepDescription'] == 'Segundos' ? 's' : 'x';
    if (reps != null) {
      return '${_findSmallestAndLargest(reps)}$type $name';
    }
    return '';
  }

  String generateSubtitle(dynamic exercise) {
    List<dynamic> pauseSeconds = exercise['pauseArray'] ?? [];
    List<dynamic> loads = exercise['intensityArray'] ?? [];

    List<int> pauseSecondsList = pauseSeconds.cast<int>();
    List<String> loadsList = loads.cast<String>();

    if (pauseSeconds.length != loads.length ||
        pauseSeconds.isEmpty ||
        loads.isEmpty) {
      return exercise['exercise']['equipament']['name'];
    }

    Set<int> uniquePauseSeconds = pauseSecondsList.toSet();
    Set<String> uniqueLoads = loadsList.toSet();

    bool singlePauseSecond = uniquePauseSeconds.length == 1;
    bool singleLoad = uniqueLoads.length == 1;

    if (singlePauseSecond && singleLoad) {
      if (loadsList.first != '-') {
        return 'Pausa ${pauseSecondsList.first}s | Carga ${loadsList.first}';
      } else {
        return 'Pausa ${pauseSecondsList.first}s';
      }
    } else {
      List<String> formattedPairs = [];
      for (int i = 0; i < pauseSecondsList.length; i++) {
        String pause = '${pauseSecondsList[i]}s';
        String load = loadsList[i];
        if (load != '-') {
          formattedPairs.add('$pause-$load');
        } else {
          formattedPairs.add(pause);
        }
      }
      return formattedPairs.join(' | ');
    }
  }

  String _findSmallestAndLargest(List<dynamic> numbers) {
    if (numbers.isEmpty) {
      return '';
    }

    int smallest = numbers[0];
    int largest = numbers[0];

    for (int number in numbers) {
      if (number < smallest) {
        smallest = number;
      }
      if (number > largest) {
        largest = number;
      }
    }

    if (smallest == largest) {
      return smallest.toString();
    } else {
      return '$smallest-$largest';
    }
  }

  bool hasPersonalNote(dynamic workoutSets, int setIndex) {
    return (workoutSets[setIndex]['personalNote'] != null &&
        workoutSets[setIndex]['personalNote'].isNotEmpty);
  }

  dynamic trainingTechniqueInfo(int exerciseCount) {
    String title = '';
    String subtitle = '';

    if (exerciseCount == 1) {
      title = 'Superset';
      subtitle =
          'Um superset é uma técnica de treinamento que envolve a realização de dois exercícios consecutivos sem descanso entre eles. Esses exercícios podem visar o mesmo grupo muscular (superset agonista) ou grupos musculares opostos (superset antagonista). Por exemplo, um superset de bíceps e tríceps seria um conjunto de cachos de bíceps seguido imediatamente por flexões de tríceps. Esta técnica é frequentemente utilizada para aumentar a intensidade do treinamento e economizar tempo na academia.';
    } else if (exerciseCount == 2) {
      title = 'Giantset';
      subtitle =
          'Um giant set é uma variação avançada do superset, envolvendo a realização de três ou mais exercícios consecutivos, normalmente visando o mesmo grupo muscular ou grupos musculares adjacentes. Os exercícios são realizados sem descanso entre eles, criando um desafio significativo para o corpo. Esta técnica é útil para maximizar a fadiga muscular e a eficiência do treino.';
    } else {
      title = 'Circuito';
      subtitle =
          'Um circuito de treinamento consiste em uma série de exercícios realizados consecutivamente, com pouco ou nenhum descanso entre eles. Cada exercício é realizado por um determinado período de tempo ou por um número específico de repetições, antes de passar para o próximo exercício no circuito. Os circuitos são uma ótima maneira de combinar exercícios de força, resistência cardiovascular e mobilidade em uma única sessão de treino, proporcionando um treino completo e eficaz.';
    }

    return {'title': title, 'subtitle': subtitle};
  }

  String getTitleAddExerciseInSet(dynamic set) {
    int quantity = set['exercises'].length;
    dynamic info = trainingTechniqueInfo(quantity);
    if (quantity > 3) {
      return info['title'];
    }
    return 'Criar ${info['title']}';
  }
}
