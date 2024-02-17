import 'dart:io';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_model.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_widget.dart';
import 'package:pump_components/components/information_dialog/information_dialog_widget.dart';
import 'package:pump_components/components/tag_component/tag_component_widget.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/upload_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  bool addNewSet = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddWorkoutModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'AddWorkout'});
    _model.yourNameController1 ??= TextEditingController();
    _model.yourNameController2 ??= TextEditingController();

    _model.workout = widget.workout;
    _model.setValues();
    reloadContent(context);

    if (widget.workoutId != null) {
      _model.isUpdate = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushNamed('EditWorkoutSeriesWidget', queryParameters: {
          'workout': serializeParam(_model.workout, ParamType.JSON),
          'showBottomButton': serializeParam(true, ParamType.bool),
        }).then((value) {
          if (value != null) {
            safeSetState(() {
              _model.workout = value;
              reloadContent(context);
            });
          }
        });
      });
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
                                    strokeWidth: 1.0,
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
                              reloadContent(context);
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

  void _goToAddExercises(BuildContext context) async {
    final dynamic result =
        await context.pushNamed('ListExercises', queryParameters: {
      'showBackButton': serializeParam(true, ParamType.bool),
      'isPicker': serializeParam(true, ParamType.bool)
    });

    if (result != null) {
      safeSetState(() {
        if (_model.workout['series'].isEmpty || addNewSet) {
          _model.addSeriesWithExercises(result);
          addNewSet = false;
        } else {
          _model.addExercisesInSet(result);
        }
        reloadContent(context);
      });
    }
  }

  void reloadContent(BuildContext context) {
    if (_model.workout['series'] == null) {
      return;
    }
    _model.dataArray = [];

    int setIndex = 0;
    _model.workout['series'].toList().forEach((set) {
      int exerciseIndex = 0;
      set['exercises'].toList().forEach((exercise) {
        int index = 0;
        int quantity = 0;

        if (exercise['tempRepArray'] == null) {
          if (set.containsKey('quantity')) {
            dynamic value = set['quantity'];
            if (value is String) {
              quantity = int.tryParse(value) ?? 0;
              set.remove('quantity');
              set['quantity'] = quantity;
            } else {
              quantity = value;
            }
          }

          int tempRep = int.tryParse(exercise['tempRep']) ?? 0;
          int pause = int.tryParse(exercise['pause']) ?? 0;

          String intensity = 'Média';
          if (exercise['intensity'] != null &&
              exercise['intensity'] != 'Moderada') {
            intensity = exercise['intensity'];
          }

          exercise['tempRepArray'] = [tempRep];
          exercise['pauseArray'] = [pause];
          exercise['intensityArray'] = [intensity];
          for (int i = 1; i < quantity; i++) {
            exercise['tempRepArray'].add(tempRep);
            exercise['pauseArray'].add(pause);
            exercise['intensityArray'].add(intensity);
          }
        }

        exercise['tempRepArray'].forEach((reps) {
          final indexCurrent = index;
          final exerciseIndexCurrent = exerciseIndex;
          final setIndexCurrent = setIndex;

          final FormFieldController<String> dropIntensityController =
              FormFieldController<String>('');
          final textRepsController = TextEditingController();
          textRepsController.text = '$reps';
          final textPauseController = TextEditingController();
          textPauseController.text = '${exercise['pauseArray'][indexCurrent]}';

          final data = DropdownData(
              setIndexCurrent,
              exerciseIndexCurrent,
              indexCurrent,
              reps,
              exercise['pauseArray'][indexCurrent],
              exercise['intensityArray'][indexCurrent],
              textPauseController,
              dropIntensityController,
              textRepsController);

          _model.dataArray.add(data);

          index++;
        });

        exerciseIndex++;
      });

      setIndex++;
    });
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
                          tagColor: Colors.white,
                          selected: _model.objectiveIsSelected(element),
                          maxHeight: 32,
                          alpha: 1,
                          selectedTextColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: 16,
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
                          tagColor: Colors.white,
                          selected: _model.levelIsSelected(element),
                          maxHeight: 32,
                          alpha: 1,
                          selectedTextColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: 16,
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
                    dynamic setsList = _model.workout?['series'] ?? [];

                    if (setsList.isEmpty) {
                      return EmptyListWidget(
                          title: 'Sem séries',
                          message:
                              'Nenhuma série adicionada ainda. Adicione as séries para criar o treino.',
                          buttonTitle: 'Adicionar',
                          onButtonPressed: () async {
                            context.pushNamed('EditWorkoutSeriesWidget',
                                queryParameters: {
                                  'workout': serializeParam(
                                      _model.workout, ParamType.JSON),
                                });

                            final result = await context.pushNamed(
                                'EditWorkoutSeriesWidget',
                                queryParameters: {
                                  'workout': serializeParam(
                                      _model.workout, ParamType.JSON),
                                  'showBottomButton':
                                      serializeParam(true, ParamType.bool),
                                }).then((value) {
                              if (value != null) {
                                _model.workout = value;
                              }
                            });
                            if (result != null) {
                              _wasEdited = true;
                              setState(() {
                                (_model.workout?['series'] as List).add(result);
                                reloadContent(context);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Exercícios atualizados.',
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
                    return EditWorkoutSeriesComponentWidget(
                      workoutSets: setsList,
                      dataArray: _model.dataArray,
                      paginatedDataTableController:
                          _model.paginatedDataTableController,
                      onButtonAddExerciseSet: (index) {
                        _model.setIndexToAddExercise = index;
                        _goToAddExercises(context);
                      },
                      onEmptyList: () {
                        safeSetState(() {});
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      logFirebaseEvent('ADD_WORKOUT_PAGE_ADICIONAR_BTN_ON_TAP');
                      logFirebaseEvent('Button_haptic_feedback');
                      HapticFeedback.lightImpact();
                      logFirebaseEvent('Button_navigate_to');

                      final result = await context.pushNamed(
                          'EditWorkoutSeriesWidget',
                          queryParameters: {
                            'workout':
                                serializeParam(_model.workout, ParamType.JSON),
                            'showBottomButton':
                                serializeParam(false, ParamType.bool),
                          }).then((value) {
                        if (value != null) {
                          _model.workout = value;
                        }
                      });
                      if (result != null) {
                        _wasEdited = true;
                        setState(() {
                          (_model.workout?['series'] as List).add(result);
                          reloadContent(context);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Exercícios atualizados.',
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
                    text: 'Exercícios',
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                    ),
                    options: FFButtonOptions(
                      height: 34,
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).info,
                      textStyle: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground),
                      elevation: 3,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).info,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    showLoadingIndicator: false,
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
