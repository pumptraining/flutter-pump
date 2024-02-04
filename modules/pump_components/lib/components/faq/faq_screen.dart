import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:pump_components/components/faq/faq_component.dart';

class FaqScreenWidget extends StatefulWidget {
  const FaqScreenWidget({
    Key? key,
    required this.questions,
    this.expandableController,
  }) : super(key: key);

  final ExpandableController? expandableController;
  final List<dynamic> questions;

  @override
  FaqScreenWidgetState createState() => FaqScreenWidgetState();
}

class FaqScreenWidgetState extends State<FaqScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          'Perguntas Frequentes',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 22.0,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
          top: false,
          bottom: false,
          child: Padding(padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
          child: FaqWidget(
            questions: widget.questions,
            expandableController: widget.expandableController,
          )),)
    );
  }
}
