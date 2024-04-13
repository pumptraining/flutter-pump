import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter_flow/transition_info.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_model.dart';
import 'package:pump_components/components/edit_workout_series/edit_workout_series_component_widget.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:pump_components/components/header_component/header_component_widget.dart';
import 'package:pump_components/components/profile_header_component/profile_header_component_widget.dart';
import 'package:pump_components/components/pump_app_bar/sliver_pump_app_bar.dart';
import 'package:pump_components/components/review_bottom_sheet/review_bottom_sheet_widget.dart';
import 'package:pump_components/components/review_card/review_card_widget.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_components/components/tag_component/tag_component_widget.dart';
import 'package:pump_components/components/two_count_component/two_count_component_widget.dart';
import 'workout_details_model.dart';
export 'workout_details_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

class WorkoutDetailsWidget extends StatefulWidget {
  const WorkoutDetailsWidget(
      {Key? key,
      this.workoutId,
      this.userId,
      this.isPersonal,
      this.showMoreButton})
      : super(key: key);

  final String? workoutId;
  final String? userId;
  final bool? isPersonal;
  final bool? showMoreButton;

  @override
  // ignore: library_private_types_in_public_api
  _WorkoutDetailsWidgetState createState() => _WorkoutDetailsWidgetState();
}

class _WorkoutDetailsWidgetState extends State<WorkoutDetailsWidget>
    with TickerProviderStateMixin {
  late WorkoutDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isError = false;
  String workoutId = '';
  String userId = currentUserUid;
  late ApiCallResponse responseContent;
  bool showMoreButton = true;

  final ScrollController _scrollController = ScrollController();
  double leftPadding = 16.0;
  final ApiLoaderController _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutDetailsModel());
    _model.isPersonal = widget.isPersonal ?? false;

    workoutId = widget.workoutId ?? '';
    showMoreButton = widget.showMoreButton ?? true;
  }

  @override
  void dispose() {
    _model.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: ApiLoaderWidget(
            apiCall: PumpGroup.workoutDetailsCall,
            params: {'trainingId': workoutId},
            controller: _apiLoaderController,
            builder: (context, snapshot) {
              _model.content = snapshot?.data?.jsonBody;
              _model.workoutSets = _model.content['series'];
              reloadContent(context);

              return Stack(
                children: [
                  buildContent(context),
                  _model.isPersonal
                      ? Container()
                      : BottomButtonFixedWidget(
                          buttonTitle: 'Começar',
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            await context.pushNamed(
                              'HomePage',
                              queryParameters: {
                                'workoutId': serializeParam(
                                  _model.content['workoutId'],
                                  ParamType.String,
                                ),
                                'userId': serializeParam(
                                  userId,
                                  ParamType.String,
                                ),
                              },
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType:
                                      PageTransitionType.bottomToTop,
                                ),
                              },
                            );
                          },
                        )
                ],
              );
            }));
  }

  SliverPumpAppBar buildAppBar(BuildContext context) {
    dynamic title =
        _model.content != null ? _model.content['workoutName'] : null;
    dynamic imageUrl =
        _model.content != null ? _model.content['imageUrl'] : null;
    return SliverPumpAppBar(
        title: title ?? '',
        imageUrl: imageUrl ?? '',
        scrollController: _scrollController);
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        Visibility(
          child: HeaderComponentWidget(
            title: 'Sobre',
            subtitle: _model.getDescription(),
          ),
          visible: _model.getDescription().isNotEmpty,
        ),
        !_model.isPersonal
            ? ProfileHeaderComponentWidget(
                rightIcon: Icons.arrow_forward_ios,
                rightIconSize: 12,
                intent: 16,
                endIntent: 16,
                safeArea: false,
                subtitle: 'Criado por',
                name: _model.content['personalName'],
                imageUrl: _model.content['personalImageUrl'],
                onTap: () {
                  context.pushNamed(
                    'PersonalProfile',
                    queryParameters: {
                      'forwardUri': serializeParam(
                        'personal/details?personalId=${_model.content?['personalId']}&userId=$currentUserUid',
                        ParamType.String,
                      ),
                    },
                  );
                },
              )
            : Container(),
        SizedBox(
          height: 8,
        ),
        TwoCountComponentWidget(
          firstTitle:
              _model.mapSkillLevel(_model.content['level']).toLowerCase(),
          secondTitle: '${_model.content['workoutTime']} min',
          firstIcon: Icons.bar_chart,
          secondIcon: Icons.timer_sharp,
        ),
        HeaderComponentWidget(
          title: 'Grupo Muscular',
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 16.0, 16.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 16),
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: (_model.content['muscleImpact'] as List<dynamic>)
                        .map<Widget>((element) {
                      if (element is String) {
                        return TagComponentWidget(
                          selectedTextColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          alpha: 1,
                          title: element,
                          tagColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          selected: true,
                          maxHeight: 24,
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        HeaderComponentWidget(
          title: 'Equipamentos',
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 16.0, 16.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 16),
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: _model.getEquipmentArray().map<Widget>((element) {
                      if (element is String) {
                        return TagComponentWidget(
                          selectedTextColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          alpha: 1,
                          title: element,
                          tagColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          selected: true,
                          maxHeight: 24,
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRateSection() {
    return Column(
      children: [
        HeaderComponentWidget(
          title: 'Avaliações',
          subtitle: _model.showRating() ? _model.getRatingStringValue() : '',
          buttonTitle: 'todas',
          showButton: _model.showRating() && showMoreButton,
          onTap: () {
            context.pushNamed(
              'ReviewScreen',
              queryParameters: {
                'workoutId': serializeParam(
                  _model.content['workoutId'],
                  ParamType.String,
                ),
                'personalId': serializeParam(
                  _model.content['personalId'],
                  ParamType.String,
                ),
                'isPersonal': serializeParam(
                  false,
                  ParamType.bool,
                ),
              },
            );
          },
        ),
        !showMoreButton
            ? Container()
            : _model.showRating()
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 250.0,
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 40.0),
                                child: PageView(
                                  controller: _model.pageViewController ??=
                                      PageController(initialPage: 0),
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(
                                      _model.content['feedbacks'].length,
                                      (index) {
                                    final feedback =
                                        _model.content['feedbacks'][index];
                                    return ReviewCardWidget(
                                      name: _model.getFeedbackName(feedback),
                                      feedback: feedback['feedbackText'],
                                      imageUrl: feedback['imageUrl'],
                                      rating: feedback['rating'],
                                    );
                                  }),
                                ),
                              ),
                              Visibility(
                                visible: _model.content['feedbacks'] != null &&
                                    _model.content['feedbacks'].length > 1,
                                child: Align(
                                  alignment: AlignmentDirectional(0.00, 1.00),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 0.0, 16.0),
                                    child: smooth_page_indicator
                                        .SmoothPageIndicator(
                                      controller: _model.pageViewController ??=
                                          PageController(initialPage: 0),
                                      count: _model.content['feedbacks'].length,
                                      axisDirection: Axis.horizontal,
                                      onDotClicked: (i) async {
                                        await _model.pageViewController!
                                            .animateToPage(
                                          i,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                      },
                                      effect: smooth_page_indicator
                                          .ExpandingDotsEffect(
                                        expansionFactor: 3.0,
                                        spacing: 8.0,
                                        radius: 16.0,
                                        dotWidth: 8.0,
                                        dotHeight: 8.0,
                                        dotColor: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        activeDotColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        paintStyle: PaintingStyle.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : buildEmptyRatingColumn(context),
      ],
    );
  }

  Widget _buildExercisesSection() {
    return Column(
      children: [HeaderComponentWidget(title: 'Exercícios')],
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
          _buildAboutSection(),
          _buildRateSection(),
          _buildExercisesSection(),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                0, 0, 0, _model.isPersonal ? 32 : 70),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                        child: Builder(
                          builder: (context) {
                            return EditWorkoutSeriesComponentWidget(
                              workoutSets: _model.workoutSets,
                              dataArray: _model.dataArray,
                              paginatedDataTableController:
                                  _model.paginatedDataTableController,
                              canEdit: false,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ])),
      ],
    );
  }

  Center buildEmptyRatingColumn(BuildContext context) {
    return Center(
      child: EmptyListWidget(
        title: 'Nenhuma avaliação',
        message: 'Seja o primeiro a deixar uma avaliação',
        buttonTitle: 'Avaliar',
        showIcon: false,
        onButtonPressed: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: ReviewBottomSheetWidget(
                  workoutId: workoutId,
                  personalId: _model.content['personalId'],
                ),
              );
            },
          ).then((value) => safeSetState(() {
                if (value == true) {
                  _model.content = null;
                  _apiLoaderController.reload?.call();
                }
              }));
        },
      ),
    );
  }

  void reloadContent(BuildContext context) {
    _model.dataArray = [];

    int setIndex = 0;
    _model.workoutSets.toList().forEach((set) {
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
}
