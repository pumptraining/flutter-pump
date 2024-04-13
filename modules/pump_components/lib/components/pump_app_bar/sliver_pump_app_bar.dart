import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:go_router/go_router.dart';

class _SliverPumpAppBarState extends State<SliverPumpAppBar>
    with TickerProviderStateMixin {
  double _leftPadding = 16;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _leftPadding = widget.leftPadding;
    _scrollController = widget.scrollController;

    if (Platform.isAndroid) {
      _leftPadding = 50.0;
    } else {
      _scrollController.addListener(() {
        double old = _leftPadding;
        if (_scrollController.offset < kToolbarHeight) {
          _leftPadding = 16.0;
        } else {
          _leftPadding = 66.0;
        }

        if (old != _leftPadding) {
          safeSetState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color appBarBackgroundColor = widget.imageUrl.isNotEmpty
        ? FlutterFlowTheme.of(context).primaryBackground
        : FlutterFlowTheme.of(context).secondaryBackground;

    if (widget.scrollController.hasClients &&
        widget.scrollController.offset < kToolbarHeight &&
        widget.imageUrl.isNotEmpty) {
      appBarBackgroundColor = FlutterFlowTheme.of(context).secondaryBackground;
    } else {
      appBarBackgroundColor = FlutterFlowTheme.of(context).primaryBackground;
    }

    return SliverAppBar(
      leading: Container(
        padding: EdgeInsets.all(8.0),
        child: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 20.0,
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 20.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
      ),
      expandedHeight: MediaQuery.sizeOf(context).height * 0.25,
      pinned: true,
      floating: false,
      snap: false,
      stretch: true,
      backgroundColor: appBarBackgroundColor,
      automaticallyImplyLeading: true,
      actions: widget.actions,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.fromLTRB(_leftPadding, 16, _leftPadding, 16),
        title: AutoSizeText(
          widget.title,
          maxLines: 2,
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Montserrat',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
        background: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: widget.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 500),
                  fadeOutDuration: Duration(milliseconds: 500),
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                )
              : null,
        ),
      ),
      centerTitle: false,
      elevation: 1,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(
          color: FlutterFlowTheme.of(context).secondaryText,
          thickness: 0.1,
          height: 1,
        ),
      ),
    );
  }
}

class SliverPumpAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String imageUrl;
  final ScrollController scrollController;
  final double leftPadding;
  final Color titleColor;
  final List<Widget>? actions;

  const SliverPumpAppBar({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.scrollController,
    this.leftPadding = 16,
    this.titleColor = Colors.white,
    this.actions,
  }) : super(key: key);

  @override
  State<SliverPumpAppBar> createState() => _SliverPumpAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
