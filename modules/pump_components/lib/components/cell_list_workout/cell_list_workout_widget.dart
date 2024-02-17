import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'cell_list_workout_model.dart';

class CellListWorkoutWidget extends StatefulWidget {
  const CellListWorkoutWidget({
    Key? key,
    this.isPicker = false,
    this.isSelected = false,
    this.isSingleSelection = true,
    required this.workoutId,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.level,
    required this.levelColor,
    required this.time,
    required this.titleImage,
    required this.onTap,
    required this.onDetailTap,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String level;
  final String imageUrl;
  final bool isPicker;
  final bool isSelected;
  final bool isSingleSelection;
  final String workoutId;
  final String time;
  final String titleImage;
  final Color levelColor;
  final void Function(String) onTap;
  final void Function(String) onDetailTap;

  @override
  _CellListWorkoutWidgetState createState() => _CellListWorkoutWidgetState();
}

class _CellListWorkoutWidgetState extends State<CellListWorkoutWidget> {
  late CellListWorkoutModel _model;
  final _unfocusNode = FocusNode();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CellListWorkoutModel());
    _unfocusNode.requestFocus();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        widget.onTap(widget.workoutId);
      },
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
          child: Container(
            width: 80.0,
            height: 80.0,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: widget.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          width: 80.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 80.0,
                          height: 80.0,
                          color:
                              FlutterFlowTheme.of(context).primaryBackground),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Color(0x331A1F24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.time,
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    lineHeight: 1.0,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(6, 0, 6, 0),
                          child: AutoSizeText(
                            widget.titleImage,
                            maxLines: 1,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  lineHeight: 1.0,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: AutoSizeText(
                    widget.title,
                    maxLines: 3,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 16.0, 0.0),
                  child: AutoSizeText(
                    widget.subtitle,
                    maxLines: 3,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Poppins',
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                  child: AutoSizeText(
                    widget.level,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Poppins',
                          color: widget.levelColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.isPicker)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Theme(
                    data: ThemeData(
                      checkboxTheme: CheckboxThemeData(
                        shape: widget.isSingleSelection
                            ? CircleBorder()
                            : RoundedRectangleBorder(),
                      ),
                      unselectedWidgetColor:
                          FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: Checkbox(
                      value: widget.isSelected,
                      onChanged: (newValue) async {
                        setState(() => widget.onTap(widget.workoutId));
                      },
                      activeColor: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
                      child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          borderWidth: 1,
                          buttonSize: 34,
                          fillColor: Colors.white,
                          icon: Icon(
                            Icons.arrow_forward,
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            size: 16,
                          ),
                          onPressed: () {
                            widget.onDetailTap(widget.workoutId);
                          })),
                ]),
          ),
      ]),
    );
  }
}
