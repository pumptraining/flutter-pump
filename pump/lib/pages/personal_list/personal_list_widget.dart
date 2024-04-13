import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:pump/flutter_flow/nav/nav.dart';
import 'package:pump_components/components/cell_circular_image/cell_circular_image_widget.dart';
import 'package:pump_components/components/pump_app_bar/pump_app_bar.dart';
import 'personal_list_model.dart';

class PersonalListWidget extends StatefulWidget {
  const PersonalListWidget({Key? key}) : super(key: key);

  @override
  _PersonalListWidgetState createState() => _PersonalListWidgetState();
}

class _PersonalListWidgetState extends State<PersonalListWidget>
    with TickerProviderStateMixin {
  late PersonalListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiLoaderController _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PersonalListModel());
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
      appBar: PumpAppBar(title: 'Personal Trainers'),
      body: SafeArea(
        top: true,
        bottom: false,
        child: ApiLoaderWidget(
            apiCall: PumpGroup.personalListCall,
            controller: _apiLoaderController,
            builder: (context, snapshot) {
              if (snapshot?.data == null) {
                return Container();
              }

              _model.content = snapshot?.data?.jsonBody;

              return SingleChildScrollView(
                padding: EdgeInsets.only(top: 32, bottom: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(
                    _model.numberOfRows(),
                    (index) {
                      final element = _model.getPersonalByIndex(index);

                      List<Widget> rowAndDivider = [];

                      final cell = CellCircularImageWidget(
                        title: element['name'],
                        imageUrl: element['imageUrl'],
                        id: element['personalId'],
                        onTap: (p0) {
                          context.pushNamed(
                            'PersonalProfile',
                            queryParameters: {
                              'forwardUri': serializeParam(
                                'personal/details?personalId=${p0}&userId=$currentUserUid',
                                ParamType.String,
                              ),
                            }.withoutNulls,
                          );
                        },
                      );

                      rowAndDivider.add(cell);

                      if (index < _model.numberOfRows() - 1) {
                        rowAndDivider.add(
                          Divider(
                            indent: 70,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            height: 1,
                            endIndent: 16,
                          ),
                        );
                      }

                      return Column(
                        children: rowAndDivider,
                      );
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}
