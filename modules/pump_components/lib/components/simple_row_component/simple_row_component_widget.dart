import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'simple_row_component_model.dart';
export 'simple_row_component_model.dart';

class SimpleRowComponentWidget extends StatefulWidget {
  const SimpleRowComponentWidget(
      {super.key,
      required this.title,
      this.onTap,
      this.leftIcon,
      this.leftIconWidget,
      this.showArrowRight = true,
      this.showSeparator = true});

  final String title;
  final VoidCallback? onTap;
  final IconData? leftIcon;
  final Icon? leftIconWidget;
  final bool showArrowRight;
  final bool showSeparator;

  @override
  State<SimpleRowComponentWidget> createState() =>
      _SimpleRowComponentWidgetState();
}

class _SimpleRowComponentWidgetState extends State<SimpleRowComponentWidget> {
  late SimpleRowComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SimpleRowComponentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.onTap?.call();
          },
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 0.0, 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible:
                      widget.leftIcon != null || widget.leftIconWidget != null,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                    child: widget.leftIconWidget ??
                        Icon(
                          widget.leftIcon,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 16.0,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Montserrat',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Visibility(
                  visible: widget.showArrowRight,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 24.0, 0.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.showSeparator,
          child: Divider(
            color: FlutterFlowTheme.of(context).secondaryText,
            indent: 16,
            endIndent: 16,
            height: 1,
          ),
        ),
      ],
    );
  }
}
