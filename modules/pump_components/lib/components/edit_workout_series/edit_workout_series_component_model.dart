import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_data_table.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/form_field_controller.dart';

class EditWorkoutSeriesComponentModel extends FlutterFlowModel {

  final paginatedDataTableController =
      FlutterFlowDataTableController<dynamic>();
  dynamic workoutSets;

  FormFieldController<String>? dropDownIntensityController;
  FormFieldController<String>? dropDownIntervalController;
  final maxRowsPerPage = 5;
  int _currentPageIndex = 0;

  List<dynamic> dataTest = [
    {
      'reps': '12',
      'carga': 'Alta',
      'interval': '1min',
    },
    {
      'reps': '12',
      'carga': 'Alta',
      'interval': '1min',
    },
    {
      'reps': '12',
      'carga': 'Alta',
      'interval': '1min',
    }
  ];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  void dataTablePageChanged(int index) {
    _currentPageIndex = index;
  }

  int numberOfRows() {
    if (dataTest.length <= maxRowsPerPage) {
      return dataTest.length;
    }
    if (_currentPageIndex == 0) {
      return maxRowsPerPage;
    }
    final rows = dataTest.length - _currentPageIndex;
    if (rows > maxRowsPerPage) {
      return maxRowsPerPage;
    }
    return dataTest.length - _currentPageIndex;
  }
}
