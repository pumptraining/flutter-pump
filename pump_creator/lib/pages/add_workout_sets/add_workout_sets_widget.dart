import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import 'package:pump_components/components/edit_exercise/edit_exercise_widget.dart';
import 'package:flutter_flow/flutter_flow_count_controller.dart';
import 'package:flutter_flow/flutter_flow_drop_down.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'add_workout_sets_model.dart';
export 'add_workout_sets_model.dart';

class AddWorkoutSetsWidget extends StatefulWidget {
  const AddWorkoutSetsWidget({
    Key? key,
    this.sets,
    this.techniques,
  }) : super(key: key);

  final dynamic sets;
  final List<dynamic>? techniques;

  @override
  _AddWorkoutSetsWidgetState createState() => _AddWorkoutSetsWidgetState();
}

class _AddWorkoutSetsWidgetState extends State<AddWorkoutSetsWidget> {
  late AddWorkoutSetsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final _commentUnfocusNode = FocusNode();
  FocusNode _editWidgetFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isEditing = false;
  String _bottomButtonText = 'Salvar';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddWorkoutSetsModel());
    _model.sets = jsonDecode(jsonEncode(widget.sets));
    _model.techniques = widget.techniques;

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'AddWorkoutSets'});
    _model.yourNameController1 ??=
        TextEditingController(text: _model.setsCountString());
    _model.yourNameController2 ??= TextEditingController();
    _model.countControllerValue = int.parse(_model.setsCountString());
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    if (_model.sets?['personalNote'] != null) {
      _model.yourNameController2.text = _model.sets['personalNote'];
    }

    if (_model.sets == null) {
      _model.sets = {};
      _model.sets['quantity'] = '3';
    } else {
      _isEditing = true;
    }

    _unfocusNode.addListener(() {
      setState(() {
        if (_unfocusNode.hasFocus) {
          _bottomButtonText = 'Confirmar';
        } else {
          _bottomButtonText = 'Salvar';
        }
      });
    });

    _commentUnfocusNode.addListener(() {
      setState(() {
        if (_commentUnfocusNode.hasFocus) {
          _bottomButtonText = 'Confirmar';
        } else {
          _bottomButtonText = 'Salvar';
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
        _unfocusNode.unfocus();
        _commentUnfocusNode.unfocus();
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
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: true,
          title: Text(
            _isEditing ? 'Editar' : 'Adicionar',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                ),
          ),
          actions: [],
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
                    alignment: AlignmentDirectional(0, 0),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 130),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 32, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 0, 8, 16),
                                    child: TextFormField(
                                      maxLength: 2,
                                      focusNode: _unfocusNode,
                                      controller: _model.yourNameController1,
                                      onChanged: (value) {
                                        setState(() {
                                          _model.sets['quantity'] = value;
                                        });
                                      },
                                      textCapitalization:
                                          TextCapitalization.words,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        labelText: 'Séries',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                20, 24, 0, 24),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      keyboardType: TextInputType.number,
                                      validator: _model
                                          .yourNameController1Validator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 20, 16),
                                  child: Container(
                                    width: 150,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(8),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        width: 1,
                                      ),
                                    ),
                                    child: FlutterFlowCountController(
                                      maximum: 99,
                                      decrementIconBuilder: (enabled) => FaIcon(
                                        FontAwesomeIcons.minus,
                                        color: enabled
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryText
                                            : Color(0xFFEEEEEE),
                                        size: 20,
                                      ),
                                      incrementIconBuilder: (enabled) => FaIcon(
                                        FontAwesomeIcons.plus,
                                        color: enabled
                                            ? Colors.blue
                                            : Color(0xFFEEEEEE),
                                        size: 20,
                                      ),
                                      countBuilder: (count) => Text(
                                        count.toString(),
                                        style: GoogleFonts.getFont(
                                          'Roboto',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      count: _model.sets?['quantity'] != null &&
                                              _model
                                                  .sets?['quantity'].isNotEmpty
                                          ? int.parse(
                                              _model.sets?['quantity'] ??= 3)
                                          : 3,
                                      updateCount: (count) {
                                        setState(() {
                                          _model.sets['quantity'] =
                                              count.toString();
                                          _model.yourNameController1.text =
                                              count.toString();
                                        });
                                        logFirebaseEvent(
                                            'ADD_WORKOUT_SETS_CountController_v4skfhu');
                                        logFirebaseEvent(
                                            'CountController_haptic_feedback');
                                        HapticFeedback.lightImpact();
                                      },
                                      stepSize: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
                            child: FlutterFlowDropDown<String>(
                              controller: _model.stateValueController ??=
                                  FormFieldController<String>(
                                _model.getSelectedTechniqueName(),
                              ),
                              options: _model.extractStringsFromTechniques(),
                              onChanged: (val) => setState(() {
                                _model.stateValue = val;
                                if (val != null) {
                                  _model.setTechniqueBy(val);
                                }
                              }),
                              width: double.infinity,
                              height: 56,
                              textStyle:
                                  FlutterFlowTheme.of(context).bodyMedium,
                              hintText: 'Técnica',
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 15,
                              ),
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 2,
                              borderColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderWidth: 2,
                              borderRadius: 8,
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(20, 4, 12, 4),
                              hidesUnderline: true,
                              isSearchable: false,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                            child: TextFormField(
                              focusNode: _commentUnfocusNode,
                              controller: _model.yourNameController2,
                              textCapitalization: TextCapitalization.sentences,
                              obscureText: false,
                              maxLength: 200,
                              decoration: InputDecoration(
                                labelText: 'Comentário',
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                hintStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20, 24, 0, 24),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              maxLines: 4,
                              validator: _model.yourNameController2Validator
                                  .asValidator(context),
                              onChanged: (value) {
                                _model.sets['personalNote'] = value;
                              },
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              final exerciseList = _model.sets['exercises'];
                              if (exerciseList == null ||
                                  exerciseList.isEmpty) {
                                return EmptyListWidget(
                                    title: 'Sem exercícios',
                                    message:
                                        'Nenhum exercício adicionado ainda. Adicione os exercícios para criar a série.',
                                    buttonTitle: 'Adicionar',
                                    onButtonPressed: () async {
                                      final dynamic result = await context
                                          .pushNamed('ListExercises',
                                              queryParameters: {
                                            'showBackButton': serializeParam(
                                                true, ParamType.bool),
                                            'isPicker': serializeParam(
                                                true, ParamType.bool)
                                          });

                                      if (result != null) {
                                        setState(() {
                                          for (var newExercise in result) {
                                            dynamic newItem = {};
                                            newExercise['videoUrl'] = null;
                                            newExercise['streamingURL'] = null;
                                            newExercise['personalId'] = null;
                                            newItem['exercise'] = newExercise;
                                            newItem['tempRepDescription'] =
                                                'Repetições';
                                            newItem['cadence'] = '3020';
                                            newItem['pause'] = '60';
                                            newItem['tempRep'] = '10';

                                            if (_model.sets?['exercises'] ==
                                                null) {
                                              _model.sets?['exercises'] = [];
                                            }

                                            (_model.sets?['exercises']
                                                    as List<dynamic>)
                                                .add(newItem);
                                          }
                                        });
                                      }
                                    });
                              }
                              return ReorderableListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: exerciseList.length,
                                onReorder: (int oldIndex, int newIndex) {
                                  setState(() {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    final item =
                                        exerciseList.removeAt(oldIndex);
                                    exerciseList.insert(newIndex, item);
                                  });
                                },
                                itemBuilder: (context, exerciseListIndex) {
                                  final exerciseListItem =
                                      exerciseList[exerciseListIndex];
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    key: Key('$exerciseListIndex'),
                                    children: [
                                      Expanded(
                                        child: wrapWithModel(
                                          model: _model.editExerciseModels
                                              .getModel(
                                            exerciseListIndex.toString(),
                                            exerciseListIndex,
                                          ),
                                          updateCallback: () => setState(() {}),
                                          child: EditExerciseWidget(
                                            key: Key(
                                              'Key2zh_${exerciseListIndex.toString()}',
                                            ),
                                            onFocus: (focusNode) {
                                              _editWidgetFocusNode = focusNode;
                                              setState(() {
                                                if (focusNode.hasFocus) {
                                                  _bottomButtonText =
                                                      'Confirmar';
                                                  _scrollController.animateTo(
                                                    _scrollController.offset +
                                                        200.0,
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.easeInOut,
                                                  );
                                                } else {
                                                  _bottomButtonText = 'Salvar';
                                                }
                                              });
                                            },
                                            exercises: exerciseListItem,
                                            onButtonDeletePressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Atenção"),
                                                    content: Text(
                                                        "Tem certeza que deseja remover o exercício?"),
                                                    actions: [
                                                      TextButton(
                                                        child: Text("Cancelar"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text("Remover"),
                                                        onPressed: () {
                                                          setState(() {
                                                            _model.sets[
                                                                    'exercises']
                                                                .removeAt(
                                                                    exerciseListIndex);
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            onChangedCadence: (value) {
                                              _model.sets['exercises']
                                                      [exerciseListIndex]
                                                  ['cadence'] = value;
                                            },
                                            onChangedReps: (value) {
                                              _model.sets['exercises']
                                                      [exerciseListIndex]
                                                  ['tempRep'] = value;
                                            },
                                            onChangedRest: (value) {
                                              _model.sets['exercises']
                                                      [exerciseListIndex]
                                                  ['pause'] = value;
                                            },
                                            onChangedChoise: (value) {
                                              _model.sets['exercises']
                                                          [exerciseListIndex]
                                                      ['tempRepDescription'] =
                                                  value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          Visibility(
                            visible: _model.sets['exercises'] != null &&
                                (_model.sets['exercises'] as List<dynamic>)
                                        .length >
                                    0,
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent(
                                      'ADD_WORKOUT_SETS_ADICIONAR_BTN_ON_TAP');
                                  logFirebaseEvent('Button_navigate_to');

                                  final dynamic result = await context
                                          .pushNamed('ListExercises',
                                              queryParameters: {
                                            'showBackButton': serializeParam(
                                                true, ParamType.bool),
                                            'isPicker': serializeParam(
                                                true, ParamType.bool)
                                          });

                                  if (result != null) {
                                    setState(() {
                                      for (var newExercise in result) {
                                        dynamic newItem = {};
                                        newExercise['videoUrl'] = null;
                                        newExercise['streamingURL'] = null;
                                        newExercise['personalId'] = null;
                                        newItem['exercise'] = newExercise;
                                        newItem['tempRepDescription'] =
                                            'Repetições';
                                        newItem['cadence'] = '3020';
                                        newItem['pause'] = '60';
                                        newItem['tempRep'] = '10';

                                        (_model.sets?['exercises']
                                                as List<dynamic>)
                                            .add(newItem);
                                      }
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Exercício adicionado.',
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
                                  }
                                },
                                text: 'Adicionar',
                                options: FFButtonOptions(
                                  width: 130,
                                  height: 40,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BottomButtonFixedWidget(
                    buttonTitle: _bottomButtonText,
                    onPressed: () async {
                      if (_editWidgetFocusNode.hasFocus) {
                        _editWidgetFocusNode.unfocus();
                        return;
                      }
                      if (_unfocusNode.hasFocus) {
                        _unfocusNode.unfocus();
                        return;
                      }
                      if (_commentUnfocusNode.hasFocus) {
                        _commentUnfocusNode.unfocus();
                        return;
                      }
                      Navigator.pop(context, _model.sets);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
