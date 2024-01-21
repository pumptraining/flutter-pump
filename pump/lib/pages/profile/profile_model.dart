import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';

class ProfileModel extends FlutterFlowModel {
  
  dynamic content;

  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }
}
