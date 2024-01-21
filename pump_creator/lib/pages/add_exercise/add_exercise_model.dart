import 'package:api_manager/api_manager/api_manager.dart';
import 'package:api_manager/model/uploaded_file.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class AddExerciseModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for yourName widget.
  TextEditingController? yourNameController;
  String? Function(BuildContext, String?)? yourNameControllerValidator;
  // State field(s) for state widget.
  String? stateValue1;
  FormFieldController<String>? stateValueController1;
  // State field(s) for state widget.
  String? stateValue2;
  FormFieldController<String>? stateValueController2;
  // Stores action output result for [Backend Call - API (UpdateExercise)] action in Button widget.
  ApiCallResponse? apiResultl1o;
  // Stores action output result for [Backend Call - API (CreateExercise)] action in Button widget.
  ApiCallResponse? createExerciseResult;

  dynamic exercise;
  List<dynamic>? categories;
  List<dynamic>? equipment;
  String? imageUrl;
  String? videoUrl;
  String? streamingURL;
  bool selectedImage = false;
  String? personalId;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    yourNameController?.dispose();
  }

  /// Additional helper methods are added here.

  bool isExerciseComplete() {
    if (exercise == null) {
      exercise = {};
    }

    final selectedCategory = categories
        ?.where((json) => json['name'] == stateValueController1?.value)
        .toList();
    final selectedEquipment = equipment
        ?.where((json) => json['name'] == stateValueController2?.value)
        .toList();

    if (selectedCategory != null && selectedCategory.length > 0) {
      exercise['category'] = selectedCategory.first;
    } else {
      return false;
    }

    if (selectedEquipment != null && selectedEquipment.length > 0) {
      exercise['equipament'] = selectedEquipment.first;
    } else {
      return false;
    }

    if (!selectedImage &&
        imageUrl == null &&
        videoUrl == null &&
        streamingURL == null) {
      return false;
    }

    if (yourNameController != null && yourNameController.text.isNotEmpty) {
      exercise['name'] = yourNameController.text;
    } else {
      return false;
    }

    if (personalId != null && personalId!.isNotEmpty) {
      exercise['personalId'] = personalId;
      return true;
    } else {
      return false;
    }
  }

  void setMediaNull() {
    imageUrl = null;
    videoUrl = null;
    streamingURL = null;
  }

  void setMedia(dynamic response) {
    streamingURL = response['response']['streamingURL'];
    videoUrl = response['response']['videoUrl'];
    imageUrl = response['response']['imageUrl'];
    exercise['imageUrl'] = imageUrl;
    exercise['videoUrl'] = videoUrl;
    exercise['streamingURL'] = streamingURL;
  }

  void setCopyName() {
    yourNameController.text = '${exercise['name']} - Cópia';
  }
}
