import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:pump/flutter_flow/nav/nav.dart';
import 'package:pump/pages/sheets_list/sheets_list_widget.dart';
import 'package:pump_components/components/bottom_gradient_component/bottom_gradient_component_widget.dart';
import 'package:pump_components/components/header_component/header_component_widget.dart';
import 'package:pump_components/components/horizontal_image_title_list_component/horizontal_image_title_list_component_widget.dart';
import 'package:pump_components/components/horizontal_workout_sheet_list_component/horizontal_workout_sheet_list_component_widget.dart';
import 'package:pump_components/components/pump_app_bar/pump_app_bar.dart';
import 'package:pump_components/components/simple_row_component/simple_row_component_widget.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'home_workout_sheets_model.dart';
export 'home_workout_sheets_model.dart';

class HomeWorkoutSheetsWidget extends StatefulWidget {
  const HomeWorkoutSheetsWidget({Key? key}) : super(key: key);

  @override
  _HomeWorkoutSheetsWidgetState createState() =>
      _HomeWorkoutSheetsWidgetState();
}

class _HomeWorkoutSheetsWidgetState extends State<HomeWorkoutSheetsWidget>
    with TickerProviderStateMixin {
  late HomeWorkoutSheetsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isError = false;
  final ApiLoaderController _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeWorkoutSheetsModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'HomeWorkoutSheets'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_model.unfocusNode.hasFocus) {
          FocusScope.of(context).requestFocus(_model.unfocusNode);
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PumpAppBar(
          title: 'Explore',
          hasBackButton: false,
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: ApiLoaderWidget(
            apiCall: PumpGroup.homeWorkoutSheetsCall,
            controller: _apiLoaderController,
            builder: (context, snapshot) {
              if (snapshot == null) {
                return Container();
              }

              _model.content = snapshot.data!.jsonBody;
              return buildContent(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderComponentWidget(
          title: 'Personal Trainer',
          subtitle:
              'Em busca de um acompanhamento profissional? Busque por um Personal Trainer',
          buttonTitle: 'todos',
          showButton: _model.canShowListPersonal(),
          onTap: () {
            context.pushNamed('PersonalListWidget');
          },
        ),
        HorizontalImageTitleListComponentWidget(
          content: _model.getHorizontalImageTitleListDTO(),
          onTap: (p0) {
            context.pushNamed(
              'PersonalProfile',
              queryParameters: {
                'forwardUri': serializeParam(
                  'personal/details?personalId=${p0.id}&userId=$currentUserUid',
                  ParamType.String,
                ),
              }.withoutNulls,
            );
          },
        ),
      ],
    );
  }

  void _pushSheetList(Requestable apiCall) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SheetsListWidget(
          apiCall: apiCall,
          showStatus: false,
        ),
      ),
    );
  }

  Widget _buildWorkoutSheetSection() {
    return Column(children: [
      HeaderComponentWidget(
        title: 'Programas de Treino',
        subtitle:
            'Encontre o programa de treino ideal e conquiste seus objetivos',
        buttonTitle: 'todos',
        showButton: true,
        onTap: () {
          _pushSheetList(PumpGroup.homeWorkoutSheetsCall);
        },
      ),
      HorizontalWorkoutSheetListComponentWidget(
        dtoList: _model.getWorkoutSheetListDTO(),
        onTap: (p0) {
          context.pushNamed(
            'WorkoutSheetDetails',
            queryParameters: {
              'workoutId': serializeParam(
                p0.id,
                ParamType.String,
              ),
            },
          );
        },
      )
    ]);
  }

  Widget _buildUserWorkout() {
    return Column(
        children: _model.canShowUserPrograms()
            ? [
                HeaderComponentWidget(
                  title: 'Meus Programas',
                  subtitle: 'Confira os programas de treino que você comprou',
                ),
                SimpleRowComponentWidget(
                  title: 'Programas de treino',
                  leftIcon: Icons.featured_play_list_outlined,
                  onTap: () {
                    _pushSheetList(PumpGroup.userPurchaseWorkoutSheetCall);
                  },
                )
              ]
            : []);
  }

  Widget _buildWorkoutLibSection() {
    return Column(children: [
      HeaderComponentWidget(
        title: 'Treinos',
        subtitle:
            'Quer sair da rotina e fazer um treino diferente? Busque por um treino a biblioteca do Pump',
      ),
      SimpleRowComponentWidget(
        title: 'Biblioteca de treinos',
        leftIcon: Icons.list_alt_outlined,
        onTap: () {
          context.pushNamed(
            'HomeWorkout',
          );
        },
      )
    ]);
  }

  Stack buildContent(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
            padding:
                EdgeInsets.only(bottom: 130 + Utils.getBottomSafeArea(context)),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPersonalSection(),
                  _buildWorkoutSheetSection(),
                  _buildUserWorkout(),
                  _buildWorkoutLibSection(),
                ])),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomGradientComponentWidget(),
        ),
      ],
    );
  }
}
