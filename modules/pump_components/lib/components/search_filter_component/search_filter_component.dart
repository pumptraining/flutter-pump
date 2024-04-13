import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:badges/badges.dart' as badges;

class SearchFilterComponentWidget extends StatefulWidget {
  const SearchFilterComponentWidget({
    Key? key,
    this.textController,
    required this.textFieldFocusNode,
    this.onTextChanged,
    this.onButtonTap,
    this.bagdeValue,
  }) : super(key: key);

  final FocusNode textFieldFocusNode;
  final TextEditingController? textController;
  final VoidCallback? onTextChanged;
  final VoidCallback? onButtonTap;
  final String? bagdeValue;

  @override
  // ignore: library_private_types_in_public_api
  _SearchFilterComponentWidgetState createState() =>
      _SearchFilterComponentWidgetState();
}

class _SearchFilterComponentWidgetState
    extends State<SearchFilterComponentWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: double.infinity,
            height: 100.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).primaryBackground,
                  Colors.transparent,
                ],
                stops: [0.0, 1.0],
                begin: AlignmentDirectional(0.0, -1.0),
                end: AlignmentDirectional(0, 1.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 0),
          child: Container(
            width: double.infinity,
            height: 60.0,
            decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                    color: FlutterFlowTheme.of(context).secondaryBackground)),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 8.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      focusNode: widget.textFieldFocusNode,
                      controller: widget.textController,
                      onChanged: (_) => widget.onTextChanged?.call(),
                      obscureText: false,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Buscar treino...',
                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        suffixIcon: null,
                      ),
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Montserrat',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                              ),
                    ),
                  )),
                  badges.Badge(
                    badgeContent: Text(
                      widget.bagdeValue ?? '',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Readex Pro',
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                    ),
                    showBadge: widget.bagdeValue != null,
                    shape: badges.BadgeShape.circle,
                    badgeColor: FlutterFlowTheme.of(context).error,
                    elevation: 4.0,
                    padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
                    position: badges.BadgePosition.topEnd(),
                    animationType: badges.BadgeAnimationType.scale,
                    toAnimate: true,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 30.0,
                        borderWidth: 1.0,
                        buttonSize: 44.0,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        icon: Icon(
                          Icons.tune_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 20.0,
                        ),
                        onPressed: () {
                          widget.onButtonTap?.call();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
