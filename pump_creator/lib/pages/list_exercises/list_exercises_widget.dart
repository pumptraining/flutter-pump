import 'package:api_manager/common/loader_state.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/bottom_sheet_filter/bottom_sheet_filter_widget.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_flow/common/user_settings.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:pump_components/components/subscribe_screen/subscribe_screen_widget.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'list_exercises_model.dart';
export 'list_exercises_model.dart';

class ListExercisesWidget extends StatefulWidget {
  const ListExercisesWidget({
    Key? key,
    bool? showBackButton,
    this.selectedCategories,
    this.personalExercises,
    this.isPicker,
  })  : this.showBackButton = showBackButton ?? false,
        super(key: key);

  final bool showBackButton;
  final List<String>? selectedCategories;
  final List<dynamic>? personalExercises;
  final bool? isPicker;

  @override
  _ListExercisesWidgetState createState() => _ListExercisesWidgetState();
}

class _ListExercisesWidgetState extends State<ListExercisesWidget>
    with TickerProviderStateMixin {
  late ListExercisesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  final animationsMap = {
    'textOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: Offset(-60.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 50.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'listViewOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 50.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  final ApiLoaderController _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListExercisesModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'ListExercises'});
    _model.textController ??= TextEditingController();

    _model.controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _model.isPicker = widget.isPicker ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _unfocusNode.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Exercícios',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
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
                  fillColor: FlutterFlowTheme.of(context).primary,
                  icon: Icon(
                    Icons.add_outlined,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  onPressed: () async {
                    logFirebaseEvent('LIST_EXERCISES_add_outlined_ICN_ON_TAP');
                    logFirebaseEvent('IconButton_navigate_to');

                    if (_model.resposeData != null) {
                      addExercise(context);
                      logFirebaseEvent('IconButton_haptic_feedback');
                      HapticFeedback.mediumImpact();
                    }
                  },
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
          leading: Container(
            padding: EdgeInsets.all(8.0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 20.0,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 20.0,
              ),
              onPressed: () async {
                context.pop(true);
              },
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, -1.01),
                child: ApiLoaderWidget(
                  apiCall: BaseGroup.personalExercisesCall,
                  controller: _apiLoaderController,
                  builder: (context, snapshot) {
                    final columnPersonalExercisesResponse = snapshot?.data;
                    _model.resposeData = columnPersonalExercisesResponse;
                    return RefreshIndicator(
                      onRefresh: () async {
                        _apiLoaderController.reload?.call();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 32.0, 16.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      focusNode: _unfocusNode,
                                      controller: _model.textController,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.textController',
                                        Duration(milliseconds: 1000),
                                        () => setState(() {}),
                                      ),
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Buscar exercício...',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        suffixIcon: _model
                                                .textController!.text.isNotEmpty
                                            ? InkWell(
                                                onTap: () async {
                                                  _model.textController
                                                      ?.clear();
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.clear,
                                                  color: Color(0xFF757575),
                                                  size: 22.0,
                                                ),
                                              )
                                            : null,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      validator: _model.textControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 0.0, 0.0),
                                    child: FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 30.0,
                                      borderWidth: 1.0,
                                      buttonSize: 44.0,
                                      icon: Icon(
                                        Icons.filter_list,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 24.0,
                                      ),
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'LIST_EXERCISES_filter_list_ICN_ON_TAP');
                                        logFirebaseEvent(
                                            'IconButton_bottom_sheet');
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (bottomSheetContext) {
                                            return GestureDetector(
                                              onTap: () => FocusScope.of(
                                                      context)
                                                  .requestFocus(_unfocusNode),
                                              child: Padding(
                                                padding: MediaQuery.of(
                                                        bottomSheetContext)
                                                    .viewInsets,
                                                child:
                                                    BottomSheetFilterWidget(),
                                              ),
                                            );
                                          },
                                        ).then((value) {
                                          setState(() {
                                            _model.selectedCategories = value;
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, _model.isPicker ? 100 : 16.0),
                              child: Builder(
                                builder: (context) {
                                  final personalList = BaseGroup
                                          .personalExercisesCall
                                          .personalExercises(
                                              columnPersonalExercisesResponse
                                                  ?.jsonBody)
                                          ?.toList() ??
                                      [];

                                  if (_model.selectedCategories?.isNotEmpty ??
                                      false) {
                                    personalList.retainWhere((exercise) {
                                      return _model.selectedCategories
                                              ?.contains(exercise['category']
                                                  ['name'] as String) ??
                                          false;
                                    });
                                  }

                                  if (_model.textController.text.isNotEmpty) {
                                    personalList.retainWhere((exercise) {
                                      return (exercise['name'] as String)
                                          .toLowerCase()
                                          .contains(_model.textController.text);
                                    });
                                  }

                                  if (personalList.isEmpty) {
                                    if (_model.selectedCategories?.isNotEmpty ??
                                        false) {
                                      return EmptyListWidget(
                                        buttonTitle: "Filtrar",
                                        title: "Sem exercícios",
                                        message:
                                            "Nenhum exercício encontrado.\nFiltre novamente ou adicione um novo exercício.",
                                        onButtonPressed: () {
                                          logFirebaseEvent(
                                              'LIST_EXERCISES_filter_list_ICN_ON_TAP');
                                          logFirebaseEvent(
                                              'IconButton_bottom_sheet');
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (bottomSheetContext) {
                                              return GestureDetector(
                                                onTap: () => FocusScope.of(
                                                        context)
                                                    .requestFocus(_unfocusNode),
                                                child: Padding(
                                                  padding: MediaQuery.of(
                                                          bottomSheetContext)
                                                      .viewInsets,
                                                  child:
                                                      BottomSheetFilterWidget(),
                                                ),
                                              );
                                            },
                                          ).then((value) {
                                            setState(() {
                                              _model.selectedCategories = value;
                                            });
                                          });
                                        },
                                      );
                                    } else {
                                      return EmptyListWidget(
                                        buttonTitle: "Adicionar",
                                        title: "Sem exercícios",
                                        message:
                                            "Nenhum exercício encontrado.\nAdicione um novo exercício.",
                                        onButtonPressed: () {
                                          addExercise(context);
                                        },
                                      );
                                    }
                                  }
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: personalList.length,
                                    itemBuilder: (context, personalListIndex) {
                                      final personalListItem =
                                          personalList[personalListIndex];
                                      return Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 4.0, 16.0, 8.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (!_model.isPicker) {
                                              Utils.showExerciseVideo(context,
                                                  personalListItem['videoUrl']);
                                            } else {
                                              setState(() {
                                                if (_model.selectedExercises
                                                    .any((element) =>
                                                        element['_id'] ==
                                                        personalListItem[
                                                            '_id'])) {
                                                  _model.selectedExercises
                                                      .removeWhere((element) =>
                                                          element['_id'] ==
                                                          personalListItem[
                                                              '_id']);
                                                } else {
                                                  _model.selectedExercises
                                                      .add(personalListItem);
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 90.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Color(0x32000000),
                                                  offset: Offset(0.0, 2.0),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          personalListItem[
                                                              'imageUrl'],
                                                      width: 70.0,
                                                      height: 70.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AutoSizeText(
                                                            personalListItem[
                                                                'name'],
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium,
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    AutoSizeText(
                                                                  personalListItem[
                                                                          'equipament']
                                                                      ['name'],
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: personalListItem[
                                                            'canEdit'] &&
                                                        !_model.isPicker,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  8.0,
                                                                  0.0),
                                                      child: Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Builder(
                                                            builder: (context) =>
                                                                FlutterFlowIconButton(
                                                              borderColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                              borderRadius:
                                                                  20.0,
                                                              borderWidth: 1.0,
                                                              buttonSize: 40.0,
                                                              fillColor: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              icon: Icon(
                                                                Icons.more_vert,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 24.0,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                showModalBottomSheet(
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                  context:
                                                                      context,
                                                                  useSafeArea:
                                                                      true,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          ListTile(
                                                                            leading:
                                                                                Icon(Icons.edit),
                                                                            title:
                                                                                Text('Editar'),
                                                                            onTap:
                                                                                () {
                                                                              context.safePop();
                                                                              context.pushNamed(
                                                                                'AddExercise',
                                                                                queryParameters: {
                                                                                  'exercise': serializeParam(
                                                                                    personalListItem,
                                                                                    ParamType.JSON,
                                                                                  ),
                                                                                  'categories': serializeParam(
                                                                                    BaseGroup.personalExercisesCall.categories(
                                                                                      columnPersonalExercisesResponse?.jsonBody,
                                                                                    ),
                                                                                    ParamType.JSON,
                                                                                    true,
                                                                                  ),
                                                                                  'equipment': serializeParam(
                                                                                    getJsonField(
                                                                                      columnPersonalExercisesResponse?.jsonBody,
                                                                                      r'''$.equipments''',
                                                                                    ),
                                                                                    ParamType.JSON,
                                                                                    true,
                                                                                  ),
                                                                                  'isUpdate': serializeParam(
                                                                                    true,
                                                                                    ParamType.bool,
                                                                                  ),
                                                                                }.withoutNulls,
                                                                              );
                                                                            },
                                                                          ),
                                                                          Divider(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            indent:
                                                                                16,
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                Utils.getBottomSafeArea(context)),
                                                                            child:
                                                                                ListTile(
                                                                              leading: Icon(Icons.cancel),
                                                                              title: Text('Cancelar'),
                                                                              onTap: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: _model.isPicker,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  6.0,
                                                                  0.0,
                                                                  8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Theme(
                                                            data: ThemeData(
                                                              checkboxTheme:
                                                                  CheckboxThemeData(),
                                                              unselectedWidgetColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                            ),
                                                            child: Checkbox(
                                                              value: _model
                                                                  .selectedExercises
                                                                  .any((element) =>
                                                                      element[
                                                                          '_id'] ==
                                                                      personalListItem[
                                                                          '_id']),
                                                              onChanged:
                                                                  (newValue) async {
                                                                setState(() {
                                                                  if (_model
                                                                      .selectedExercises
                                                                      .any((element) =>
                                                                          element[
                                                                              '_id'] ==
                                                                          personalListItem[
                                                                              '_id'])) {
                                                                    _model.selectedExercises.removeWhere((element) =>
                                                                        element[
                                                                            '_id'] ==
                                                                        personalListItem[
                                                                            '_id']);
                                                                  } else {
                                                                    _model
                                                                        .selectedExercises
                                                                        .add(
                                                                            personalListItem);
                                                                  }
                                                                });
                                                              },
                                                              activeColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
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
                                        ).animateOnPageLoad(animationsMap[
                                            'containerOnPageLoadAnimation']!),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: _model.isPicker,
                child: BottomButtonFixedWidget(
                  buttonTitle: 'Confirmar',
                  onPressed: () async {
                    if (_unfocusNode.hasFocus) {
                      _unfocusNode.unfocus();
                      return;
                    }
                    Navigator.pop(context, _model.selectedExercises);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addExercise(BuildContext context) {
    if (UserSettings().isSubscriber()) {
      context.pushNamed(
        'AddExercise',
        queryParameters: {
          'categories': serializeParam(
            BaseGroup.personalExercisesCall.categories(
              _model.resposeData!.jsonBody,
            ),
            ParamType.JSON,
            true,
          ),
          'equipment': serializeParam(
            getJsonField(
              _model.resposeData!.jsonBody,
              r'''$.equipments''',
            ),
            ParamType.JSON,
            true,
          ),
          'isUpdate': serializeParam(
            false,
            ParamType.bool,
          ),
        }.withoutNulls,
      );
    } else {
      showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
              height: MediaQuery.of(context).size.height,
              child: SubscribeScreenWidget(),
            );
          }).then((value) => {
            if (value != null && value is bool && value) {context.pop(true)}
          });
    }
  }
}
