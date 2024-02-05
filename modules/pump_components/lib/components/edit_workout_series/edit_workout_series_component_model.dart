import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_data_table.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/form_field_controller.dart';

class EditWorkoutSeriesComponentModel extends FlutterFlowModel {

  final paginatedDataTableController =
      FlutterFlowDataTableController<dynamic>();
  dynamic workout;

  FormFieldController<String>? dropDownIntensityController;
  FormFieldController<String>? dropDownIntervalController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

}
