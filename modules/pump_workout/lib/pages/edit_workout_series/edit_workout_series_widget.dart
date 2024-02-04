import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'edit_workout_series_model.dart';

class EditWorkoutSeriesWidget extends StatefulWidget {
  const EditWorkoutSeriesWidget(
      {Key? key, this.workout})
      : super(key: key);

  final dynamic workout;

  @override
  _EditWorkoutSeriesWidgetState createState() => _EditWorkoutSeriesWidgetState();
}

class _EditWorkoutSeriesWidgetState extends State<EditWorkoutSeriesWidget> {
  late EditWorkoutSeriesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditWorkoutSeriesModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Séries',
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
      body: Container()
    );
  }
}
