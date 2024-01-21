import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_model.dart';
import 'package:font_awesome_flutter/src/fa_icon.dart';

class BottomButtonFixedWidget extends StatefulWidget {
  const BottomButtonFixedWidget({Key? key, required this.buttonTitle, required this.onPressed, this.icon}) : super(key: key);

  final String buttonTitle;
  final Future<void> Function() onPressed;
  final FaIcon? icon;

  @override
  // ignore: library_private_types_in_public_api
  _BottomButtonFixedState createState() => _BottomButtonFixedState();
}

class _BottomButtonFixedState extends State<BottomButtonFixedWidget> {
  late BottomButtonFixedModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomButtonFixedModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Container(
        width: double.infinity,
        height: 100.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 2.0),
            )
          ],
        ),
        child: Align(
          alignment: AlignmentDirectional(0.0, 0.05),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 32.0),
            child: FFButtonWidget(
              showLoadingIndicator: true,
              onPressed: () async {
                await widget.onPressed(); 
              },
              icon: widget.icon,
              text: widget.buttonTitle,
              options: FFButtonOptions(
                width: double.infinity,
                height: 50.0,
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                elevation: 2.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
