import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:go_router/go_router.dart';
import 'package:pump/pages/personal_profile/profile14_other_user_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:pump/pages/personal_profile/profile14_other_user_model.dart';
import 'package:pump_components/components/review_bottom_sheet/review_bottom_sheet_widget.dart';
import 'package:pump_components/components/review_card/review_card_widget.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import '../../backend/firebase_analytics/analytics.dart';

class Profile14OtherUserWidget extends StatefulWidget {
  const Profile14OtherUserWidget({Key? key, this.forwardUri}) : super(key: key);

  final String? forwardUri;

  @override
  State<Profile14OtherUserWidget> createState() =>
      _Profile14OtherUserWidgetState();
}

class _Profile14OtherUserWidgetState extends State<Profile14OtherUserWidget>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool isError = false;
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String forwardUri = "";
  late Profile14OtherUserModel _model;
  late ApiCallResponse responseContent;

  Future<ApiCallResponse>? _loadContent() async {
    if (_model.content != null) {
      return responseContent;
    }
    isLoading = true;
    isError = false;

    responseContent =
        await PumpGroup.personalDetailsCall.call(forwardUri: forwardUri);

    if (responseContent.succeeded) {
      isLoading = false;
      isError = false;
    } else {
      isLoading = false;
      isError = true;
    }
    return responseContent;
  }

  final animationsMap = {
    'textOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
      ],
    ),
    'textOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
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
          begin: 0,
          end: 1,
        ),
      ],
    ),
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(50, 0),
          end: Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(50, 0),
          end: Offset(0, 0),
        ),
      ],
    ),
  };

  Color _appBarBackgroundColor = Colors.black;
  final ScrollController _scrollController = ScrollController();
  double leftPadding = 16.0;
  Color _titleColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Profile14OtherUserModel());

    forwardUri = widget.forwardUri ?? '';

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'PersonalProfile'});

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
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
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
        Container(
          padding: EdgeInsets.all(8.0),
          child: FlutterFlowIconButton(
            borderColor: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: 20.0,
            borderWidth: 1.0,
            buttonSize: 40.0,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            icon: Icon(
              Icons.ios_share_sharp,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 20.0,
            ),
            onPressed: () async {
              String text = 'https://pumpapp.com.br';
              String subject = 'Pump Training: Cadastre-se!';

              await Share.share('$subject\n$text');
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.fromLTRB(leftPadding, 16, leftPadding, 16),
        title: AutoSizeText(
          (_model.content != null && _model.content['personal']['name'] != null)
              ? _model.content['personal']['name']
              : '',
          maxLines: 2,
          style: FlutterFlowTheme.of(context)
              .titleLarge
              .override(fontFamily: 'Readex Pro', color: _titleColor),
        ),
        centerTitle: false,
        background: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: (_model.content != null &&
                  _model.content['personal']['imageUrl'] != null)
              ? CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 500),
                  fadeOutDuration: Duration(milliseconds: 500),
                  imageUrl: _model.content['personal']['imageUrl'],
                  fit: BoxFit.cover,
                )
              : null,
        ),
      ),
      centerTitle: false,
      elevation: 1,
    );
  }

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
                        child: CircularProgressIndicator(strokeWidth: 1.0,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  ));
            }

            if (isError) {
              return buildErrorColumn(context);
            }

            _model.content = snapshot.data?.jsonBody;

            return Stack(
              children: [
                _buildContent(context),
                Visibility(
                    visible: (_model.content != null &&
                        _model.content['personal']['phone'] != null),
                    child: BottomButtonFixedWidget(
                      buttonTitle: 'Solicitar Consultoria',
                      icon: FaIcon(
                        FontAwesomeIcons.whatsapp,
                      ),
                      onPressed: () async {
                        var contact = '+${_model.content['personal']['phone']}';
                        var androidUrl =
                            "whatsapp://send?phone=$contact&text=Olá, encontrei seu perfil no Pump App e gostaria de mais informações sobre os seus serviços.";
                        var iosUrl =
                            "https://wa.me/$contact?text=${Uri.parse('Olá, encontrei seu perfil no Pump App e gostaria de mais informações sobre os seus serviços.')}";

                        try {
                          if (Platform.isIOS) {
                            launchURL(iosUrl);
                          } else {
                            launchURL(androidUrl);
                          }
                        } on Exception {
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
                    ))
              ],
            );
          }),
    );
  }

  Center buildEmptyRatingColumn(BuildContext context) {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 32, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 50,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ainda não há avaliações',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Seja o primeiro a deixar uma avaliação!',
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
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
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                    child: FFButtonWidget(
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: ReviewBottomSheetWidget(
                                personalId: _model.content != null
                                    ? _model.content['personal']['personalId']
                                    : null,
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {
                              if (value == true) {
                                _model.content = null;
                                _loadContent();
                              }
                            }));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 16.0,
                      ),
                      text: 'Avaliar',
                      options: FFButtonOptions(
                        height: 40,
                        width: 120,
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Lexend Deca',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                        elevation: 2,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
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

  CustomScrollView _buildContent(BuildContext context) {
    return CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        slivers: [
          buildAppBar(context),
          SliverList(
              delegate: SliverChildListDelegate([
            Visibility(
              visible: !_model.isPumpProfile(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 16, 12, 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                                child: Text(
                                  _model.content['customerCount'] == null
                                      ? '0'
                                      : '${_model.content['customerCount']}',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineLarge,
                                ),
                              ),
                              Text(
                                (_model.content['customerCount'] != null &&
                                        _model.content['customerCount'] == 1)
                                    ? 'Aluno'
                                    : 'Alunos',
                                style: FlutterFlowTheme.of(context).labelMedium,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: VerticalDivider(
                            thickness: 1,
                            color: FlutterFlowTheme.of(context).accent4,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                                child: Text(
                                  _model.content['averageRating'] == null
                                      ? '-'
                                      : _model.content['averageRating'],
                                  style: FlutterFlowTheme.of(context)
                                      .headlineLarge,
                                ),
                              ),
                              Text(
                                'Nota',
                                style: FlutterFlowTheme.of(context).labelMedium,
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  0, _model.isPumpProfile() ? 32 : 0, 0, 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                    child: Text(
                      'Sobre',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.normal,
                          ),
                    ).animateOnPageLoad(
                        animationsMap['textOnPageLoadAnimation1']!),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: Text(
                      (_model.content != null &&
                              _model.content['personal']['description'] != null)
                          ? _model.content['personal']['description']
                          : '',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 14,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
              child: Divider(
                height: 2,
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
            Visibility(
              visible: !_model.isPumpProfile(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                      child: Text(
                        'Avaliações',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.normal,
                            ),
                      ).animateOnPageLoad(
                          animationsMap['textOnPageLoadAnimation2']!),
                    ),
                    Visibility(
                        visible: _model.showRating(),
                        child: InkWell(
                          onTap: () {
                            context.pushNamed('ReviewScreen', queryParameters: {
                              'personalId': serializeParam(
                                  _model.content['personal']['personalId'],
                                  ParamType.String)
                            }).then((value) => safeSetState(() {
                                  _model.content = null;
                                  _loadContent();
                                }));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                                child: Text(
                                  'Ver todas',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 14,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            _model.isPumpProfile()
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
                                        0.0,
                                        0.0,
                                        0.0,
                                        _model.content['feedbacks'].length > 1
                                            ? 40.0
                                            : 0),
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
                                          name:
                                              _model.getFeedbackName(feedback),
                                          feedback: feedback['feedbackText'],
                                          imageUrl: feedback['imageUrl'],
                                          rating: feedback['rating'],
                                        );
                                      }),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _model.content['feedbacks'] !=
                                            null &&
                                        _model.content['feedbacks'].length > 1,
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional(0.00, 1.00),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 16.0),
                                        child: smooth_page_indicator
                                            .SmoothPageIndicator(
                                          controller: _model
                                                  .pageViewController ??=
                                              PageController(initialPage: 0),
                                          count: _model
                                              .content['feedbacks'].length,
                                          axisDirection: Axis.horizontal,
                                          onDotClicked: (i) async {
                                            await _model.pageViewController!
                                                .animateToPage(
                                              i,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.ease,
                                            );
                                          },
                                          effect: smooth_page_indicator
                                              .ExpandingDotsEffect(
                                            expansionFactor: 3.0,
                                            spacing: 8.0,
                                            radius: 16.0,
                                            dotWidth: 16.0,
                                            dotHeight: 8.0,
                                            dotColor:
                                                FlutterFlowTheme.of(context)
                                                    .accent2,
                                            activeDotColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  12, 12, 12, _model.canShowWorkoutSheets() ? 0 : 130),
              child: Divider(
                height: 2,
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
            Visibility(
              visible: _model.canShowWorkoutSheets(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                      child: Text(
                        'Programas de treino',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.normal,
                            ),
                      ).animateOnPageLoad(
                          animationsMap['textOnPageLoadAnimation3']!),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _model.canShowWorkoutSheets(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 130),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.29,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        _model.content['workoutSheets'].length, (index) {
                      final workout = _model.content['workoutSheets'][index];
                      return InkWell(
                        onTap: () async {
                          await context.pushNamed(
                            'WorkoutSheetDetails',
                            queryParameters: {
                              'workoutId': serializeParam(
                                workout['workoutId'],
                                ParamType.String,
                              ),
                              'showStartButton': serializeParam(
                                workout['status'] != 'active',
                                ParamType.bool,
                              ),
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              index == 0 ? 16 : 0, 0, 16, 16),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x520E151B),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height * 1,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0x33000000),
                                    offset: Offset(0, 2),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: workout['imageUrl'],
                                      width: MediaQuery.sizeOf(context).width,
                                      height:
                                          MediaQuery.sizeOf(context).height * 1,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    height:
                                        MediaQuery.sizeOf(context).height * 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0x4C000000),
                                          Color(0xAF000000)
                                        ],
                                        stops: [0, 1],
                                        begin: AlignmentDirectional(0, -1),
                                        end: AlignmentDirectional(0, 1),
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(-1, 1),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Visibility(
                                                visible:
                                                    workout['amount'] != null,
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1, 1),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                16, 0, 16, 16),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        IntrinsicWidth(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0x801AD155),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  blurRadius: 4,
                                                                  color: Color(
                                                                      0x33000000),
                                                                  offset:
                                                                      Offset(
                                                                          0, 2),
                                                                )
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      workout['amount'] != null && workout['amount'].toString().isNotEmpty
                                                                          ? NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(double.parse(workout['amount'].toString()).isNegative
                                                                              ? double.parse(workout['amount'].toString()) * -1
                                                                              : double.parse(workout['amount'].toString()))
                                                                          : "",
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).info,
                                                                          ),
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
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1, 1),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(16, 0,
                                                                    16, 6),
                                                        child: AutoSizeText(
                                                          workout['title'],
                                                          maxLines: 2,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .info),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Align(
                                                alignment:
                                                    AlignmentDirectional(-1, 0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(16, 0, 0, 16),
                                                  child: Text(
                                                    _model.getSubtitle(workout),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ]))
        ]);
  }
}
