import 'package:expandable/expandable.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRange {
  final String title;
  final int value;

  DateRange({required this.title, required this.value});
}

class ActivityModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  dynamic content;
  int time = 7;
  ExpandableController? expandableController;

  final dateRanges = [
    DateRange(title: 'Últimos 7 dias', value: 7),
    DateRange(title: 'Últimos 30 dias', value: 30),
    DateRange(title: 'Últimos 90 dias', value: 90),
  ];

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  List<int> generateXData() {
    List<int> xData =
        List.generate(content['totalSecondsTimes'].length, (index) => index);
    return xData;
  }

  List<int> generateYData() {
    List<dynamic> totalSecondsTimes = content['totalSecondsTimes'];
    List<int> yData = totalSecondsTimes
        .map<int>((totalSeconds) => (totalSeconds / 60).toInt())
        .toList();
    return yData;
  }

  List<dynamic> getMuscularGroupValues() {
    List<dynamic> categories = content['categories'];
    List<int> yData = categories
        .map<int>((category) => (category['percentage'] * 100).toInt())
        .toList();
    return yData;
  }

  List<dynamic> getObjectiveValues() {
    List<dynamic> categories = content['objective'];
    List<int> yData = categories
        .map<int>((category) => (category['percentage'] * 100).toInt())
        .toList();
    return yData;
  }

  List<dynamic> getFirstThreeCategories() {
    List<dynamic> categories = content['categories'];
    if (categories.length >= 3) {
      return categories.sublist(0, 3);
    } else {
      return categories;
    }
  }

  String formatPercentage(dynamic number) {
    final formatter = NumberFormat.percentPattern();
    return formatter.format(number / 100);
  }

  List<dynamic> getMoreCategories(int index) {
    List<dynamic> categories = content['categories'];
    if (index >= categories.length) {
      return [];
    }
    return categories.sublist(index);
  }

  List<T> getArrayColorFromIndex<T>(List<T> originalList, int index) {
    if (index >= originalList.length) {
      return [];
    }
    return originalList.sublist(index);
  }

  void selectedDays(String value) {
    String targetTitle = value;

    DateRange? targetDateRange = dateRanges.firstWhere(
      (dateRange) => dateRange.title == targetTitle,
    );
    time = targetDateRange.value;
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

  bool allZeros(List<int> numbers) {
    return numbers.every((number) => number == 0);
  }
}
