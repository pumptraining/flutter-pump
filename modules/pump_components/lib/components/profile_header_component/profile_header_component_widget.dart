import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';

import 'profile_header_component_model.dart';

export 'profile_header_component_model.dart';

class ProfileHeaderComponentWidget extends StatefulWidget {
  const ProfileHeaderComponentWidget(
      {super.key,
      required this.subtitle,
      required this.name,
      required this.imageUrl,
      this.safeArea = true,
      this.intent = 0.0,
      this.endIntent = 0.0,
      this.rightIcon,
      this.rightIconSize = 20.0,
      this.onTap});

  final String subtitle;
  final String name;
  final String imageUrl;
  final bool safeArea;
  final double intent;
  final double endIntent;
  final IconData? rightIcon;
  final double rightIconSize;
  final VoidCallback? onTap;

  @override
  State<ProfileHeaderComponentWidget> createState() =>
      _ProfileHeaderComponentWidgetState();
}

class _ProfileHeaderComponentWidgetState
    extends State<ProfileHeaderComponentWidget> {
  late ProfileHeaderComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileHeaderComponentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap?.call();
      },
      child: Container(
        width: double.infinity,
        height: 86 + (widget.safeArea ? Utils.getTopSafeArea(context) : 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: (widget.safeArea
              ? MainAxisAlignment.end
              : MainAxisAlignment.center),
          children: [
            Padding(
              padding:
                  EdgeInsets.only(bottom: 0, top: (widget.safeArea ? 16 : 0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 0.0, 16.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {},
                            child: Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x33000000),
                                    offset: Offset(0.0, 2.0),
                                  )
                                ],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 500),
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  imageUrl: widget.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 16.0, 4.0),
                              child: Text(
                                widget.subtitle,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Montserrat',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 16.0, 0.0),
                              child: AutoSizeText(
                                widget.name,
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Montserrat',
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 24.0, 0.0),
                      child: Icon(
                        widget.rightIcon,
                        size: widget.rightIconSize,
                        color: FlutterFlowTheme.of(context).primary,
                      )),
                ],
              ),
            ),
            Divider(
              color: FlutterFlowTheme.of(context).secondaryText,
              height: 2,
              indent: widget.intent,
              endIndent: widget.endIntent,
            )
          ],
        ),
      ),
    );
  }
}
