import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/model/uploaded_file.dart';
import 'package:flutter_flow/common/user_settings.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for TextField widget.
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;

  String? imagePath;
  dynamic personal;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    textController1?.dispose();
    textController2?.dispose();
    textController3?.dispose();
    textController4?.dispose();
    textController5?.dispose();
  }

  /// Action blocks are added here.

  void setMediaNull() {
    if (personal != null && personal['personalImageUrl'] != null) {
      personal['personalImageUrl'] = null;
    }
  }

  void setMedia(dynamic response) {
    if (personal == null) {
      personal = {};
    }
    personal['personalImageUrl'] = response['response']['imageUrl'];
  }

  bool needUploadImage() {
    if (imagePath != null &&
        (personal == null || personal['personalImageUrl'] == null)) {
      return true;
    }
    return false;
  }

  void setPersonal() {
    personal['firstName'] = textController1.text;
    personal['phone'] = formatPhoneNumber(textController4.text);
    personal['description'] = textController5.text;
    personal['fcmToken'] = UserSettings().getFcmToken();
  }

  bool canSave() {
    if (personal['firstName'].isEmpty ||
        personal['phone'].isEmpty ||
        personal['phone'].length != 13) {
      return false;
    }
    return currentUserPhoto.isNotEmpty ||
        personal['personalImageUrl'] != null ||
        imagePath != null;
  }

  String formatPhoneNumber(String input) {
    String numericString = input.replaceAll(RegExp(r'[^0-9]'), '');
    return numericString;
  }

  String formatPhoneNumberText(String input) {
    String numericString = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericString.length >= 11) {
      return '+${numericString.substring(0, 2)} (${numericString.substring(2, 4)}) ${numericString.substring(4, 5)} ${numericString.substring(5, 9)}-${numericString.substring(9)}';
    } else {
      return '';
    }
  }
}
