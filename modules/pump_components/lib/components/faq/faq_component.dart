import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';

class FaqWidget extends StatefulWidget {
  const FaqWidget({
    Key? key,
    required this.questions,
    this.expandableController,
  }) : super(key: key);

  final ExpandableController? expandableController;
  final List<dynamic> questions;

  @override
  FaqWidgetState createState() => FaqWidgetState();
}

class FaqWidgetState extends State<FaqWidget> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faqWidgets = _buildQuestionWidgets().fold<List<Widget>>(
      [],
      (previousValue, element) => previousValue..addAll(element),
    );
    return Column(children: faqWidgets, mainAxisSize: MainAxisSize.max);
  }

  List<List<Widget>> _buildQuestionWidgets() {
    return List.generate(widget.questions.length, (index) {
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
                          widget.questions[index]['question'],
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
                                widget.questions[index]['answer'],
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

  List<Widget> _buildFAQ() {
    final faqWidgets = _buildQuestionWidgets().fold<List<Widget>>(
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
                    controller: widget.expandableController,
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
}
