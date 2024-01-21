import 'dart:io';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/information_dialog/information_dialog_widget.dart';
import 'package:pump_components/components/tag_component/tag_component_widget.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import 'package:pump_creator/index.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/upload_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'add_workout_model.dart';
export 'add_workout_model.dart';

class AddWorkoutWidget extends StatefulWidget {
  const AddWorkoutWidget({
    Key? key,
    this.workout,
    this.workoutId,
  }) : super(key: key);

  final dynamic workout;
  final String? workoutId;

  @override
  _AddWorkoutWidgetState createState() => _AddWorkoutWidgetState();
}

class _AddWorkoutWidgetState extends State<AddWorkoutWidget> {
  late AddWorkoutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final _commentUnfocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  String _bottomButtonText = 'Salvar';
  bool _wasEdited = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddWorkoutModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'AddWorkout'});
    _model.yourNameController1 ??= TextEditingController();
    _model.yourNameController2 ??= TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _model.workout = widget.workout;
    _model.setValues();

    if (widget.workoutId != null) {
      _model.isUpdate = true;
    }

    _unfocusNode.addListener(() {
      setState(() {
        if (_unfocusNode.hasFocus) {
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

    _commentUnfocusNode.addListener(() {
      setState(() {
        if (_commentUnfocusNode.hasFocus) {
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
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    _commentUnfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _commentUnfocusNode.unfocus();
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
                              'O treino foi alterado. Tem certeza que deseja sair do treino sem salvar?',
                          actionButtonTitle: 'Sair do treino',
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
              _model.isUpdate ? 'Editar' : 'Novo Treino',
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
                    borderColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
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
                Stack(
                  children: [
                    Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: FutureBuilder<ApiCallResponse>(
                          future: BaseGroup.trainingContentCall
                              .call(params: {'workoutId': widget.workoutId}),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: CircularProgressIndicator(
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              );
                            }
                            _model.contentResponse = snapshot.data!.jsonBody;

                            if (widget.workoutId != null &&
                                _model.workout['series'] == null) {
                              _model.workout =
                                  _model.contentResponse['workout'];
                              _model.setValues();
                            }

                            _model.prepareObjectives();
                            return buildContent(context);
                          },
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Stack buildContent(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 130),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 16.0),
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
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: _model.selectedImage &&
                                          _model.imagePath != null
                                      ? Image.asset(
                                          _model.imagePath!,
                                          width: 557.0,
                                          height: 254.0,
                                          fit: BoxFit.cover,
                                        )
                                      : _model.workout != null &&
                                              _model.workout[
                                                      'trainingImageUrl'] !=
                                                  null &&
                                              (_model.workout['trainingImageUrl']
                                                          as String)
                                                      .isNotEmpty ==
                                                  true
                                          ? CachedNetworkImage(
                                              imageUrl: _model
                                                  .workout['trainingImageUrl'],
                                              width: 557.0,
                                              height: 254.0,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-0.01, 0.0),
                                child: FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30.0,
                                  borderWidth: 1.0,
                                  buttonSize: 50.0,
                                  fillColor: Color(0x78FFFFFF),
                                  icon: Icon(
                                    Icons.camera_alt_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 30.0,
                                  ),
                                  onPressed: () async {
                                    logFirebaseEvent(
                                        'ADD_WORKOUT_camera_alt_rounded_ICN_ON_TA');
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
                                        selectedMedia
                                            .first.filePath!.isNotEmpty) {
                                      File imageFile =
                                          File(selectedMedia.first.filePath!);
                                      int imageFileLength =
                                          await imageFile.length();
                                      double imageSizeInMB =
                                          imageFileLength / (1024 * 1024);

                                      if (imageSizeInMB <= 5.0) {
                                        _model.imagePath =
                                            selectedMedia.first.filePath;

                                        setState(() {
                                          _model.setMediaNull();
                                          _model.selectedImage = true;
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'A imagem é muito grande. Por favor, selecione uma imagem menor que 5MB.',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                child: TextFormField(
                  focusNode: _unfocusNode,
                  maxLength: 30,
                  controller: _model.yourNameController1,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: false,
                  onChanged: (value) {
                    _model.workout['namePortuguese'] = value;
                    _wasEdited = true;
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'Nome do treino',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium,
                    hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primaryBackground,
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
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  validator:
                      _model.yourNameController1Validator.asValidator(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                child: TextFormField(
                  focusNode: _commentUnfocusNode,
                  maxLength: 200,
                  controller: _model.yourNameController2,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: false,
                  onChanged: (value) {
                    _model.workout['description'] = value;
                    _wasEdited = true;
                  },
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium,
                    hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primaryBackground,
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
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  maxLines: 4,
                  validator:
                      _model.yourNameController2Validator.asValidator(context),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0, 16.0, 0.0),
                      child: Text(
                        'Objetivo',
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 12.0),
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: _model.objectiveTags.map((element) {
                        return TagComponentWidget(
                          title: element['title'],
                          tagColor: FlutterFlowTheme.of(context).primary,
                          selected: _model.objectiveIsSelected(element),
                          maxHeight: 32,
                          onTagPressed: () {
                            _wasEdited = true;
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _model.objectiveTags.forEach((element) {
                                element['isSelected'] = false;
                              });
                              element['isSelected'] = !element['isSelected'];
                              _model.setObjective(element['title']);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Divider(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 0.0),
                      child: Text(
                        'Nível',
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 12.0),
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: _model.levelTags.map((element) {
                        return TagComponentWidget(
                          title: element['title'],
                          tagColor: FlutterFlowTheme.of(context).primary,
                          selected: _model.levelIsSelected(element),
                          maxHeight: 32,
                          onTagPressed: () {
                            _wasEdited = true;
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _model.levelTags.forEach((element) {
                                element['isSelected'] = false;
                              });
                              element['isSelected'] = !element['isSelected'];
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
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Divider(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 0.0),
                      child: Text(
                        'Séries',
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                child: Builder(
                  builder: (context) {
                    final setsList = _model.workout?['series'] ?? [];

                    if (setsList.isEmpty) {
                      return EmptyListWidget(
                          title: 'Sem séries',
                          message:
                              'Nenhuma série adicionada ainda. Adicione as séries para criar o treino.',
                          buttonTitle: 'Adicionar',
                          onButtonPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddWorkoutSetsWidget(
                                  sets: null,
                                  techniques:
                                      _model.contentResponse['techniques'],
                                ),
                              ),
                            );
                            if (result != null && result['exercises'] != null) {
                              _wasEdited = true;
                              setState(() {
                                if ((result['exercises'] as List).length > 0) {
                                  if (_model.workout?['series'] == null) {
                                    if (_model.workout == null) {
                                      _model.workout = {};
                                    }
                                    _model.workout?['series'] = [];
                                  }
                                  _model.workout?['series'].add(result);
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Série atualizada.',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 1000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                            }
                          });
                    }

                    return ReorderableListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: setsList.length,
                      onReorder: (int oldIndex, int newIndex) {
                        _wasEdited = true;
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item =
                              _model.workout?['series']?.removeAt(oldIndex);
                          _model.workout?['series']?.insert(newIndex, item);
                        });
                      },
                      itemBuilder: (context, setsListIndex) {
                        final setsListItem = setsList[setsListIndex];
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          key: Key('Key2zh_$setsListIndex'),
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 8.0, 16.0, 8.0),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 750.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x33000000),
                                        offset: Offset(0.0, 2.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 16.0, 16.0, 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 12),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 2,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${(setsListItem["quantity"])} Séries',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLarge,
                                              ),
                                            ),
                                            FFButtonWidget(
                                              onPressed: () async {
                                                logFirebaseEvent(
                                                    'ADD_WORKOUT_PAGE_EDITAR_BTN_ON_TAP');
                                                logFirebaseEvent(
                                                    'Button_navigate_to');

                                                final result =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddWorkoutSetsWidget(
                                                      sets: setsListItem,
                                                      techniques: _model
                                                              .contentResponse[
                                                          'techniques'],
                                                    ),
                                                  ),
                                                );
                                                if (result != null) {
                                                  _wasEdited = true;
                                                  setState(() {
                                                    if ((result['exercises']
                                                                as List)
                                                            .length ==
                                                        0) {
                                                      (_model.workout?['series']
                                                              as List)
                                                          .removeAt(
                                                              setsListIndex);
                                                    } else {
                                                      (_model.workout?['series']
                                                                  as List)[
                                                              setsListIndex] =
                                                          result;
                                                    }
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Série atualizada.',
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 1000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  );
                                                }
                                              },
                                              text: 'Editar',
                                              options: FFButtonOptions(
                                                width: 90.0,
                                                height: 34.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 4.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                        ),
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible:
                                              setsListItem["techniqueId"] !=
                                                      null &&
                                                  setsListItem["techniqueId"]
                                                      .isNotEmpty,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 12.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    setsListItem[
                                                                "techniqueId"] !=
                                                            null
                                                        ? _model
                                                            .getTechniqueNameBy(
                                                                setsListItem[
                                                                    "techniqueId"])
                                                        : "",
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Builder(
                                          builder: (context) {
                                            final exerciseList =
                                                setsListItem['exercises'] ?? [];
                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: exerciseList.length,
                                              itemBuilder:
                                                  (context, exerciseListIndex) {
                                                final exerciseListItem =
                                                    exerciseList[
                                                        exerciseListIndex];
                                                final isLast =
                                                    exerciseList.length ==
                                                        (exerciseListIndex + 1);
                                                return Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0,
                                                          exerciseListIndex == 0
                                                              ? 24
                                                              : 0,
                                                          0.0,
                                                          isLast ? 0 : 12.0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      boxShadow: [],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      4.0,
                                                                      0.0,
                                                                      12.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            1.0,
                                                                            1.0,
                                                                            1.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: (exerciseListItem['exercise']['imageUrl'] as String)
                                                                              .isNotEmpty ==
                                                                          true
                                                                      ? CachedNetworkImage(
                                                                          imageUrl:
                                                                              exerciseListItem['exercise']['imageUrl'],
                                                                          width:
                                                                              70.0,
                                                                          height:
                                                                              70.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : Container(),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                AutoSizeText(
                                                                              exerciseListItem['exercise']['name'],
                                                                              maxLines: 2,
                                                                              style: FlutterFlowTheme.of(context).titleMedium,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                AutoSizeText(
                                                                              '${_model.getExerciseSubtitle(exerciseListItem)}',
                                                                              maxLines: 2,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
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
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            80,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Divider(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                )),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        Visibility(
                                          visible:
                                              setsListItem["personalNote"] !=
                                                      null &&
                                                  setsListItem["personalNote"]
                                                      .isNotEmpty,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 6.0, 0.0, 0.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    child: ExpandableNotifier(
                                                      initialExpanded: false,
                                                      child: ExpandablePanel(
                                                        header: Text(
                                                          'Comentário',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleSmall,
                                                        ),
                                                        collapsed: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1.0,
                                                          height: 54.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        8.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              _model.textLimit(
                                                                  setsListItem?[
                                                                      'personalNote'],
                                                                  50),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        expanded: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              setsListItem?[
                                                                      'personalNote'] ??
                                                                  "",
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        theme:
                                                            ExpandableThemeData(
                                                          tapHeaderToExpand:
                                                              false,
                                                          tapBodyToExpand: true,
                                                          tapBodyToCollapse:
                                                              true,
                                                          headerAlignment:
                                                              ExpandablePanelHeaderAlignment
                                                                  .center,
                                                          hasIcon: true,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                visible: _model.workout != null &&
                    _model.workout?['series'] != null &&
                    _model.workout?['series'].isNotEmpty,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      logFirebaseEvent('ADD_WORKOUT_PAGE_ADICIONAR_BTN_ON_TAP');
                      logFirebaseEvent('Button_haptic_feedback');
                      HapticFeedback.lightImpact();
                      logFirebaseEvent('Button_navigate_to');

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddWorkoutSetsWidget(
                            sets: null,
                            techniques: _model.contentResponse['techniques'],
                          ),
                        ),
                      );
                      if (result != null) {
                        _wasEdited = true;
                        setState(() {
                          (_model.workout?['series'] as List).add(result);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Série atualizada.',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 1000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );
                      }
                    },
                    text: 'Adicionar',
                    options: FFButtonOptions(
                      width: 130.0,
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primary,
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
        ),
        BottomButtonFixedWidget(
          buttonTitle: _bottomButtonText,
          onPressed: () async {
            if (_unfocusNode.hasFocus) {
              _unfocusNode.unfocus();
              return;
            }
            if (_commentUnfocusNode.hasFocus) {
              _commentUnfocusNode.unfocus();
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
                  final result = await UploadImageCall.call(_model.imagePath!);

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
                _model.apiResultl1o = await BaseGroup.updateWorkoutCall
                    .call(params: _model.workout);
                _shouldSetState = true;
                if ((_model.apiResultl1o?.succeeded ?? true)) {
                  logFirebaseEvent('Button_navigate_back');
                  context.pop(true);
                  logFirebaseEvent('Button_show_snack_bar');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Treino atualizado.',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      duration: Duration(milliseconds: 4000),
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

                if (_shouldSetState) setState(() {});
                return;
              } else {
                logFirebaseEvent('Button_backend_call');
                _model.createExerciseResult =
                    await BaseGroup.createWorkoutCall.call(
                  params: _model.workout,
                );
                _shouldSetState = true;
                if ((_model.createExerciseResult?.succeeded ?? true)) {
                  logFirebaseEvent('Button_navigate_back');
                  context.pop(true);
                  logFirebaseEvent('Button_show_snack_bar');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Treino cadastrado.',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      duration: Duration(milliseconds: 4000),
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
              }
            }

            setState(() {});
          },
        )
      ],
    );
  }
}
