import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'bottom_gradient_component_model.dart';
export 'bottom_gradient_component_model.dart';

class BottomGradientComponentWidget extends StatefulWidget {
  const BottomGradientComponentWidget({super.key});

  @override
  State<BottomGradientComponentWidget> createState() =>
      _BottomGradientComponentWidgetState();
}

class _BottomGradientComponentWidgetState
    extends State<BottomGradientComponentWidget> {
  late BottomGradientComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomGradientComponentModel());
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
          gradient: LinearGradient(
            colors: [
              Color(0x001D2428),
              FlutterFlowTheme.of(context).primaryBackground
            ],
            stops: [0.0, 1.0],
            begin: AlignmentDirectional(0.0, -1.0),
            end: AlignmentDirectional(0, 1.0),
          ),
        ),
      ),
    );
  }
}
