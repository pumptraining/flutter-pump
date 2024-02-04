import 'package:api_manager/common/loader_state.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:pump_components/components/action_sheet_buttons_new/action_sheet_buttons_new_widget.dart';
import 'package:pump_components/components/cell_list_workout/cell_list_workout_widget.dart';
import 'package:pump_components/components/training_bottom_sheet_filter/training_bottom_sheet_filter_widget.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:pump_components/components/empty_list/empty_list_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import 'package:pump_creator/pages/workout_picker/workout_picker_widget.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'list_workout_model.dart';
export 'list_workout_model.dart';

class ListWorkoutWidget extends StatefulWidget {
  const ListWorkoutWidget({
    Key? key,
    this.setupExercises,
    bool? showBackButton,
  })  : this.showBackButton = showBackButton ?? false,
        super(key: key);

  final List<dynamic>? setupExercises;
  final bool showBackButton;

  @override
  _ListWorkoutWidgetState createState() => _ListWorkoutWidgetState();
}

class _ListWorkoutWidgetState extends State<ListWorkoutWidget>
    with TickerProviderStateMixin {
  late ListWorkoutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final ApiLoaderController _apiLoaderController = ApiLoaderController();

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
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListWorkoutModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'ListWorkout'});
    _model.textController ??= TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Treinos',
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
                    logFirebaseEvent('LIST_WORKOUT_add_outlined_ICN_ON_TAP');
                    logFirebaseEvent('IconButton_haptic_feedback');
                    HapticFeedback.mediumImpact();
                    logFirebaseEvent('IconButton_navigate_to');

                    _addNew();
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
          child: ApiLoaderWidget(
            apiCall: BaseGroup.personalWorkoutCall,
            controller: _apiLoaderController,
            builder: (context, snapshot) {
              final stackPersonalWorkoutResponse = snapshot?.data;
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
                                controller: _model.textController,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.textController',
                                  Duration(milliseconds: 1000),
                                  () => setState(() {}),
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Buscar treino...',
                                  labelStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  suffixIcon:
                                      _model.textController!.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () async {
                                                _model.textController?.clear();
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
                                style: FlutterFlowTheme.of(context).bodyMedium,
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  logFirebaseEvent(
                                      'LIST_EXERCISES_filter_list_ICN_ON_TAP');
                                  logFirebaseEvent('IconButton_bottom_sheet');
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (bottomSheetContext) {
                                      return GestureDetector(
                                        onTap: () => FocusScope.of(context)
                                            .requestFocus(_unfocusNode),
                                        child: Padding(
                                          padding:
                                              MediaQuery.of(bottomSheetContext)
                                                  .viewInsets,
                                          child:
                                              TrainingBottomSheetFilterWidget(),
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    setState(() {
                                      _model.selectedFilter = value;
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
                            0.0, 12.0, 0.0, 16.0),
                        child: Builder(
                          builder: (context) {
                            var workoutList = getJsonField(
                              stackPersonalWorkoutResponse?.jsonBody,
                              r'''$''',
                            ).toList();

                            workoutList = _model.filterTrainings(workoutList);

                            if (_model.textController.text.isNotEmpty) {
                              workoutList.retainWhere((exercise) {
                                return (exercise['namePortuguese'] as String)
                                    .toLowerCase()
                                    .contains(_model.textController.text);
                              });
                            }

                            if (workoutList.isEmpty) {
                              return EmptyListWidget(
                                buttonTitle: "Adicionar",
                                title: "Sem treinos",
                                message:
                                    "Nenhum treino encontrado.\nAdicione um novo treino.",
                                onButtonPressed: () {
                                  _addNew();
                                },
                              );
                            }

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
                                  imageUrl: workoutListItem['trainingImageUrl'],
                                  title: workoutListItem['namePortuguese'],
                                  subtitle:
                                      _model.mapCategories(workoutListItem),
                                  level: _model.mapSkillLevel(
                                      workoutListItem['trainingLevel']),
                                  levelColor: _model.mapSkillLevelColor(
                                      workoutListItem['trainingLevel']),
                                  workoutId: workoutListItem['_id'],
                                  time: _model
                                      .calculateTotalWorkoutTime(
                                          workoutListItem)
                                      .toString(),
                                      titleImage: 'min',
                                  onTap: (p0) {
                                    if (!widget.showBackButton) {
                                      context.pushNamed(
                                        'WorkoutDetails',
                                        queryParameters: {
                                          'workoutId': serializeParam(
                                            workoutListItem['_id'],
                                            ParamType.String,
                                          ),
                                          'isPersonal': serializeParam(
                                            true,
                                            ParamType.bool,
                                          ),
                                        },
                                      );
                                    }
                                  },
                                  onDetailTap: (p0) {},
                                );

                                rowAndDivider.add(cell);

                                if (workoutListIndex < workoutList.length - 1) {
                                  rowAndDivider.add(
                                    Divider(
                                      indent: 106,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      thickness: 1.0, // Espessura do divisor
                                    ),
                                  );
                                }

                                return Column(
                                  children: rowAndDivider,
                                );
                              },
                            ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation']!);
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
      ),
    );
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
                  firstAction: () async {
                    context.pushNamed('AddWorkout').then((value) {
                      if (value != null && value is bool && value) {
                        _apiLoaderController.reload?.call();
                      }
                    });
                  },
                  firstActionTitle: 'Em Branco',
                  secondAction: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutPickerWidget(
                          showBackButton: true,
                          isPumpList: true,
                        ),
                      ),
                    );

                    if (result != null && result.length > 0) {
                      dynamic selected = result[0];
                      selected['_id'] = null;
                      selected['trainingImageUrl'] =
                          'https://res.cloudinary.com/hssoaq6x7/image/upload/v1704734551/IconAppPump-removebg-preview-4_sxmknd.png';
                      selected['namePortuguese'] = "";
                      selected['nameEnglish'] = null;
                      selected['personalId'] = null;
                      context.pushNamed('AddWorkout', queryParameters: {
                        'workout': serializeParam(selected, ParamType.JSON),
                      }).then((value) {
                        if (value != null && value is bool && value) {
                          _apiLoaderController.reload?.call();
                        }
                      });
                    }
                  },
                  secondActionTitle: 'Usar Modelo',
                  title: 'Novo Treino',
                )),
          );
        });
  }
}
