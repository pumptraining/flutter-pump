import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/flutter_flow_data_table.dart';
import 'package:flutter_flow/flutter_flow_drop_down.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:go_router/go_router.dart';
import 'edit_workout_series_component_model.dart';

class EditWorkoutSeriesComponentWidget extends StatefulWidget {
  const EditWorkoutSeriesComponentWidget({
    Key? key,
    this.workoutSets,
  }) : super(key: key);

  final dynamic workoutSets;

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

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _model.workoutSets = widget.workoutSets;
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

      return Padding(
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
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.16,
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
                                        Icons.keyboard_control,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        print('IconButton pressed ...');
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
                                        print('Button pressed ...');
                                      },
                                      text: 'Superset',
                                      icon: Icon(
                                        Icons.add_link,
                                        size: 20,
                                      ),
                                      options: FFButtonOptions(
                                        height: 34,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 16, 0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0, 0, 0, 0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        icon: Icon(
                                          Icons.info_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          print('IconButton pressed ...');
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
      );
    });
  }

  List<Widget> _exercisesForSet(BuildContext context, int setIndex) {
    return List.generate(_model.workoutSets[setIndex]['exercises'].length,
        (index) {
      final exercise = _model.workoutSets[setIndex]['exercises'][index];
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
                                    child: Text(
                                      'Air Max',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Hello World',
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
                              Icons.edit,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 16,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      child: _createTableExerciseInfo(context),
                      visible: false,
                    ),
                    Visibility(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FFButtonWidget(
                              onPressed: () {
                                safeSetState(() {
                                  _model.dataTest.add({
                                    'reps': '12',
                                    'carga': 'Alta',
                                    'interval': '1min',
                                  });
                                });
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
                    Divider(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      endIndent: 8,
                      indent: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _createTableExerciseInfo(BuildContext context) {
    final numberOfRows = _model.numberOfRows();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 8),
      child: FlutterFlowDataTable<dynamic>(
        paginated: true,
        selectable: false,
        hidePaginator: _model.dataTest.length <= _model.maxRowsPerPage,
        showFirstLastButtons: _model.dataTest.length > _model.maxRowsPerPage,
        headingRowHeight: 34,
        columnSpacing: 8,
        headingRowColor: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        addHorizontalDivider: true,
        horizontalDividerColor: FlutterFlowTheme.of(context).primaryBackground,
        horizontalDividerThickness: 1,
        addVerticalDivider: false,
        numRows: _model.dataTest.length,
        onPageChanged: (p0) {
          safeSetState(() {
            _model.dataTablePageChanged(p0);
          });
        },
        dataRowHeight: 54,
        height: (54 * (numberOfRows)) +
            (_model.dataTest.length <= _model.maxRowsPerPage ? 34 : 100),
        controller: _model.paginatedDataTableController,
        data: _model.dataTest,
        columnsBuilder: (onSortChanged) => [
          DataColumn2(
            label: DefaultTextStyle.merge(
              softWrap: true,
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  'Repetições',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                      ),
                ),
              ),
            ),
            fixedWidth: 70,
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
            fixedWidth: 90,
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
            fixedWidth: 90,
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
            (Item, paginatedDataTableIndex, selected, onSelectChanged) =>
                DataRow(
          color: MaterialStateProperty.all(
            FlutterFlowTheme.of(context).secondaryBackground,
          ),
          cells: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
              child: TextFormField(
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
                controller: _model.dropDownIntervalController ??=
                    FormFieldController<String>(null),
                options: ['Alta', 'Média', 'Baixa'],
                onChanged: (val) => {},
                height: 50,
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownIntensityController ??=
                    FormFieldController<String>(null),
                options: ['Alta', 'Média', 'Baixa'],
                onChanged: (val) => {},
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
            Align(
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
                  safeSetState(() {
                    _model.dataTest.removeLast();
                  });
                },
              ),
            ),
          ].map((c) => DataCell(c)).toList(),
        ),
      ),
    );
  }
}
