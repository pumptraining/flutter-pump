import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'information_dialog_model.dart';

export 'information_dialog_model.dart';
export 'information_dialog_widget.dart';

class InformationDialogWidget extends StatefulWidget {
  const InformationDialogWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.actionButtonTitle,
    this.isIconButton = false,
    this.iconData = Icons.info_outline,
    this.cancelTap,
    this.confirmTap,
  }) : super(key: key);

  final String title;
  final String message;
  final String actionButtonTitle;
  final bool isIconButton;
  final IconData iconData;
  final VoidCallback? cancelTap;
  final VoidCallback? confirmTap;

  @override
  _InformationDialogWidgetState createState() =>
      _InformationDialogWidgetState();
}

class _InformationDialogWidgetState extends State<InformationDialogWidget> {
  late InformationDialogModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InformationDialogModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 530.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: Color(0x33000000),
                offset: Offset(0.0, 1.0),
              )
            ],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).primaryBackground,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 32.0, 12.0, 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0.0, 0.0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: Icon(
                            widget.iconData,
                            color: FlutterFlowTheme.of(context).warning,
                            size: 34.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Montserrat',
                                color: Colors.black,
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 24.0),
                        child: Text(
                          widget.message,
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Montserrat',
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.isIconButton
                    ? Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 12.0, 0.0),
                              child: FlutterFlowIconButton(
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.pop(context);
                                  widget.cancelTap?.call();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: FlutterFlowTheme.of(context).error,
                                ),
                                borderColor: FlutterFlowTheme.of(context).error,
                                borderRadius: 25,
                                buttonSize: 50,
                              ),
                            ),
                            FlutterFlowIconButton(
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                Navigator.pop(context);
                                widget.confirmTap?.call();
                              },
                              icon: Icon(
                                Icons.check_sharp,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              borderColor: FlutterFlowTheme.of(context).primary,
                              borderRadius: 25,
                              buttonSize: 50,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 16.0, 4.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 12.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  Navigator.pop(context, 'cancel');
                                },
                                text: 'Cancelar',
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Colors.transparent,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                Navigator.pop(context, 'leave');
                              },
                              text: widget.actionButtonTitle,
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 20.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).error,
                                textStyle:
                                    FlutterFlowTheme.of(context).titleSmall,
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
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
    );
  }
}
