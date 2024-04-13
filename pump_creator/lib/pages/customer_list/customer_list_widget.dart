import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:pump_components/components/action_sheet_buttons_new/action_sheet_buttons_new_widget.dart';
import 'package:pump_creator/common/invite_link.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import 'package:pump_creator/models/tag_model.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:pump_components/components/tag_component/tag_component_widget.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'customer_list_model.dart';
import 'dart:ui' as ui;
export 'customer_list_model.dart';

class CustomerListWidget extends StatefulWidget {
  const CustomerListWidget({Key? key}) : super(key: key);

  @override
  _CustomerListWidgetState createState() => _CustomerListWidgetState();
}

class _CustomerListWidgetState extends State<CustomerListWidget>
    with TickerProviderStateMixin {
  late CustomerListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String imageUrl = '';

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 50),
          end: Offset(0, 0),
        ),
      ],
    ),
    'rowOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 200.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
      ],
    ),
  };

  final ApiLoaderController apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CustomerListModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'CustomerList'});

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Alunos',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22,
                ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 20.0,
                  borderWidth: 1.0,
                  buttonSize: 40.0,
                  fillColor: Colors.transparent,
                  icon: Icon(
                    Icons.add_outlined,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    _addNew();
                  },
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: ApiLoaderWidget(
            apiCall: BaseGroup.customersCall,
            controller: apiLoaderController,
            builder: (context, snapshot) {
              _model.content = snapshot?.data?.jsonBody['response'];

              if (_model.showEmptyState()) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmptyListWidget(
                      buttonTitle: "Enviar Convite",
                      title: "Sem alunos",
                      message:
                          "Nenhum aluno encontrado.\n\nEnvie o convite por e-mail ou compartilhe seu link único de cadastro para os seus alunos.",
                      onButtonPressed: () async {
                        _addNew();
                      },
                      iconData: Icons.people_outlined,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.all(32),
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: FFButtonWidget(
                          onPressed: () async {
                            if (isiOS) {
                              launchUrlString(
                                  'https://apps.apple.com/br/app/pump-training/id1626404347',
                                  mode: LaunchMode.externalApplication);
                              return;
                            }
                            await launchUrlString(
                                'https://pumpapp.page.link/pump',
                                mode: LaunchMode.externalApplication);
                          },
                          text: 'Conheça o App do Aluno',
                          icon: Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          options: FFButtonOptions(
                            height: 44,
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Lexend Deca',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return buildContent(context);
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildContent(BuildContext context) {
    dynamic filtered = _model.returnFilteredContent();
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(
        filtered.length + 1,
        (index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 16),
              child: TextFormField(
                onChanged: (value) {
                  safeSetState(() {});
                },
                controller: _model.textController,
                focusNode: _model.textFieldFocusNode,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Buscar por aluno...',
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
                maxLines: null,
                validator: _model.textControllerValidator.asValidator(context),
              ),
            );
          }

          final customerItem = filtered[index - 1];
          final isLast = _model.isLastCustomer(index - 1, filtered);

          return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, isLast ? 24 : 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      context.pushNamed('CustomerDetails', queryParameters: {
                        'customerId': serializeParam(
                          customerItem['userId'],
                          ParamType.String,
                        ),
                        'email': serializeParam(
                          customerItem['email'],
                          ParamType.String,
                        ),
                      }).then((value) => {
                            if (value != null && value is bool && value)
                              {
                                safeSetState(() {
                                  apiLoaderController.reload?.call();
                                })
                              }
                          });
                    },
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(44.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.zero,
                                child: Stack(
                                  children: <Widget>[
                                    if (customerItem["imageUrl"] != null &&
                                        customerItem["imageUrl"]!.isNotEmpty)
                                      Container(
                                        width: 44.0,
                                        height: 44.0,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                customerItem["imageUrl"]!),
                                      ),
                                    if (customerItem["imageUrl"] == null ||
                                        customerItem["imageUrl"]!.isEmpty)
                                      Container(
                                        width: 44.0,
                                        height: 44.0,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground),
                                        child: Center(
                                          child: AutoSizeText(
                                              (customerItem["name"] ??
                                                      'Usuário')[0]
                                                  .toUpperCase(),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 21, 16, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      customerItem["name"],
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge,
                                    ),
                                    Visibility(
                                      visible: customerItem['tags'] != null ||
                                          !_model.customerIsBlockedOrPending(
                                              customerItem),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 8, 16),
                                              child: Wrap(
                                                  spacing: 4.0,
                                                  runSpacing: 4.0,
                                                  children: (customerItem[
                                                                  'tags'] !=
                                                              null ||
                                                          !_model
                                                              .customerIsBlockedOrPending(
                                                                  customerItem))
                                                      ? List.generate(
                                                          _model.tagCount(
                                                              customerItem),
                                                          (index) {
                                                          if (_model
                                                              .customerIsBlockedOrPending(
                                                                  customerItem)) {
                                                            String title = '';
                                                            Color tagColor =
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .error;
                                                            if (customerItem?[
                                                                    'status'] ==
                                                                'blocked') {
                                                              title =
                                                                  'Bloqueado';
                                                            } else if (customerItem?[
                                                                    'personalInvite'] ==
                                                                'pending') {
                                                              title =
                                                                  'Pendente';
                                                              tagColor =
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .warning;
                                                            } else if (customerItem?[
                                                                    'personalInvite'] ==
                                                                'rejected') {
                                                              title =
                                                                  'Recusado';
                                                              tagColor =
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .error;
                                                            }
                                                            return TagComponentWidget(
                                                              title: title,
                                                              tagColor:
                                                                  tagColor,
                                                              selected: true,
                                                              onTagPressed: () {
                                                                context.pushNamed(
                                                                    'CustomerDetails',
                                                                    queryParameters: {
                                                                      'customerId':
                                                                          serializeParam(
                                                                        customerItem[
                                                                            'userId'],
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                      'email':
                                                                          serializeParam(
                                                                        customerItem[
                                                                            'email'],
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                    }).then(
                                                                    (value) => {
                                                                          if (value != null &&
                                                                              value is bool &&
                                                                              value)
                                                                            {
                                                                              safeSetState(() {
                                                                                apiLoaderController.reload?.call();
                                                                              })
                                                                            }
                                                                        });
                                                              },
                                                            );
                                                          } else {
                                                            final tagId =
                                                                customerItem[
                                                                        'tags']
                                                                    [index];
                                                            final TagModel
                                                                element = _model
                                                                    .tagModelWithId(
                                                                        tagId);

                                                            return TagComponentWidget(
                                                              borderRadius: 10,
                                                              alpha: 0.4,
                                                              title:
                                                                  element.title,
                                                              tagColor:
                                                                  element.color,
                                                              selected: element
                                                                  .isSelected,
                                                              onTagPressed: () {
                                                                context.pushNamed(
                                                                    'CustomerDetails',
                                                                    queryParameters: {
                                                                      'customerId':
                                                                          serializeParam(
                                                                        customerItem[
                                                                            'userId'],
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                      'email':
                                                                          serializeParam(
                                                                        customerItem[
                                                                            'email'],
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                    }).then(
                                                                    (value) => {
                                                                          if (value != null &&
                                                                              value is bool &&
                                                                              value)
                                                                            {
                                                                              safeSetState(() {
                                                                                apiLoaderController.reload?.call();
                                                                              })
                                                                            }
                                                                        });
                                                              },
                                                            );
                                                          }
                                                        })
                                                      : []),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animateOnPageLoad(
                      animationsMap['containerOnPageLoadAnimation']!),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }

  void _addNew() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (bottomSheetContext) {
          return GestureDetector(
            onTap: () =>
                FocusScope.of(context).requestFocus(_model.unfocusNode),
            child: Padding(
                padding: MediaQuery.of(bottomSheetContext).viewInsets,
                child: ActionSheetButtonsNewWidget(
                  firstIcon: Icons.ios_share_outlined,
                  firstAction: () async {
                    HapticFeedback.mediumImpact();
                    await InviteLink.shareDynamicLink();
                  },
                  firstActionTitle: 'Compartilhar Link',
                  secondIcon: Icons.email_outlined,
                  secondAction: () async {
                    HapticFeedback.mediumImpact();
                    context.pushNamed('AddCustomer');
                  },
                  secondActionTitle: 'Enviar Convite por E-mail',
                  title: 'Novo Treino',
                )),
          );
        });
  }
}
