import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:pump_components/components/review_bottom_sheet/review_bottom_sheet_widget.dart';
import 'package:pump_components/components/review_card/review_card_widget.dart';
import 'review_screen_model.dart';
export 'review_screen_model.dart';

class ReviewScreenWidget extends StatefulWidget {
  const ReviewScreenWidget(
      {Key? key, this.workoutId, this.personalId, this.isPersonal})
      : super(key: key);

  final String? workoutId;
  final String? personalId;
  final bool? isPersonal;

  @override
  _ReviewScreenWidgetState createState() => _ReviewScreenWidgetState();
}

class _ReviewScreenWidgetState extends State<ReviewScreenWidget> {
  late ReviewScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isError = false;
  String workoutId = '';
  String personalId = '';
  late ApiCallResponse responseContent;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewScreenModel());

    workoutId = widget.workoutId ?? '';
    personalId = widget.personalId ?? '';
    _model.isPersonal = widget.isPersonal ?? false;
    _loadContent();
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
      responseContent = await PumpGroup.getPersonalReviewsCall(params: { 'personalId': personalId });
    } else {
      responseContent = await PumpGroup.workoutRatingsCall(workoutId: workoutId);
    }

    if (responseContent.succeeded) {
      isLoading = false;
      isError = false;
      if (workoutId.isEmpty) {
        _model.content = responseContent.jsonBody['response'];
      } else {
        _model.content = responseContent.jsonBody;
      }
    } else {
      isLoading = false;
      isError = true;
    }
    return responseContent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Avaliações',
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
      body: FutureBuilder<ApiCallResponse>(
          future: _loadContent(),
          builder: (context, snapshot) {
            if (isLoading) {
              return Scaffold(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                body: Center(
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: CircularProgressIndicator(strokeWidth: 1.0,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              );
            }

            if (isError) {
              return buildErrorColumn(context);
            }

            return buildContent(context);
          }),
    );
  }

  SafeArea buildContent(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 24.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 12.0),
                              child: Text(
                                '${_model.content['ratings']?.length}',
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Outfit',
                                      fontSize: 28.0,
                                    ),
                              ),
                            ),
                            Text(
                              'avaliações',
                              style: FlutterFlowTheme.of(context).labelMedium,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 12.0),
                                  child: Text(
                                    _model.content['averageRating'],
                                    style: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 28.0,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4.0, 0.0, 0.0, 12.0),
                                  child: Icon(
                                    Icons.star_rounded,
                                    color: FlutterFlowTheme.of(context).warning,
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'nota',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 12.0,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !_model.isPersonal,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
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
                                  workoutId: workoutId.isEmpty ? null : workoutId,
                                  personalId: personalId,
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
                        text: 'Avaliar',
                        icon: Icon(
                          Icons.edit,
                          size: 16.0,
                        ),
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        showLoadingIndicator: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children:
                    List.generate(_model.content['ratings'].length, (index) {
                  final feedback = _model.content['ratings'][index];
                  return ReviewCardWidget(
                    name: _model.getFeedbackName(feedback),
                    feedback: feedback['feedbackText'],
                    imageUrl: feedback['imageUrl'],
                    rating: feedback['rating'],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center buildErrorColumn(BuildContext context) {
    return Center(
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
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
    );
  }
}
