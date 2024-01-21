import 'package:flutter_flow/flutter_flow_model.dart';
import 'tag_component_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class TagComponentWidget extends StatefulWidget {
  const TagComponentWidget(
      {Key? key,
      required this.title,
      required this.tagColor,
      required this.selected,
      this.onTagPressed,
      this.maxHeight, 
      this.unselectedColor})
      : super(key: key);

  final String title;
  final Color tagColor;
  final bool selected;
  final VoidCallback? onTagPressed;
  final double? maxHeight;
  final Color? unselectedColor;

  @override
  _TagComponentWidgetState createState() => _TagComponentWidgetState();
}

class _TagComponentWidgetState extends State<TagComponentWidget> {
  late TagComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TagComponentModel());
    _model.maxHeight = widget.maxHeight ?? 19;

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () {
          if (widget.onTagPressed != null) {
            widget.onTagPressed!();
          }
        },
        child: Container(
          height: _model.maxHeight,
          constraints: BoxConstraints(
            maxHeight: _model.maxHeight,
          ),
          decoration: BoxDecoration(
            color: widget.selected
                ? widget.tagColor.withOpacity(0.6)
                : widget.unselectedColor ??
                    FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              width: 1,
              color: widget.selected
                  ? widget.tagColor.withOpacity(0.7)
                  : widget.tagColor.withOpacity(0.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Text(
                      widget.title,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Lexend Deca',
                            color: widget.selected
                                ? Colors.white
                                : FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
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
