import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'horizontal_image_title_list_component_model.dart';
export 'horizontal_image_title_list_component_model.dart';

class HorizontalImageTitleListDTO {
  const HorizontalImageTitleListDTO(
      {required this.id, required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;
  final String id;
}

class HorizontalImageTitleListComponentWidget extends StatefulWidget {
  const HorizontalImageTitleListComponentWidget(
      {super.key, required this.content, this.onTap});

  final List<HorizontalImageTitleListDTO> content;
  final Function(HorizontalImageTitleListDTO)? onTap;

  @override
  State<HorizontalImageTitleListComponentWidget> createState() =>
      _HorizontalImageTitleListComponentWidgetState();
}

class _HorizontalImageTitleListComponentWidgetState
    extends State<HorizontalImageTitleListComponentWidget>
    with TickerProviderStateMixin {
  late HorizontalImageTitleListComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => HorizontalImageTitleListComponentModel());
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
      height: 140,
      alignment: AlignmentDirectional.topStart,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: ListView(
        padding: EdgeInsetsDirectional.fromSTEB(4, 16, 16, 0),
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: List.generate(widget.content.length, (index) {
          HorizontalImageTitleListDTO element = widget.content[index];

          return GestureDetector(
            onTap: () async {
              widget.onTap?.call(element);
            },
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Container(
                alignment: AlignmentDirectional.topCenter,
                width: 84,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 6, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0x4CFFFFFF),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0x33000000),
                                offset: Offset(0, 2),
                              )
                            ],
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          child: Container(
                            width: 60,
                            height: 60,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CachedNetworkImage(
                              fadeInDuration: Duration(milliseconds: 500),
                              fadeOutDuration: Duration(milliseconds: 500),
                              imageUrl: element.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: AutoSizeText(
                          element.title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
