import 'package:api_manager/api_manager/api_manager.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_flow/upload_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_creator/flutter_flow/nav/nav.dart';
import '../../backend/firebase_analytics/analytics.dart';
import 'edit_profile_model.dart';
export 'edit_profile_model.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({
    Key? key,
    bool? showBackButton,
  })  : this.showBackButton = showBackButton ?? false,
        super(key: key);

  final bool showBackButton;

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late EditProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNodeName = FocusNode();
  final _unfocusNodePhone = FocusNode();
  final _unfocusNodeDescription = FocusNode();
  final ScrollController _scrollController = ScrollController();
  String _bottomButtonText = 'Salvar';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileModel());

    _bottomButtonText = widget.showBackButton ? 'Atualizar' : 'Salvar';

    _unfocusNodeName.addListener(() {
      setState(() {
        if (_unfocusNodeName.hasFocus) {
          _bottomButtonText = 'Confirmar';
          _scrollController.animateTo(
            _scrollController.offset + 100.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            _scrollController.offset - 100.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          _bottomButtonText = widget.showBackButton ? 'Atualizar' : 'Salvar';
        }
      });
    });

    _unfocusNodePhone.addListener(() {
      setState(() {
        if (_unfocusNodePhone.hasFocus) {
          _bottomButtonText = 'Confirmar';
          _scrollController.animateTo(
            _scrollController.offset + 100.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            _scrollController.offset - 100.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          _bottomButtonText = widget.showBackButton ? 'Atualizar' : 'Salvar';
        }
      });
    });

    _unfocusNodeDescription.addListener(() {
      setState(() {
        if (_unfocusNodeDescription.hasFocus) {
          _bottomButtonText = 'Confirmar';
          _scrollController.animateTo(
            _scrollController.offset + 150.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            _scrollController.offset - 150.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          _bottomButtonText = widget.showBackButton ? 'Atualizar' : 'Salvar';
        }
      });
    });

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'EditProfile'});
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
        _unfocusNodeName.unfocus();
        _unfocusNodePhone.unfocus();
        _unfocusNodeDescription.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: false,
          bottom: false,
          child: FutureBuilder<ApiCallResponse>(
            future: BaseGroup.personalDetailsCall.call(),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                );
              }
              final stackPersonalDetailsResponse = snapshot.data!;
              if (_model.personal == null &&
                  stackPersonalDetailsResponse.jsonBody['response'] != null) {
                _model.personal =
                    stackPersonalDetailsResponse.jsonBody['response'];
              }
              return Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5,
                                  color: Color(0x430F1113),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 100, 0, 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 0),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                              ),
                                            ),
                                            child: Visibility(
                                              visible: currentUserPhoto
                                                      .isNotEmpty ||
                                                  _model.imagePath != null ||
                                                  (stackPersonalDetailsResponse
                                                              .jsonBody !=
                                                          null &&
                                                      BaseGroup
                                                              .personalDetailsCall
                                                              .imageUrl(
                                                                  stackPersonalDetailsResponse
                                                                      .jsonBody)
                                                              ?.isNotEmpty ==
                                                          true),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: _model.imagePath !=
                                                          null
                                                      ? Image.asset(
                                                          _model.imagePath!,
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : (stackPersonalDetailsResponse
                                                                      .jsonBody !=
                                                                  null &&
                                                              BaseGroup
                                                                      .personalDetailsCall
                                                                      .imageUrl(
                                                                          stackPersonalDetailsResponse
                                                                              .jsonBody)
                                                                      ?.isNotEmpty ==
                                                                  true)
                                                          ? CachedNetworkImage(
                                                              imageUrl: BaseGroup
                                                                  .personalDetailsCall
                                                                  .imageUrl(
                                                                      stackPersonalDetailsResponse
                                                                          .jsonBody)!,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.network(
                                                              currentUserPhoto,
                                                              width: 100,
                                                              height: 100,
                                                              fit: BoxFit.cover,
                                                            ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 12, 0, 12),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'EDIT_PROFILE_PAGE_EDITAR_FOTO_BTN_ON_TAP');
                                              logFirebaseEvent(
                                                  'Button_store_media_for_upload');

                                              final selectedMedia =
                                                  await selectMediaWithSourceBottomSheet(
                                                context: context,
                                                allowVideo: false,
                                                allowPhoto: true,
                                              );
                                              if (selectedMedia != null &&
                                                  selectedMedia.isNotEmpty) {
                                                if (selectedMedia.first
                                                    .filePath!.isNotEmpty) {
                                                  _model.imagePath =
                                                      selectedMedia
                                                          .first.filePath;
                                                }
                                              }

                                              setState(() {
                                                if (selectedMedia != null &&
                                                    selectedMedia.isNotEmpty) {
                                                  _model.setMediaNull();
                                                }
                                              });
                                            },
                                            text: 'Editar Foto',
                                            options: FFButtonOptions(
                                              width: 130,
                                              height: 40,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 20, 20, 16),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  focusNode: _unfocusNodeName,
                                                  maxLength: 50,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  controller:
                                                      _model.textController1 ??=
                                                          TextEditingController(
                                                    text: BaseGroup
                                                            .personalDetailsCall
                                                            .name(
                                                              stackPersonalDetailsResponse
                                                                  .jsonBody,
                                                            )
                                                            ?.toString() ??
                                                        currentUserDisplayName,
                                                  ),
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    counterText: '',
                                                    labelText: 'Nome',
                                                    labelStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium,
                                                    hintStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20.0,
                                                                24.0,
                                                                20.0,
                                                                24.0),
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                  maxLines: 1,
                                                  validator: _model
                                                      .textController1Validator
                                                      .asValidator(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 0, 20, 16),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  maxLength: 80,
                                                  controller:
                                                      _model.textController2 ??=
                                                          TextEditingController(
                                                    text: BaseGroup
                                                            .personalDetailsCall
                                                            .email(
                                                              stackPersonalDetailsResponse
                                                                  .jsonBody,
                                                            )
                                                            ?.toString() ??
                                                        currentUserEmail,
                                                  ),
                                                  obscureText: false,
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                    counterText: '',
                                                    labelText: 'E-mail',
                                                    labelStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium,
                                                    hintStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20.0,
                                                                24.0,
                                                                20.0,
                                                                24.0),
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                      ),
                                                  maxLines: 1,
                                                  validator: _model
                                                      .textController2Validator
                                                      .asValidator(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 0, 20, 16),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  focusNode: _unfocusNodePhone,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    MaskTextInputFormatter(
                                                        mask:
                                                            '+55 (##) # ####-####',
                                                        filter: {
                                                          "#": RegExp(r'[0-9]')
                                                        },
                                                        type:
                                                            MaskAutoCompletionType
                                                                .lazy)
                                                  ],
                                                  controller:
                                                      _model.textController4 ??=
                                                          TextEditingController(
                                                    text: _model
                                                        .formatPhoneNumberText(
                                                            _model.personal[
                                                                    'phone'] ??
                                                                ''),
                                                  ),
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    counterText: '',
                                                    labelText: 'WhatsApp',
                                                    labelStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium,
                                                    hintStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20.0,
                                                                24.0,
                                                                20.0,
                                                                24.0),
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                  maxLines: 1,
                                                  validator: _model
                                                      .textController4Validator
                                                      .asValidator(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 0, 20, 16),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  width: 100,
                                                  height: 144,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: TextFormField(
                                                    focusNode:
                                                        _unfocusNodeDescription,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    controller: _model
                                                            .textController5 ??=
                                                        TextEditingController(
                                                      text: BaseGroup
                                                              .personalDetailsCall
                                                              .description(
                                                                stackPersonalDetailsResponse
                                                                    .jsonBody,
                                                              )
                                                              ?.toString() ??
                                                          '',
                                                    ),
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      counterText: '',
                                                      labelText: 'Sobre',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      filled: true,
                                                      fillColor: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  24.0,
                                                                  20.0,
                                                                  24.0),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                    maxLines: 5,
                                                    validator: _model
                                                        .textController5Validator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                              ),
                                            ],
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
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.showBackButton,
                    child: Align(
                      alignment: AlignmentDirectional(0, -0.87),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x520E151B),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                  child: FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 20,
                                    borderWidth: 1,
                                    buttonSize: 40,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    icon: Icon(
                                      Icons.arrow_back_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'EDIT_PROFILE_arrow_back_rounded_ICN_ON_T');
                                      logFirebaseEvent(
                                          'IconButton_navigate_back');
                                      context.pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BottomButtonFixedWidget(
                      buttonTitle: _bottomButtonText,
                      onPressed: () async {
                        if (_unfocusNodeDescription.hasFocus ||
                            _unfocusNodeName.hasFocus ||
                            _unfocusNodePhone.hasFocus) {
                          _unfocusNodeName.unfocus();
                          _unfocusNodePhone.unfocus();
                          _unfocusNodeDescription.unfocus();
                          return;
                        }
                        await _saveProfile();
                      }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    HapticFeedback.selectionClick();

    _model.setPersonal();

    if (!_model.canSave()) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Atenção'),
            content: Text(
                'Antes de salvar, preencha todos os campos, incluindo seu nome, número de telefone e foto de perfil.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_model.needUploadImage()) {
      try {
        final result = await UploadImageCall.call(_model.imagePath!);

        final json = jsonDecode(result.body);
        _model.setMedia(json);
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text(
                  'Ocorreu um erro ao fazer o upload da imagem. Por favor, tente novamente.'),
              actions: [
                TextButton(
                  child: Text('Fechar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    final result =
        await BaseGroup.updatePersonalCall.call(params: _model.personal);

    if (result.succeeded) {
      logFirebaseEvent('Button_navigate_back');
      context.safePop();
      logFirebaseEvent('Button_show_snack_bar');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Perfil atualizado.',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    } else {
      logFirebaseEvent('Button_alert_dialog');
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
}
