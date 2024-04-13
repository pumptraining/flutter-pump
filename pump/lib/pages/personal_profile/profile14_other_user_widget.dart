import 'dart:io';

import 'package:api_manager/common/loader_state.dart';
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
import 'package:pump/pages/sheets_list/sheets_list_widget.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:pump_components/components/header_component/header_component_widget.dart';
import 'package:pump_components/components/horizontal_workout_sheet_list_component/horizontal_workout_sheet_list_component_widget.dart';
import 'package:pump_components/components/pump_app_bar/sliver_pump_app_bar.dart';
export 'package:pump/pages/personal_profile/profile14_other_user_model.dart';
import 'package:pump_components/components/review_bottom_sheet/review_bottom_sheet_widget.dart';
import 'package:pump_components/components/review_card/review_card_widget.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/two_count_component/two_count_component_widget.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String forwardUri = "";
  late Profile14OtherUserModel _model;

  final ScrollController _scrollController = ScrollController();
  ApiLoaderController _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Profile14OtherUserModel());

    forwardUri = widget.forwardUri ?? '';

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'PersonalProfile'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  SliverPumpAppBar buildAppBar(BuildContext context) {
    return SliverPumpAppBar(
      title:
          (_model.content != null && _model.content['personal']['name'] != null)
              ? _model.content['personal']['name']
              : '',
      imageUrl: (_model.content != null &&
              _model.content['personal']['imageUrl'] != null)
          ? _model.content['personal']['imageUrl']
          : '',
      scrollController: _scrollController,
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
              String text = 'https://https://pump-personal-trainer.webflow.io/';
              String subject = 'Pump Training: Cadastre-se!';

              await Share.share('$subject\n$text');
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: ApiLoaderWidget(
          apiCall: PumpGroup.personalDetailsCall,
          params: {'forwardUri': forwardUri},
          controller: _apiLoaderController,
          builder: (context, snapshot) {
            _model.content = snapshot?.data?.jsonBody;

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

  Widget _buildRateSection() {
    return Column(
      children: [
        HeaderComponentWidget(
          title: 'Avaliações',
          buttonTitle: 'todas',
          showButton: _model.showRating(),
          onTap: () {
            context.pushNamed('ReviewScreen', queryParameters: {
              'personalId': serializeParam(
                  _model.content['personal']['personalId'], ParamType.String)
            }).then((value) => safeSetState(() {
                  _model.content = null;
                  _apiLoaderController.reload?.call();
                }));
          },
        ),
        _model.showRating()
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
                                  _model.content['feedbacks'].length, (index) {
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
                                child:
                                    smooth_page_indicator.SmoothPageIndicator(
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
                                  effect:
                                      smooth_page_indicator.ExpandingDotsEffect(
                                    expansionFactor: 3.0,
                                    spacing: 8.0,
                                    radius: 16.0,
                                    dotWidth: 8.0,
                                    dotHeight: 8.0,
                                    dotColor: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    activeDotColor: FlutterFlowTheme.of(context)
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

  void _pushSheetList(Requestable apiCall) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SheetsListWidget(
          apiCall: apiCall,
          showStatus: false,
        ),
      ),
    );
  }

  Widget _buildWorkoutSheetSection() {
    return Column(children: [
      HeaderComponentWidget(
        title: 'Programas de Treino',
      ),
      HorizontalWorkoutSheetListComponentWidget(
        dtoList: _model.getWorkoutSheetListDTO(),
        onTap: (p0) {
          context.pushNamed(
            'WorkoutSheetDetails',
            queryParameters: {
              'workoutId': serializeParam(
                p0.id,
                ParamType.String,
              ),
            },
          );
        },
      )
    ]);
  }

  Center buildEmptyRatingColumn(BuildContext context) {
    return Center(
      child: EmptyListWidget(
        title: 'Nenhuma avaliação',
        message: 'Seja o primeiro a deixar uma avaliação!',
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
                  personalId: _model.content != null
                      ? _model.content['personal']['personalId']
                      : null,
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
                              _apiLoaderController.reload?.call();
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
            SizedBox(
              height: 24,
            ),
            Visibility(
              visible: !_model.isPumpProfile(),
              child: TwoCountComponentWidget(
                  firstTitle: 'alunos',
                  secondTitle: 'nota',
                  firstCount: _model.content['customerCount'] == null
                      ? '0'
                      : '${_model.content['customerCount']}',
                  secondCount: _model.content['averageRating'] == null
                      ? '-'
                      : _model.content['averageRating'],
                  secondIcon: Icons.star_border_outlined,
                  firstIcon: Icons.people_outline_outlined),
            ),
            Visibility(
              visible: (_model.content != null &&
                  _model.content['personal']['description'] != null),
              child: HeaderComponentWidget(
                title: 'Sobre',
                subtitle: _model.content['personal']['description'] ?? '',
              ),
            ),
            Visibility(
              visible: _model.content['personal']['name'] != 'Pump Training',
              child: _buildRateSection(),
            ),
            Visibility(
              visible: _model.canShowWorkoutSheets(),
              child: _buildWorkoutSheetSection(),
            ),
            SizedBox(
              height: 130,
            )
          ]))
        ]);
  }
}
