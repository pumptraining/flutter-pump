import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/nav/serialization_util.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/tag_component/tag_component_widget.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'add_customer_model.dart';
export 'add_customer_model.dart';

class AddCustomerWidget extends StatefulWidget {
  const AddCustomerWidget({
    Key? key,
    this.isEdit,
    this.selectedTags,
    this.email,
  }) : super(key: key);

  final bool? isEdit;
  final List<dynamic>? selectedTags;
  final String? email;

  @override
  _AddCustomerWidgetState createState() => _AddCustomerWidgetState();
}

class _AddCustomerWidgetState extends State<AddCustomerWidget> {
  late AddCustomerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _bottomButtonText = 'Atualizar';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddCustomerModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'AddCustomer'});
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textControllerAlert ??= TextEditingController();
    _model.textFieldFocusNodeAlert ??= FocusNode();

    _model.isEdit = widget.isEdit ?? false;
    _model.email = widget.email ?? '';
    _model.selectedTags = widget.selectedTags ?? [];

    _model.textFieldFocusNode1!.addListener(() {
      setState(() {
        if (_model.textFieldFocusNode1!.hasFocus) {
          _bottomButtonText = 'Confirmar';
        } else {
          _bottomButtonText = _model.isEdit ? 'Atualizar' : 'Enviar Convite';
        }
      });
    });

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

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            _model.isEdit ? 'Editar Tags' : 'Novo Aluno',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                ),
          ),
          actions: [],
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
                context.safePop();
              },
            ),
          ),
        ),
        body: ApiLoaderWidget(
          apiCall: BaseGroup.personalTagsCall,
          builder: (context, snapshot) {
            _model.content = snapshot?.data?.jsonBody['response'];
            _model.createTagModels();
            return buildContent(context);
          },
        ));
  }

  Widget buildContent(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_model.textFieldFocusNode1 != null &&
            _model.textFieldFocusNode1!.hasFocus) {
          _model.textFieldFocusNode1!.unfocus();
        }
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Visibility(
                  visible: !_model.isEdit,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Informações do aluno',
                            style: FlutterFlowTheme.of(context).bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !_model.isEdit,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: TextFormField(
                              controller: _model.textController1,
                              focusNode: _model.textFieldFocusNode1,
                              obscureText: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                hintStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
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
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              maxLength: 200,
                              maxLengthEnforcement: MaxLengthEnforcement.none,
                              buildCounter: (context,
                                      {required currentLength,
                                      required isFocused,
                                      maxLength}) =>
                                  null,
                              keyboardType: TextInputType.emailAddress,
                              validator: _model.textController1Validator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: Text(
                          'Selecione as tags',
                          style: FlutterFlowTheme.of(context).bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Text(
                          'Facilite a gestão e acompanhamento, atribuindo tags de nível, objetivo e preferências',
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 12.0,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 24.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 8, 16),
                          child: Wrap(
                            spacing: 6.0,
                            runSpacing: 6.0,
                            children: _model.tags!.map((element) {
                              return TagComponentWidget(
                                alpha: 0.4,
                                title: element.title,
                                tagColor: element.color,
                                selected: element.isSelected,
                                maxHeight: 28,
                                borderRadius: 14,
                                onTagPressed: () {
                                  setState(() {
                                    element.isSelected = !element.isSelected;
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      _dialogBuilder(context);
                    },
                    text: 'Nova Tag',
                    icon: Icon(
                      Icons.add,
                      size: 20,
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primaryText,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                            fontFamily: 'Poppins',
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            fontSize: 14.0,
                          ),
                      elevation: 3.0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primaryText,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomButtonFixedWidget(
              buttonTitle: _bottomButtonText,
              onPressed: () async {
                if (_model.textFieldFocusNode1!.hasFocus) {
                  _model.textFieldFocusNode1!.unfocus();
                  return;
                }

                if (_model.isEdit) {
                  dynamic payload = {};
                  payload['tags'] = _model.getSelectedTags();
                  payload['email'] = _model.email;

                  final result =
                      await BaseGroup.editCustomerTagCall.call(params: payload);

                  await requestResponse(
                      result.succeeded, 'Tags atualizadas.', true);
                  return;
                }

                String? errorMessage = _model.validateEmail();

                if (errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        errorMessage,
                      ),
                    ),
                  );
                  return;
                }

                dynamic payload = {};
                payload['tags'] = _model.getSelectedTags();
                payload['email'] = _model.textController1.text;

                final result =
                    await BaseGroup.inviteCustomersCall.call(params: payload);

                await requestResponse(
                    result.succeeded, 'Convite enviado.', false);
              }),
        ],
      ),
    );
  }

  Future<void> requestResponse(
      bool succeeded, String sucessesMessage, bool pop) async {
    if (succeeded) {
      if (pop) {
        context.pop(true);
      } else {
        context.pushNamed('CustomerDetails', queryParameters: {
          'customerId': serializeParam(
            '',
            ParamType.String,
          ),
          'email': serializeParam(
            _model.textController1.text,
            ParamType.String,
          ),
          'reloadBack': serializeParam(
            true,
            ParamType.bool,
          ),
        }).then((value) => {context.pop(true)});
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            sucessesMessage,
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Ooops'),
            content:
                Text('Ocorreu um erro inesperado. Por favor, tente novamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = Colors.blue;

        return AlertDialog(
          title: const Text('Nova Tag'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _model.textControllerAlert,
                focusNode: _model.textFieldFocusNodeAlert,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Tag',
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  hintStyle: FlutterFlowTheme.of(context).labelMedium,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primaryBackground,
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
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
                maxLength: 50,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) =>
                    null,
                validator:
                    _model.textController1ValidatorAlert.asValidator(context),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: MaterialColorPicker(
                  allowShades: false,
                  onMainColorChange: (value) {
                    selectedColor = value?[500] ?? Colors.blue;
                  },
                  selectedColor: Colors.blue,
                  colors: [
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                    Colors.yellow,
                    Colors.orange,
                    Colors.purple,
                    Colors.pink,
                    Colors.cyan,
                    Colors.brown,
                    Colors.grey,
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Adicionar'),
              onPressed: () {
                Navigator.of(context).pop();

                if (_model.textControllerAlert.text.isNotEmpty) {
                  setState(() {
                    _model.addNewTag(
                        _model.textControllerAlert.text, selectedColor);
                  });
                  _model.textControllerAlert.text = "";
                }
              },
            ),
          ],
        );
      },
    );
  }
}
