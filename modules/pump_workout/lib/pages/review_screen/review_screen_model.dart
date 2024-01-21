import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:pump_components/components/review_card/review_card_model.dart';

class ReviewScreenModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // Model for ReviewCard component.
  late ReviewCardModel reviewCardModel1;
  // Model for ReviewCard component.
  late ReviewCardModel reviewCardModel2;
  // Model for ReviewCard component.
  late ReviewCardModel reviewCardModel3;
  // Model for ReviewCard component.
  late ReviewCardModel reviewCardModel4;

  dynamic content;
  late bool isPersonal;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    reviewCardModel1 = createModel(context, () => ReviewCardModel());
    reviewCardModel2 = createModel(context, () => ReviewCardModel());
    reviewCardModel3 = createModel(context, () => ReviewCardModel());
    reviewCardModel4 = createModel(context, () => ReviewCardModel());
  }

  void dispose() {
    reviewCardModel1.dispose();
    reviewCardModel2.dispose();
    reviewCardModel3.dispose();
    reviewCardModel4.dispose();
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
}
