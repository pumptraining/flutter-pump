import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:pump_creator/models/tag_model.dart';
import 'package:flutter/material.dart';

class CustomerListModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  dynamic content;

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  String? choiceChipsValue1;
  FormFieldController<List<String>>? choiceChipsValueController1;

  List<String>? selectedCategories;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    textController ??= TextEditingController();
  }

  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  bool showEmptyState() {
    return content['customers'] == null || content['customers']?.isEmpty;
  }

  String mapSkillLevel(String level) {
    switch (level) {
      case "advanced":
        return "avançado";
      case "intermediate":
        return "intermediário";
      case "beginner":
        return "iniciante";
      default:
        return "";
    }
  }

  Color mapSkillLevelColor(String level, bool opacity) {
    switch (level) {
      case "advanced":
        return opacity ? Color(0xFFEB7F7F).withOpacity(0.3) : Color(0xFFEB7F7F);
      case "intermediate":
        return opacity ? Color(0xFFFFD10F).withOpacity(0.3) : Color(0xFFFFD10F);
      case "beginner":
        return opacity ? Color(0xFFC4EF19).withOpacity(0.3) : Color(0xFFC4EF19);
      default:
        return Colors.white.withOpacity(0.4);
    }
  }

  String mapStatus(String status) {
    switch (status) {
      case "active":
        return "ativo";
      case "inactive":
        return "inativo";
      default:
        return "";
    }
  }

  Color mapStatusColor(String status, bool opacity) {
    switch (status) {
      case "inactive":
        return opacity
            ? Color.fromARGB(255, 238, 77, 77).withOpacity(0.3)
            : Color.fromARGB(255, 238, 77, 77);
      case "active":
        return opacity
            ? Color.fromARGB(255, 15, 255, 39).withOpacity(0.3)
            : Color.fromARGB(255, 15, 255, 39);
      default:
        return Colors.white.withOpacity(0.3);
    }
  }

  Color mapObjectiveColor(String objective, bool opacity) {
    switch (objective) {
      case "hipertrofia":
        return opacity
            ? Color.fromARGB(255, 80, 77, 238).withOpacity(0.3)
            : Color.fromARGB(255, 80, 77, 238);
      case "perda de peso":
        return opacity
            ? Color.fromARGB(255, 15, 255, 255).withOpacity(0.3)
            : Color.fromARGB(255, 15, 255, 255);
      case "resistência":
        return opacity
            ? Color.fromARGB(255, 235, 215, 37).withOpacity(0.3)
            : Color.fromARGB(255, 235, 215, 37);
      default:
        return Colors.white.withOpacity(0.3);
    }
  }

  bool isLastCustomer(int index, dynamic array) {
    return array.length == index + 1;
  }

  TagModel tagModelWithId(String tagId) {
    List<dynamic> allTags = content['allTags'];
    final tag = allTags.where((tag) => tag['id'] == tagId).first;
    return TagModel(
        title: tag['title'],
        color: Color(int.parse(tag['color'].substring(1), radix: 16)),
        isSelected: true);
  }

  bool customerIsBlockedOrPending(dynamic customer) {
    return (customer?['status'] != null && customer?['status'] == 'blocked') || customer?['personalInvite'] == 'pending' || customer?['personalInvite'] == 'rejected';
  }

  int tagCount(dynamic customer) {
    if (customerIsBlockedOrPending(customer)) {
      return 1;
    }
    int count = customer['tags'].length;
    return count;
  }

  dynamic returnFilteredContent() {
    if (textController == null || textController!.text.isEmpty) {
      return content['customers'];
    }
    dynamic filteredCustomers = content['customers']
        .where((customer) =>
            textController!.text.isEmpty ||
            customer['name']
                .toLowerCase()
                .contains(textController!.text.toLowerCase()))
        .toList();
    return filteredCustomers;
  }
}
