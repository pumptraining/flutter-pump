import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'invite_with_image_component_model.dart';
export 'invite_with_image_component_model.dart';

class InviteWithImageComponentWidget extends StatefulWidget {
  const InviteWithImageComponentWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageString,
    required this.onAccept,
    required this.onDecline,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String imageString;
  final Function(Function(bool)) onAccept;
  final Function(Function(bool)) onDecline;
  final VoidCallback? onTap;

  @override
  State<InviteWithImageComponentWidget> createState() =>
      _InviteWithImageComponentWidgetState();
}

class _InviteWithImageComponentWidgetState
    extends State<InviteWithImageComponentWidget> {
  late InviteWithImageComponentModel _model;

  bool _isLoading = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InviteWithImageComponentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () async {
          widget.onTap?.call();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                child: Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Color(0x4CFFFFFF),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 500),
                      fadeOutDuration: Duration(milliseconds: 500),
                      imageUrl: widget.imageString,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          widget.subtitle,
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: 'Montserrat',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                      ),
                      Text(
                        widget.title,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Montserrat',
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: !_isLoading,
                      child: Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: FlutterFlowIconButton(
                          borderColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: 20.0,
                          borderWidth: 1.0,
                          buttonSize: 34.0,
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          icon: Icon(
                            Icons.close_outlined,
                            color: FlutterFlowTheme.of(context).error,
                            size: 18.0,
                          ),
                          onPressed: () {
                            widget.onDecline(
                              (p0) {
                                safeSetState(() {
                                  _isLoading = p0;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_isLoading,
                      child: FlutterFlowIconButton(
                        borderColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: 20.0,
                        borderWidth: 1.0,
                        buttonSize: 34.0,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        icon: Icon(
                          Icons.check,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 18.0,
                        ),
                        onPressed: () {
                          widget.onAccept(
                            (p0) {
                              safeSetState(() {
                                _isLoading = p0;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: _isLoading,
                      child: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
