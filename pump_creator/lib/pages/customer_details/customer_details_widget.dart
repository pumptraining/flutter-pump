import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:pump_components/components/information_dialog/information_dialog_widget.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import 'package:pump_creator/models/tag_model.dart';
import 'package:pump_components/components/action_sheet_buttons/action_sheet_buttons_widget.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:pump_components/components/tag_component/tag_component_widget.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'package:badges/badges.dart' as badges;
import 'customer_details_model.dart';
export 'customer_details_model.dart';

class CustomerDetailsWidget extends StatefulWidget {
  const CustomerDetailsWidget(
      {Key? key,
      required this.customerId,
      required this.email,
      this.reloadBack})
      : super(key: key);

  final String customerId;
  final String email;
  final bool? reloadBack;

  @override
  _CustomerDetailsWidgetState createState() => _CustomerDetailsWidgetState();
}

class _CustomerDetailsWidgetState extends State<CustomerDetailsWidget>
    with TickerProviderStateMixin {
  late CustomerDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation1':
        _createAnimation(1, 0, 600, Offset(100, 0)),
    'containerOnPageLoadAnimation2':
        _createScaleAnimation(1, 0, 600, Offset(0.8, 0.8), Offset(1, 1)),
    'textOnPageLoadAnimation1': _createAnimation(180, 180, 600, Offset(20, 0)),
    'textOnPageLoadAnimation2': _createAnimation(200, 200, 600, Offset(40, 0)),
    'containerOnPageLoadAnimation3':
        _createAnimation(1, 0, 600, Offset(120, 0)),
    'containerOnPageLoadAnimation4':
        _createScaleAnimation(1, 0, 600, Offset(0.8, 0.8), Offset(1, 1)),
    'textOnPageLoadAnimation3': _createAnimation(220, 220, 600, Offset(20, 0)),
    'textOnPageLoadAnimation4': _createAnimation(240, 240, 600, Offset(40, 0)),
    'textOnPageLoadAnimation5': _createAnimation(600, 600, 600, Offset(0, 30)),
    'containerOnPageLoadAnimation5':
        _createMoveFadeAnimation(800, 600, Offset(0, 50)),
    'progressBarOnPageLoadAnimation1':
        _createScaleAnimation(1200, 1200, 400, Offset(0.8, 0.8), Offset(1, 1)),
    'progressBarOnPageLoadAnimation2':
        _createScaleAnimation(1200, 1200, 400, Offset(0.8, 0.8), Offset(1, 1)),
    'dividerOnPageLoadAnimation':
        _createAnimation(1400, 1400, 600, Offset(0, 30)),
    'textOnPageLoadAnimation6':
        _createMoveFadeAnimation(1600, 0, Offset(0, 30)),
    'textOnPageLoadAnimation7':
        _createMoveFadeAnimation(1600, 1600, Offset(0, 50)),
    'containerOnPageLoadAnimation6':
        _createMoveFadeAnimation(1600, 1600, Offset(0, 90)),
    'textOnPageLoadAnimation8': _createAnimation(200, 200, 600, Offset(40, 0)),
    'textOnPageLoadAnimation9': _createAnimation(180, 180, 600, Offset(20, 0)),
    'containerOnPageLoadAnimation7':
        _createScaleAnimation(1, 0, 600, Offset(0.8, 0.8), Offset(1, 1)),
    'containerOnPageLoadAnimation8': _createMoveScaleFadeAnimation(
        0, 0, 400, Offset(0.9, 0.9), Offset(1, 1), Offset(0, 20)),
    'containerOnPageLoadAnimation9': _createMoveScaleFadeAnimation(
        0, 0, 400, Offset(0.9, 0.9), Offset(1, 1), Offset(0, 20)),
    'containerOnPageLoadAnimation10': _createMoveScaleFadeAnimation(
        0, 0, 400, Offset(0.9, 0.9), Offset(1, 1), Offset(0, 20)),
    'containerOnPageLoadAnimation11': _createMoveScaleFadeAnimation(
        0, 0, 400, Offset(0.9, 0.9), Offset(1, 1), Offset(0, 20)),
    'containerOnPageLoadAnimation12':
        _createMoveFadeAnimation(1600, 1600, Offset(0, 90)),
    'textOnPageLoadAnimation10': _createAnimation(200, 200, 600, Offset(40, 0)),
    'textOnPageLoadAnimation11': _createAnimation(180, 180, 600, Offset(20, 0)),
    'containerOnPageLoadAnimation13':
        _createScaleAnimation(1, 0, 600, Offset(0.8, 0.8), Offset(1, 1)),
    'containerOnPageLoadAnimation14':
        _createMoveFadeAnimation(0, 0, Offset(0, 50)),
    'containerOnPageLoadAnimation15':
        _createMoveFadeAnimation(0, 0, Offset(0, 50)),
  };

  static AnimationInfo _createAnimation(
      int duration, int delay, int effectDuration, Offset moveOffset) {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: duration.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: delay.ms,
          duration: effectDuration.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: delay.ms,
          duration: effectDuration.ms,
          begin: moveOffset,
          end: Offset.zero,
        ),
      ],
    );
  }

  static AnimationInfo _createScaleAnimation(
      int duration, int delay, int effectDuration, Offset begin, Offset end) {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: duration.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: delay.ms,
          duration: effectDuration.ms,
          begin: 0,
          end: 1,
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: delay.ms,
          duration: effectDuration.ms,
          begin: begin,
          end: end,
        ),
      ],
    );
  }

  static AnimationInfo _createMoveScaleFadeAnimation(
    int delay,
    int visibilityDuration,
    int effectDuration,
    Offset scaleBegin,
    Offset scaleEnd,
    Offset moveOffset,
  ) {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: visibilityDuration.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: delay.ms + visibilityDuration.ms,
          duration: effectDuration.ms,
          begin: 0,
          end: 1,
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: delay.ms + visibilityDuration.ms,
          duration: effectDuration.ms,
          begin: scaleBegin,
          end: scaleEnd,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: delay.ms + visibilityDuration.ms,
          duration: effectDuration.ms,
          begin: moveOffset,
          end: Offset.zero,
        ),
      ],
    );
  }

  static AnimationInfo _createMoveFadeAnimation(
      int delay, int effectDuration, Offset moveOffset) {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: delay.ms,
          duration: effectDuration.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: delay.ms,
          duration: effectDuration.ms,
          begin: moveOffset,
          end: Offset.zero,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CustomerDetailsModel());
    _model.reloadBack = widget.reloadBack ?? false;

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'CustomerDetails'});
    _model.expandableController1 = ExpandableController(initialExpanded: false);
    _model.expandableController2 = ExpandableController(initialExpanded: false);

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  final ApiLoaderController apiLoaderController = ApiLoaderController();

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: false,
          bottom: false,
          child: ApiLoaderWidget(
            apiCall: BaseGroup.customerHomeCall,
            params: {'email': widget.email},
            controller: apiLoaderController,
            builder: (context, snapshot) {
              _model.content = snapshot?.data?.jsonBody['response'];
              return buildContent(context);
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildHeaderContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 12),
                        child: GestureDetector(
                          onTap: () async {
                            await context.pushNamed(
                              'WorkoutCompletedList',
                              queryParameters: {
                                'userId': serializeParam(
                                  widget.customerId,
                                  ParamType.String,
                                ),
                                'isPersonal': serializeParam(
                                  true,
                                  ParamType.bool,
                                ),
                              },
                            );
                          },
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x1F000000),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 12, 12, 12),
                                        child: Icon(
                                          Icons.fitness_center,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation2']!),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12, 12, 12, 12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Treinos Realizados',
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium,
                                        ).animateOnPageLoad(animationsMap[
                                            'textOnPageLoadAnimation1']!),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 8, 0, 0),
                                          child: Text(
                                            '${_model.content?['completedWorkoutCount']}',
                                            style: FlutterFlowTheme.of(context)
                                                .displaySmall,
                                          ).animateOnPageLoad(animationsMap[
                                              'textOnPageLoadAnimation2']!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation1']!),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 16, 12),
                        child: GestureDetector(
                          onTap: () async {
                            await context.pushNamed(
                              'CompletedWorkoutSheetList',
                              queryParameters: {
                                'customerId': serializeParam(
                                  widget.customerId,
                                  ParamType.String,
                                ),
                                'isPersonal': serializeParam(
                                  true,
                                  ParamType.bool,
                                ),
                              },
                            );
                          },
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x1F000000),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 12, 12, 12),
                                        child: Icon(
                                          Icons.featured_play_list,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation4']!),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12, 12, 12, 12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Programas Realizados',
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium,
                                        ).animateOnPageLoad(animationsMap[
                                            'textOnPageLoadAnimation3']!),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 8, 0, 0),
                                          child: Text(
                                            '${_model.content?['workoutSheetCompletedCount']}',
                                            style: FlutterFlowTheme.of(context)
                                                .displaySmall,
                                          ).animateOnPageLoad(animationsMap[
                                              'textOnPageLoadAnimation4']!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation3']!),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                await context.pushNamed(
                  'ActivityWidget',
                  queryParameters: {
                    'customerId': serializeParam(
                      widget.customerId,
                      ParamType.String,
                    ),
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Color(0x3416202A),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    )),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                        child: Icon(
                          Icons.bar_chart,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 28,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Text(
                          'Atividades',
                          style: FlutterFlowTheme.of(context).titleSmall,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.9, 0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
              visible: true,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context
                        .pushNamed('CustomerPaymentsWidget', queryParameters: {
                      'customerId':
                          serializeParam(widget.customerId, ParamType.String)
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color(0x3416202A),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                            child: Icon(
                              Icons.attach_money,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 28,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Text(
                              'Pagamentos',
                              style: FlutterFlowTheme.of(context).titleSmall,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 8, 0),
                                  child: Text(
                                    'inativo',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          fontSize: 12,
                                        ),
                                  ),
                                ),
                                badges.Badge(
                                  badgeContent: Text(
                                    '!',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                  ),
                                  showBadge: true,
                                  shape: badges.BadgeShape.circle,
                                  badgeColor:
                                      FlutterFlowTheme.of(context).error,
                                  elevation: 4,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 8, 8, 8),
                                  position: badges.BadgePosition.topEnd(),
                                  animationType:
                                      badges.BadgeAnimationType.scale,
                                  toAnimate: true,
                                  child: Align(
                                    alignment: AlignmentDirectional(0.9, 0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 8, 0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 18,
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
              )),
        ],
      ),
    );
  }

  EmptyListWidget buildEmptyColumn(BuildContext context) {
    if (!_model.customerIsResistered()) {
      return EmptyListWidget(
        buttonTitle: "Compartilhar",
        title: "Aluno não cadastrado",
        message:
            "\nO aluno ainda não se cadastrou no App Pump para receber os treinos.\n\nQuer compartilhar o convite?",
        onButtonPressed: () async {
          String text = 'https://pumpapp.com.br';
          String subject = 'Pump Training: Cadastre-se!';

          await Share.share('$subject\n$text');
        },
      );
    }
    if (_model.customerIsBlocked()) {
      return EmptyListWidget(
        buttonTitle: "Desbloquear",
        title: "Nenhum programa ativo",
        message:
            "Desbloqueie o aluno para adicionar um novo programa de treino.",
        buttonBorderColor: FlutterFlowTheme.of(context).error,
        onButtonPressed: () async {
          await changeCustomerStatus('unblocked', 'Treinos desbloqueados.');
        },
      );
    }

    if (_model.customerIsPending()) {
      return EmptyListWidget(
        buttonTitle: "Enviar novamente",
        title: "Pendente de aprovação",
        message: "O aluno ainda não aceitou seu convite.",
        onButtonPressed: () async {
          await _resendInvite();
        },
      );
    }

    if (_model.customerRejectedInvite()) {
      return EmptyListWidget(
        buttonTitle: "Enviar novamente",
        title: "Convite recusado",
        message: "O aluno recusou o seu convite. Deseja enviar novamente?",
        onButtonPressed: () async {
          await _resendInvite();
        },
      );
    }

    return EmptyListWidget(
      buttonTitle: "Adicionar",
      title: "Sem programa",
      message:
          "O aluno ainda não possui um programa de treino ativo.\nDeseja adicionar um programa?",
      onButtonPressed: () async {
        context.pushNamed('WorkoutSheetPickerWidget', queryParameters: {
          'customerId': serializeParam(widget.customerId, ParamType.String),
          'pickerEnabled': serializeParam(true, ParamType.bool),
          'showConfirmAlert':
              serializeParam(_model.hasActiveSheet(), ParamType.bool),
        }).then((value) => {
              if (value != null && value is bool && value)
                {
                  safeSetState(() {
                    _model.reloadBack = true;
                    apiLoaderController.reload?.call();
                  })
                }
            });
      },
    );
  }

  Future<void> _resendInvite() async {
    dynamic payload = {};
    payload['email'] = widget.email;
    final result = await BaseGroup.inviteCustomersCall.call(params: payload);

    if (result.succeeded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Convite enviado.',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).info,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
      context.pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ocorreu um erro inesperado. Por favor, tente novamente.',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).info,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  Stack buildContent(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 112, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.zero,
                          child: Stack(
                            children: <Widget>[
                              if (_model.content['userImageUrl'] != null &&
                                  _model.content['userImageUrl']!.isNotEmpty)
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          _model.content['userImageUrl']!),
                                ),
                              if (_model.content['userImageUrl'] == null ||
                                  _model.content['userImageUrl']!.isEmpty)
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground),
                                  child: Center(
                                    child: AutoSizeText(
                                      (_model.content['userName'] ??
                                              'Usuário')[0]
                                          .toUpperCase(),
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            8, _model.topSpacingName(), 16, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                _model.content['userName'],
                                textAlign: TextAlign.center,
                                style:
                                    FlutterFlowTheme.of(context).headlineSmall,
                                maxLines: 1,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 8, 8, 16),
                                      child: Wrap(
                                          spacing: 4.0,
                                          runSpacing: 4.0,
                                          children: _model.content != null &&
                                                  _model.content['userTags'] !=
                                                      null
                                              ? List.generate(
                                                  _model.tagsCount(), (index) {
                                                  if (_model
                                                          .customerIsBlocked() &&
                                                      index == 0) {
                                                    return TagComponentWidget(
                                                      title: 'Bloqueado',
                                                      tagColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      selected: true,
                                                    );
                                                  }
                                                  if (_model
                                                      .customerIsBlocked()) {
                                                    index = index - 1;
                                                  }
                                                  final tagId =
                                                      _model.content['userTags']
                                                          [index];
                                                  final TagModel element =
                                                      _model.tagModelWithId(
                                                          tagId);
                                                  return TagComponentWidget(
                                                    title: element.title,
                                                    tagColor: element.color,
                                                    selected:
                                                        element.isSelected,
                                                  );
                                                })
                                              : []),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Divider(
                  height: 24,
                  thickness: 1,
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
              Visibility(
                visible: _model.hasWorkoutDone(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: buildHeaderContent(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: _model.hasActiveSheet()
                    ? buildActiveSheetContent(context)
                    : buildEmptyColumn(context),
              ),
            ],
          ),
        ),
        Align(
          alignment: AlignmentDirectional(0, -0.87),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x520E151B),
                        offset: Offset(0, 2),
                      )
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 20,
                    borderWidth: 1,
                    buttonSize: 40,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20,
                    ),
                    onPressed: () async {
                      logFirebaseEvent(
                          'CUSTOMER_DETAILS_arrow_back_rounded_ICN_');
                      logFirebaseEvent('IconButton_navigate_back');
                      context.pop(_model.reloadBack);
                    },
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x520E151B),
                        offset: Offset(0, 2),
                      )
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 20,
                    borderWidth: 1,
                    buttonSize: 40,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    icon: Icon(
                      Icons.keyboard_control_sharp,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20,
                    ),
                    onPressed: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (bottomSheetContext) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context)
                                .requestFocus(_model.unfocusNode),
                            child: Padding(
                              padding:
                                  MediaQuery.of(bottomSheetContext).viewInsets,
                              child: ActionSheetButtonsWidget(
                                removeCustomer: () async {
                                  showAlignedDialog(
                                    context: context,
                                    isGlobal: true,
                                    avoidOverflow: false,
                                    targetAnchor: AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    followerAnchor: AlignmentDirectional(
                                            0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    builder: (dialogContext) {
                                      return Material(
                                        color: Colors.transparent,
                                        child: GestureDetector(
                                          onTap: () => FocusScope.of(context)
                                              .requestFocus(_model.unfocusNode),
                                          child: InformationDialogWidget(
                                            title: 'Atenção',
                                            message: _model.hasActiveSheet()
                                                ? 'O programa atual será encerrado. Tem certeza que deseja remover o aluno?'
                                                : 'Tem certeza que deseja remover o aluno?',
                                            actionButtonTitle: 'Remover',
                                          ),
                                        ),
                                      );
                                    },
                                  ).then(
                                    (value) async {
                                      if (value == 'leave') {
                                        final response = await BaseGroup
                                            .removeCustomerCall
                                            .call(params: {
                                          'email': widget.email
                                        });

                                        if (response.succeeded) {
                                          _model.reloadBack = true;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Aluno removido.',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                            ),
                                          );
                                          context.pop(true);
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Ooops'),
                                                content: Text(
                                                    'Ocorreu um erro inesperado. Por favor, tente novamente.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                  );
                                },
                                secondaryButtonTitle: _model.customerIsBlocked()
                                    ? 'Desbloquear Treinos'
                                    : 'Bloquear Treinos',
                                blockCustomer: () async {
                                  if (_model.customerIsBlocked()) {
                                    await changeCustomerStatus(
                                        'unblocked', 'Treinos desbloqueados.');
                                  } else {
                                    if (_model.hasActiveSheet()) {
                                      showAlignedDialog(
                                        context: context,
                                        isGlobal: true,
                                        avoidOverflow: false,
                                        targetAnchor:
                                            AlignmentDirectional(0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                        followerAnchor:
                                            AlignmentDirectional(0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                        builder: (dialogContext) {
                                          return Material(
                                            color: Colors.transparent,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _model.unfocusNode),
                                              child: InformationDialogWidget(
                                                title: 'Atenção',
                                                message:
                                                    'O programa atual será encerrado. Tem certeza que deseja bloquear os treinos do aluno?',
                                                actionButtonTitle: 'Encerrar',
                                              ),
                                            ),
                                          );
                                        },
                                      ).then(
                                        (value) async {
                                          if (value == 'leave') {
                                            await changeCustomerStatus(
                                                'blocked',
                                                'Treinos bloqueados.');
                                          }
                                        },
                                      );
                                    } else {
                                      await changeCustomerStatus(
                                          'blocked', 'Treinos bloqueados.');
                                    }
                                  }
                                },
                                editTags: () async {
                                  context.pushNamed(
                                    'AddCustomer',
                                    queryParameters: {
                                      'isEdit':
                                          serializeParam(true, ParamType.bool),
                                      'email': serializeParam(
                                          widget.email, ParamType.String),
                                      'selectedTags': serializeParam(
                                          _model.content['userTags'],
                                          ParamType.JSON,
                                          true)
                                    },
                                  ).then((value) => {
                                        if (value != null &&
                                            value is bool &&
                                            value)
                                          {
                                            safeSetState(() {
                                              _model.reloadBack = true;
                                              apiLoaderController.reload
                                                  ?.call();
                                            })
                                          }
                                      });
                                },
                              ),
                            ),
                          );
                        },
                      ).then((value) => setState(() => {}));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> changeCustomerStatus(
      String status, String successMessage) async {
    String trainingSheetId = '';
    if (status == 'blocked') {
      dynamic workoutSheet = _model.getActiveWorkoutSheet();
      if (workoutSheet != null) {
        trainingSheetId = workoutSheet['trainingSheetId'];
      }
    }

    final response = await BaseGroup.changeCustomerStatusCall.call(params: {
      'email': widget.email,
      'status': status,
      'trainingSheetId': trainingSheetId
    });

    if (response.succeeded) {
      _model.reloadBack = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            successMessage,
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
      safeSetState(() {
        apiLoaderController.reload?.call();
      });
    } else {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Ooops'),
            content:
                Text('Ocorreu um erro inesperado. Por favor, tente novamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }

  Column buildActiveSheetContent(BuildContext context) {
    dynamic workoutSheet = _model.getActiveWorkoutSheet();

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 0),
          child: GestureDetector(
            onTap: () async {
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
                  'isPersonal': serializeParam(
                    true,
                    ParamType.bool,
                  ),
                },
              );
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 250,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 500),
                      fadeOutDuration: Duration(milliseconds: 500),
                      imageUrl: workoutSheet['imageUrl'],
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * 1,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 422,
                    height: MediaQuery.sizeOf(context).height * 2.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0x34000000), Color(0x66000000)],
                        stops: [0, 1],
                        begin: AlignmentDirectional(0, -1),
                        end: AlignmentDirectional(0, 1),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional(0, 0),
                                  children: [
                                    CircularPercentIndicator(
                                      percent: _model.getWorkoutSheetPercent(),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      radius: 62,
                                      lineWidth: 20,
                                      animation: true,
                                      progressColor:
                                          FlutterFlowTheme.of(context).primary,
                                      backgroundColor: Color(0x4CFFFFFF),
                                    ).animateOnPageLoad(animationsMap[
                                        'progressBarOnPageLoadAnimation1']!),
                                    CircularPercentIndicator(
                                      percent: _model.getWorkoutWeekPercent(),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      radius: 40,
                                      lineWidth: 20,
                                      animation: true,
                                      progressColor:
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                      backgroundColor: Color(0x4CFFFFFF),
                                    ).animateOnPageLoad(animationsMap[
                                        'progressBarOnPageLoadAnimation2']!),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 24,
                            thickness: 1,
                            color: Colors.white,
                          ).animateOnPageLoad(
                              animationsMap['dividerOnPageLoadAnimation']!),
                          AutoSizeText(
                            workoutSheet['name'],
                            maxLines: 1,
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                          ).animateOnPageLoad(
                              animationsMap['textOnPageLoadAnimation7']!),
                          Text(
                            '${workoutSheet['weeksCount']} Semanas',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0x9AFFFFFF),
                                ),
                          ).animateOnPageLoad(
                              animationsMap['textOnPageLoadAnimation7']!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animateOnPageLoad(
                animationsMap['containerOnPageLoadAnimation13']!),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      await showWorkoutSheetPicker();
                    },
                    text: 'Novo Programa',
                    options: FFButtonOptions(
                      height: 44,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                      elevation: 3,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation13']!),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x1F000000),
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FlutterFlowTheme.of(context).primaryBackground,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 6),
                  child: Container(
                    width: double.infinity,
                    color: Color(0x00FFFFFF),
                    child: ExpandableNotifier(
                      initialExpanded: false,
                      child: ExpandablePanel(
                        header: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 8, 16, 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4, 12, 12, 12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Programa',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge,
                                          ).animateOnPageLoad(animationsMap[
                                              'textOnPageLoadAnimation9']!),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 4, 0, 0),
                                            child: Text(
                                              '${_model.content?['programProgress']}% do programa concluído',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                            ).animateOnPageLoad(animationsMap[
                                                'textOnPageLoadAnimation10']!),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Card(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 12, 12, 12),
                                          child: Icon(
                                            Icons.featured_play_list,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'containerOnPageLoadAnimation8']!),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: LinearPercentIndicator(
                                  percent: _model.getWorkoutSheetPercent(),
                                  lineHeight: 16,
                                  animation: true,
                                  progressColor:
                                      FlutterFlowTheme.of(context).primary,
                                  backgroundColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  barRadius: Radius.circular(24),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                        collapsed: Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 1,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                        ),
                        expanded: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(
                            _model.content?['activeSheet']['weeksCount'],
                            (weekIndex) {
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 1),
                                      child: Container(
                                        width: double.infinity,
                                        height: 70,
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16, 0, 16, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 24,
                                                child: Stack(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0, 0),
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 32, 0, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          VerticalDivider(
                                                            thickness: 2,
                                                            color: (_model.content?['activeSheet']
                                                                            [
                                                                            'weeksCount'] -
                                                                        1) ==
                                                                    weekIndex
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground
                                                                : _model.currentWeekIsLessThan(
                                                                        weekIndex)
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBackground
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, -1),
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Visibility(
                                                          visible: !_model
                                                                  .currentWeekIsLessThan(
                                                                      weekIndex) ||
                                                              _model
                                                                  .isCurrentWeek(
                                                                      weekIndex),
                                                          child: Icon(
                                                            Icons.check_circle,
                                                            color: _model
                                                                    .isCurrentWeek(
                                                                        weekIndex)
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            size: 24,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(16, 2, 16, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              'Semana ${weekIndex + 1}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              _model.isCurrentWeek(
                                                                      weekIndex)
                                                                  ? 'Em progresso'
                                                                  : !_model.currentWeekIsLessThan(
                                                                          weekIndex)
                                                                      ? 'Concluído'
                                                                      : '',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'containerOnPageLoadAnimation9']!),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        theme: ExpandableThemeData(
                          tapHeaderToExpand: true,
                          tapBodyToExpand: true,
                          tapBodyToCollapse: true,
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          hasIcon: false,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation13']!),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 50),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x1F000000),
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FlutterFlowTheme.of(context).primaryBackground,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: Color(0x00FFFFFF),
                  child: ExpandableNotifier(
                    initialExpanded: false,
                    child: ExpandablePanel(
                      header: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 8, 16, 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4, 12, 12, 12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Meta da Semana',
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge,
                                        ).animateOnPageLoad(animationsMap[
                                            'textOnPageLoadAnimation11']!),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 4, 0, 0),
                                          child: Text(
                                            '${_model.content?['weekProgress']}% concluído',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 12, 12, 12),
                                        child: Icon(
                                          Icons.show_chart_outlined,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation13']!),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              child: LinearPercentIndicator(
                                percent: _model.getWorkoutWeekPercent(),
                                lineHeight: 16,
                                animation: true,
                                progressColor:
                                    FlutterFlowTheme.of(context).secondary,
                                backgroundColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                barRadius: Radius.circular(24),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                      collapsed: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 1,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                      ),
                      expanded: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(
                              _model
                                  .content?['activeSheet']['currentWeek']
                                      ['workouts']
                                  .length, (index) {
                            String workoutId = _model.content?['activeSheet']
                                ['currentWeek']['workouts'][index];
                            dynamic workout = _model.filterById(workoutId);
                            return GestureDetector(
                              onTap: () async {
                                await context.pushNamed(
                                  'WorkoutDetails',
                                  queryParameters: {
                                    'workoutId': serializeParam(
                                      workoutId,
                                      ParamType.String,
                                    ),
                                    'isPersonal': serializeParam(
                                      true,
                                      ParamType.bool,
                                    ),
                                  },
                                );
                              },
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 16, 0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 113,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4,
                                                color: Color(0x32000000),
                                                offset: Offset(0, 2),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(12, 0, 0, 0),
                                                child: Container(
                                                  width: 90,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: Container(
                                                    width: 90,
                                                    height: 90,
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            fadeOutDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            imageUrl: workout[
                                                                'imageUrl'],
                                                            width: 90,
                                                            height: 90,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 90,
                                                          height: 90,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0x801A1F24),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: _model
                                                                  .workoutIsCompleted(
                                                                      workoutId)
                                                              ? Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Icon(
                                                                            Icons.check_circle,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondary,
                                                                            size:
                                                                                32,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              : Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          '${workout['workoutTime']}',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .override(
                                                                                fontFamily: 'Outfit',
                                                                                color: Colors.white,
                                                                                lineHeight: 1,
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'min',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .override(
                                                                                fontFamily: 'Readex Pro',
                                                                                lineHeight: 1,
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(12, 12, 12, 12),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  AutoSizeText(
                                                                workout[
                                                                    'workoutName'],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          4,
                                                                          0,
                                                                          0),
                                                              child:
                                                                  AutoSizeText(
                                                                _model.mapSkillLevel(
                                                                    workout[
                                                                        'level']),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color: _model
                                                                          .mapSkillLevelBorderColor(
                                                                              workout['level']),
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 4, 0, 6),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            4,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    AutoSizeText(
                                                                  _model.formatArrayToString(
                                                                      workout[
                                                                          'muscleImpact']),
                                                                  maxLines: 1,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Readex Pro',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
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
                                            ],
                                          ),
                                        ).animateOnPageLoad(animationsMap[
                                            'containerOnPageLoadAnimation13']!),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      theme: ExpandableThemeData(
                        tapHeaderToExpand: true,
                        tapBodyToExpand: true,
                        tapBodyToCollapse: true,
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        hasIcon: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation7']!),
        ),
      ],
    );
  }

  Future showWorkoutSheetPicker() async {
    await context.pushNamed(
      'WorkoutSheetPickerWidget',
      queryParameters: {
        'customerId': serializeParam(
          widget.customerId,
          ParamType.String,
        ),
        'showConfirmAlert':
            serializeParam(_model.hasActiveSheet(), ParamType.bool),
      },
    ).then((value) => {
          if (value != null && value is bool && value)
            {
              safeSetState(() {
                apiLoaderController.reload?.call();
              })
            }
        });
  }
}
