import 'package:api_manager/common/loader_state.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter/material.dart';
import 'package:pump/common/map_skill_level.dart';
import 'package:pump/flutter_flow/nav/nav.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_widget.dart';
import 'package:pump_components/components/pump_app_bar/sliver_pump_app_bar.dart';
import 'category_list_model.dart';
export 'category_list_model.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({
    Key? key,
    this.forwardUri,
    this.imageUrl,
    this.categoryName,
    this.userId,
  }) : super(key: key);

  final String? forwardUri;
  final String? imageUrl;
  final String? categoryName;
  final String? userId;

  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget>
    with TickerProviderStateMixin {
  late CategoryListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String forwardUri = '';
  String userId = currentUserUid;
  String categoryName = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategoryListModel());

    forwardUri = widget.forwardUri ?? '';
    categoryName = widget.categoryName ?? '';
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ApiLoaderWidget(
          apiCall: PumpGroup.categoryListCall,
          params: {'forwardUri': forwardUri},
          builder: (context, snapshot) {
            _model.workouts = snapshot?.data?.jsonBody;
            _model.workouts['workoutList'].sort(_model.compareByLevel);

            return buildContent(context);
          },
        ),
      ),
    );
  }

  CustomScrollView buildContent(BuildContext context) {
    return CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        slivers: [
          buildAppBar(context),
          SliverList(
              delegate: SliverChildListDelegate([
            ListView.builder(
                padding: EdgeInsets.only(top: 24, bottom: 32, left: 8),
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _model.workouts['workoutList'].length,
                itemBuilder: (context, workoutListIndex) {
                  final workout = _model.workouts['workoutList']
                      .elementAt(workoutListIndex);

                  List<Widget> rowAndDivider = [];

                  final cell = CellListWorkoutWidget(
                    imageUrl: workout['imageUrl'],
                    title: workout['workoutName'],
                    subtitle:
                        WorkoutMap.formatArrayToString(workout['muscleImpact']),
                    level: WorkoutMap.mapSkillLevel(workout['level']),
                    levelColor:
                        WorkoutMap.mapSkillLevelBorderColor(workout['level']),
                    workoutId: workout['workoutId'],
                    time: '${workout['workoutTime']}',
                    titleImage: 'min',
                    isCheck: false,
                    isSelected: false,
                    onTap: (p0) {
                      context.pushNamed(
                        'WorkoutDetails',
                        queryParameters: {
                          'workoutId': serializeParam(
                            workout['workoutId'],
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

                  if (workoutListIndex <
                      _model.workouts['workoutList'].length - 1) {
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
                })
          ]))
        ]);
  }

  SliverPumpAppBar buildAppBar(BuildContext context) {
    return SliverPumpAppBar(
        title: categoryName,
        imageUrl: widget.imageUrl ?? '',
        scrollController: _scrollController);
  }
}
