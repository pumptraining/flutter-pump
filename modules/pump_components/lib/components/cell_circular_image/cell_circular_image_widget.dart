import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';

class CellCircularImageWidget extends StatefulWidget {
  const CellCircularImageWidget({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.id = '',
  }) : super(key: key);

  final String title;
  final String imageUrl;
  final String id;
  final void Function(String) onTap;

  @override
  // ignore: library_private_types_in_public_api
  _CellCircularImageWidgetState createState() =>
      _CellCircularImageWidgetState();
}

class _CellCircularImageWidgetState extends State<CellCircularImageWidget> {
  final _unfocusNode = FocusNode();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    _unfocusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap.call(widget.id),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 6, 0, 6),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: FlutterFlowTheme.of(context).primaryBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(44.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.zero,
                  child: Stack(
                    children: <Widget>[
                      widget.imageUrl.isNotEmpty
                          ? Container(
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
                                  maxHeightDiskCache: 200,
                                  memCacheHeight: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: 40.0,
                              height: 40.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground),
                              child: Center(
                                child: AutoSizeText(widget.title,
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 16, 0),
                child: AutoSizeText(widget.title,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
