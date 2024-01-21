import 'dart:io';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_drop_down.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter_flow/upload_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/information_dialog/information_dialog_widget.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'add_exercise_model.dart';
export 'add_exercise_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddExerciseWidget extends StatefulWidget {
  const AddExerciseWidget({
    Key? key,
    this.exercise,
    this.categories,
    this.equipment,
    bool? isUpdate,
  })  : this.isUpdate = isUpdate ?? false,
        super(key: key);

  final dynamic exercise;
  final List<dynamic>? categories;
  final List<dynamic>? equipment;
  final bool isUpdate;

  @override
  _AddExerciseWidgetState createState() => _AddExerciseWidgetState();
}

class _AddExerciseWidgetState extends State<AddExerciseWidget> {
  late AddExerciseModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic exercise;
  String? videoImageUrl;
  String? selectedVideoPath;
  bool selectedVideo = false;
  bool isUpdate = false;
  bool _wasEdited = false;
  final _unfocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  String _bottomButtonText = 'Salvar';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddExerciseModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'AddExercise'});
    _model.yourNameController ??= TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    exercise = widget.exercise;
    _model.equipment = widget.equipment;
    _model.categories = widget.categories;
    _model.personalId = currentUserUid;
    isUpdate = widget.isUpdate;

    _unfocusNode.addListener(() {
      setState(() {
        if (_unfocusNode.hasFocus) {
          _bottomButtonText = 'Confirmar';
          _scrollController.animateTo(
            _scrollController.offset + 100.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            _scrollController.offset - 100.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          _bottomButtonText = isUpdate ? 'Atualizar' : 'Salvar';
        }
      });
    });

    if (exercise != null) {
      videoImageUrl = exercise['imageUrl'] as String;
      _model.yourNameController?.text = exercise['name'] as String;
      _model.exercise = exercise;
      _model.videoUrl = exercise['videoUrl'] as String;
      _model.imageUrl = exercise['imageUrl'] as String;
      _model.streamingURL = exercise['streamingURL'] as String;
      // _model.personalId = exercise['personalId'] as String;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _unfocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _unfocusNode.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            onPressed: () async {
              if (_wasEdited) {
                await showAlignedDialog(
                  context: context,
                  isGlobal: true,
                  avoidOverflow: false,
                  targetAnchor: AlignmentDirectional(0.0, 0.0)
                      .resolve(Directionality.of(context)),
                  followerAnchor: AlignmentDirectional(0.0, 0.0)
                      .resolve(Directionality.of(context)),
                  builder: (dialogContext) {
                    return Material(
                      color: Colors.transparent,
                      child: InformationDialogWidget(
                        title: 'Atenção',
                        message:
                            'O exercício foi alterado. Tem certeza que deseja sair do exercício sem salvar?',
                        actionButtonTitle: 'Sair do exercício',
                      ),
                    );
                  },
                ).then(
                  (value) {
                    setState(() {
                      if (value == 'leave') {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: true,
          title: Text(
            isUpdate ? 'Editar' : 'Novo Exercício',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                ),
          ),
          actions: [
            Visibility(
              visible: isUpdate,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: FlutterFlowIconButton(
                  borderColor: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: 20.0,
                  borderWidth: 1.0,
                  buttonSize: 40.0,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  icon: Icon(
                    Icons.keyboard_control_sharp,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 20.0,
                  ),
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      useSafeArea: true,
                      builder: (BuildContext context) {
                        return Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.copy),
                                title: Text('Duplicar'),
                                onTap: () {
                                  _wasEdited = true;
                                  isUpdate = false;
                                  _model.setCopyName();
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Treino duplicado.',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 1000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                    ),
                                  );
                                  setState(() {});
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.cancel),
                                title: Text('Cancelar'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 32.0, 0.0, 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  child: Container(
                                    width: 429.0,
                                    height: 309.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: selectedVideo
                                                ? Image.asset(
                                                    videoImageUrl!,
                                                    width: 557.0,
                                                    height: 439.0,
                                                    fit: BoxFit.cover,
                                                  )
                                                : videoImageUrl?.isNotEmpty ==
                                                        true
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            videoImageUrl!,
                                                        width: 557.0,
                                                        height: 439.0,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Container(),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-0.01, 0.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30.0,
                                            borderWidth: 1.0,
                                            buttonSize: 50.0,
                                            fillColor: Color(0x78FFFFFF),
                                            icon: Icon(
                                              Icons.videocam_sharp,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 30.0,
                                            ),
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'ADD_EXERCISE_videocam_sharp_ICN_ON_TAP');
                                              logFirebaseEvent(
                                                  'IconButton_store_media_for_upload');
                                              final selectedMedia =
                                                  await selectMediaWithSourceBottomSheet(
                                                    context: context,
                                                allowVideo: true,
                                                allowPhoto: false,
                                              );

                                              if (selectedMedia != null &&
                                                  selectedMedia.isNotEmpty) {
                                                if (selectedMedia.first
                                                    .filePath!.isNotEmpty) {
                                                  File videoFile = File(
                                                      selectedMedia
                                                          .first.filePath!);
                                                  int videoFileLength =
                                                      await videoFile.length();
                                                  double videoSizeInMB =
                                                      videoFileLength /
                                                          (1024 * 1024);

                                                  if (videoSizeInMB <= 10.0) {
                                                    _wasEdited = true;
                                                    selectedVideoPath =
                                                        selectedMedia
                                                            .first.filePath!;
                                                    videoImageUrl =
                                                        await VideoThumbnail
                                                            .thumbnailFile(
                                                                video: selectedMedia
                                                                    .first
                                                                    .filePath!);

                                                    setState(() {
                                                      if (selectedMedia
                                                          .isNotEmpty) {
                                                        _model.setMediaNull();
                                                        _model.selectedImage =
                                                            true;
                                                        selectedVideo = true;
                                                      }
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'O vídeo é muito grande. Por favor, selecione um vídeo menor que 10MB.',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 0.0, 16, 16.0),
                          child: TextFormField(
                            focusNode: _unfocusNode,
                            maxLength: 30,
                            controller: _model.yourNameController,
                            textCapitalization: TextCapitalization.sentences,
                            obscureText: false,
                            onChanged: (value) {
                              _wasEdited = true;
                            },
                            decoration: InputDecoration(
                              counterText: '',
                              labelText: 'Nome',
                              labelStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              hintStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 24.0, 0.0, 24.0),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            validator: _model.yourNameControllerValidator
                                .asValidator(context),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 12.0),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.stateValueController1 ??=
                                FormFieldController<String>(
                              _model.stateValue1 ??= getJsonField(
                                widget.exercise,
                                r'''$.category.name''',
                              ).toString(),
                            ),
                            options: widget.categories!
                                .map((e) => getJsonField(
                                      e,
                                      r'''$.name''',
                                    ))
                                .toList()
                                .map((e) => e.toString())
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _model.stateValue1 = val),
                            width: double.infinity,
                            height: 56.0,
                            textStyle: FlutterFlowTheme.of(context).bodyMedium,
                            hintText: 'Grupo muscular',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 15.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2.0,
                            borderColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderWidth: 2.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                20.0, 4.0, 12.0, 4.0),
                            hidesUnderline: true,
                            isSearchable: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 12.0),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.stateValueController2 ??=
                                FormFieldController<String>(
                              _model.stateValue2 ??= getJsonField(
                                widget.exercise,
                                r'''$.equipament.name''',
                              ).toString(),
                            ),
                            options: widget.equipment!
                                .map((e) => getJsonField(
                                      e,
                                      r'''$.name''',
                                    ))
                                .toList()
                                .map((e) => e.toString())
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _model.stateValue2 = val),
                            width: double.infinity,
                            height: 56.0,
                            textStyle: FlutterFlowTheme.of(context).bodyMedium,
                            hintText: 'Equipamento',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 15.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2.0,
                            borderColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderWidth: 2.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                20.0, 4.0, 12.0, 4.0),
                            hidesUnderline: true,
                            isSearchable: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  BottomButtonFixedWidget(
                    buttonTitle: _bottomButtonText,
                    onPressed: () async {
                      if (_unfocusNode.hasFocus) {
                        _unfocusNode.unfocus();
                        return;
                      }
                      await sendExercise(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendExercise(BuildContext context) async {
    if (_model.isExerciseComplete()) {
      if (_model.streamingURL == null &&
          _model.videoUrl == null &&
          _model.imageUrl == null &&
          selectedVideoPath != null) {
        try {
          final result = await UploadVideoCall.call(selectedVideoPath!);

          final json = jsonDecode(result.body);
          _model.setMedia(json);
        } catch (error) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Erro'),
                content: Text(
                    'Ocorreu um erro ao fazer o upload do vídeo. Por favor, tente novamente.'),
                actions: [
                  TextButton(
                    child: Text('Fechar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          return;
        }
      }

      if (isUpdate) {
        logFirebaseEvent('Button_backend_call');
        _model.apiResultl1o =
            await BaseGroup.updateExerciseCall.call(params: _model.exercise);
        if ((_model.apiResultl1o?.succeeded ?? true)) {
          logFirebaseEvent('Button_navigate_back');
          logFirebaseEvent('Button_show_snack_bar');
          context.pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Exercício atualizado.',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              duration: Duration(milliseconds: 2000),
              backgroundColor: FlutterFlowTheme.of(context).secondary,
            ),
          );
        } else {
          logFirebaseEvent('Button_alert_dialog');
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Ooops'),
                content: Text(
                    'Ocorreu um erro inesperado. Por favor, tente novamente.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }

        setState(() {});
      } else {
        logFirebaseEvent('Button_backend_call');
        _model.createExerciseResult =
            await BaseGroup.createExerciseCall.call(params: _model.exercise);
        if ((_model.createExerciseResult?.succeeded ?? true)) {
          logFirebaseEvent('Button_navigate_back');
          context.pop(true);
          logFirebaseEvent('Button_show_snack_bar');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Exercício cadastrado.',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              duration: Duration(milliseconds: 2000),
              backgroundColor: FlutterFlowTheme.of(context).secondary,
            ),
          );
        } else {
          logFirebaseEvent('Button_alert_dialog');
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Ooops'),
                content: Text(
                    'Ocorreu um erro inesperado. Por favor, tente novamente.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }

        setState(() {});
      }
      return;
    }
    await showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: Text('Ooops'),
          content:
              Text('Preencha todos os campos antes de salvar o exercício.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
