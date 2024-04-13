import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_flow/flutter_flow_choice_chips.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/form_field_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter_flow/transition_info.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:pump/flutter_flow/nav/nav.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/header_component/header_component_widget.dart';
import 'package:pump_components/components/profile_header_component/profile_header_component_widget.dart';
import 'package:pump_components/components/pump_app_bar/pump_app_bar.dart';
import 'package:pump_components/components/tag_component/tag_component_widget.dart';
import 'package:pump_components/components/two_count_component/two_count_component_widget.dart';
import 'completed_workout_model.dart';
export 'completed_workout_model.dart';

class CompletedWorkoutWidget extends StatefulWidget {
  const CompletedWorkoutWidget(
      {Key? key,
      this.workoutId,
      this.userId,
      this.totalSecondsTime,
      this.timeString,
      this.imageUrl,
      this.personalId,
      this.personalImageUrl,
      this.level})
      : super(key: key);

  final String? workoutId;
  final String? userId;
  final int? totalSecondsTime;
  final String? timeString;
  final String? imageUrl;
  final String? personalId;
  final String? personalImageUrl;
  final String? level;

  @override
  _CompletedWorkoutWidgetState createState() => _CompletedWorkoutWidgetState();
}

class _CompletedWorkoutWidgetState extends State<CompletedWorkoutWidget>
    with TickerProviderStateMixin {
  late CompletedWorkoutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CompletedWorkoutModel());

    _model.textController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApiLoaderWidget(
      apiCall: PumpGroup.completeWorkoutCall,
      params: {
        'trainingId': widget.workoutId,
        'userId': widget.userId,
        'totalSecondsTime': widget.totalSecondsTime
      },
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: PumpAppBar(
              title: 'Treino Concluído',
              hasBackButton: false,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        TwoCountComponentWidget(
                            firstTitle: '${widget.level?.toLowerCase()}',
                            secondTitle: widget.timeString ?? '00:00',
                            secondIcon: Icons.timer_outlined,
                            firstIcon: Icons.bar_chart),
                        ProfileHeaderComponentWidget(
                            rightIconSize: 12,
                            intent: 16,
                            endIntent: 16,
                            safeArea: false,
                            subtitle: 'Dê seu feedback',
                            name: 'Como foi seu treino?',
                            imageUrl: widget.personalImageUrl ?? ''),
                        HeaderComponentWidget(
                          title: 'Intensidade',
                          subtitle:
                              'Selecione o nível de intensidade para esse treino',
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16, 16.0, 16.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 8, 16),
                                  child: Wrap(
                                    spacing: 6.0,
                                    runSpacing: 6.0,
                                    children: (['Baixo', 'Moderado', 'Alto'])
                                        .map<Widget>((element) {
                                      return TagComponentWidget(
                                        selectedTextColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        title: element,
                                        tagColor: FlutterFlowTheme.of(context)
                                            .primary,
                                        selected:
                                            _model.choiceChipsValue == element,
                                        maxHeight: 24,
                                        onTagPressed: () {
                                          safeSetState(() {
                                            _model.choiceChipsValue = element;
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        HeaderComponentWidget(
                          title: 'Avaliação',
                          subtitle:
                              'Deixe uma avaliação para esse treino e nos ajude a oferecer um treino cada vez melhor',
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 0.0, 0.0),
                          child: RatingBar.builder(
                            onRatingUpdate: (newValue) => setState(
                                () => _model.ratingBarValue = newValue),
                            itemBuilder: (context, index) => Icon(
                              Icons.star_rounded,
                              color: FlutterFlowTheme.of(context).tertiary,
                            ),
                            direction: Axis.horizontal,
                            initialRating: _model.ratingBarValue ??= 0.0,
                            unratedColor: FlutterFlowTheme.of(context).accent3,
                            itemCount: 5,
                            itemSize: 24.0,
                            glowColor: FlutterFlowTheme.of(context).tertiary,
                          ),
                        ),
                        Container(
                          height: 200.0,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 24.0, 16.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _model.textController,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Comentário',
                                labelStyle: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText),
                                hintStyle:
                                    FlutterFlowTheme.of(context).bodySmall,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              maxLines: null,
                              maxLength: 250,
                              validator: _model.textControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ]),
                ),
                BottomButtonFixedWidget(
                  buttonTitle: 'Voltar',
                  onPressed: () async {
                    HapticFeedback.mediumImpact();

                    await PumpGroup.feedbackCall.call(
                        personalId: widget.personalId,
                        trainingId: widget.workoutId,
                        userId: widget.userId,
                        intensity: _model.getIntensity(),
                        rating: _model.ratingBarValue?.toInt(),
                        feedbackText: _model.textController.text);

                    await context.pushNamed(
                      'Home',
                      queryParameters: {
                        'canShowFeedback': serializeParam(
                          true,
                          ParamType.bool,
                        ),
                      },
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                        ),
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
