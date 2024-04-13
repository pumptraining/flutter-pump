import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/common/user_settings.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/subscribe_screen/subscribe_screen_widget.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';
import '../../backend/firebase_analytics/analytics.dart';
import 'customer_payments_model.dart';

class CustomerPaymentsWidget extends StatefulWidget {
  const CustomerPaymentsWidget({
    Key? key,
    required this.customerId,
  }) : super(key: key);

  final String customerId;

  @override
  _CustomerPaymentsWidgetState createState() => _CustomerPaymentsWidgetState();
}

class _CustomerPaymentsWidgetState extends State<CustomerPaymentsWidget>
    with TickerProviderStateMixin {
  late CustomerPaymentsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ExpandableController _expandableController = ExpandableController();
  ScrollController _scrollController = ScrollController();
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CustomerPaymentsModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'CustomerPayments'});

    _expandableController.addListener(_onExpandableStateChanged);
    _initUniLinks();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _expandableController.removeListener(_onExpandableStateChanged);
    _scrollController.dispose();
    _sub.cancel();

    super.dispose();
  }

  Future<void> _initUniLinks() async {
    _sub = linkStream.listen((String? link) {
      _apiLoaderController.reload?.call();
    }, onError: (err) {});
  }

  void _onExpandableStateChanged() {
    bool isExpanded = _expandableController.expanded;
    if (isExpanded) {
      setState(() {
        _scrollController.animateTo(
          200.0,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  final ApiLoaderController _apiLoaderController = ApiLoaderController();

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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          'Pagamentos',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 22.0,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ApiLoaderWidget(
          apiCall: BaseGroup.bankAccountCall,
          controller: _apiLoaderController,
          builder: (context, snapshot) {
            _model.content = snapshot?.data?.jsonBody['response'];
            return Stack(children: [
              _buildContent(context),
              _buildBottomButton(context),
            ]);
          },
        ),
      ),
    );
  }

  SingleChildScrollView _buildContent(BuildContext context) {
    final contentWidgets = _buildBankHeader();
    contentWidgets.addAll(_buildFAQ(_model.getQuestions()));

    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: 140.0),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: contentWidgets),
    );
  }

  List<Widget> _buildBankHeader() {
    final circleColor = _model.circleColor(context);
    return [
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: circleColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: circleColor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: circleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Icon(
                        Icons.account_balance_sharp,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Text(
                  _model.getTitle(),
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Text(
                  _model.getSubtitle(),
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<List<Widget>> _buildQuestionWidgets(List<dynamic> questions) {
    return List.generate(questions.length, (index) {
      return [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: Container(
                    width: double.infinity,
                    color: Color(0x00FFFFFF),
                    child: ExpandableNotifier(
                      child: ExpandablePanel(
                        header: Text(
                          questions[index]['question'],
                          style: FlutterFlowTheme.of(context)
                              .displaySmall
                              .override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                        collapsed: Container(),
                        expanded: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                              child: Text(
                                questions[index]['answer'],
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        theme: ExpandableThemeData(
                          tapHeaderToExpand: true,
                          tapBodyToExpand: true,
                          tapBodyToCollapse: true,
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          hasIcon: true,
                          iconColor: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
      ];
    });
  }

  List<Widget> _buildFAQ(List<dynamic> questions) {
    final faqWidgets = _buildQuestionWidgets(questions).fold<List<Widget>>(
      [],
      (previousValue, element) => previousValue..addAll(element),
    );
    final faq = Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Container(
                width: double.infinity,
                color: Color(0x00FFFFFF),
                child: ExpandableNotifier(
                  child: ExpandablePanel(
                    controller: _expandableController,
                    header: Text(
                      'Perguntas frequentes',
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    collapsed: Container(),
                    expanded: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: faqWidgets,
                    ),
                    theme: ExpandableThemeData(
                      tapHeaderToExpand: true,
                      tapBodyToExpand: true,
                      tapBodyToCollapse: true,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      hasIcon: true,
                      iconColor: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return [
      Padding(
        padding: EdgeInsetsDirectional.only(top: 44),
        child: Divider(
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
      ),
      faq,
      Divider(
        thickness: 1,
        indent: 16,
        endIndent: 16,
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
    ];
  }

  Widget _buildBottomButton(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0, 1),
      child: !_model.showTerms()
          ? BottomButtonFixedWidget(
              buttonTitle: _model.getBottomButtonTitle(),
              onPressed: () async {
                // if (!UserSettings().isSubscriber()) { TODO: REMOVER
                //   showSubscribeScreen(context);
                //   return;
                // }

                await _showStripeDashboard(context);
              },
            )
          : Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: FlutterFlowTheme.of(context).primary,
                    offset: Offset(0, -1),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 12, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue ??= false,
                              onChanged: (newValue) async {
                                HapticFeedback.mediumImpact();
                                setState(
                                    () => _model.checkboxValue = newValue!);
                              },
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor:
                                  FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await launchURL(
                                'https://pump-personal-trainer.webflow.io/termos-de-uso');
                          },
                          child: Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                              child: RichText(
                                textScaleFactor:
                                    MediaQuery.of(context).textScaleFactor,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Li e concordo com os ',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Termos de Uso.',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                      ),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        0,
                        8,
                        0,
                        Utils.getBottomSafeArea(context) == 0
                            ? 16
                            : Utils.getBottomSafeArea(context)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (!(_model.checkboxValue ?? false)) {
                                  return;
                                }
                                if (!UserSettings().isSubscriber()) {
                                  showSubscribeScreen(context);
                                  return;
                                }

                                _showStripeDashboard(context);
                              },
                              text: 'Conectar Conta',
                              options: FFButtonOptions(
                                height: 44,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24, 0, 24, 0),
                                iconPadding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                color: (_model.checkboxValue ?? false)
                                    ? FlutterFlowTheme.of(context).primary
                                    : Color.fromARGB(255, 103, 210, 148),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                elevation: 3,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(22),
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
  }

  Future<void> _showStripeDashboard(BuildContext context) async {
    final result = await BaseGroup.stripeOboardingLinkCall();

    if (result.succeeded) {
      final urlString = result.jsonBody['response']['url'];
      await launchUrlString(urlString, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ocorreu um erro. Por favor, tente novamente.',
          style: TextStyle(
            fontSize: 14,
            color: FlutterFlowTheme.of(context).info,
          ),
        ),
        duration: Duration(milliseconds: 3000),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ));
    }
  }

  void showSubscribeScreen(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
            height: MediaQuery.of(context).size.height,
            child: SubscribeScreenWidget(),
          );
        }).then((value) => {
          if (value != null && value) {safeSetState(() {})}
        });
  }
}
