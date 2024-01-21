import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

class Profile14OtherUserModel extends FlutterFlowModel {
  /// Initialization and disposal methods.

  final unfocusNode = FocusNode();
  dynamic content;
  PageController? pageViewController;
  
  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  bool showRating() {
    return content['feedbacks'] != null && content['feedbacks'].length > 0;
  }

  bool canShowWorkoutSheets() {
    return content['workoutSheets'] != null && content['workoutSheets'].length > 0;
  }

  String getFeedbackName(dynamic feedback) {
    if (feedback['name'] != null && feedback['name'].isNotEmpty) {
      return feedback['name'];
    } else if (feedback['email'] != null && feedback['email'].isNotEmpty) {
      final email = feedback['email'];
      int indexOfAtSymbol = email.indexOf('@');
      if (indexOfAtSymbol != -1) {
        String username = email.substring(0, indexOfAtSymbol);
        return username;
      }
    }
    return "Usuário";
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

  String getSubtitle(dynamic workout) {
    return '${mapSkillLevel(workout['level'])} · ${workout['objective']}';
  }

  bool isPumpProfile() {
    return content['personal']['personalUserId'] == 'Cq3RNV2Qvueil8hbRRrLbd82c0p2';
  }
}
