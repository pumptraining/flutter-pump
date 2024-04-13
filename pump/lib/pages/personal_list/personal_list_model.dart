import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';

class PersonalListModel extends FlutterFlowModel {
  dynamic content;

  void initState(BuildContext context) {}

  void dispose() {}

  int numberOfRows() {
    final List<dynamic> personalList = content['personalList'];
    return personalList.length;
  }

  dynamic getPersonalByIndex(int index) {
    final List<dynamic> personalList = content['personalList'];
    return personalList.elementAt(index);
  }
}
