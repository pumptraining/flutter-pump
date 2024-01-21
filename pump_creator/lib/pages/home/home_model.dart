import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_util.dart';

class HomeModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  dynamic content;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  String getCustomerCount() {
    if (showActiveCustomerChart()) {
      return content?['customerCount']?.toString() ?? "0";
    }
    return "0";
  }

  String getWorkoutSheetCount() {
    return content?['workoutSheetsCount']?.toString() ?? "0";
  }

  String getWorkoutCount() {
    return content?['workoutCount']?.toString() ?? "0";
  }

  String getExerciseCount() {
    return content?['exerciseCount']?.toString() ?? "0";
  }

  List<dynamic> getActiveCustomerValues() {
    if (showActiveCustomerChart()) {
      List<dynamic> activeCustomers = content['activeCustomers'];
      List<int> yData = activeCustomers
          .map<int>((customer) => ((customer['percentage'] ?? 0) * 100).toInt())
          .toList();
      return yData;
    }
    return [];
  }

  String formatPercentage(dynamic number) {
    final formatter = NumberFormat.percentPattern();
    return formatter.format(number);
  }

  bool showActiveCustomerChart() {
    return content != null &&
        content['activeCustomers'] != null &&
        content['activeCustomers']?.isNotEmpty;
  }
}
