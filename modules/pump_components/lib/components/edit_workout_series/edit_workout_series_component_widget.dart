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
      this.onEmptyList,
      this.canEdit = true})
      : super(key: key);

  final dynamic workoutSets;
  final List<dynamic> dataArray;
  final FlutterFlowDataTableController<dynamic> paginatedDataTableController;
  final AddExerciseSetCallback? onButtonAddExerciseSet;
  final VoidCallback? onEmptyList;
  final bool canEdit;

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
    return List.generate(widget.workoutSets.length, (index) {
      final set = widget.workoutSets[index];

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              0, 0, 0, (widget.workoutSets.length == index + 1) ? 32 : 0),
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
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
                                  Visibility(
                                    visible: widget.canEdit,
                                    child: Align(
                                      alignment: AlignmentDirectional(-1, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 12),
                                        child: FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 20,
                                          borderWidth: 1,
                                          buttonSize: 34,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
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
                        Visibility(
                          visible: widget.canEdit,
                          child: Padding(
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
                                          text: _model
                                              .getTitleAddExerciseInSet(set),
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
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .labelMedium
                                                .override(
                                                    fontFamily: 'Montserrat',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText),
                                            elevation: 0,
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                          ),
                                          showLoadingIndicator: false,
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(1, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
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
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              top: 8,
                            ),
                            child: Divider(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              endIndent: 16,
                              indent: 16,
                            )),
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
    return List.generate(widget.workoutSets[setIndex]['exercises'].length,
        (index) {
      final exercise = widget.workoutSets[setIndex]['exercises'][index];
      final setsCount = widget.workoutSets[setIndex]['quantity'];

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
                      visible: _model.hasPersonalNote(
                              widget.workoutSets, setIndex) &&
                          index == 0,
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
                      visible: _model.hasPersonalNote(
                              widget.workoutSets, setIndex) &&
                          index == 0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                widget.workoutSets[setIndex]['personalNote'] ??
                                    '',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Montserrat',
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
                    InkWell(
                      onTap: () {
                        Utils.showExerciseVideo(
                            context, exercise['exercise']['videoUrl']);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: exercise['exercise']['imageUrl'] != null
                                  ? CachedNetworkImage(
                                      fadeInDuration:
                                          Duration(milliseconds: 500),
                                      fadeOutDuration:
                                          Duration(milliseconds: 500),
                                      imageUrl: exercise['exercise']
                                          ['imageUrl'],
                                      width: 38,
                                      height: 38,
                                      maxHeightDiskCache: 200,
                                      memCacheHeight: 150,
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
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          _model.getExerciseTitle(exercise),
                                          maxLines: 2,
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: AutoSizeText(
                                        _model.generateSubtitle(exercise),
                                        maxLines: 2,
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontFamily: 'Montserrat',
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
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
                                  widget.workoutSets[setIndex]['exercises']
                                      .removeAt(index);

                                  if (widget.workoutSets[setIndex]['exercises']
                                          .length ==
                                      0) {
                                    widget.workoutSets.removeAt(setIndex);
                                  }

                                  reloadContent();
                                  if (widget.workoutSets.length == 0) {
                                    widget.onEmptyList?.call();
                                  }
                                  safeSetState(() {});
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.canEdit,
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 20,
                                borderWidth: 1,
                                buttonSize: 34,
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                icon: Icon(
                                  _model.setIsEditing(setIndex, index)
                                      ? Icons.save_alt
                                      : Icons.edit,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
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
                          ),
                        ],
                      ),
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
                                  borderWidth: 0.0,
                                  borderRadius: 12,
                                  alpha: 1,
                                  selectedTextColor: Colors.black,
                                  tagColor: FlutterFlowTheme.of(context).info,
                                  selected: widget.workoutSets[setIndex]
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
                                      widget.workoutSets[setIndex]['exercises']
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
                          .animateOnPageLoad(Utils.defaultaAnimation),
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
                                widget.workoutSets[setIndex]['exercises']
                                    .forEach((element) {
                                  final int lastPause =
                                      element['pauseArray'].last;
                                  final String lastIntensity =
                                      element['intensityArray'].last;
                                  final int lastReps =
                                      element['tempRepArray'].last;

                                  element['pauseArray'].add(lastPause);
                                  element['intensityArray'].add(lastIntensity);
                                  element['tempRepArray'].add(lastReps);
                                });

                                widget.workoutSets[setIndex]['quantity'] += 1;
                                reloadContent();
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
                                        fontFamily: 'Montserrat',
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
                    widget.workoutSets[setIndex]['exercises'].length !=
                            (index + 1)
                        ? Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(60, 6, 16, 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Divider(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: Icon(
                                    Icons.link_sharp,
                                    size: 20,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : widget.canEdit
                            ? Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 12, 12, 6),
                                child: Divider(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  thickness: 0.7,
                                ))
                            : Container(),
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
      widget.workoutSets[setIndex]['exercises'].forEach((element) {
        element['pauseArray'].removeAt(itemIndex);
        element['intensityArray'].removeAt(itemIndex);
        element['tempRepArray'].removeAt(itemIndex);
      });

      widget.workoutSets[setIndex]['quantity'] -= 1;

      if (widget.workoutSets[setIndex]['quantity'] == 0) {
        widget.workoutSets.removeAt(setIndex);

        if (widget.workoutSets.length == 0) {
          widget.onEmptyList?.call();
        }

        _model.isEditingSet = {};
      }
      reloadContent();
    });
  }

  void reloadContent() {
    List<DropdownData> dataArray = [];

    int setIndex = 0;
    widget.workoutSets.toList().forEach((set) {
      int exerciseIndex = 0;
      set['exercises'].toList().forEach((exercise) {
        int index = 0;

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

          dataArray.add(data);

          index++;
        });

        exerciseIndex++;
      });

      setIndex++;
    });

    widget.dataArray.clear();
    widget.dataArray.addAll(dataArray);
  }

  FlutterFlowDataTable _buildDataTable(
      BuildContext context, int setIndex, int index) {
    final currentExercise = widget.workoutSets[setIndex]['exercises'][index];

    List<dynamic> data = [];
    int currentIndex = 0;
    widget.dataArray.forEach((element) {
      if (element.setIndexCurrent == setIndex &&
          element.exercisesIndex == index) {
        element.textPauseController.text =
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
                            fontFamily: 'Montserrat',
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
                    'Pausa (seg)',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Montserrat',
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
                          fontFamily: 'Montserrat',
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
              String? value = val;
              Item.textPauseController.text = value;
              if (val?.isEmpty == true) {
                value = '0';
              }
              final pause = int.parse(value ?? '0');
              currentExercise['pauseArray'][Item.index] = pause;
              Item.updatePause(pause);
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
                        fontFamily: 'Montserrat',
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
                child: TextFormField(
                  onChanged: (value) {
                    updatePause(value);
                  },
                  controller: Item.textPauseController,
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
                        fontFamily: 'Montserrat',
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
                  controller: Item.intensityDropdownController,
                  options: ['-', 'Baixa', 'Média', 'Alta'],
                  onChanged: (val) => updateIntensity(val),
                  height: 40,
                  textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Montserrat',
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
