import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';

class PumpAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasBackButton;

  const PumpAppBar({Key? key, required this.title, this.hasBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      leading: hasBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_sharp,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          : null,
      automaticallyImplyLeading: false,
      title: AutoSizeText(
        title.toUpperCase(),
        maxLines: 2,
        style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Montserrat',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: [],
      centerTitle: false,
      elevation: 2,
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
