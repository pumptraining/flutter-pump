import 'dart:io';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:pump_components/components/information_dialog/information_dialog_widget.dart';
import 'package:pump_components/components/tag_component/tag_component_widget.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import 'package:pump_creator/pages/add_workout_sheet_plan/add_workout_sheet_plan_widget.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/upload_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'add_workout_sheet_model.dart';
export 'add_workout_sheet_model.dart';

class AddWorkoutSheetWidget extends StatefulWidget {
  const AddWorkoutSheetWidget({
    Key? key,
    this.workoutSheet,
    this.workoutId,
    this.isUpdate,
  }) : super(key: key);

  final dynamic workoutSheet;
  final String? workoutId;
  final bool? isUpdate;

  @override
  _AddWorkoutSheetWidgetState createState() => _AddWorkoutSheetWidgetState();
}

class _AddWorkoutSheetWidgetState extends State<AddWorkoutSheetWidget> {
  late AddWorkoutSheetModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _wasEdited = false;

  final _unfocusNodeName = FocusNode();
  final _unfocusNodeDescription = FocusNode();
  final ScrollController _scrollController = ScrollController();
  String _bottomButtonText = 'Salvar';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddWorkoutSheetModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'AddWorkoutSheet'});
    _model.yourNameController1 ??= TextEditingController();
    _model.yourNameController2 ??= TextEditingController();
    _model.yourNameController3 ??= TextEditingController();

    _model.isUpdate = widget.isUpdate ?? false;

    _unfocusNodeName.addListener(() {
      setState(() {
        if (_unfocusNodeName.hasFocus) {
          _bottomButtonText = 'Confirmar';
          _scrollController.animateTo(
            _scrollController.offset + 130.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            _scrollController.offset - 130.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          _bottomButtonText = _model.isUpdate ? 'Atualizar' : 'Salvar';
        }
      });
    });

    _unfocusNodeDescription.addListener(() {
      setState(() {
        if (_unfocusNodeDescription.hasFocus) {
          _bottomButtonText = 'Confirmar';
          _scrollController.animateTo(
            _scrollController.offset + 130.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            _scrollController.offset - 130.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          _bottomButtonText = _model.isUpdate ? 'Atualizar' : 'Salvar';
        }
      });
    });

    if (widget.workoutSheet != null) {
      _model.setValues(widget.workoutSheet);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNodeName.dispose();
    _unfocusNodeDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _unfocusNodeDescription.unfocus();
        _unfocusNodeName.unfocus();
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
                            'O programa de treino foi alterado.\nTem certeza que deseja sair do programa sem salvar?',
                        actionButtonTitle: 'Sair do programa',
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
            _model.isUpdate ? 'Editar' : 'Novo Programa',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                ),
          ),
          actions: [
            Visibility(
              visible: _model.isUpdate,
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
                                  _model.isUpdate = false;
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
                                      duration: Duration(milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                    ),
                                  );
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
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: FutureBuilder<ApiCallResponse>(
                  future: BaseGroup.trainingContentSheetCall.call(params: {
                    'workoutId': widget.workoutId ?? _model.getWorkoutSheetId()
                  }),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator(strokeWidth: 1.0,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      );
                    }
                    _model.contentResponse = snapshot.data!.jsonBody;

                    if (_model.workoutSheet == null) {
                      _model.setValues(_model.contentResponse['workoutSheet']);
                      _model.workouts = _model.contentResponse['workouts'];
                    }

                    _model.prepareObjectives();

                    return SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 100),
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
                                      height: 249.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: _model.selectedImage &&
                                                      _model.imagePath != null
                                                  ? Image.asset(
                                                      _model.imagePath!,
                                                      width: 557.0,
                                                      height: 254.0,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : _model.workoutSheet !=
                                                              null &&
                                                          _model.workoutSheet[
                                                                  'imageUrl'] !=
                                                              null &&
                                                          (_model.workoutSheet[
                                                                          'imageUrl']
                                                                      as String)
                                                                  .isNotEmpty ==
                                                              true
                                                      ? CachedNetworkImage(
                                                          imageUrl: _model
                                                                  .workoutSheet[
                                                              'imageUrl'],
                                                          width:
                                                              double.infinity,
                                                          height: 254.0,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Container(),
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional(
                                                -0.01, 0.0),
                                            child: FlutterFlowIconButton(
                                              borderColor: Colors.transparent,
                                              borderRadius: 30.0,
                                              borderWidth: 1.0,
                                              buttonSize: 50.0,
                                              fillColor: Color(0x78FFFFFF),
                                              icon: Icon(
                                                Icons.camera_alt_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 30.0,
                                              ),
                                              onPressed: () async {
                                                logFirebaseEvent(
                                                    'ADD_WORKOUT_SHEET_camera_alt_rounded_ICN');
                                                logFirebaseEvent(
                                                    'IconButton_store_media_for_upload');
                                                final selectedMedia =
                                                    await selectMediaWithSourceBottomSheet(
                                                  context: context,
                                                  allowVideo: false,
                                                  allowPhoto: true,
                                                );
                                                if (selectedMedia != null &&
                                                    selectedMedia.isNotEmpty &&
                                                    selectedMedia.first
                                                        .filePath!.isNotEmpty) {
                                                  File imageFile = File(
                                                      selectedMedia
                                                          .first.filePath!);
                                                  int imageFileLength =
                                                      await imageFile.length();
                                                  double imageSizeInMB =
                                                      imageFileLength /
                                                          (1024 * 1024);

                                                  if (imageSizeInMB <= 5.0) {
                                                    _model.imagePath =
                                                        selectedMedia
                                                            .first.filePath;

                                                    setState(() {
                                                      _model.setMediaNull();
                                                      _model.selectedImage =
                                                          true;
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'A imagem é muito grande. Por favor, selecione uma imagem menor que 5MB.',
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
                          // SwitchListTile.adaptive(
                          //   value: _model.switchListTileValue ??=
                          //       _model.getToggleValue(),
                          //   onChanged: (newValue) async {
                          //     setState(() {
                          //       _model.switchListTileValue = newValue!;
                          //       _model.setToggle(newValue);
                          //     });
                          //   },
                          //   title: Text(
                          //     'Disponível no Pump',
                          //     style: FlutterFlowTheme.of(context).titleSmall,
                          //   ),
                          //   tileColor:
                          //       FlutterFlowTheme.of(context).primaryBackground,
                          //   activeColor: Color(0xFF4B39EF),
                          //   activeTrackColor: Color(0x8D4B39EF),
                          //   dense: false,
                          //   controlAffinity: ListTileControlAffinity.trailing,
                          //   contentPadding: EdgeInsetsDirectional.fromSTEB(
                          //       24.0, 0.0, 20.0, 12.0),
                          // ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 16.0),
                            child: TextFormField(
                              focusNode: _unfocusNodeName,
                              maxLength: 30,
                              controller: _model.yourNameController1,
                              textCapitalization: TextCapitalization.sentences,
                              obscureText: false,
                              onChanged: (value) {
                                _wasEdited = true;
                                _model.setTitle(value);
                              },
                              decoration: InputDecoration(
                                counterText: '',
                                labelText: 'Nome do programa',
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
                                    20.0, 24.0, 20.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              validator: _model.yourNameController1Validator
                                  .asValidator(context),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 16.0),
                              child: TextFormField(
                                controller: _model.yourNameController2,
                                inputFormatters: [
                                  CurrencyTextInputFormatter(
                                      locale: 'pt-br', symbol: 'R\$')
                                ],
                                keyboardType: TextInputType.number,
                                textCapitalization: TextCapitalization.words,
                                obscureText: false,
                                onChanged: (value) {
                                  _model.setAmount(value);
                                  _wasEdited = true;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Valor',
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          20.0, 24.0, 20.0, 24.0),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                validator: _model.yourNameController2Validator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 16.0),
                            child: TextFormField(
                              focusNode: _unfocusNodeDescription,
                              maxLength: 300,
                              controller: _model.yourNameController3,
                              textCapitalization: TextCapitalization.sentences,
                              obscureText: false,
                              onChanged: (value) {
                                _model.setDescription(value);
                                _wasEdited = true;
                              },
                              decoration: InputDecoration(
                                labelText: 'Descrição',
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
                                    20.0, 24.0, 20.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              maxLines: 4,
                              validator: _model.yourNameController3Validator
                                  .asValidator(context),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0, 16.0, 0.0),
                                  child: Text(
                                    'Objetivo',
                                    style:
                                        FlutterFlowTheme.of(context).titleLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 24.0, 16.0, 12.0),
                                child: Wrap(
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  children: _model.objectiveTags.map((element) {
                                    return TagComponentWidget(
                                      title: element['title'],
                                      tagColor:
                                          FlutterFlowTheme.of(context).primary,
                                      selected:
                                          _model.objectiveIsSelected(element),
                                      maxHeight: 32,
                                      onTagPressed: () {
                                        _wasEdited = true;
                                        HapticFeedback.mediumImpact();
                                        setState(() {
                                          _model.objectiveTags
                                              .forEach((element) {
                                            element['isSelected'] = false;
                                          });
                                          element['isSelected'] =
                                              !element['isSelected'];
                                          _model
                                              .setObjectives(element['title']);
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            child: Divider(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 32.0, 16.0, 0.0),
                                  child: Text(
                                    'Nível',
                                    style:
                                        FlutterFlowTheme.of(context).titleLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 24.0, 16.0, 12.0),
                                child: Wrap(
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  children: _model.levelTags.map((element) {
                                    return TagComponentWidget(
                                      title: element['title'],
                                      tagColor:
                                          FlutterFlowTheme.of(context).primary,
                                      selected: _model.levelIsSelected(element),
                                      maxHeight: 32,
                                      onTagPressed: () {
                                        _wasEdited = true;
                                        HapticFeedback.mediumImpact();
                                        setState(() {
                                          _model.levelTags.forEach((element) {
                                            element['isSelected'] = false;
                                          });
                                          element['isSelected'] =
                                              !element['isSelected'];
                                          _model.setLevel(element['title']);
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                            child: Divider(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 32.0, 16.0, 0.0),
                                  child: Text(
                                    'Treinos',
                                    style:
                                        FlutterFlowTheme.of(context).titleLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                            child: Builder(
                              builder: (context) {
                                final weeks = _model.workoutPlan;

                                if (weeks.length == 0) {
                                  return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 32),
                                      child: EmptyListWidget(
                                          title: 'Sem treinos',
                                          message:
                                              'Nenhum treino adicionada ainda. Adicione os treinos para criar o programa.',
                                          buttonTitle: 'Adicionar',
                                          onButtonPressed: () async {
                                            await addWorkout(context);
                                          }));
                                }

                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: weeks.length,
                                  itemBuilder: (context, weeksIndex) {
                                    final weeksItem = weeks[weeksIndex];
                                    return Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 8, 16, 12),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxWidth: 750,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 4,
                                                    color: Color(0x33000000),
                                                    offset: Offset(0, 2),
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(16, 16, 16, 8),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 0, 12),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: 70,
                                                            height: 2,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 0, 24),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              '${weeksItem['quantity']} Semanas',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleLarge,
                                                            ),
                                                          ),
                                                          FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              final result =
                                                                  await Navigator
                                                                      .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AddWorkoutSheetPlanWidget(
                                                                    key: Key(
                                                                        '$weeksIndex'),
                                                                    workoutPlan:
                                                                        weeksItem,
                                                                    workouts: _model
                                                                        .workouts,
                                                                  ),
                                                                ),
                                                              );
                                                              if (result !=
                                                                  null) {
                                                                setState(() {
                                                                  final indexkey =
                                                                      result[0]
                                                                          .value;
                                                                  final indexPlan =
                                                                      int.parse(
                                                                          indexkey);
                                                                  _model.workouts =
                                                                      result[2];
                                                                  _model.workoutPlan[
                                                                          indexPlan] =
                                                                      result[1];
                                                                  _model
                                                                      .setWeeks();
                                                                });
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'Programa atualizado.',
                                                                      style:
                                                                          TextStyle(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                      ),
                                                                    ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            1000),
                                                                    backgroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            text: 'Editar',
                                                            options:
                                                                FFButtonOptions(
                                                              width: 90.0,
                                                              height: 34.0,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          4.0),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            14,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                      ),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Builder(
                                                      builder: (context) {
                                                        final workoutList =
                                                            _model.workoutPlan[
                                                                    weeksIndex]
                                                                ['workouts'];
                                                        return ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount: workoutList
                                                              .length,
                                                          itemBuilder: (context,
                                                              workoutListIndex) {
                                                            final workoutListItem =
                                                                _model.filterWorkoutById(
                                                                    workoutList[
                                                                        workoutListIndex]);
                                                            final isLast = workoutList
                                                                    .length ==
                                                                (workoutListIndex +
                                                                    1);

                                                            return Padding(
                                                              padding: EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      isLast
                                                                          ? 0
                                                                          : 12),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              4,
                                                                              0,
                                                                              12),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                1,
                                                                                1,
                                                                                1),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(12),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(12),
                                                                                child: workoutListItem != null && workoutListItem['trainingImageUrl'] != null
                                                                                    ? CachedNetworkImage(
                                                                                        imageUrl: workoutListItem['trainingImageUrl'],
                                                                                        width: 70.0,
                                                                                        height: 70.0,
                                                                                        fit: BoxFit.cover,
                                                                                      )
                                                                                    : Container(),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          workoutListItem != null ? workoutListItem['namePortuguese'] : '',
                                                                                          style: FlutterFlowTheme.of(context).titleSmall,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          _model.mapCategories(workoutListItem),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Poppins',
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          _model.mapSkillLevel(workoutListItem != null ? workoutListItem['trainingLevel'] : ''),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Poppins',
                                                                                                color: _model.mapSkillLevelColor(workoutListItem != null ? workoutListItem['trainingLevel'] : ''),
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    isLast
                                                                        ? Container()
                                                                        : Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                80,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Divider(
                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                            )),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: _model.workoutPlan.length > 0,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 32.0, 0.0, 32.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  await addWorkout(context);
                                },
                                text: 'Adicionar',
                                options: FFButtonOptions(
                                  width: 130.0,
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              BottomButtonFixedWidget(
                  buttonTitle: _bottomButtonText,
                  onPressed: () async {
                    if (_unfocusNodeName.hasFocus ||
                        _unfocusNodeDescription.hasFocus) {
                      _unfocusNodeName.unfocus();
                      _unfocusNodeDescription.unfocus();
                      return;
                    }

                    if (_model.validateErrorMessage() != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Atenção'),
                            content: Text(_model.validateErrorMessage()!),
                            actions: [
                              TextButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      if (_model.needUploadImage()) {
                        try {
                          final result =
                              await UploadImageCall.call(_model.imagePath!);

                          final json = jsonDecode(result.body);
                          _model.setMedia(json);
                        } catch (error) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Erro'),
                                content: Text(
                                    'Ocorreu um erro ao fazer o upload da imagem. Por favor, tente novamente.'),
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
                        }
                      }
                      var _shouldSetState = false;
                      if (_model.isUpdate) {
                        logFirebaseEvent('Button_backend_call');
                        _model.apiResultl1o =
                            await BaseGroup.updateTrainingSheetCall.call(
                          params: _model.workoutSheet,
                        );
                        _shouldSetState = true;
                        if ((_model.apiResultl1o?.succeeded ?? true)) {
                          logFirebaseEvent('Button_navigate_back');
                          context.pop(true);
                          logFirebaseEvent('Button_show_snack_bar');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Programa atualizado.',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 2000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
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
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext),
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                        if (_shouldSetState) setState(() {});
                        return;
                      } else {
                        logFirebaseEvent('Button_backend_call');
                        _model.createWorkoutSheetResult =
                            await BaseGroup.createTrainingSheetCall.call(
                          params: _model.workoutSheet,
                        );
                        _shouldSetState = true;
                        if ((_model.createWorkoutSheetResult?.succeeded ??
                            true)) {
                          logFirebaseEvent('Button_navigate_back');
                          context.pop(true);
                          logFirebaseEvent('Button_show_snack_bar');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Programa cadastrado.',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 2000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
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
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext),
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    }

                    setState(() {});
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addWorkout(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWorkoutSheetPlanWidget(
          key: Key(_model.getNextSectionIndex()),
        ),
      ),
    );
    if (result != null && result[1] != null) {
      setState(() {
        if (_model.workouts == null) {
          _model.workouts = [];
        }
        (_model.workouts as List).addAll(result[2]);
        _model.workouts = jsonDecode(jsonEncode(_model.workouts));

        final newWorkoutPlan = result[1].map<String, dynamic>(
          (key, value) => MapEntry(key.toString(), value),
        );
        _model.workoutPlan.add(newWorkoutPlan);
        _model.setWeeks();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Programa atualizado.',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: Duration(milliseconds: 1000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    }
  }
}
