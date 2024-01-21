import 'dart:io';

import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/common/user_settings.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/subscribe_screen/subscribe_screen_widget.dart';
import 'workout_sheet_details_model.dart';
export 'workout_sheet_details_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class WorkoutSheetDetailsWidget extends StatefulWidget {
  const WorkoutSheetDetailsWidget(
      {Key? key,
      this.workoutId,
      this.showStartButton,
      this.isPersonal,
      this.canDuplicate})
      : super(key: key);

  final String? workoutId;
  final bool? showStartButton;
  final bool? isPersonal;
  final bool? canDuplicate;

  @override
  _WorkoutSheetDetailsWidgetState createState() =>
      _WorkoutSheetDetailsWidgetState();
}

class _WorkoutSheetDetailsWidgetState extends State<WorkoutSheetDetailsWidget>
    with TickerProviderStateMixin {
  late WorkoutSheetDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isError = false;
  String workoutId = '';
  String userId = currentUserUid;
  late ApiCallResponse responseContent;
  bool showStartButton = true;

  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, -250.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'textOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(-10.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'textOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 50.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 50.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 50.ms,
          duration: 600.ms,
          begin: Offset(-20.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 30.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 30.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'textOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'containerOnPageLoadAnimation4': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'containerOnPageLoadAnimation5': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 90.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  final ScrollController _scrollController = ScrollController();
  double leftPadding = 16.0;
  Color _appBarBackgroundColor = Colors.black;
  Color _titleColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutSheetDetailsModel());

    workoutId = widget.workoutId ?? '';
    showStartButton = widget.showStartButton ?? true;
    _model.isPersonal = widget.isPersonal ?? false;

    if (Platform.isAndroid) {
      leftPadding = 50.0;
    } else {
      _scrollController.addListener(() {
        double old = leftPadding;
        if (_scrollController.offset < kToolbarHeight) {
          leftPadding = 16.0;
          _titleColor = FlutterFlowTheme.of(context).info;
        } else {
          leftPadding = 66.0;
          _titleColor = FlutterFlowTheme.of(context).primaryText;
        }

        if (old != leftPadding) {
          safeSetState(() {});
        }
      });
    }

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<ApiCallResponse>? _loadContent() async {
    if (_model.content != null) {
      return responseContent;
    }

    isLoading = true;
    isError = false;

    if (workoutId.isEmpty) {
      return ApiCallResponse([], new Map<String, String>(), 0);
    }

    responseContent = await PumpGroup.workoutSheetDetailsCall(
        workoutId: workoutId, userId: userId);

    if (responseContent.succeeded) {
      isLoading = false;
      isError = false;
      _model.content = responseContent.jsonBody;

      setState(() {});
    } else {
      isLoading = false;
      isError = true;
    }
    return responseContent;
  }

  Future<void> initPaymentSheet(double amount, String personalId) async {
    try {
      // 1. create payment intent on the server
      final response = await PumpGroup.paymentSheetCall(
          amount: amount,
          personalId: personalId,
          userId: userId,
          trainingSheetId: workoutId);

      dynamic data = response.jsonBody;

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Pump Training',
          paymentIntentClientSecret: data['paymentIntent'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          // Extra options
          style: ThemeMode.dark,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              // background: Colors.lightBlue,
              primary: FlutterFlowTheme.of(context).primary,
              // componentBorder: Colors.red,
            ),
            shapes: PaymentSheetShape(
              borderWidth: 4,
              shadow: PaymentSheetShadowParams(color: Colors.red),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              // shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Color.fromARGB(255, 231, 235, 30),
                  text: Color.fromARGB(255, 235, 92, 30),
                  border: Color.fromARGB(255, 235, 92, 30),
                ),
              ),
            ),
          ),
        ),
      );

      displayPaymentSheet();
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        final response = await PumpGroup.userStartedWorkoutSheetCall(
            params: {'trainingSheetId': workoutId});

        if (response.succeeded) {
          context.go('/home');
        } else {
          setState(() {
            isLoading = false;
            isError = true;
          });
        }
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Falha no pagamento. Por favor, tente novamente.')),
      );
    } catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _appBarBackgroundColor = FlutterFlowTheme.of(context).secondaryBackground;
    return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: FutureBuilder(
            future: _loadContent(),
            builder: (context, snapshot) {
              if (isLoading) {
                return NestedScrollView(
                    headerSliverBuilder: (context, _) => [buildAppBar(context)],
                    body: Scaffold(
                      backgroundColor:
                          FlutterFlowTheme.of(context).primaryBackground,
                      body: Center(
                        child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    ));
              }

              if (isError) {
                return buildErrorColumn(context);
              }

              return Stack(
                children: [
                  buildContent(context),
                  _model.isPersonal
                      ? Container()
                      : BottomButtonFixedWidget(
                          onPressed: () async {
                            HapticFeedback.mediumImpact();

                            final amount = _model.content?['amount'];
                            if (amount != null) {
                              await initPaymentSheet(
                                  amount, _model.content?['personalId']);
                            } else {
                              final response =
                                  await PumpGroup.userStartedWorkoutSheetCall(
                                      params: {'trainingSheetId': workoutId});

                              if (response.succeeded) {
                                context.go('/home');
                              } else {
                                setState(() {
                                  isLoading = false;
                                  isError = true;
                                });
                              }
                            }
                          },
                          buttonTitle: (_model.content?['amount'] != null)
                              ? 'Por apenas ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(_model.content?['amount'])}'
                              : 'Começar',
                        )
                ],
              );
            }));
  }

  SliverAppBar buildAppBar(BuildContext context) {
    if (_scrollController.hasClients &&
        _scrollController.offset < kToolbarHeight) {
      _appBarBackgroundColor = FlutterFlowTheme.of(context).secondaryBackground;
    } else {
      _appBarBackgroundColor = FlutterFlowTheme.of(context).primaryBackground;
    }
    return SliverAppBar(
      leading: Container(
        padding: EdgeInsets.all(8.0),
        child: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 20.0,
          fillColor: Platform.isAndroid
              ? FlutterFlowTheme.of(context).secondaryBackground
              : FlutterFlowTheme.of(context).primaryBackground,
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 20.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
      ),
      expandedHeight: MediaQuery.sizeOf(context).height * 0.25,
      pinned: true,
      floating: false,
      snap: false,
      stretch: true,
      backgroundColor: isLoading
          ? FlutterFlowTheme.of(context).secondaryBackground
          : _appBarBackgroundColor,
      automaticallyImplyLeading: true,
      actions: [
        Visibility(
          visible: _model.isPersonal,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              icon: Icon(
                Icons.keyboard_control_sharp,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 20.0,
              ),
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  builder: (BuildContext context) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.copy),
                            title: Text('Editar'),
                            onTap: () async {
                              Navigator.pop(context);

                              if (!UserSettings().isSubscriber() &&
                                  !UserSettings().canAddWorkoutSheet()) {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                .viewInsets
                                                .top),
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: SubscribeScreenWidget(),
                                      );
                                    }).then((value) => {
                                      if (value != null && value)
                                        {context.pushNamed('Home')}
                                    });
                                return;
                              }
                              await context.pushNamed(
                                'AddWorkoutSheet',
                                queryParameters: {
                                  'workoutId': serializeParam(
                                    workoutId,
                                    ParamType.String,
                                  ),
                                  'isUpdate':
                                      serializeParam(true, ParamType.bool),
                                },
                              ).then((value) => {
                                    if (value != null && value is bool && value)
                                      {
                                        safeSetState(() {
                                          _model.content = null;
                                          _loadContent();
                                        })
                                      }
                                  });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.cancel),
                            title: Text('Cancelar'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.fromLTRB(leftPadding, 16, leftPadding, 16),
        title: AutoSizeText(
          (_model.content != null && _model.content['workoutName'] != null)
              ? _model.content['workoutName']
              : '',
          style: FlutterFlowTheme.of(context).titleLarge.override(
                fontFamily: 'Readex Pro',
                color: _titleColor,
              ),
        ),
        centerTitle: false,
        background: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: (_model.content != null && _model.content['imageUrl'] != null)
              ? CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 500),
                  fadeOutDuration: Duration(milliseconds: 500),
                  imageUrl: _model.content['imageUrl'],
                  fit: BoxFit.cover,
                )
              : null,
        ),
      ),
      centerTitle: false,
      elevation: 1,
    );
  }

  CustomScrollView buildContent(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: [
        buildAppBar(context),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 0.0, 0.0),
                child: Text(
                  'Sobre',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.normal,
                      ),
                ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation1']!),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    0, 0, 0, _model.isPersonal ? 32 : 100),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: _model.content['sections'][0]['description'] !=
                              null &&
                          !_model.content['sections'][0]['description'].isEmpty,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 12.0, 16.0, 12.0),
                        child: Text(
                          _model.content['sections'][0]['description'] ?? '',
                          style: FlutterFlowTheme.of(context).labelMedium,
                        ).animateOnPageLoad(
                            animationsMap['textOnPageLoadAnimation2']!),
                      ),
                    ),
                    Visibility(
                      visible: !_model.isPersonal,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 20.0, 16.0, 2.0),
                        child: GestureDetector(
                          onTap: () {
                            // HapticFeedback.mediumImpact();
                            // context.pushNamed(
                            //   'PersonalProfile',
                            //   queryParameters: {
                            //     'forwardUri': serializeParam(
                            //       'personal/details?personalId=${_model.content['personalId']}&userId=${userId}',
                            //       ParamType.String,
                            //     ),
                            //     'userId': serializeParam(
                            //       userId,
                            //       ParamType.String,
                            //     ),
                            //   }.withoutNulls,
                            //   extra: <String, dynamic>{
                            //     kTransitionInfoKey: TransitionInfo(
                            //       hasTransition: true,
                            //       transitionType:
                            //           PageTransitionType.bottomToTop,
                            //     ),
                            //   },
                            // );
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x33000000),
                                  offset: Offset(0.0, 2.0),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 0.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        // HapticFeedback.mediumImpact();
                                        // context.pushNamed(
                                        //   'PersonalProfile',
                                        //   queryParameters: {
                                        //     'forwardUri': serializeParam(
                                        //       'personal/details?personalId=${_model.content['personalId']}&userId=${userId}',
                                        //       ParamType.String,
                                        //     ),
                                        //     'userId': serializeParam(
                                        //       userId,
                                        //       ParamType.String,
                                        //     ),
                                        //   }.withoutNulls,
                                        //   extra: <String, dynamic>{
                                        //     kTransitionInfoKey:
                                        //         TransitionInfo(
                                        //       hasTransition: true,
                                        //       transitionType:
                                        //           PageTransitionType
                                        //               .bottomToTop,
                                        //     ),
                                        //   },
                                        // );
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          // HapticFeedback.mediumImpact();
                                          // context.pushNamed(
                                          //   'PersonalProfile',
                                          //   queryParameters: {
                                          //     'forwardUri': serializeParam(
                                          //       'personal/details?personalId=${_model.content['personalId']}&userId=${userId}',
                                          //       ParamType.String,
                                          //     ),
                                          //     'userId': serializeParam(
                                          //       userId,
                                          //       ParamType.String,
                                          //     ),
                                          //   }.withoutNulls,
                                          //   extra: <String, dynamic>{
                                          //     kTransitionInfoKey:
                                          //         TransitionInfo(
                                          //       hasTransition: true,
                                          //       transitionType:
                                          //           PageTransitionType
                                          //               .bottomToTop,
                                          //     ),
                                          //   },
                                          // );
                                        },
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Color(0x4CFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x33000000),
                                                offset: Offset(0.0, 2.0),
                                              )
                                            ],
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                          ),
                                          child: Container(
                                            width: 40.0,
                                            height: 40.0,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: CachedNetworkImage(
                                              fadeInDuration:
                                                  Duration(milliseconds: 500),
                                              fadeOutDuration:
                                                  Duration(milliseconds: 500),
                                              imageUrl: _model
                                                  .content['personalImageUrl'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 16.0, 8.0, 8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Criado por',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Readex Pro',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _model.content['personalName'],
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsetsDirectional.fromSTEB(
                                //       0.0, 0.0, 16.0, 0.0),
                                //   child: FlutterFlowIconButton(
                                //     borderColor: Colors.transparent,
                                //     borderRadius: 30.0,
                                //     borderWidth: 1.0,
                                //     buttonSize: 40.0,
                                //     fillColor: FlutterFlowTheme.of(context)
                                //         .primaryBackground,
                                //     icon: Icon(
                                //       Icons.arrow_forward,
                                //       color: FlutterFlowTheme.of(context)
                                //           .primaryText,
                                //       size: 20.0,
                                //     ),
                                //     onPressed: () async {
                                //       // HapticFeedback.mediumImpact();
                                //       // context.pushNamed(
                                //       //   'PersonalProfile',
                                //       //   queryParameters: {
                                //       //     'forwardUri': serializeParam(
                                //       //       'personal/details?personalId=${_model.content['personalId']}&userId=${userId}',
                                //       //       ParamType.String,
                                //       //     ),
                                //       //     'userId': serializeParam(
                                //       //       userId,
                                //       //       ParamType.String,
                                //       //     ),
                                //       //   }.withoutNulls,
                                //       //   extra: <String, dynamic>{
                                //       //     kTransitionInfoKey: TransitionInfo(
                                //       //       hasTransition: true,
                                //       //       transitionType: PageTransitionType
                                //       //           .bottomToTop,
                                //       //     ),
                                //       //   },
                                //       // );
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation2']!),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 750.0,
                                      ),
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
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 16.0, 4.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Icon(
                                                      Icons.timer_sharp,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        '${_model.content['sections'][0]['array'][1]['title']}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsetsDirectional
                                            //       .fromSTEB(
                                            //           0.0, 0.0, 0.0, 12.0),
                                            //   child: Row(
                                            //     mainAxisSize:
                                            //         MainAxisSize.max,
                                            //     children: [
                                            //       Container(
                                            //         width: 40.0,
                                            //         height: 40.0,
                                            //         decoration:
                                            //             BoxDecoration(
                                            //           color: FlutterFlowTheme
                                            //                   .of(context)
                                            //               .primaryBackground,
                                            //           borderRadius:
                                            //               BorderRadius
                                            //                   .circular(
                                            //                       8.0),
                                            //         ),
                                            //         child: Icon(
                                            //           Icons.bar_chart,
                                            //           color: FlutterFlowTheme
                                            //                   .of(context)
                                            //               .primaryText,
                                            //           size: 20.0,
                                            //         ),
                                            //       ),
                                            //       Expanded(
                                            //         child: Padding(
                                            //           padding:
                                            //               EdgeInsetsDirectional
                                            //                   .fromSTEB(
                                            //                       12.0,
                                            //                       0.0,
                                            //                       0.0,
                                            //                       0.0),
                                            //           child: Text(
                                            //             _model.mapSkillLevel(
                                            //                 _model.content[
                                            //                     'level']),
                                            //             style: FlutterFlowTheme
                                            //                     .of(context)
                                            //                 .labelLarge
                                            //                 .override(
                                            //                   fontFamily:
                                            //                       'Readex Pro',
                                            //                   color: FlutterFlowTheme.of(
                                            //                           context)
                                            //                       .primaryText,
                                            //                 ),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Icon(
                                                      Icons.calendar_month,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        '${_model.content['sections'][0]['array'][0]['title']}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Icon(
                                                      Icons.fitness_center,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        '${_model.content['sections'][0]['array'][2]['title']}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
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
                          ],
                        ),
                      ),
                    ).animateOnPageLoad(
                        animationsMap['containerOnPageLoadAnimation3']!),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 0.0, 6.0),
                            child: Text(
                              '${_model.content['sections'][2]['array'].length} Treinos',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.normal,
                                  ),
                            ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation3']!),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                            child: Builder(
                              builder: (context) {
                                final workoutList =
                                    _model.content['sections'][2]['array'];
                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(workoutList.length,
                                      (workoutIndex) {
                                    final workout = workoutList[workoutIndex];
                                    return GestureDetector(
                                      onTap: () async {
                                        final amount =
                                            _model.content?['amount'];

                                        if (amount == null ||
                                            _model.isPersonal) {
                                          await context.pushNamed(
                                            'WorkoutDetails',
                                            queryParameters: {
                                              'workoutId': serializeParam(
                                                workout['workoutId'],
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
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 12.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 113.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 4.0,
                                                      color: Color(0x32000000),
                                                      offset: Offset(0.0, 2.0),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Container(
                                                        width: 90.0,
                                                        height: 90.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Container(
                                                          width: 90.0,
                                                          height: 90.0,
                                                          child: Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
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
                                                                  imageUrl:
                                                                      workout['imageUrl'] ??
                                                                          '',
                                                                  width: 90.0,
                                                                  height: 90.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 90.0,
                                                                height: 90.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0x331A1F24),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                child: Column(
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
                                                                                color: FlutterFlowTheme.of(context).info,
                                                                                lineHeight: 1.0,
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
                                                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                              fontFamily: 'Readex Pro',
                                                                              lineHeight: 1.0,
                                                                              color: Colors.white),
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
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    12.0,
                                                                    12.0,
                                                                    12.0,
                                                                    12.0),
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
                                                                    MainAxisSize
                                                                        .max,
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
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
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
                                                                            color:
                                                                                _model.mapSkillLevelBorderColor(workout['level']),
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
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          6.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          AutoSizeText(
                                                                        _model.formatArrayToString(
                                                                            workout['muscleImpact']),
                                                                        maxLines:
                                                                            2,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .override(
                                                                              fontFamily: 'Readex Pro',
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
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
                                                  'containerOnPageLoadAnimation2']!),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
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
            ],
          ),
        ),
      ],
    );
  }

  NestedScrollView buildErrorColumn(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [buildAppBar(context)],
      body: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 1),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 90,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ooops!',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                      fontFamily: 'Outfit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Não foi possível carregar as informações.\nPor favor, tente novamente.',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 28, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _loadContent();
                            });
                          },
                          text: 'Tentar novamente',
                          options: FFButtonOptions(
                            width: 170,
                            height: 50,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Lexend Deca',
                                  color: FlutterFlowTheme.of(context).info,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                            elevation: 2,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
