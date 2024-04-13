import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:pump_components/components/card_workout_sheet_component/card_workout_sheet_component_widget.dart';
import 'package:pump_components/components/horizontal_image_title_list_component/horizontal_image_title_list_component_widget.dart';

class HomeWorkoutSheetsModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  dynamic content;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  bool canShowUserPrograms() {
    return content != null &&
        content['userTrainingSheets'] != null &&
        content['userTrainingSheets'] == true;
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
        return Color(0xFFEB7F7F).withOpacity(0.3);
      case "intermediate":
        return Color(0xFFFFD10F).withOpacity(0.3);
      case "beginner":
        return Color(0xFFC4EF19).withOpacity(0.3);
      default:
        return Colors.white.withOpacity(0.3);
    }
  }

  Color mapSkillLevelBorderColor(String level) {
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

  String getSubtitle(dynamic workout) {
    return '${mapSkillLevel(workout['level'])} · ${workout['objective']}';
  }

  List<HorizontalImageTitleListDTO> getHorizontalImageTitleListDTO() {
    final List<dynamic> dynamicList = content['personals'] as List<dynamic>;

    return dynamicList.map((item) {
      return HorizontalImageTitleListDTO(
        id: item['personalId'] as String,
        title: item['name'] as String,
        imageUrl: item['imageUrl'] as String,
      );
    }).toList();
  }

  List<CardWorkoutSheetDTO> getWorkoutSheetListDTO() {
    final List<dynamic> dynamicList = content['workoutSheets'];
    return dynamicList.map((item) {
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
          tagTitle: amount,
          subtitle: getSubtitle(item));
    }).toList();
  }

  bool canShowListPersonal() {
    return (content['personals'] as List<dynamic>).length >= 5;
  }
}
