import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

class CancelSubscriptionModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.
  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
