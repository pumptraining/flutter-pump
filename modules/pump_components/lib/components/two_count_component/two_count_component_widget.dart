import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'two_count_component_model.dart';
export 'two_count_component_model.dart';

class TwoCountComponentWidget extends StatefulWidget {
  const TwoCountComponentWidget(
      {super.key,
      this.firstCount = '',
      this.secondCount = '',
      required this.firstTitle,
      required this.secondTitle,
      required this.secondIcon,
      required this.firstIcon,
      this.firstCallback,
      this.secondCallback});

  final String firstCount;
  final String secondCount;
  final String firstTitle;
  final String secondTitle;
  final IconData firstIcon;
  final IconData secondIcon;
  final VoidCallback? firstCallback;
  final VoidCallback? secondCallback;

  @override
  State<TwoCountComponentWidget> createState() =>
      _TwoCountComponentWidgetState();
}

class _TwoCountComponentWidgetState extends State<TwoCountComponentWidget>
    with TickerProviderStateMixin {
  late TwoCountComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TwoCountComponentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 4.0, 0.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: () {
                          widget.firstCallback?.call();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 16.0, 12.0, 4.0),
                                    child: FlutterFlowIconButton(
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: 8,
                                      buttonSize: 34,
                                      onPressed: () {
                                        widget.firstCallback?.call();
                                      },
                                      icon: Icon(
                                        widget.firstIcon,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: widget.firstCount.isNotEmpty,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 6.0, 0.0, 0.0),
                                  child: AutoSizeText(
                                    widget.firstCount,
                                    style: FlutterFlowTheme.of(context)
                                        .displaySmall,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 6.0, 6.0, 16.0),
                                child: AutoSizeText(
                                  widget.firstTitle,
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Montserrat',
                                      ),
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
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 16.0, 0.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: () {
                          widget.secondCallback?.call();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 16.0, 12.0, 4.0),
                                    child: FlutterFlowIconButton(
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: 8,
                                      buttonSize: 34,
                                      onPressed: () {
                                        widget.secondCallback?.call();
                                      },
                                      icon: Icon(
                                        widget.secondIcon,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: widget.secondCount.isNotEmpty,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 6.0, 0.0, 0.0),
                                  child: AutoSizeText(
                                    widget.secondCount,
                                    style: FlutterFlowTheme.of(context)
                                        .displaySmall,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 6.0, 6.0, 16.0),
                                child: AutoSizeText(
                                  widget.secondTitle,
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Montserrat',
                                      ),
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
            ),
          ],
        ),
      ),
    );
  }
}
