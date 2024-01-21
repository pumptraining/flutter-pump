import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:pump_creator/models/tag_model.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class AddCustomerModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for ChoiceChips widget.
  String? choiceChipsValue;
  FormFieldController<List<String>>? choiceChipsValueController;

  FocusNode? textFieldFocusNodeAlert;
  TextEditingController? textControllerAlert;
  String? Function(BuildContext, String?)? textController1ValidatorAlert;
  List<TagModel>? tags;

  dynamic content;
  late bool isEdit;
  late String email;
  late List<dynamic> selectedTags;

  void initState(BuildContext context) {
    tags = [];
  }

  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }

  void addNewTag(String name, Color color) {
    tags?.add(TagModel(title: name, color: color, isSelected: true));
  }

  List<Map<String, dynamic>> getSelectedTags() {
    List<TagModel> selectedTags = tags ?? [];
    List<Map<String, dynamic>> dynamicTags = selectedTags
        .map((tag) => {
              'title': tag.title,
              'color': tag.color.toCssString(),
              'isSelected': tag.isSelected,
              'id': tag.id,
            })
        .toList();

    return dynamicTags;
  }

  String? validateEmail() {
    String? email = textController1?.text;

    if (email == null || email.isEmpty) {
      return 'Digite o e-mail do aluno para enviar o convite.';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Formato do e-mail inválido.';
    }

    return null;
  }

  void createTagModels() {
    if (tags!.isEmpty) {
      for (var tag in content['allTags']) {
        tags?.add(TagModel(
          id: tag['id']?.toString(),
          title: tag['title'] ?? "",
          color: Color(int.parse(tag['color'].substring(1), radix: 16)),
          isSelected: selectedTags.contains(tag['id']?.toString()),
        ));
      }
    }
  }
}
