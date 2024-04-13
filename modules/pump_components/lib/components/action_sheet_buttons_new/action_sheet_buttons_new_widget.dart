import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'action_sheet_buttons_new_model.dart';
export 'action_sheet_buttons_new_model.dart';

class ActionSheetButtonsNewWidget extends StatefulWidget {
  const ActionSheetButtonsNewWidget({
    Key? key,
    this.firstAction,
    this.secondAction,
    this.firstActionTitle,
    this.secondActionTitle,
    this.title,
    this.firstIcon,
    this.secondIcon
  }) : super(key: key);

  final VoidCallback? firstAction;
  final VoidCallback? secondAction;
  final String? firstActionTitle;
  final String? secondActionTitle;
  final String? title;
  final IconData? firstIcon;
  final IconData? secondIcon;

  @override
  _ActionSheetButtonsNewWidgetState createState() =>
      _ActionSheetButtonsNewWidgetState();
}

class _ActionSheetButtonsNewWidgetState
    extends State<ActionSheetButtonsNewWidget> {
  late ActionSheetButtonsNewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActionSheetButtonsNewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Color(0x3B1D2429),
            offset: Offset(0.0, -3.0),
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 44.0),
                  child: Text(
                    widget.title ?? 'Opções',
                    style: FlutterFlowTheme.of(context).titleLarge,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                  child: FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: 20.0,
                    borderWidth: 1.0,
                    buttonSize: 34.0,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    icon: Icon(
                      Icons.close,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 16.0,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.firstAction?.call();
              },
              child: Padding(
                padding: EdgeInsetsDirectional.only(bottom: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      widget.firstIcon ?? Icons.note_add,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 16),
                      child: Text(
                        widget.firstActionTitle ?? '',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 16,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.secondAction?.call();
              },
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                    bottom: 16 + Utils.getBottomSafeArea(context), top: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      widget.secondIcon ?? Icons.content_copy_rounded,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 16),
                      child: Text(
                        widget.secondActionTitle ?? '',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 16,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
