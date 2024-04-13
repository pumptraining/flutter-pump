import 'package:api_manager/common/loader_state.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_widget.dart';
import 'package:pump_components/components/pump_app_bar/pump_app_bar.dart';
import 'workout_completed_list_model.dart';
export 'workout_completed_list_model.dart';

class WorkoutCompletedListWidget extends StatefulWidget {
  const WorkoutCompletedListWidget({
    Key? key,
    this.userId,
    this.isPersonal,
  }) : super(key: key);

  final String? userId;
  final bool? isPersonal;

  @override
  _WorkoutCompletedListWidgetState createState() =>
      _WorkoutCompletedListWidgetState();
}

class _WorkoutCompletedListWidgetState extends State<WorkoutCompletedListWidget>
    with TickerProviderStateMixin {
  late WorkoutCompletedListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String userId = currentUserUid;
  late ApiCallResponse responseContent;
  final ApiLoaderController _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutCompletedListModel());
    userId = widget.userId ?? currentUserUid;
    _model.isPersonal = widget.isPersonal ?? false;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PumpAppBar(
          title: 'Treinos Realizados',
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: ApiLoaderWidget(
            apiCall: PumpGroup.getCompletedWorkoutCall,
            params: {'userId': userId},
            controller: _apiLoaderController,
            builder: (context, snapshot) {
              if (snapshot?.data == null) {
                return Container();
              }

              _model.content = snapshot?.data?.jsonBody;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(
                                    _model.content['workouts'].length,
                                    (workoutIndex) {
                                      final workoutItem = _model
                                          .content['workouts'][workoutIndex];

                                      final isLast =
                                          _model.content['workouts'].length ==
                                              (workoutIndex + 1);

                                      List<Widget> rowAndDivider = [];

                                      CellListWorkoutWidget cell =
                                          CellListWorkoutWidget(
                                        workoutId: workoutItem['_id'],
                                        title: workoutItem['namePortuguese'],
                                        subtitle: workoutItem['finishDate'],
                                        imageUrl:
                                            workoutItem['trainingImageUrl'],
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
                                              'isPersonal': serializeParam(
                                                _model.isPersonal,
                                                ParamType.bool,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
