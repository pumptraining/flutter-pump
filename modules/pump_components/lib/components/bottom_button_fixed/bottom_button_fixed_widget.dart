import 'package:flutter/material.dart';
import 'package:flutter_flow/common/utils.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_model.dart';
import 'package:pump_components/components/bottom_gradient_component/bottom_gradient_component_widget.dart';

class BottomButtonFixedWidget extends StatefulWidget {
  const BottomButtonFixedWidget({
    Key? key,
    required this.buttonTitle,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  final String buttonTitle;
  final Future<void> Function() onPressed;
  final Icon? icon;

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
    return Stack(
      children: [
        BottomGradientComponentWidget(),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: Utils.getBottomSafeArea(context) == 0
              ? 16
              : Utils.getBottomSafeArea(context),
          child: FFButtonWidget(
            onPressed: () async {
              await widget.onPressed.call();
            },
            icon: widget.icon,
            text: widget.buttonTitle.toUpperCase(),
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsets.zero,
              color: FlutterFlowTheme.of(context).primaryText,
              textStyle: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
              elevation: 2.0,
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ],
    );
  }
}
