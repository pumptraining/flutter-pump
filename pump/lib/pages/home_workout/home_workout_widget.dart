import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:pump/common/map_skill_level.dart';
import 'package:pump/flutter_flow/nav/nav.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_widget.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:pump_components/components/header_component/header_component_widget.dart';
import 'package:pump_components/components/horizontal_workout_sheet_list_component/horizontal_workout_sheet_list_component_widget.dart';
import 'package:pump_components/components/pump_app_bar/pump_app_bar.dart';
import 'package:pump_components/components/search_filter_component/search_filter_component.dart';
import '/components/workout_filter_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'home_workout_model.dart';
export 'home_workout_model.dart';

class HomeWorkoutWidget extends StatefulWidget {
  const HomeWorkoutWidget({Key? key}) : super(key: key);

  @override
  _HomeWorkoutWidgetState createState() => _HomeWorkoutWidgetState();
}

class _HomeWorkoutWidgetState extends State<HomeWorkoutWidget>
    with TickerProviderStateMixin {
  late HomeWorkoutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic filteredListContent;
  String userId = currentUserUid;
  ApiLoaderController _apiLoaderController = ApiLoaderController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerFilterList = ScrollController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeWorkoutModel());

    _model.textController ??= TextEditingController();

    _scrollController.addListener(() {
      if (_model.textFieldFocusNode.hasFocus) {
        _model.textFieldFocusNode.unfocus();
      }
    });

    _scrollControllerFilterList.addListener(() {
      if (_model.textFieldFocusNode.hasFocus) {
        _model.textFieldFocusNode.unfocus();
      }
    });
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
        if (_model.textFieldFocusNode.hasFocus) {
          _model.textFieldFocusNode.unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PumpAppBar(title: 'Treinos'),
        body: SafeArea(
          top: true,
          bottom: false,
          child: ApiLoaderWidget(
            apiCall: PumpGroup.homeWorkoutsCall,
            builder: (context, snapshot) {
              if (snapshot == null) {
                return Container();
              }

              _model.homeWorkouts = snapshot.data?.jsonBody;
              return Stack(
                children: [_buildContent(context), _buildSearchSection()],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SearchFilterComponentWidget(
      textFieldFocusNode: _model.textFieldFocusNode,
      textController: _model.textController,
      bagdeValue: _model.filterContent.isNotEmpty &&
              _model.filterContent['filterCount'] != null
          ? '${_model.filterContent['filterCount']}'
          : null,
      onTextChanged: () {
        EasyDebounce.debounce(
            '_model.textController', Duration(milliseconds: 2000), () {
          safeSetState(() {
            _model.showFilter = true;
          });
        });
      },
      onButtonTap: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
              height: MediaQuery.of(context).size.height * 0.93,
              child: WorkoutFilterWidget(
                selectedFilter: _model.filterContent,
              ),
            );
          },
        ).then((value) {
          if (value != null) {
            if (value['filterCount'] == 0) {
              value = null;
              _model.showFilter = false;
            } else {
              _model.showFilter = true;
            }

            if (value != null) {
              _model.mergeFilterContent(value);
            } else {
              _model.showFilter = false;
              _model.filterContent = {};
            }

            safeSetState(() {
              _model.textController?.clear();
            });
          }
        });
      },
    );
  }

  Widget buildEmptyColumn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 94),
      child: EmptyListWidget(
        title: 'Ooops!',
        message: 'Não encontramos nenhum treino com esses critérios de busca',
        showButton: false,
        showIcon: false,
      ),
    );
  }

  Widget _buildHighlightSection() {
    return HorizontalWorkoutSheetListComponentWidget(
      dtoList: _model.getWorkoutSheetListDTO(),
      onTap: (p0) {
        context.pushNamed(
          'WorkoutDetails',
          queryParameters: {
            'workoutId': serializeParam(
              p0.id,
              ParamType.String,
            ),
            'userId': serializeParam(
              userId,
              ParamType.String,
            ),
          },
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_model.showFilter) {
      return _model.filterContent['workouts'] != null
          ? _buildFilterList(context)
          : ApiLoaderWidget(
              apiCall: PumpGroup.homeWorkoutFilterCall,
              builder: (context, snapshot) {
                _model.mergeFilterContent(snapshot?.data?.jsonBody);
                _model.lastFilter = snapshot?.data?.jsonBody;
                return _buildFilterList(context);
              },
            );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 94),
      controller: _scrollController,
      child: Container(
        // height: MediaQuery.of(context).size.height - 94,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Visibility(
              visible: !_model.showFilter,
              child: HeaderComponentWidget(title: 'Destaques'),
            ),
            Visibility(
              visible: !_model.showFilter,
              child: _buildHighlightSection(),
            ),
            Visibility(
              visible: !_model.showFilter,
              child: HeaderComponentWidget(title: 'Categorias'),
            ),
            Visibility(
              visible: !_model.showFilter,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                child: ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children:
                        List.generate(_model.homeWorkouts['categories'].length,
                            (categoryIndex) {
                      dynamic category =
                          _model.homeWorkouts['categories'][categoryIndex];

                      return Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 16.0),
                        child: Container(
                          width: 170.0,
                          height: 170.0,
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
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 500),
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  imageUrl: category['imageUrl'],
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await context.pushNamed(
                                    'CategoryList',
                                    queryParameters: {
                                      'forwardUri': serializeParam(
                                        category['forwardUri'],
                                        ParamType.String,
                                      ),
                                      'imageUrl': serializeParam(
                                        category['imageUrl'],
                                        ParamType.String,
                                      ),
                                      'categoryName': serializeParam(
                                        category['title'],
                                        ParamType.String,
                                      ),
                                      'userId': serializeParam(
                                        userId,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 170.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0x4C1D2428),
                                        Color(0xB1000000)
                                      ],
                                      stops: [0.0, 1.0],
                                      begin: AlignmentDirectional(0.0, -1.0),
                                      end: AlignmentDirectional(0, 1.0),
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 24.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 8.0, 0.0),
                                                child: Text(
                                                  category['title'],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily:
                                                            'Montserrat',
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 0.0, 16.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 24.0,
                                                height: 24.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0x66FFFFFF),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 4.0,
                                                      color: Color(0x33000000),
                                                      offset: Offset(0.0, 2.0),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Icon(
                                                  Icons.fitness_center_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .warning,
                                                  size: 16.0,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        6.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  '${category['count']} treinos',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .override(
                                                          fontFamily:
                                                              'Montserrat',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .info),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterList(BuildContext context) {
    filteredListContent = null;
    filteredListContent = _model.filteredContent();

    if (filteredListContent.length == 0) {
      return ListView(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [buildEmptyColumn(context)]);
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 94, bottom: 32, left: 8),
      primary: false,
      shrinkWrap: true,
      controller: _scrollControllerFilterList,
      scrollDirection: Axis.vertical,
      itemCount: filteredListContent.length,
      itemBuilder: (context, workoutListIndex) {
        final workoutId = filteredListContent.elementAt(workoutListIndex);
        final workout = _model.filterContent['workouts']
            .firstWhere((element) => element['_id'] == workoutId['_id']);

        List<Widget> rowAndDivider = [];

        final cell = CellListWorkoutWidget(
          imageUrl: workout['trainingImageUrl'],
          title: workout['namePortuguese'],
          subtitle: WorkoutMap.formatArrayToString(workout['muscleImpact']),
          level: WorkoutMap.mapSkillLevel(workout['trainingLevel']),
          levelColor:
              WorkoutMap.mapSkillLevelBorderColor(workout['trainingLevel']),
          workoutId: workout['_id'],
          time: '${workout['time']}',
          titleImage: 'min',
          isCheck: false,
          isSelected: false,
          onTap: (p0) {
            context.pushNamed(
              'WorkoutDetails',
              queryParameters: {
                'workoutId': serializeParam(
                  workout['_id'],
                  ParamType.String,
                ),
                'isPersonal': serializeParam(
                  false,
                  ParamType.bool,
                ),
              },
            );
          },
          onDetailTap: (p0) {},
        );

        rowAndDivider.add(cell);

        if (workoutListIndex < filteredListContent.length - 1) {
          rowAndDivider.add(
            Divider(
              indent: 78,
              color: FlutterFlowTheme.of(context).secondaryText,
              height: 1,
              endIndent: 16,
            ),
          );
        }

        return Column(
          children: rowAndDivider,
        );
      },
    );
  }
}
