import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_data_table.dart';
import 'package:flutter_flow/flutter_flow_drop_down.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:pump_components/components/comment_bottom_sheet/comment_bottom_sheet_widget.dart';
import '../information_bottom_sheet_text/information_bottom_sheet_text_widget.dart';
import '../tag_component/tag_component_widget.dart';
import 'edit_workout_series_component_model.dart';
import 'dart:math' as math;
import 'package:flutter_flow/common/utils.dart';

typedef AddExerciseSetCallback = Function(int index);

class EditWorkoutSeriesComponentWidget extends StatefulWidget {
  const EditWorkoutSeriesComponentWidget(
      {Key? key,
      this.workoutSets,
      required this.dataArray,
      required this.paginatedDataTableController,
      this.onButtonAddExerciseSet,
      this.onEmptyList})
      : super(key: key);

  final dynamic workoutSets;
  final List<dynamic> dataArray;
  final FlutterFlowDataTableController<dynamic> paginatedDataTableController;
  final AddExerciseSetCallback? onButtonAddExerciseSet;
  final VoidCallback? onEmptyList;

  @override
  _EditWorkoutSeriesComponentWidgetState createState() =>
      _EditWorkoutSeriesComponentWidgetState();
}

class _EditWorkoutSeriesComponentWidgetState
    extends State<EditWorkoutSeriesComponentWidget> {
  late EditWorkoutSeriesComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditWorkoutSeriesComponentModel());

    _model.workoutSets = widget.workoutSets;
    _model.paginatedDataTableController = widget.paginatedDataTableController;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: _listOfSets(context) ?? [],
    );
  }

  List<Widget>? _listOfSets(BuildContext context) {
    return List.generate(_model.workoutSets.length, (index) {
      final set = _model.workoutSets[index];

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12, 16, 12, 0),
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(4, 12, 4, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.16,
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1, 0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 0, 0, 12),
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 20,
                                        borderWidth: 1,
                                        buttonSize: 34,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        icon: Icon(
                                          Icons.comment_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          _addPersonalNote(set);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: _exercisesForSet(context, index),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: FFButtonWidget(
                                        onPressed: () {
                                          widget.onButtonAddExerciseSet
                                              ?.call(index);
                                        },
                                        text: _model.getTitleAddExerciseInSet(set),
                                        icon: Icon(
                                          Icons.add_link,
                                          size: 20,
                                        ),
                                        options: FFButtonOptions(
                                          height: 34,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16, 0, 16, 0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                      fontFamily: 'Poppins',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText),
                                          elevation: 0,
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                        ),
                                        showLoadingIndicator: false,
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(1, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 6, 0),
                                        child: FlutterFlowIconButton(
                                          borderColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          borderRadius: 20,
                                          borderWidth: 1,
                                          buttonSize: 34,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          icon: Icon(
                                            Icons.info_outlined,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            _showInformationSet(set);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
      );
    });
  }

  void _addPersonalNote(dynamic set) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: CommentBottomSheetWidget(
            comment: set['personalNote'],
          ),
        );
      },
    ).then((value) => safeSetState(() {
          if (value != null && value is String) {
            safeSetState(() {
              set['personalNote'] = value;
            });
          }
        }));
  }

  void _showInformationSet(dynamic set) {
    dynamic information = _model.trainingTechniqueInfo(set['exercises'].length);
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: InformationBottomSheetTextWidget(
            title: information['title'],
            personalNote: information['subtitle'],
          ),
        );
      },
    );
  }

  List<Widget> _exercisesForSet(BuildContext context, int setIndex) {
    return List.generate(_model.workoutSets[setIndex]['exercises'].length,
        (index) {
      final exercise = _model.workoutSets[setIndex]['exercises'][index];
      final setsCount = _model.workoutSets[setIndex]['quantity'];

      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: _model.hasPersonalNote(setIndex),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                'Instruções',
                                style: FlutterFlowTheme.of(context).titleSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _model.hasPersonalNote(setIndex),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                _model.workoutSets[setIndex]['personalNote'] ??
                                    '',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: index == 0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                '$setsCount séries',
                                maxLines: 2,
                                style: FlutterFlowTheme.of(context).titleSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: exercise['exercise']['imageUrl'] != null
                                ? CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fadeOutDuration:
                                        Duration(milliseconds: 500),
                                    imageUrl: exercise['exercise']['imageUrl'],
                                    width: 38,
                                    height: 38,
                                    fit: BoxFit.cover,
                                  )
                                : Container(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      _model.getExerciseTitle(exercise),
                                      maxLines: 2,
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      '${exercise['exercise']['equipament']['name']}',
                                      maxLines: 2,
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _model.setIsEditing(setIndex, index),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                            child: FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 20,
                              borderWidth: 1,
                              buttonSize: 34,
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              icon: Icon(
                                Icons.delete_outlined,
                                color: FlutterFlowTheme.of(context).error,
                                size: 16,
                              ),
                              onPressed: () {
                                _model.isEditingSet = {};
                                widget.dataArray.removeWhere((element) =>
                                    element.setIndexCurrent == setIndex &&
                                    element.exercisesIndex == index);
                                _model.workoutSets[setIndex]['exercises']
                                    .removeAt(index);

                                if (_model.workoutSets[setIndex]['exercises']
                                        .length ==
                                    0) {
                                  _model.workoutSets.removeAt(setIndex);
                                  updateSetsIndexes();
                                }

                                updateExercisesInSetIndexes();
                                if (_model.workoutSets.length == 0) {
                                  widget.onEmptyList?.call();
                                }
                                safeSetState(() {});
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 20,
                            borderWidth: 1,
                            buttonSize: 34,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            icon: Icon(
                              _model.setIsEditing(setIndex, index)
                                  ? Icons.save_alt
                                  : Icons.edit,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 16,
                            ),
                            onPressed: () {
                              if (_model.setIsEditing(setIndex, index)) {
                                _model.isEditingSet['editing'] = false;
                              } else {
                                _model.isEditingSet = {
                                  'setIndex': setIndex,
                                  'exerciseIndex': index,
                                  'editing': true
                                };
                              }
                              safeSetState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _model.setIsEditing(setIndex, index),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 16, 0, 0),
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: _model.secOrRepsTags.map((element) {
                                return TagComponentWidget(
                                  title: element,
                                  tagColor:
                                      FlutterFlowTheme.of(context).primary,
                                  selected: _model.workoutSets[setIndex]
                                              ['exercises'][index]
                                          ['tempRepDescription'] ==
                                      element,
                                  maxHeight: 24,
                                  unselectedColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  onTagPressed: () {
                                    HapticFeedback.mediumImpact();
                                    safeSetState(() {
                                      _model.choiceChipsValue = element;
                                      _model.workoutSets[setIndex]['exercises']
                                              [index]['tempRepDescription'] =
                                          element;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      child: _createTableExerciseInfo(context, setIndex, index)
                          .animateOnPageLoad(
                              Utils.defaultaAnimation),
                      visible: _model.setIsEditing(setIndex, index),
                    ),
                    Visibility(
                      visible: _model.setIsEditing(setIndex, index),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FFButtonWidget(
                              onPressed: () {
                                int forIndex = 0;
                                _model.workoutSets[setIndex]['exercises']
                                    .forEach((element) {
                                  int lastPause = exercise['pauseArray'].last;
                                  String lastIntensity =
                                      exercise['intensityArray'].last;
                                  int lastReps = exercise['tempRepArray'].last;

                                  element['pauseArray'].add(lastPause);
                                  element['intensityArray'].add(lastIntensity);
                                  element['tempRepArray'].add(lastReps);

                                  final FormFieldController<String>
                                      dropPauseController =
                                      FormFieldController<String>('');
                                  final FormFieldController<String>
                                      dropIntensityController =
                                      FormFieldController<String>('');
                                  final textRepsController =
                                      TextEditingController();
                                  textRepsController.text = '$lastReps';

                                  int currentIndex =
                                      element['tempRepArray'].length - 1;
                                  final data = DropdownData(
                                      setIndex,
                                      forIndex,
                                      currentIndex,
                                      lastReps,
                                      lastPause,
                                      lastIntensity,
                                      dropPauseController,
                                      dropIntensityController,
                                      textRepsController);

                                  widget.dataArray.add(data);
                                  forIndex++;
                                });

                                _model.workoutSets[setIndex]['quantity'] += 1;

                                safeSetState(() {});
                              },
                              text: 'Série',
                              icon: Icon(
                                Icons.add,
                                size: 20,
                              ),
                              options: FFButtonOptions(
                                height: 34,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                iconPadding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
                          ],
                        ),
                      ),
                    ),
                    _model.workoutSets[setIndex]['exercises'].length !=
                            (index + 1)
                        ? Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 6, 12, 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: Icon(
                                    Icons.link_sharp,
                                    size: 20,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 0.7,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 12, 12, 6),
                            child: Divider(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              thickness: 0.7,
                            )),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _createTableExerciseInfo(
      BuildContext context, int setIndex, int index) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(6, 12, 6, 8),
      child: _buildDataTable(context, setIndex, index),
    );
  }

  void updateRemoveSetData(int itemIndex, int setIndex, int index) {
    safeSetState(() {
      widget.dataArray.removeWhere((element) =>
          element.setIndexCurrent == setIndex && element.index == itemIndex);

      _model.workoutSets[setIndex]['exercises'].forEach((element) {
        element['pauseArray'].removeAt(itemIndex);
        element['intensityArray'].removeAt(itemIndex);
        element['tempRepArray'].removeAt(itemIndex);
      });

      _model.workoutSets[setIndex]['quantity'] -= 1;

      if (_model.workoutSets[setIndex]['quantity'] == 0) {
        _model.workoutSets.removeAt(setIndex);

        if (_model.workoutSets.length == 0) {
          widget.onEmptyList?.call();
        }

        updateSetsIndexes();
        _model.isEditingSet = {};
      }
      updateIndexes();
    });
  }

  void updateIndexes() {
    Map<int, List<DropdownData>> mapByExercisesIndex = {};

    for (var element in widget.dataArray) {
      int exercisesIndex = element.exercisesIndex;
      if (!mapByExercisesIndex.containsKey(exercisesIndex)) {
        mapByExercisesIndex[exercisesIndex] = [];
      }
      mapByExercisesIndex[exercisesIndex]!.add(element);
    }

    for (var elementsList in mapByExercisesIndex.values) {
      for (int i = 0; i < elementsList.length; i++) {
        elementsList[i].updateIndex(i);
      }
    }

    widget.dataArray.clear();
    for (var elementsList in mapByExercisesIndex.values) {
      widget.dataArray.addAll(elementsList);
    }
  }

  void updateExercisesInSetIndexes() {
    Map<int, List<DropdownData>> mapByExercisesIndex = {};

    for (var element in widget.dataArray) {
      int exercisesIndex = element.exercisesIndex;
      if (!mapByExercisesIndex.containsKey(exercisesIndex)) {
        mapByExercisesIndex[exercisesIndex] = [];
      }
      mapByExercisesIndex[exercisesIndex]!.add(element);
    }

    int newIndex = 0;
    for (var elementsList in mapByExercisesIndex.values) {
      for (var element in elementsList) {
        element.exercisesIndex = newIndex;
      }
      newIndex++;
    }
  }

  void updateSetsIndexes() {
    int currentIndex = 0;
    widget.dataArray.forEach((element) {
      element.setIndexCurrent = currentIndex;
    });
  }

  FlutterFlowDataTable _buildDataTable(
      BuildContext context, int setIndex, int index) {
    final currentExercise = _model.workoutSets[setIndex]['exercises'][index];

    List<dynamic> data = [];
    int currentIndex = 0;
    widget.dataArray.forEach((element) {
      if (element.setIndexCurrent == setIndex &&
          element.exercisesIndex == index) {
        element.pauseDropdownController.value =
            '${currentExercise['pauseArray'][currentIndex]}';
        element.intensityDropdownController.value =
            currentExercise['intensityArray'][currentIndex];
        element.textRepsController.text =
            '${currentExercise['tempRepArray'][currentIndex]}';

        data.add(element);
        currentIndex++;
      }
    });

    final numberOfRows = _model.numberOfRows(data);
    final setsCount = data.length;

    String getRepsTitle() {
      return currentExercise['tempRepDescription'];
    }

    return FlutterFlowDataTable(
        paginated: true,
        selectable: false,
        hidePaginator: setsCount <= _model.maxRowsPerPage,
        showFirstLastButtons: setsCount > _model.maxRowsPerPage,
        headingRowHeight: 34,
        columnSpacing: 8,
        headingRowColor: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(8),
        addHorizontalDivider: true,
        horizontalDividerColor: FlutterFlowTheme.of(context).primaryBackground,
        horizontalDividerThickness: 1,
        addVerticalDivider: false,
        numRows: setsCount,
        onPageChanged: (p0) {
          safeSetState(() {
            _model.dataTablePageChanged(p0);
          });
        },
        dataRowHeight: 54,
        height: (54 * (numberOfRows)) +
            (setsCount <= _model.maxRowsPerPage ? 34 : 100),
        controller: widget.paginatedDataTableController,
        data: data,
        columnsBuilder: (onSortChanged) => [
              DataColumn2(
                label: DefaultTextStyle.merge(
                  softWrap: true,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      getRepsTitle(),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                          ),
                    ),
                  ),
                ),
              ),
              DataColumn2(
                label: DefaultTextStyle.merge(
                  softWrap: true,
                  child: Text(
                    'Pausa',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
              DataColumn2(
                label: DefaultTextStyle.merge(
                  softWrap: true,
                  child: Text(
                    'Carga',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
              DataColumn2(
                label: DefaultTextStyle.merge(
                  softWrap: true,
                  child: Text(
                    '',
                    style: FlutterFlowTheme.of(context).labelLarge,
                  ),
                ),
                fixedWidth: 35,
              ),
            ],
        dataRowBuilder:
            (Item, paginatedDataTableIndex, selected, onSelectChanged) {
          void updatePause(String? val) {
            safeSetState(() {
              final pause = int.parse(val ?? '0');
              currentExercise['pauseArray'][Item.index] = pause;
              Item.updatePause(pause);
              Item.pauseDropdownController.value = val;
            });
          }

          void updateIntensity(String? val) {
            safeSetState(() {
              currentExercise['intensityArray'][Item.index] = val;
              Item.updateIntensity(val ?? '');
              Item.intensityDropdownController.value = val;
            });
          }

          void updateReps(String? val) {
            safeSetState(() {
              String? value = val;
              Item.textRepsController.text = value;
              if (val?.isEmpty == true) {
                value = '0';
              }
              final reps = int.parse(value ?? '0');
              currentExercise['tempRepArray'][Item.index] = reps;
              Item.updateReps(reps);
            });
          }

          void updateRemoveSet() {
            updateRemoveSetData(Item.index, setIndex, index);
          }

          return DataRow(
            color: MaterialStateProperty.all(
              FlutterFlowTheme.of(context).secondaryBackground,
            ),
            cells: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: TextFormField(
                  onChanged: (value) {
                    updateReps(value);
                  },
                  controller: Item.textRepsController,
                  textAlignVertical: TextAlignVertical.top,
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    labelStyle: FlutterFlowTheme.of(context).labelMedium,
                    hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                      ),
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      null,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: FlutterFlowDropDown<String>(
                  controller: Item.pauseDropdownController,
                  options: ['30', '60', '90'],
                  onChanged: (val) => updatePause(val),
                  height: 40,
                  textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                      ),
                  hintText: 'Pausa',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 12,
                  ),
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  elevation: 2,
                  borderColor: FlutterFlowTheme.of(context).primaryBackground,
                  borderWidth: 2,
                  borderRadius: 8,
                  margin: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
                  hidesUnderline: true,
                  isSearchable: false,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: FlutterFlowDropDown<String>(
                  controller: Item.intensityDropdownController,
                  options: ['Alta', 'Média', 'Baixa'],
                  onChanged: (val) => updateIntensity(val),
                  height: 40,
                  textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                      ),
                  hintText: 'Carga',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 12,
                  ),
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  elevation: 2,
                  borderColor: FlutterFlowTheme.of(context).primaryBackground,
                  borderWidth: 2,
                  borderRadius: 8,
                  margin: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
                  hidesUnderline: true,
                  isSearchable: false,
                ),
              ),
              Visibility(
                visible: true,
                child: Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: FlutterFlowIconButton(
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 30,
                    icon: Icon(
                      Icons.close_rounded,
                      color: FlutterFlowTheme.of(context).error,
                      size: 16,
                    ),
                    onPressed: () {
                      updateRemoveSet();
                    },
                  ),
                ),
              ),
            ].map((c) => DataCell(c)).toList(),
          );
        });
  }
}
