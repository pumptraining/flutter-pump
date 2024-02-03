import 'package:pump_components/components/error_component/error_component_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import '../api_requests/pump_creator_api_calls.dart';

class ApiLoaderController {
  void Function()? reload;
}

class ApiLoaderWidget extends StatefulWidget {
  const ApiLoaderWidget({
    Key? key,
    required this.apiCall,
    this.params,
    required this.builder,
    this.controller,
  }) : super(key: key);

  final Requestable apiCall;
  final dynamic params;
  final Widget Function(
      BuildContext context, AsyncSnapshot<ApiCallResponse>? snapshot) builder;
  final ApiLoaderController? controller; 

  @override
  // ignore: library_private_types_in_public_api
  _ApiLoaderWidgetState createState() => _ApiLoaderWidgetState();
}

class _ApiLoaderWidgetState extends State<ApiLoaderWidget> {
  ApiCallResponse? response;
  bool isLoading = false;
  bool isError = false;

  void reload() {
    setState(() {
      response = null;
    });

    loadApiContent(widget.apiCall, params: widget.params);
  }

  Future<ApiCallResponse?>? loadApiContent(Requestable apiCall,
      {dynamic params}) async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    response ??= await apiCall.call(params: params);

    setState(() {
      isLoading = false;
      isError = !(response?.succeeded ?? true);
    });

    return response;
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.reload = reload;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadApiContent(widget.apiCall, params: widget.params);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: SizedBox(
            width: 40.0,
            height: 40.0,
            child: CircularProgressIndicator(strokeWidth: 1.0,
              color: FlutterFlowTheme.of(context).primary,
            ),
          ),
        ),
      );
    }

    if (isError) {
      return ErrorComponentWidget(
        onButtonPressed: () {
          setState(() {
            response = null;
            isLoading = true;
            loadApiContent(widget.apiCall, params: widget.params);
          });
        },
      );
    }

    if (response == null) {
      return Container();
    }

    return widget.builder(
        context,
        AsyncSnapshot<ApiCallResponse>.withData(
            ConnectionState.done, response!));
  }
}