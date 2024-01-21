import 'api_call_response.dart';

abstract class Requestable {
  Future<ApiCallResponse> call({dynamic params});
}