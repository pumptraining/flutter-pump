import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:go_router/go_router.dart';
import 'package:pump/pages/sheets_list/sheets_list_model.dart';
import 'package:flutter/material.dart';
import 'package:pump_components/components/card_workout_sheet_component/card_workout_sheet_component_widget.dart';
import 'package:pump_components/components/pump_app_bar/pump_app_bar.dart';

class SheetsListWidget extends StatefulWidget {
  const SheetsListWidget(
      {Key? key, required this.apiCall, required this.showStatus})
      : super(key: key);

  final Requestable apiCall;
  final bool showStatus;

  @override
  _SheetsListWidgetState createState() => _SheetsListWidgetState();
}

class _SheetsListWidgetState extends State<SheetsListWidget>
    with TickerProviderStateMixin {
  late SheetsListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SheetsListModel());
    _model.showStatus = widget.showStatus;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PumpAppBar(title: 'Programas'),
        body: SafeArea(
          top: false,
          bottom: false,
          child: ApiLoaderWidget(
            apiCall: widget.apiCall,
            controller: _apiLoaderController,
            builder: (context, snapshot) {
              if (snapshot == null) {
                return Container();
              }

              _model.content = snapshot.data?.jsonBody;
              return _buildContent();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(16, 32, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: List.generate(_model.numberOfRows(), (index) {
          final dto = _model.getCardWorkoutSheetDTO(
              index,
              MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () {
                context.pushNamed(
                  'WorkoutSheetDetails',
                  queryParameters: {
                    'workoutId': serializeParam(
                      dto.id,
                      ParamType.String,
                    ),
                  },
                );
              },
              child: CardWorkoutSheetComponentWidget(dto: dto),
            ),
          );
        }),
      ),
    );
  }
}
