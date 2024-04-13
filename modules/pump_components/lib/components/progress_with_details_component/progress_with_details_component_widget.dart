import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'progress_with_details_component_model.dart';
export 'progress_with_details_component_model.dart';

class ProgressWithDetailsComponentWidget extends StatefulWidget {
  const ProgressWithDetailsComponentWidget(
      {super.key,
      required this.title,
      required this.primarySubtitle,
      required this.secondarySubtitle,
      required this.linkButtonTitle,
      required this.sheetPercent,
      required this.weekPercent,
      this.onTap});

  final String title;
  final String primarySubtitle;
  final String secondarySubtitle;
  final String linkButtonTitle;
  final double sheetPercent;
  final double weekPercent;
  final VoidCallback? onTap;

  @override
  State<ProgressWithDetailsComponentWidget> createState() =>
      _ProgressWithDetailsComponentWidgetState();
}

class _ProgressWithDetailsComponentWidgetState
    extends State<ProgressWithDetailsComponentWidget>
    with TickerProviderStateMixin {
  late ProgressWithDetailsComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProgressWithDetailsComponentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 0.0, 0.0),
      child: InkWell(
        onTap: () {
          widget.onTap?.call();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
                  child: Stack(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    children: [
                      CircularPercentIndicator(
                        circularStrokeCap: CircularStrokeCap.round,
                        percent: widget.sheetPercent,
                        radius: 40.0,
                        lineWidth: 16.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).primary,
                        backgroundColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      CircularPercentIndicator(
                        circularStrokeCap: CircularStrokeCap.round,
                        percent: widget.weekPercent,
                        radius: 20.0,
                        lineWidth: 16.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).secondary,
                        backgroundColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text(
                                  widget.primarySubtitle,
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Montserrat',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                color: FlutterFlowTheme.of(context).secondary,
                                size: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text(
                                  widget.secondarySubtitle,
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Montserrat',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                              ),
                            ]),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 2.0, 3.0),
                            child: Text(
                              widget.linkButtonTitle,
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Montserrat',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 16.0, 0.0),
                            child: Icon(
                              Icons.arrow_forward,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 14.0,
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
    );
  }
}
