import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_charts.dart';
import 'package:flutter_flow/flutter_flow_drop_down.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_components/components/bottom_gradient_component/bottom_gradient_component_widget.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_widget.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:pump_components/components/header_component/header_component_widget.dart';
import 'package:pump_components/components/pump_app_bar/pump_app_bar.dart';
import 'package:pump_components/components/simple_row_component/simple_row_component_widget.dart';
import 'activity_model.dart';
export 'activity_model.dart';
export 'activity_widget.dart';

class ActivityWidget extends StatefulWidget {
  const ActivityWidget({Key? key, this.customerId}) : super(key: key);

  final String? customerId;

  @override
  _ActivityWidgetState createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget>
    with TickerProviderStateMixin {
  late ActivityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String userId = currentUserUid;
  final ApiLoaderController _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActivityModel());

    if (widget.customerId != null) {
      userId = widget.customerId!;
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_model.unfocusNode.hasFocus) {
          _model.unfocusNode.unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PumpAppBar(
            title: 'Atividades', hasBackButton: widget.customerId != null),
        body: SafeArea(
          top: true,
          bottom: false,
          child: ApiLoaderWidget(
            apiCall: PumpGroup.userActivityCall,
            params: {'userId': userId, 'time': _model.time},
            controller: _apiLoaderController,
            builder: (context, snapshot) {
              if (snapshot?.data == null) {
                return Container();
              }

              _model.content = snapshot?.data?.jsonBody;

              if (_model.content['categories'] == null ||
                  _model.content['categories'].isEmpty) {
                return _buildEmptyColumn(context);
              }

              return Stack(children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: 130 + Utils.getBottomSafeArea(context)),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      dropdownTimeSelect(context),
                      muscularGroupRow(),
                      Visibility(
                          visible: !_model.allZeros(_model.generateYData()),
                          child: _buildTrainingTimeSection()),
                      _buildTrainingTypeSection(),
                      _buildLastTrainingsSections(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomGradientComponentWidget(),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingTypeSection() {
    final chartPieChartColorsList3 = [
      Color(0xFF2536A4),
      Color(0xFF6F28CB),
      Color(0xFFD354E3),
    ];

    final chartPieChartColorsListWithAlpha =
        chartPieChartColorsList3.map((color) {
      return color.withOpacity(0.5);
    }).toList();

    return Column(
      children: [
        HeaderComponentWidget(
          title: 'Tipo de Treino',
          subtitle:
              'Percentual de tipo de treino com base na quantidade de treinos realizados',
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    color: Color(0x00F1F4F8),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 150.0,
                                    child: FlutterFlowPieChart(
                                      data: FFPieChartData(
                                        values: _model.getObjectiveValues(),
                                        colors:
                                            chartPieChartColorsListWithAlpha,
                                        radius: [70.0],
                                        borderWidth: [2],
                                        borderColor: chartPieChartColorsList3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(
                                  _model.content['objective'].length,
                                  (objectiveIndex) {
                                    final objectiveItem = _model
                                        .content['objective'][objectiveIndex];

                                    final icon = Icon(
                                      Icons.circle,
                                      color: chartPieChartColorsList3[
                                          objectiveIndex],
                                      size: 10,
                                    );

                                    final title =
                                        '${_model.formatPercentage(objectiveItem['percentage'])} ${objectiveItem['name']}';

                                    return SimpleRowComponentWidget(
                                      title: title,
                                      leftIconWidget: icon,
                                      showArrowRight: false,
                                      showSeparator: objectiveIndex != 2,
                                    );
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrainingTimeSection() {
    final List<FlSpot> spots = [
      FlSpot(0, 10),
      FlSpot(1, 20),
      FlSpot(2, 30),
      FlSpot(3, 30),
      FlSpot(4, 30),
    ];

    return Column(children: [
      HeaderComponentWidget(
        title: 'Tempo',
        subtitle: 'Tempo de treino ativo em minutos',
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 0.0),
                              child: Container(
                                height: 180.0,
                                child: FlutterFlowLineChart(
                                  data: [
                                    FFLineChartData(
                                      xData: _model.generateXData(),
                                      yData: _model.generateYData(),
                                      settings: LineChartBarData(
                                        spots: spots,
                                        color: Color(0xFF4B39EF),
                                        barWidth: 2.0,
                                        isCurved: true,
                                        preventCurveOverShooting: true,
                                        dotData: FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Color(0x4C4B39EF),
                                        ),
                                      ),
                                    )
                                  ],
                                  chartStylingInfo: ChartStylingInfo(
                                    enableTooltip: true,
                                    backgroundColor: Colors.transparent,
                                    showBorder: false,
                                    tooltipBackgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .primaryText,
                                  ),
                                  axisBounds: AxisBounds(),
                                  xAxisLabelInfo: AxisLabelInfo(),
                                  yAxisLabelInfo: AxisLabelInfo(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  Column muscularGroupRow() {
    final chartPieChartColorsList1 = [
      Color(0xFF2536A4),
      Color(0xFF6F28CB),
      Color(0xFFD354E3),
      Color(0xFF539A80),
      Color(0xFF4A57C1),
      Color(0xFF3E8DD0),
      Color(0xFF2F1F86),
      Color(0xFF333EBA),
      Color(0xFF5C6BF4),
      Color(0xFF8F5CB5),
      Color(0xFFA487ED),
      Color(0xFF6A80C9),
      Color(0xFF7849BD)
    ];

    final chartPieChartColorsListWithAlpha =
        chartPieChartColorsList1.map((color) {
      return color.withOpacity(0.5);
    }).toList();

    final colorMoreIndex =
        _model.getArrayColorFromIndex(chartPieChartColorsList1, 3);

    _model.expandableController ??= ExpandableController();

    return Column(children: [
      HeaderComponentWidget(
        title: 'Grupo Muscular',
        subtitle:
            'Percentual de grupo muscular trabalhado com base na quantidade de séries realizadas',
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 250,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: Color(0x00F1F4F8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 250,
                                      child: FlutterFlowPieChart(
                                        data: FFPieChartData(
                                          values:
                                              _model.getMuscularGroupValues(),
                                          borderColor: chartPieChartColorsList1,
                                          borderWidth: [2],
                                          colors:
                                              chartPieChartColorsListWithAlpha,
                                          radius: [120],
                                        ),
                                        donutHoleRadius: 0,
                                        donutHoleColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(
                                  _model.getFirstThreeCategories().length,
                                  (categoryIndex) {
                                    final categoryItem =
                                        _model.getFirstThreeCategories()[
                                            categoryIndex];

                                    final icon = Icon(
                                      Icons.circle,
                                      color: chartPieChartColorsList1[
                                          categoryIndex],
                                      size: 10,
                                    );

                                    final title =
                                        '${_model.formatPercentage(categoryItem['percentage'])} ${categoryItem['name']}';

                                    return SimpleRowComponentWidget(
                                      title: title,
                                      leftIconWidget: icon,
                                      showArrowRight: false,
                                      showSeparator: categoryIndex != 2,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Visibility(
                              visible: _model.content['categories'].length > 3,
                              child: Expanded(
                                child: Container(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  child: ExpandableNotifier(
                                    initialExpanded: false,
                                    child: ExpandablePanel(
                                      controller: _model.expandableController,
                                      header: Align(
                                        alignment: AlignmentDirectional(-1, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16, 0, 0, 0),
                                          child: Text(
                                            'ver todos',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily: 'Montserrat',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                          ),
                                        ),
                                      ),
                                      collapsed: Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        height: 1,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                        ),
                                      ),
                                      expanded: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: List.generate(
                                          _model.getMoreCategories(3).length,
                                          (categoryIndex) {
                                            final categoryItem =
                                                _model.getMoreCategories(
                                                    3)[categoryIndex];

                                            final icon = Icon(
                                              Icons.circle,
                                              color:
                                                  colorMoreIndex[categoryIndex],
                                              size: 10,
                                            );

                                            final title =
                                                '${_model.formatPercentage(categoryItem['percentage'])} ${categoryItem['name']}';

                                            return SimpleRowComponentWidget(
                                              title: title,
                                              leftIconWidget: icon,
                                              showArrowRight: false,
                                            );
                                          },
                                        ),
                                      ),
                                      theme: ExpandableThemeData(
                                          tapHeaderToExpand: true,
                                          tapBodyToExpand: true,
                                          tapBodyToCollapse: true,
                                          headerAlignment:
                                              ExpandablePanelHeaderAlignment
                                                  .center,
                                          hasIcon: true,
                                          iconSize: 18,
                                          iconPadding: EdgeInsets.fromLTRB(
                                              0,
                                              2,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              0),
                                          iconColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary),
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
      ),
    ]);
  }

  Widget _buildLastTrainingsSections() {
    return Column(
      children: [
        HeaderComponentWidget(
          title: 'Recentes',
          subtitle: 'Últimos treinos concluídos',
          buttonTitle: 'todos',
          showButton: true,
          onTap: () {
            context.pushNamed(
              'WorkoutCompletedList',
              queryParameters: {
                'userId': serializeParam(
                  userId,
                  ParamType.String,
                ),
              },
            );
          },
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 12, 0, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(
                            _model.content['lastTrainings'].length,
                            (workoutIndex) {
                              final workoutItem =
                                  _model.content['lastTrainings'][workoutIndex];

                              final isLast =
                                  _model.content['lastTrainings'].length ==
                                      (workoutIndex + 1);

                              List<Widget> rowAndDivider = [];

                              CellListWorkoutWidget cell =
                                  CellListWorkoutWidget(
                                workoutId: workoutItem['_id'],
                                title: workoutItem['namePortuguese'],
                                subtitle: workoutItem['finishDate'],
                                imageUrl: workoutItem['trainingImageUrl'],
                                level: _model.mapSkillLevel(
                                    workoutItem['trainingLevel']),
                                levelColor: _model.mapSkillLevelColor(
                                    workoutItem['trainingLevel']),
                                time:
                                    '${(workoutItem['totalSecondsTime'] ?? 0) ~/ 60}',
                                titleImage: '',
                                onTap: (p0) {
                                  context.pushNamed(
                                    'WorkoutDetails',
                                    queryParameters: {
                                      'workoutId': serializeParam(
                                        workoutItem['_id'],
                                        ParamType.String,
                                      ),
                                      'userId': serializeParam(
                                        userId,
                                        ParamType.String,
                                      ),
                                    },
                                  );
                                },
                                onDetailTap: (p0) {},
                              );

                              rowAndDivider.add(cell);

                              if (!isLast) {
                                rowAndDivider.add(
                                  Divider(
                                    indent: 78,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    height: 1,
                                    endIndent: 16,
                                  ),
                                );
                              }

                              return Column(
                                children: rowAndDivider,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyColumn(BuildContext context) {
    return EmptyListWidget(
      title: 'Nenhum registro de atividade',
      message: widget.customerId != null
          ? 'O aluno não possui nenhum registro de atividade no período selecionado.'
          : 'Após concluir seus treinos, acompanhe suas métricas e progresso para alcançar seus objetivos!',
      showButton: false,
      iconData: Icons.bar_chart,
    );
  }

  Widget dropdownTimeSelect(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  child: FlutterFlowDropDown<String>(
                    controller: _model.dropDownValueController ??=
                        FormFieldController<String>(
                      _model.dropDownValue ??= 'Últimos 7 dias',
                    ),
                    options: _model.dateRanges
                        .map((dateRange) => dateRange.title)
                        .toList(),
                    onChanged: (val) {
                      if (_model.dropDownValue != val) {
                        _model.selectedDays(val!);
                        _model.content = null;
                        _apiLoaderController.reload!(
                            params: {'userId': userId, 'time': _model.time});

                        setState(() {
                          _model.dropDownValue = val;
                        });
                      }
                    },
                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Montserrat',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.normal,
                        ),
                    hintText: 'Selecionar',
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 18.0,
                    ),
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    elevation: 0.0,
                    borderColor: FlutterFlowTheme.of(context).primaryBackground,
                    borderWidth: 1.0,
                    borderRadius: 8.0,
                    margin:
                        EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                    hidesUnderline: true,
                    isSearchable: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          indent: 16,
          color: FlutterFlowTheme.of(context).secondaryText,
          height: 1,
          endIndent: 16,
        ),
      ],
    );
  }
}
