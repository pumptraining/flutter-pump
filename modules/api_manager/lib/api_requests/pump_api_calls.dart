import 'dart:convert';
import 'dart:io';
import 'package:api_manager/api_requests/pump_creator_api_calls.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import '../api_manager/api_manager.dart';
import 'package:http/http.dart' as http;

import '../auth/firebase_auth/auth_util.dart';

export '../common/api_call_response.dart';
export '../common/requestable.dart';

/// Start Pump Group Code

class PumpGroup {
  static String get baseUrl => Environment.baseUrl;
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': '*/*',
    'locale': 'PT'
  };
  static AuthCall authCall = AuthCall();
  static WorkoutDetailsCall workoutDetailsCall = WorkoutDetailsCall();
  static CompleteWorkoutCall completeWorkoutCall = CompleteWorkoutCall();
  static FeedbackCall feedbackCall = FeedbackCall();
  static UserActivityCall userActivityCall = UserActivityCall();
  static GetCompletedWorkoutCall getCompletedWorkoutCall =
      GetCompletedWorkoutCall();
  static HomeWorkoutFilterCall homeWorkoutFilterCall = HomeWorkoutFilterCall();
  static HomeWorkoutsCall homeWorkoutsCall = HomeWorkoutsCall();
  static CategoryListCall categoryListCall = CategoryListCall();
  static UserDetailsCall userDetailsCall = UserDetailsCall();
  static UpdateUserCall updateUserCall = UpdateUserCall();
  static HomeWorkoutSheetsCall homeWorkoutSheetsCall = HomeWorkoutSheetsCall();
  static PersonalDetailsCall personalDetailsCall = PersonalDetailsCall();
  static WorkoutSheetDetailsCall workoutSheetDetailsCall =
      WorkoutSheetDetailsCall();
  static PaymentSheetCall paymentSheetCall = PaymentSheetCall();
  static UserHomeCall userHomeCall = UserHomeCall();
  static UserWorkoutSheetCompletedCall userWorkoutSheetCompletedCall =
      UserWorkoutSheetCompletedCall();
  static UserCancelledWorkoutSheetCall userCancelledWorkoutSheetCall =
      UserCancelledWorkoutSheetCall();
  static UserStartedWorkoutSheetCall userStartedWorkoutSheetCall =
      UserStartedWorkoutSheetCall();
  static WorkoutRatingsCall workoutRatingsCall = WorkoutRatingsCall();
  static UserDeleteAccountCall userDeleteAccountCall = UserDeleteAccountCall();
  static PersonalReviewCall personalReviewCall = PersonalReviewCall();
  static GetPersonalReviewsCall getPersonalReviewsCall = GetPersonalReviewsCall();
  static UserPurchaseWorkoutSheetCall userPurchaseWorkoutSheetCall = UserPurchaseWorkoutSheetCall();
  static ChangePersonalInviteCall changePersonalInviteCall = ChangePersonalInviteCall();
  static UpdateUserFCMTokenCall updateUserFCMTokenCall = UpdateUserFCMTokenCall();
}

class AuthCall {
  Future<ApiCallResponse> call() {
    return ApiManager.instance.makeApiCall(
      callName: 'Auth',
      apiUrl: '${PumpGroup.baseUrl}/user/user-auth',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class WorkoutDetailsCall {
  Future<ApiCallResponse> call({
    String? trainingId = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'WorkoutDetails',
      apiUrl: '${PumpGroup.baseUrl}/trainingDetails',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {
        'trainingId': '${trainingId}',
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic sets(dynamic response) => getJsonField(
        response,
        r'''$.sets''',
        true,
      );

  String personalImageUrl(dynamic response) => getJsonField(
        response,
        r'''$.personalImageUrl''',
      );

  String workoutId(dynamic response) => getJsonField(
        response,
        r'''$.workoutId''',
      );

  String? personalId(dynamic response) => getJsonField(
        response,
        r'''$.personalId''',
      );

  String? imageUrl(dynamic response) => getJsonField(
        response,
        r'''$.imageUrl''',
      );
}

class CompleteWorkoutCall {
  Future<ApiCallResponse> call({
    String? trainingId = '',
    String? userId = '',
    DateTime? newDate,
    int? totalSecondsTime = 0,
  }) {
    final DateTime effectiveDate = newDate ?? DateTime.now().toLocal();
    dynamic json = {};
    json['workoutId'] = trainingId;
    json['userId'] = userId;
    json['newDate'] = effectiveDate.toIso8601String();
    json['totalSecondsTime'] = totalSecondsTime;

    final jsonData = _serializeJson(json);
    final body = '''
      ${jsonData}''';

    return ApiManager.instance.makeApiCall(
      callName: 'CompleteWorkout',
      apiUrl: '${PumpGroup.baseUrl}/completed',
      callType: ApiCallType.POST,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class FeedbackCall {
  Future<ApiCallResponse> call({
    String? trainingId = '',
    String? userId = '',
    String? personalId = '',
    DateTime? newDate,
    int? intensity,
    int? rating,
    String? feedbackText,
  }) {
    final DateTime effectiveDate = newDate ?? DateTime.now().toLocal();
    dynamic json = {};
    json['workoutId'] = trainingId;
    json['userId'] = userId;
    json['date'] = effectiveDate.toIso8601String();
    json['intensity'] = intensity;
    json['rating'] = rating;
    json['feedbackText'] = feedbackText;
    json['personalId'] = personalId;

    final jsonData = _serializeJson(json);
    final body = '''
      ${jsonData}''';

    return ApiManager.instance.makeApiCall(
      callName: 'FeedbackCall',
      apiUrl: '${PumpGroup.baseUrl}/send-feedback',
      callType: ApiCallType.POST,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class UserActivityCall {
  Future<ApiCallResponse> call({
    String? userId = '',
    int? time = 7,
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'WorkoutDetails',
      apiUrl: '${PumpGroup.baseUrl}/activity/user-activity',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {
        'userId': '${userId}',
        'time': '${time}',
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class GetCompletedWorkoutCall {
  Future<ApiCallResponse> call({
    String? userId = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'GetCompletedWorkoutCall',
      apiUrl: '${PumpGroup.baseUrl}/activity/completed-workouts',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {
        'userId': '$userId',
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class HomeWorkoutFilterCall {
  Future<ApiCallResponse> call() {
    return ApiManager.instance.makeApiCall(
      callName: 'HomeWorkoutFilter',
      apiUrl: '${PumpGroup.baseUrl}/home-workout/filter-content',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }
}

class HomeWorkoutsCall {
  Future<ApiCallResponse> call() {
    return ApiManager.instance.makeApiCall(
      callName: 'HomeWorkouts',
      apiUrl: '${PumpGroup.baseUrl}/home-workout/home',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }
}

class CategoryListCall {
  Future<ApiCallResponse> call({
    String? forwardUri = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'CategoryList',
      apiUrl: '${PumpGroup.baseUrl}${forwardUri}',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class UserDetailsCall {
  Future<ApiCallResponse> call() {
    return ApiManager.instance.makeApiCall(
      callName: 'UserDetails',
      apiUrl: '${PumpGroup.baseUrl}/user/user-details',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
    );
  }
}

class UploadImageCall {
  static Future<http.Response> call(String imageFilePath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${PumpGroup.baseUrl}/user/upload-image'));

    final token = ApiManager.getAccessToken();
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

    request.files
        .add(await http.MultipartFile.fromPath('image', imageFilePath));

    var response = await request.send();
    return http.Response.fromStream(response);
  }
}

class UpdateUserCall {
  Future<ApiCallResponse> call({
    dynamic personal,
  }) {
    final personalJson = _serializeJson(personal);
    final body = '''
${personalJson}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateUser',
      apiUrl: '${PumpGroup.baseUrl}/user/update-user', // ok
      callType: ApiCallType.POST,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      bodyType: BodyType.JSON,
      body: body,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class HomeWorkoutSheetsCall {
  Future<ApiCallResponse> call() {
    return ApiManager.instance.makeApiCall(
      callName: 'HomeWorkoutSheets',
      apiUrl: '${PumpGroup.baseUrl}/workout-sheet/home',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class PersonalDetailsCall {
  Future<ApiCallResponse> call({
    String? forwardUri = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'PersonalDetails',
      apiUrl: '${PumpGroup.baseUrl}/$forwardUri',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class WorkoutSheetDetailsCall {
  Future<ApiCallResponse> call({
    String? workoutId = '',
    String? userId = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'WorkoutSheetDetails',
      apiUrl:
          '${PumpGroup.baseUrl}/workout-sheet-details?id=$workoutId&userId=$userId',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class PaymentSheetCall {
  Future<ApiCallResponse> call({
    double? amount = 0.0,
    String? userId = '',
    String? personalId = '',
    String? trainingSheetId = '',
  }) {
    dynamic json = {};
    json['trainingSheetId'] = trainingSheetId;
    json['userId'] = userId;
    json['personalId'] = personalId;
    json['amount'] = amount;

    final jsonData = _serializeJson(json);
    final body = '''
      $jsonData''';

    return ApiManager.instance.makeApiCall(
      callName: 'PaymentSheet',
      apiUrl: '${PumpGroup.baseUrl}/payment-sheet/purchase',
      callType: ApiCallType.POST,
      headers: {
        ...PumpGroup.headers,
      },
      body: body,
      bodyType: BodyType.JSON,
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class UserHomeCall {
  Future<ApiCallResponse> call() {
    return ApiManager.instance.makeApiCall(
      callName: 'UserHome',
      apiUrl: '${PumpGroup.baseUrl}/home-pump/home',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class UserWorkoutSheetCompletedCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    var apiUrl = '${PumpGroup.baseUrl}/workout-sheet/user-workout-sheet-completed';
    if (params != null && params['customerId'] != null) {
      final customerId = params['customerId'];
      apiUrl =
          '${BaseGroup.baseUrl}/workout-sheet/user-workout-sheet-completed?customerId=$customerId';
    }
    return ApiManager.instance.makeApiCall(
      callName: 'UserWorkoutSheetCompleted',
      apiUrl: apiUrl,
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class UserCancelledWorkoutSheetCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final jsonData = _serializeJson(params);
    final body = '''
      $jsonData''';

    return ApiManager.instance.makeApiCall(
      callName: 'UserCancelledWorkoutSheet',
      apiUrl: '${PumpGroup.baseUrl}/workout-sheet/user-cancelled',
      callType: ApiCallType.POST,
      headers: {
        ...PumpGroup.headers,
      },
      body: body,
      bodyType: BodyType.JSON,
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class UserStartedWorkoutSheetCall extends Requestable {
  @override
  Future<ApiCallResponse> call({
    dynamic params
  }) {

    final jsonData = _serializeJson(params);
    final body = '''
      $jsonData''';

    return ApiManager.instance.makeApiCall(
      callName: 'UserStartedWorkoutSheet',
      apiUrl: '${PumpGroup.baseUrl}/workout-sheet/user-start',
      callType: ApiCallType.POST,
      headers: {
        ...PumpGroup.headers,
      },
      body: body,
      bodyType: BodyType.JSON,
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class WorkoutRatingsCall {
  Future<ApiCallResponse> call({
    String? workoutId = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'WorkoutRatings',
      apiUrl: '${PumpGroup.baseUrl}/workout/ratings?workoutId=$workoutId',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class GetPersonalReviewsCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final personalId = params['personalId'];
    return ApiManager.instance.makeApiCall(
      callName: 'GetPersonalReviewsCall',
      apiUrl: '${PumpGroup.baseUrl}/personal/get-reviews?personalId=$personalId',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class UserDeleteAccountCall {
  Future<ApiCallResponse> call() {
    dynamic json = {};
    json['userId'] = currentUserUid;

    final jsonData = _serializeJson(json);
    final body = '''
      $jsonData''';

    return ApiManager.instance.makeApiCall(
      callName: 'UserDeleteAccountCall',
      apiUrl: '${PumpGroup.baseUrl}/delete-account',
      callType: ApiCallType.POST,
      headers: {
        ...PumpGroup.headers,
      },
      body: body,
      bodyType: BodyType.JSON,
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class PersonalReviewCall extends Requestable {
  @override
  Future<ApiCallResponse> call({
    dynamic params,
  }) {
    final personalJson = _serializeJson(params);
    final body = '''
${personalJson}''';
    return ApiManager.instance.makeApiCall(
      callName: 'PersonalReviewCall',
      apiUrl: '${PumpGroup.baseUrl}/personal/review',
      callType: ApiCallType.POST,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      bodyType: BodyType.JSON,
      body: body,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class UserPurchaseWorkoutSheetCall {
  Future<ApiCallResponse> call() {
    return ApiManager.instance.makeApiCall(
      callName: 'UserPurchaseWorkoutSheet',
      apiUrl: '${PumpGroup.baseUrl}/workout-sheet/user-purchases',
      callType: ApiCallType.GET,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class ChangePersonalInviteCall extends Requestable {
  @override
  Future<ApiCallResponse> call({
    dynamic params,
  }) {
    final personalJson = _serializeJson(params);
    final body = '''
${personalJson}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ChangePersonalInviteCall',
      apiUrl: '${PumpGroup.baseUrl}/personal/change-personal-invite',
      callType: ApiCallType.POST,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      bodyType: BodyType.JSON,
      body: body,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class UpdateUserFCMTokenCall extends Requestable {
  @override
  Future<ApiCallResponse> call({
    dynamic params,
  }) {
    final personalJson = _serializeJson(params);
    final body = '''
${personalJson}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateUserFCMTokenCall',
      apiUrl: '${PumpGroup.baseUrl}/user/update-fcm-token',
      callType: ApiCallType.POST,
      headers: {
        ...PumpGroup.headers,
      },
      params: {},
      bodyType: BodyType.JSON,
      body: body,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

/// End Pump Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
