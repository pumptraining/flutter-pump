import 'package:flutter_flow/flutter_flow_choice_chips.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/form_field_controller.dart';

class WorkoutFilterModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for ChoiceChips widget.
  List<String>? choiceChipsValues1;
  FormFieldController<List<String>>? choiceChipsValueController1;
  // State field(s) for ChoiceChips widget.
  List<String>? choiceChipsValues2;
  FormFieldController<List<String>>? choiceChipsValueController2;
  // State field(s) for ChoiceChips widget.
  List<String>? choiceChipsValues3;
  FormFieldController<List<String>>? choiceChipsValueController3;
  // State field(s) for ChoiceChips widget.
  List<String>? choiceChipsValues4;
  FormFieldController<List<String>>? choiceChipsValueController4;

  dynamic homeFilter;
  dynamic filteredWorkouts;
  List<String> selectedDifficulties = [];

  Map<String, String> levelMapping = {
    'Iniciante': 'beginner',
    'Intermediário': 'intermediate',
    'Avançado': 'advanced',
  };

  void initState(BuildContext context) {}

  void dispose() {}

  List<ChipData> getObjectivesChipOptions() {
    List<ChipData> chipDataArray = (homeFilter['objectives'] as List<dynamic>)
        .map((label) => ChipData(label['namePortuguese']))
        .toList();

    return chipDataArray;
  }

  List<ChipData> getCategoriesChipOptions() {
    List<ChipData> chipDataArray = (homeFilter['categories'] as List<dynamic>)
        .map((label) => ChipData(label['name']))
        .toList();

    return chipDataArray;
  }

  List<ChipData> getEquipmentsChipOptions() {
    List<ChipData> chipDataArray = (homeFilter['equipments'] as List<dynamic>)
        .map((label) => ChipData(label['name']))
        .toList();

    return chipDataArray;
  }

  void setFilter() {
    if (homeFilter == null) {
      return;
    }

    dynamic workouts = homeFilter['workouts'];
    dynamic objectives = homeFilter['objectives'];

    selectedDifficulties = choiceChipsValueController1?.value?.map((level) {
          return levelMapping[level] ?? level;
        }).toList() ??
        [];

    List<String> selectedObjectives = objectives
        .where((objective) {
          return choiceChipsValueController2?.value
                  ?.contains(objective['namePortuguese']) ??
              false;
        })
        .map((objective) => objective['_id'].toString())
        .toList()
        .cast<String>();

    List<String> selectedCategory = choiceChipsValueController3?.value ?? [];
    List<String> selectedEquipment = choiceChipsValueController4?.value ?? [];

    filteredWorkouts = workouts.where((workout) {
      String objectiveId = workout['trainingObjective']['_id'];

      bool difficultyFilter = selectedDifficulties.isEmpty ||
          selectedDifficulties.contains(workout['trainingLevel']);

      bool objectiveFilter = selectedObjectives.isEmpty ||
          selectedObjectives.contains(objectiveId);

      bool categoryFilter = selectedCategory.isEmpty ||
          workout['muscleImpact']
              .any((impact) => selectedCategory.contains(impact));

      bool equipmentsFilter = selectedEquipment.isEmpty ||
          workout['equipments']
              .every((equipment) => selectedEquipment.contains(equipment));

      return difficultyFilter &&
          objectiveFilter &&
          categoryFilter &&
          equipmentsFilter;
    }).toList();
  }

  String applyFilterTitle() {
    setFilter();

    if (homeFilter == null || filteredWorkouts == null) {
      return 'Aplicar';
    }

    if (filteredWorkouts.length == 0) {
      return '0 Treinos';
    }

    int filterCount = (choiceChipsValueController1?.value?.length ?? 0) +
        (choiceChipsValueController2?.value?.length ?? 0) +
        (choiceChipsValueController3?.value?.length ?? 0) +
        (choiceChipsValueController4?.value?.length ?? 0);

    if (filterCount == 0 && filteredWorkouts.length == homeFilter['workouts'].length) {
      return 'Aplicar';
    } 

    return 'Ver ${filteredWorkouts.length} Treinos';
  }

  bool applyButtonIsEnabled() {
    if (homeFilter == null || filteredWorkouts == null) {
      return false;
    }
    return filteredWorkouts.length > 0;
  }

  Map<String, dynamic> getFilterResult() {
    Map<String, dynamic> result = {};
    result['homeFilter'] = homeFilter;
    result['selectedDifficulties'] = choiceChipsValueController1?.value;
    result['selectedObjectives'] = choiceChipsValueController2?.value;
    result['selectedCategory'] = choiceChipsValueController3?.value;
    result['selectedEquipment'] = choiceChipsValueController4?.value;
    result['filteredWorkouts'] = filteredWorkouts;

    result['filterCount'] = (choiceChipsValueController1?.value?.length ?? 0) +
        (choiceChipsValueController2?.value?.length ?? 0) +
        (choiceChipsValueController3?.value?.length ?? 0) +
        (choiceChipsValueController4?.value?.length ?? 0);

    return result;
  }

  void setSelectedFilter(dynamic filter) {
    homeFilter = filter['homeFilter'];

    choiceChipsValueController1 = FormFieldController<List<String>>([]);
    choiceChipsValueController2 = FormFieldController<List<String>>([]);
    choiceChipsValueController3 = FormFieldController<List<String>>([]);
    choiceChipsValueController4 = FormFieldController<List<String>>([]);

    choiceChipsValueController1?.value = filter['selectedDifficulties'];
    choiceChipsValueController2?.value = filter['selectedObjectives'];
    choiceChipsValueController3?.value = filter['selectedCategory'];
    choiceChipsValueController4?.value = filter['selectedEquipment'];
    filteredWorkouts = filter['filteredWorkouts'];
  }
}
