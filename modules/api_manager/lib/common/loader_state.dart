import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:pump_components/components/error_component/error_component_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import '../api_requests/pump_creator_api_calls.dart';

class ApiLoaderController {
  void Function({dynamic params})? reload;
}

class ApiLoaderWidget extends StatefulWidget {
  const ApiLoaderWidget(
      {Key? key,
      required this.apiCall,
      this.params,
      required this.builder,
      this.controller,
      this.appBar})
      : super(key: key);

  final Requestable apiCall;
  final dynamic params;
  final Widget Function(
      BuildContext context, AsyncSnapshot<ApiCallResponse>? snapshot) builder;
  final ApiLoaderController? controller;
  final PreferredSizeWidget? appBar;

  @override
  // ignore: library_private_types_in_public_api
  _ApiLoaderWidgetState createState() => _ApiLoaderWidgetState();
}

class _ApiLoaderWidgetState extends State<ApiLoaderWidget> {
  ApiCallResponse? response;
  bool isLoading = false;
  bool isError = false;

  void reload({dynamic params}) {
    safeSetState(() {
      response = null;
    });

    loadApiContent(widget.apiCall, params: params ?? widget.params);
  }

  Future<ApiCallResponse?>? loadApiContent(Requestable apiCall,
      {dynamic params}) async {
    if (mounted) {
      safeSetState(() {
        isLoading = true;
        isError = false;
      });
    }

    response ??= await apiCall.call(params: params);

    if (mounted) {
      safeSetState(() {
        isLoading = false;
        isError = !(response?.succeeded ?? true);
      });
    }

    return response;
  }

  @override
  void dispose() {
    super.dispose();
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
        appBar: widget.appBar,
        body: Center(
          child: SizedBox(
            width: 40.0,
            height: 40.0,
            child: CircularProgressIndicator(
              strokeWidth: 1.0,
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
