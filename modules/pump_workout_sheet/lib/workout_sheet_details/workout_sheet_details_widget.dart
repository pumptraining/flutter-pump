import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_widget.dart';
import 'package:pump_components/components/header_component/header_component_widget.dart';
import 'package:pump_components/components/profile_header_component/profile_header_component_widget.dart';
import 'package:pump_components/components/pump_app_bar/sliver_pump_app_bar.dart';
import 'package:pump_components/components/two_count_component/two_count_component_widget.dart';

import 'workout_sheet_details_model.dart';

export 'workout_sheet_details_model.dart';

class WorkoutSheetDetailsWidget extends StatefulWidget {
  const WorkoutSheetDetailsWidget(
      {Key? key,
      this.workoutId,
      this.showStartButton,
      this.isPersonal,
      this.canDuplicate})
      : super(key: key);

  final String? workoutId;
  final bool? showStartButton;
  final bool? isPersonal;
  final bool? canDuplicate;

  @override
  // ignore: library_private_types_in_public_api
  _WorkoutSheetDetailsWidgetState createState() =>
      _WorkoutSheetDetailsWidgetState();
}

class _WorkoutSheetDetailsWidgetState extends State<WorkoutSheetDetailsWidget>
    with TickerProviderStateMixin {
  late WorkoutSheetDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String workoutId = '';
  String userId = currentUserUid;
  bool showStartButton = true;

  final ScrollController _scrollController = ScrollController();
  final ApiLoaderController _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutSheetDetailsModel());

    workoutId = widget.workoutId ?? '';
    showStartButton = widget.showStartButton ?? true;
    _model.isPersonal = widget.isPersonal ?? false;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> initPaymentSheet(double amount, String personalId) async {
    try {
      final response = await PumpGroup.paymentSheetCall(
          amount: amount,
          personalId: personalId,
          userId: userId,
          trainingSheetId: workoutId);

      dynamic data = response.jsonBody;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Pump Training',
          paymentIntentClientSecret: data['paymentIntent'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          style: ThemeMode.dark,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: FlutterFlowTheme.of(context).primary,
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: FlutterFlowTheme.of(context).primary,
                  text: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ),
          ),
        ),
      );

      await displayPaymentSheet();
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        final response = await PumpGroup.userStartedWorkoutSheetCall(
            params: {'trainingSheetId': workoutId});

        if (response.succeeded) {
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Ocorreu um erro. Por favor, tente novamente.')),
          );
        }
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Falha no pagamento. Por favor, tente novamente.')),
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: ApiLoaderWidget(
            apiCall: PumpGroup.workoutSheetDetailsCall,
            params: {'userId': userId, 'workoutId': workoutId},
            controller: _apiLoaderController,
            builder: (context, snapshot) {
              _model.content = snapshot?.data?.jsonBody;
              return Stack(
                children: [
                  buildContent(context),
                  _model.isPersonal
                      ? Container()
                      : BottomButtonFixedWidget(
                          icon: Icon(
                            Icons.arrow_forward_rounded,
                            size: 22,
                          ),
                          onPressed: () async {
                            HapticFeedback.mediumImpact();

                            final amount = _model.content?['amount'];
                            if (amount != null) {
                              await initPaymentSheet(
                                  amount, _model.content?['personalId']);
                            } else {
                              final response =
                                  await PumpGroup.userStartedWorkoutSheetCall(
                                      params: {'trainingSheetId': workoutId});

                              if (response.succeeded) {
                                context.go('/home');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Ocorreu um erro. Por favor, tente novamente.')),
                                );
                              }
                            }
                          },
                          buttonTitle: (_model.content?['amount'] != null)
                              ? 'Por apenas ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(_model.content?['amount'])}'
                              : 'Começar',
                        )
                ],
              );
            }));
  }

  SliverPumpAppBar buildAppBar(BuildContext context) {
    return SliverPumpAppBar(
      title: (_model.content != null && _model.content['workoutName'] != null)
          ? _model.content['workoutName']
          : '',
      imageUrl: (_model.content != null && _model.content['imageUrl'] != null)
          ? _model.content['imageUrl']
          : '',
      scrollController: _scrollController,
      actions: [
        Visibility(
          visible: _model.isPersonal,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              icon: Icon(
                Icons.keyboard_control_sharp,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 20.0,
              ),
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  builder: (BuildContext context) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.copy),
                            title: Text('Editar'),
                            onTap: () async {
                              Navigator.pop(context);
                              await context.pushNamed(
                                'AddWorkoutSheet',
                                queryParameters: {
                                  'workoutId': serializeParam(
                                    workoutId,
                                    ParamType.String,
                                  ),
                                  'isUpdate':
                                      serializeParam(true, ParamType.bool),
                                },
                              ).then((value) {
                                if (value != null && value is bool && value) {
                                  _model.content = null;
                                  _apiLoaderController.reload?.call();
                                }
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.cancel),
                            title: Text('Cancelar'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: [
        buildAppBar(context),
        _model.content == null
            ? Container()
            : SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Visibility(
                      visible: _model.content['sections'][0]['description'] !=
                              null &&
                          _model.content['sections'][0]['description']
                              .toString()
                              .isNotEmpty,
                      child: HeaderComponentWidget(
                        title: 'Sobre',
                        subtitle:
                            _model.content['sections'][0]['description'] ?? '',
                      ),
                    ),
                    Visibility(
                      visible: !_model.isPersonal,
                      child: ProfileHeaderComponentWidget(
                        rightIcon: Icons.arrow_forward_ios,
                        rightIconSize: 12,
                        intent: 16,
                        endIntent: 16,
                        safeArea: false,
                        subtitle: 'Criado por',
                        imageUrl: _model.content['personalImageUrl'],
                        name: _model.content['personalName'],
                        onTap: () {
                          context.pushNamed(
                            'PersonalProfile',
                            queryParameters: {
                              'forwardUri': serializeParam(
                                'personal/details?personalId=${_model.content?['personalId']}&userId=$currentUserUid',
                                ParamType.String,
                              ),
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TwoCountComponentWidget(
                        firstTitle: '${_model.content['timerCount']}',
                        secondTitle: '${_model.content['weeksCount']} semanas',
                        secondIcon: Icons.calendar_month_outlined,
                        firstIcon: Icons.timer_sharp),
                    TwoCountComponentWidget(
                        firstTitle:
                            _model.content['goal'].toString().toLowerCase(),
                        secondTitle:
                            '${_model.content['perWeekCount']}x na semana',
                        secondIcon: Icons.checklist_rtl,
                        firstIcon: Icons.fitness_center_sharp),
                    HeaderComponentWidget(
                        title:
                            '${_model.content['sections'][2]['array'].length} treinos'),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          8, 16, 16, 80 + Utils.getBottomSafeArea(context)),
                      child: Builder(
                        builder: (context) {
                          final workoutList =
                              _model.content['sections'][2]['array'];

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: workoutList.length,
                            itemBuilder: (context, workoutListIndex) {
                              final workoutListItem =
                                  workoutList[workoutListIndex];

                              List<Widget> rowAndDivider = [];

                              CellListWorkoutWidget cell =
                                  CellListWorkoutWidget(
                                imageUrl: workoutListItem['imageUrl'],
                                title: workoutListItem['workoutName'],
                                subtitle: _model.formatArrayToString(
                                    workoutListItem['muscleImpact']),
                                level: _model
                                    .mapSkillLevel(workoutListItem['level']),
                                levelColor: _model.mapSkillLevelBorderColor(
                                    workoutListItem['level']),
                                workoutId: workoutListItem['workoutId'],
                                time: workoutListItem['workoutTime'].toString(),
                                titleImage: 'min',
                                onTap: (p0) async {
                                  final amount = _model.content?['amount'];

                                  if (amount == null ||
                                      _model.isPersonal ||
                                      authManager.isUserAdmin()) {
                                    await context.pushNamed(
                                      'WorkoutDetails',
                                      queryParameters: {
                                        'workoutId': serializeParam(
                                          workoutListItem['workoutId'],
                                          ParamType.String,
                                        ),
                                        'userId': serializeParam(
                                          userId,
                                          ParamType.String,
                                        ),
                                        'isPersonal': serializeParam(
                                          _model.isPersonal,
                                          ParamType.bool,
                                        ),
                                      },
                                    );
                                  } else {
                                    await initPaymentSheet(
                                        amount, _model.content?['personalId']);
                                  }
                                },
                                onDetailTap: (p0) {},
                              );

                              rowAndDivider.add(cell);

                              if (workoutListIndex < workoutList.length - 1) {
                                rowAndDivider.add(
                                  Divider(
                                    indent: 78,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    height: 1,
                                    endIndent: 0,
                                  ),
                                );
                              }

                              return Column(
                                children: rowAndDivider,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
