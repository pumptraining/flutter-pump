import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:pump/common/map_skill_level.dart';
import 'package:pump_components/components/card_workout_sheet_component/card_workout_sheet_component_widget.dart';

class SheetsListModel extends FlutterFlowModel {
  dynamic content;
  bool showStatus = false;

  void initState(BuildContext context) {}

  void dispose() {}

  int numberOfRows() {
    final List<dynamic> dynamicList = content['workoutSheets'];
    return dynamicList.length;
  }

  dynamic _getSheetByIndex(int index) {
    final List<dynamic> dynamicList = content['workoutSheets'];
    return dynamicList.elementAt(index);
  }

  CardWorkoutSheetDTO getCardWorkoutSheetDTO(
      int index, double viewHeight, double viewWidth) {
    final item = _getSheetByIndex(index);
    final dynamic amountValue = item['amount'];
    final amount = amountValue != null
        ? NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(
            amountValue is String
                ? double.parse(amountValue)
                : amountValue.isNegative
                    ? -amountValue
                    : amountValue,
          )
        : '';

    return CardWorkoutSheetDTO(
        id: item['workoutId'] as String,
        title: item['title'] as String,
        imageUrl: item['imageUrl'] as String,
        circleImageUrl: item['personalImageUrl'],
        tagTitle: showStatus ? WorkoutMap.mapStatus(item['status']) : amount,
        tagColor: showStatus
            ? WorkoutMap.mapStatusColor(item['status'])
            : Color(0xFF1AD155),
        subtitle: WorkoutMap.getSubtitle(item),
        height: viewHeight / 3.5,
        width: viewWidth);
  }
}
