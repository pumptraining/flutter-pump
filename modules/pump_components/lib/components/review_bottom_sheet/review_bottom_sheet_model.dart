import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

class ReviewBottomSheetModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for RatingBar widget.
  double? ratingBarValue;
  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  bool isPersonal = false;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textController?.dispose();
  }

  bool sendButtonEnabled() {
    if (!isPersonal) {
      return ratingBarValue != 0.0;
    }
    return ratingBarValue != 0.0 && textController!.text.trim().isNotEmpty;
  }
}
