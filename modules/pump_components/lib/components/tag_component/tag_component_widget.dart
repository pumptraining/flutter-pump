import 'package:flutter_flow/flutter_flow_model.dart';
import 'tag_component_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class TagComponentWidget extends StatefulWidget {
  const TagComponentWidget({
    Key? key,
    required this.title,
    required this.tagColor,
    required this.selected,
    this.onTagPressed,
    this.maxHeight,
    this.unselectedColor,
    this.alpha = 0.7,
    this.borderWidth = 1.0,
    this.borderRadius = 4,
    this.selectedTextColor,
  }) : super(key: key);

  final String title;
  final Color tagColor;
  final bool selected;
  final VoidCallback? onTagPressed;
  final double? maxHeight;
  final Color? unselectedColor;
  final double alpha;
  final double borderWidth;
  final double borderRadius;
  final Color? selectedTextColor;

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
    final Color selectedTextColor = widget.selectedTextColor ?? Colors.white;
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
                ? widget.tagColor.withOpacity(widget.alpha)
                : widget.unselectedColor ??
                    FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              width: widget.borderWidth,
              color: widget.selected
                  ? widget.tagColor
                      .withOpacity(widget.alpha != 1 ? (widget.alpha + 0.1) : 1)
                  : widget.unselectedColor ??
                      FlutterFlowTheme.of(context).secondaryBackground,
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
                            fontFamily: 'Montserrat',
                            color: widget.selected
                                ? selectedTextColor
                                : FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
