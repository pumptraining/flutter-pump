import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:go_router/go_router.dart';
import '../cell_list_workout/cell_list_workout_widget.dart';
import 'edit_workout_model.dart';
export 'edit_workout_model.dart';

class EditWorkoutWidget extends StatefulWidget {
  const EditWorkoutWidget({
    Key? key,
    this.dto,
    this.index,
    this.onButtonDeletePressed,
  }) : super(key: key);

  final dynamic dto;
  final int? index;
  final ValueChanged<int?>? onButtonDeletePressed;

  @override
  _EditWorkoutWidgetState createState() => _EditWorkoutWidgetState();
}

class _EditWorkoutWidgetState extends State<EditWorkoutWidget> {
  late EditWorkoutModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditWorkoutModel());
    _model.setValues(widget.dto);

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: 750.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 2.0),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70.0,
                        height: 2.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CellListWorkoutWidget(
                          imageUrl: _model.dto['trainingImageUrl'],
                          title: _model.dto['namePortuguese'],
                          subtitle: _model.mapCategories(_model.dto),
                          level:
                              _model.mapSkillLevel(_model.dto['trainingLevel']),
                          levelColor: _model
                              .mapSkillLevelColor(_model.dto['trainingLevel']),
                          workoutId: _model.dto['_id'],
                          time: '',
                          titleImage: '',
                          onTap: (p0) {
                            context.pushNamed(
                              'WorkoutDetails',
                              queryParameters: {
                                'workoutId': serializeParam(
                                  _model.dto['_id'],
                                  ParamType.String,
                                ),
                                'isPersonal': serializeParam(
                                  true,
                                  ParamType.bool,
                                ),
                              },
                            );
                          },
                          onDetailTap: (p0) {},
                        ),
                      ),
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 20,
                        borderWidth: 1,
                        buttonSize: 34,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        icon: Icon(
                          Icons.delete_outlined,
                          color: FlutterFlowTheme.of(context).error,
                          size: 16,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Atenção"),
                                content: Text(
                                    "Tem certeza que deseja remover o treino do programa?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancelar"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Remover"),
                                    onPressed: () {
                                      if (widget.onButtonDeletePressed !=
                                          null) {
                                        widget.onButtonDeletePressed!(
                                            widget.index);
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
