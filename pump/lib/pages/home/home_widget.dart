import 'dart:async';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter_flow/transition_info.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pump/flutter_flow/nav/nav.dart';
import 'package:pump/pages/sheets_list/sheets_list_widget.dart';
import 'package:pump_components/components/bottom_gradient_component/bottom_gradient_component_widget.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_widget.dart';
import 'package:pump_components/components/comment_bottom_sheet/comment_bottom_sheet_widget.dart';
import 'package:pump_components/components/header_component/header_component_widget.dart';
import 'package:pump_components/components/information_dialog/information_dialog_widget.dart';
import 'package:pump_components/components/invite_with_image_component/invite_with_image_component_widget.dart';
import 'package:pump_components/components/next_workout_component/next_workout_component_widget.dart';
import 'package:pump_components/components/progress_with_details_component/progress_with_details_component_widget.dart';
import 'package:pump_components/components/simple_row_component/simple_row_component_widget.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'home_model.dart';
import 'package:pump_components/components/profile_header_component/profile_header_component_widget.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({this.canShowFeedback = false, Key? key}) : super(key: key);

  final bool canShowFeedback;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  ApiCallResponse? response;
  String deeplinkInvite = "";
  bool hasDeeplinkInvite = false;
  final ApiLoaderController _apiLoaderController = ApiLoaderController();
  bool _reviewRequested = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Home'});
    _fetchLinkData();
  }

  void _fetchLinkData() async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    if (link != null) {
      _handleLinkData(link);
    }

    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData dynamicLink) async {
      _handleLinkData(dynamicLink);
    });
  }

  void _handleLinkData(PendingDynamicLinkData data) {
    final Uri uri = data.link;
    final queryParams = uri.queryParameters;
    if (queryParams.length > 0) {
      if (queryParams["personal"] != null && !hasDeeplinkInvite) {
        String? invite = queryParams["personal"];
        if (invite != null && invite.isNotEmpty) {
          deeplinkInvite = invite;
          hasDeeplinkInvite = true;
          setState(() {
            response = null;
            _apiLoaderController.reload?.call();
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    response = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_model.unfocusNode.hasFocus) {
          FocusScope.of(context).requestFocus(_model.unfocusNode);
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: false,
          bottom: false,
          child: ApiLoaderWidget(
            apiCall: PumpGroup.userHomeCall,
            params: {'invite': deeplinkInvite},
            controller: _apiLoaderController,
            builder: (context, snapshot) {
              if (snapshot == null) {
                return Container();
              }

              if (!_reviewRequested && widget.canShowFeedback) {
                unawaited(_showFeedbackIfNeeded());
              }

              _model.content = snapshot.data?.jsonBody['response'];

              return buildContent(context);
            },
          ),
        ),
      ),
    );
  }

  Stack buildContent(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ProfileHeaderComponentWidget(
            rightIcon: Icons.more_vert,
            subtitle: _model.getWellcomeText(),
            name: _model.content['userName'],
            imageUrl: _model.content?['userImageUrl'] ??
                'https://res.cloudinary.com/hssoaq6x7/image/upload/v1706652351/images/1706652351_image.jpg',
            onTap: () async {
              await context
                  .pushNamed(
                'ProfileDetails',
              )
                  .then((value) {
                if (value != null && value is bool && value == true) {
                  response = null;
                  _apiLoaderController.reload?.call();
                }
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 84 + Utils.getTopSafeArea(context)),
          child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: 130 + Utils.getBottomSafeArea(context)),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildAllContent(context))),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomGradientComponentWidget(),
        ),
      ],
    );
  }

  List<Widget> _buildAllContent(BuildContext context) {
    final widgets = _buildPersonalInviteIfNeeded(context);
    widgets.addAll([buildActiveSheetContent(context)]);
    return widgets;
  }

  SingleChildScrollView buildActiveSheetContent(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          _model.hasActiveSheet() ? _activeSheetSection() : _buildEmptyColumn(),
          _personalSection(),
          _resumeSection(),
          _feedbackSection(),
        ]));
  }

  Widget _buildEmptyColumn() {
    return Column(children: [
      HeaderComponentWidget(
        title: _model.getEmptyStateTitle(),
        subtitle: _model.getEmptyStateDescription(),
      ),
      SimpleRowComponentWidget(
        title: 'Buscar programa',
        leftIcon: Icons.featured_play_list_outlined,
        onTap: () {
          context.pushReplacementNamed(
            'HomeWorkoutSheets',
          );
        },
      ),
    ]);
  }

  List<Widget> _buildPersonalInviteIfNeeded(BuildContext context) {
    return _model.showPersonalInviteHeader()
        ? [
            HeaderComponentWidget(
              title: 'Novo Convite',
              subtitle:
                  '${_model.content?['personalInvite']['personalName']} quer te adicionar como aluno. Deseja aceitar o convite?',
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, bottom: 16),
              child: InviteWithImageComponentWidget(
                onTap: () async {
                  await context.pushNamed(
                    'PersonalProfile',
                    queryParameters: {
                      'forwardUri': serializeParam(
                        'personal/details?personalId=${_model.content?['personalInvite']['personalId']}&userId=$currentUserUid',
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );
                },
                title: _model.content?['personalInvite']['personalName'],
                subtitle: 'Personal Trainer',
                imageString: _model.content?['personalInvite']
                    ['personalImageUrl'],
                onAccept: (p0) async {
                  HapticFeedback.mediumImpact();
                  p0.call(true);

                  final result = await PumpGroup.changePersonalInviteCall(
                      params: {'personalInvite': 'accepted'});

                  if (result.succeeded) {
                    hasDeeplinkInvite = false;
                    deeplinkInvite = '';
                    safeSetState(() {
                      response = null;
                      _apiLoaderController.reload?.call();
                    });
                  } else {
                    p0.call(false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Ocorreu um erro. Por favor, tente novamente.',
                        style: TextStyle(
                          fontSize: 14,
                          color: FlutterFlowTheme.of(context).info,
                        ),
                      ),
                      duration: Duration(milliseconds: 5000),
                      backgroundColor: FlutterFlowTheme.of(context).error,
                    ));
                  }
                },
                onDecline: (p0) async {
                  HapticFeedback.mediumImpact();

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
                        child: GestureDetector(
                          onTap: () => FocusScope.of(context)
                              .requestFocus(_model.unfocusNode),
                          child: InformationDialogWidget(
                            title: 'Atenção',
                            message:
                                'Você não irá ter acesso ao programa de treino do Personal. Tem certeza que deseja recusar o convite?',
                            actionButtonTitle: 'Recusar',
                          ),
                        ),
                      );
                    },
                  ).then(
                    (value) async {
                      p0.call(true);
                      if (value == 'leave') {
                        final result = await _sendInviteResponse('rejected');
                        p0.call(result);
                      }
                    },
                  );
                },
              ),
            ),
            Divider(
              color: FlutterFlowTheme.of(context).secondaryText,
              endIndent: 16,
              indent: 16,
            )
          ]
        : [];
  }

  Future<bool> _sendInviteResponse(String action) async {
    final result = await PumpGroup.changePersonalInviteCall(
        params: {'personalInvite': action});

    if (result.succeeded) {
      hasDeeplinkInvite = false;
      deeplinkInvite = '';
      safeSetState(() {
        response = null;
        _apiLoaderController.reload?.call();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ocorreu um erro. Por favor, tente novamente.',
          style: TextStyle(
            fontSize: 14,
            color: FlutterFlowTheme.of(context).info,
          ),
        ),
        duration: Duration(milliseconds: 5000),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ));
      return false;
    }
    return true;
  }

  Widget _activeSheetSection() {
    dynamic nextWorkout = _model.getNextWorkout();
    dynamic workoutSheet = _model.getActiveWorkoutSheet();
    return Column(
      children: [
        HeaderComponentWidget(
          title: 'Programa Ativo',
        ),
        NextWorkoutComponentWidget(
          header: '${nextWorkout['workoutTime']}',
          title: nextWorkout['workoutName'],
          subtitle: 'Próximo Treino',
          detail: _model.formatArrayToString(nextWorkout['muscleImpact']),
          imageUrl: nextWorkout['imageUrl'],
          onTap: () async {
            HapticFeedback.mediumImpact();
            await context.pushNamed(
              'HomePage',
              queryParameters: {
                'workoutId': serializeParam(
                  nextWorkout['workoutId'],
                  ParamType.String,
                ),
              }.withoutNulls,
              extra: <String, dynamic>{
                kTransitionInfoKey: TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                ),
              },
            );
            safeSetState(() {
              response = null;
              _apiLoaderController.reload?.call();
            });
          },
        ),
        ProgressWithDetailsComponentWidget(
          title: workoutSheet['name'],
          primarySubtitle: '${_model.getSheetPercentString()} do programa',
          secondarySubtitle: '${_model.getWeekPercentString()} da semana',
          linkButtonTitle: 'detalhes',
          sheetPercent: _model.getWorkoutSheetPercent(),
          weekPercent: _model.getWorkoutWeekPercent(),
          onTap: () async {
            HapticFeedback.mediumImpact();
            await context.pushNamed(
              'WorkoutSheetDetails',
              queryParameters: {
                'workoutId': serializeParam(
                  workoutSheet['trainingSheetId'],
                  ParamType.String,
                ),
                'showStartButton': serializeParam(
                  false,
                  ParamType.bool,
                ),
              },
            );
          },
        ),
        Divider(
          color: FlutterFlowTheme.of(context).secondaryText,
          indent: 16,
          endIndent: 16,
          height: 1,
        ),
        HeaderComponentWidget(
          title: 'Treinos da Semana',
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 0.0, 4.0),
          child: _buildWeekWorkouts(context),
        ),
      ],
    );
  }

  Widget _personalSection() {
    if (_model.content['personalDetails'] != null &&
        _model.content['personalDetails']['name'] != null &&
        _model.content['personalDetails']['name'] == 'Pump Training') {
      return Container();
    }
    return Column(
      children: _model.hasPersonal()
          ? [
              HeaderComponentWidget(title: 'Personal Trainer'),
              ProfileHeaderComponentWidget(
                subtitle: 'Personal Trainer',
                name: _model.content['personalDetails']['name'],
                imageUrl: _model.content['personalDetails']['imageUrl'],
                safeArea: false,
                rightIcon: Icons.arrow_forward_ios,
                rightIconSize: 12,
                intent: 16,
                endIntent: 16,
                onTap: () async {
                  await context.pushNamed(
                    'PersonalProfile',
                    queryParameters: {
                      'forwardUri': serializeParam(
                        'personal/details?personalId=${_model.content?['personalDetails']['personalId']}&userId=$currentUserUid',
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );
                },
              ),
            ]
          : [],
    );
  }

  Widget _resumeSection() {
    return _model.hasWorkoutDone()
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderComponentWidget(
                title: 'Histórico',
              ),
              SimpleRowComponentWidget(
                title: '${_model.content?['completedWorkoutCount']} treinos',
                leftIcon: Icons.list_alt_outlined,
                onTap: () {
                  context.pushNamed(
                    'WorkoutCompletedList',
                  );
                },
              ),
              Visibility(
                visible: _model.hasSheetDone(),
                child: SimpleRowComponentWidget(
                  title:
                      '${_model.content?['workoutSheetCompletedCount']} programas',
                  leftIcon: Icons.featured_play_list_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SheetsListWidget(
                          apiCall: PumpGroup.newUserWorkoutSheetCompletedCall,
                          showStatus: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _feedbackSection() {
    final canShow = FirebaseRemoteConfig.instance.getBool('show_user_feedback');
    if (!canShow) {
      return Container();
    }
    return Column(
      children: [
        HeaderComponentWidget(
          title: 'Feedback',
          subtitle:
              'Conte como está sendo sua experiência. Sua opinião é importante para nós',
        ),
        SimpleRowComponentWidget(
          title: 'Enviar feedback',
          leftIcon: Icons.feedback_outlined,
          onTap: () async {
            _showFeedback();
          },
        ),
      ],
    );
  }

  Future _showFeedbackIfNeeded() async {
    _reviewRequested = true;
    final InAppReview _inAppReview = InAppReview.instance;
    final isAvailable = await _inAppReview.isAvailable();
    final canShow = FirebaseRemoteConfig.instance.getBool('show_user_feedback');

    if (isAvailable && canShow) {
      _showFeedback();
    }
  }

  Future _showFeedback() async {
    await showAlignedDialog(
      context: context,
      isGlobal: true,
      avoidOverflow: true,
      targetAnchor:
          AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
      followerAnchor:
          AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
      builder: (dialogContext) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              dialogContext.safePop();
            },
            child: InformationDialogWidget(
              title: 'Feedback',
              message: 'Está gostando de usar o Pump App?',
              actionButtonTitle: '',
              isIconButton: true,
              iconData: Icons.star_border_outlined,
              confirmTap: () async {
                final InAppReview _inAppReview = InAppReview.instance;
                final isAvailable = await _inAppReview.isAvailable();

                if (isAvailable) {
                  await _inAppReview.requestReview();
                }
              },
              cancelTap: () {
                _showFeedbackBottomSheet();
              },
            ),
          ),
        );
      },
    );
  }

  void _showFeedbackBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: CommentBottomSheetWidget(
            title: 'Feedback',
            subtitle:
                'Conte como está sendo sua experiência. Como podemos melhorar?',
            buttonTitle: 'Enviar',
            placeholder: 'Feedback',
            onConfirmTap: (p0) {
              if (p0 != null) {
                unawaited(PumpGroup.feedbackCall
                    .call(userId: currentUserUid, feedbackText: p0));
              }
            },
          ),
        );
      },
    );
  }

  ListView _buildWeekWorkouts(BuildContext context) {
    Iterable<dynamic> weekWorkouts = _model.getWeekWorkouts();
    final List<dynamic> workouts =
        _model.content['activeSheet']['currentWeek']['workouts'];

    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: weekWorkouts.length,
      itemBuilder: (context, workoutListIndex) {
        final workoutId = workouts.elementAt(workoutListIndex);
        final workout = weekWorkouts
            .firstWhere((element) => element['workoutId'] == workoutId);

        List<Widget> rowAndDivider = [];

        final cell = CellListWorkoutWidget(
          imageUrl: workout['imageUrl'],
          title: workout['workoutName'],
          subtitle: _model.formatArrayToString(workout['muscleImpact']),
          level: _model.mapSkillLevel(workout['level']),
          levelColor: _model.mapSkillLevelBorderColor(workout['level']),
          workoutId: workout['workoutId'],
          time: '${workout['workoutTime']}',
          titleImage: 'min',
          isCheck: true,
          isSelected: _model.workoutIsCompleted(workout['workoutId']),
          onTap: (p0) {
            context.pushNamed(
              'WorkoutDetails',
              queryParameters: {
                'workoutId': serializeParam(
                  workout['workoutId'],
                  ParamType.String,
                ),
                'isPersonal': serializeParam(
                  true,
                  ParamType.bool,
                ),
              },
            );
          },
          onDetailTap: (p0) {},
        );

        rowAndDivider.add(cell);

        if (workoutListIndex < weekWorkouts.length - 1) {
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
