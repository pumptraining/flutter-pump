import 'dart:convert';
import 'dart:io';
import 'package:api_manager/api_manager/api_manager.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:http/http.dart' as http;
import '../common/requestable.dart';

export '../common/api_call_response.dart';
export '../common/requestable.dart';

/// Start Base Group Code

class Environment {
  static String get baseUrl {
    // return 'https://pump-api.herokuapp.com/api/v1';
    return kReleaseMode
        ? 'https://pump-api.herokuapp.com/api/v1'
        : 'http://localhost:4242/api/v1';
  }
}

class BaseGroup {

  static String get baseUrl => Environment.baseUrl;
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': '*/*',
  };
  static AuthCall authCall = AuthCall();
  static PersonalExercisesCall personalExercisesCall = PersonalExercisesCall();
  static PersonalWorkoutSheetsCall personalWorkoutSheetsCall =
      PersonalWorkoutSheetsCall();
  static PersonalWorkoutCall personalWorkoutCall = PersonalWorkoutCall();
  static CreateExerciseCall createExerciseCall = CreateExerciseCall();
  static UpdateExerciseCall updateExerciseCall = UpdateExerciseCall();
  static TrainingContentCall trainingContentCall = TrainingContentCall();
  static UpdateWorkoutCall updateWorkoutCall = UpdateWorkoutCall();
  static CreateWorkoutCall createWorkoutCall = CreateWorkoutCall();
  static TrainingSheetContentCall trainingContentSheetCall =
      TrainingSheetContentCall();
  static CreateWorkoutSheetCall createTrainingSheetCall =
      CreateWorkoutSheetCall();
  static UpdateWorkoutSheetCall updateTrainingSheetCall =
      UpdateWorkoutSheetCall();
  static PersonalDetailsCall personalDetailsCall = PersonalDetailsCall();
  static UpdatePersonalCall updatePersonalCall = UpdatePersonalCall();
  static HomeCall homeCall = HomeCall();
  static CustomersCall customersCall = CustomersCall();
  static InviteCustomersCall inviteCustomersCall = InviteCustomersCall();
  static GetExercisesContentCall getExercisesContentCall =
      GetExercisesContentCall();
  static PersonalTagsCall personalTagsCall = PersonalTagsCall();
  static CustomerHomeCall customerHomeCall = CustomerHomeCall();
  static EditCustomerTagCall editCustomerTagCall = EditCustomerTagCall();
  static ChangeCustomerStatusCall changeCustomerStatusCall = ChangeCustomerStatusCall();
  static RemoveCustomerCall removeCustomerCall = RemoveCustomerCall();
  static PaymentIntentCall paymentIntentCall = PaymentIntentCall();
  static DeleteAccountCall deleteAccountCall = DeleteAccountCall();
  static CancelSubscriptionCall cancelSubscriptionCall = CancelSubscriptionCall();
  static UpdateUserFCMTokenCall updateUserFCMTokenCall = UpdateUserFCMTokenCall();
  static BankAccountCall bankAccountCall = BankAccountCall();
  static StripeOboardingLinkCall stripeOboardingLinkCall = StripeOboardingLinkCall();
}

class AuthCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'Auth',
      apiUrl: '${BaseGroup.baseUrl}/user/auth',
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
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

class UpdatePersonalCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final personalJson = _serializeJson(params);
    final body = '''
$personalJson''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdatePersonal',
      apiUrl: '${BaseGroup.baseUrl}/user/update-personal', // ok
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
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

class PersonalExercisesCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'PersonalExercises',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/all-exercises', // ok
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {
        'personalId': currentUserUid,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic systemExercises(dynamic response) => getJsonField(
        response,
        r'''$.systemExercises''',
        true,
      );
  dynamic systemExercisesid(dynamic response) => getJsonField(
        response,
        r'''$.systemExercises[:]._id''',
        true,
      );
  dynamic systemExercisesname(dynamic response) => getJsonField(
        response,
        r'''$.systemExercises[:].name''',
        true,
      );
  dynamic systemExercisescategory(dynamic response) => getJsonField(
        response,
        r'''$.systemExercises[:].category''',
        true,
      );
  dynamic systemExercisescategoryid(dynamic response) => getJsonField(
        response,
        r'''$.systemExercises[:].category._id''',
        true,
      );
  dynamic systemExercisescategoryname(dynamic response) => getJsonField(
        response,
        r'''$.systemExercises[:].category.name''',
        true,
      );
  dynamic systemExercisesequipamentname(dynamic response) => getJsonField(
        response,
        r'''$.systemExercises[:].equipament.name''',
        true,
      );
  dynamic systemExercisesimageUrl(dynamic response) => getJsonField(
        response,
        r'''$.systemExercises[:].imageUrl''',
        true,
      );
  dynamic personalExercises(dynamic response) => getJsonField(
        response,
        r'''$.personalExercises''',
        true,
      );
  dynamic personalExercisesid(dynamic response) => getJsonField(
        response,
        r'''$.personalExercises[:]._id''',
        true,
      );
  dynamic personalExercisesname(dynamic response) => getJsonField(
        response,
        r'''$.personalExercises[:].name''',
        true,
      );
  dynamic personalExercisescategory(dynamic response) => getJsonField(
        response,
        r'''$.personalExercises[:].category''',
        true,
      );
  dynamic personalExercisescategoryid(dynamic response) => getJsonField(
        response,
        r'''$.personalExercises[:].category._id''',
        true,
      );
  dynamic personalExercisescategoryname(dynamic response) => getJsonField(
        response,
        r'''$.personalExercises[:].category.name''',
        true,
      );
  dynamic personalExercisesequipamentname(dynamic response) => getJsonField(
        response,
        r'''$.personalExercises[:].equipament.name''',
        true,
      );
  dynamic personalExercisesimageUrl(dynamic response) => getJsonField(
        response,
        r'''$.personalExercises[:].imageUrl''',
        true,
      );
  dynamic personalExercisespersonalId(dynamic response) => getJsonField(
        response,
        r'''$.personalExercises[:].personalId''',
        true,
      );
  dynamic categories(dynamic response) => getJsonField(
        response,
        r'''$.categories''',
        true,
      );
  dynamic categoriesid(dynamic response) => getJsonField(
        response,
        r'''$.categories[:]._id''',
        true,
      );
  dynamic categoriesname(dynamic response) => getJsonField(
        response,
        r'''$.categories[:].name''',
        true,
      );
}

class PersonalWorkoutSheetsCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'PersonalWorkoutSheets',
      apiUrl: '${BaseGroup.baseUrl}/workout-sheet/workout-sheets', // ok
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {
        'personalId': currentUserUid,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic title(dynamic response) => getJsonField(
        response,
        r'''$[:].title''',
        true,
      );
  dynamic imageUrl(dynamic response) => getJsonField(
        response,
        r'''$[:].imageUrl''',
        true,
      );
  dynamic amount(dynamic response) => getJsonField(
        response,
        r'''$[:].amount''',
        true,
      );
  dynamic longDescription(dynamic response) => getJsonField(
        response,
        r'''$[:].longDescription''',
        true,
      );
  dynamic trainingLevel(dynamic response) => getJsonField(
        response,
        r'''$[:].trainingLevel''',
        true,
      );
  dynamic shortDescription(dynamic response) => getJsonField(
        response,
        r'''$[:].shortDescription''',
        true,
      );
}

class PersonalWorkoutCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'PersonalWorkout',
      apiUrl: '${BaseGroup.baseUrl}/personal/workouts', // ok
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {
        'personalId': currentUserUid,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic name(dynamic response) => getJsonField(
        response,
        r'''$[:].namePortuguese''',
        true,
      );
  dynamic level(dynamic response) => getJsonField(
        response,
        r'''$[:].trainingLevel''',
        true,
      );
  dynamic imageUrl(dynamic response) => getJsonField(
        response,
        r'''$[:].trainingImageUrl''',
        true,
      );
}

class CreateExerciseCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final exercise = _serializeJson(params);
    final body = '''
${exercise}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateExercise',
      apiUrl: '${BaseGroup.baseUrl}/personal/new-exercise', // ok
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class UpdateExerciseCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final exercise = _serializeJson(params);
    final body = '''
${exercise}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateExercise',
      apiUrl: '${BaseGroup.baseUrl}/personal/update-exercise', // ok
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class CreateWorkoutCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    final exercise = _serializeJson(params);
    final body = '''
${exercise}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateWorkout',
      apiUrl: '${BaseGroup.baseUrl}/personal/save-workout', // ok
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class UpdateWorkoutCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    final exercise = _serializeJson(params);
    final body = '''
${exercise}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateWorkout',
      apiUrl: '${BaseGroup.baseUrl}/personal/update-workout', // ok
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class TrainingContentCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    var apiUrl = '${BaseGroup.baseUrl}/personal-app/create-training-content';
    if (params != null && params['workoutId'] != null) {
      final workoutId = params['workoutId'];
      apiUrl =
          '${BaseGroup.baseUrl}/personal-app/create-training-content?workoutId=$workoutId';
    }
    return ApiManager.instance.makeApiCall(
      callName: 'TrainingContent',
      apiUrl: apiUrl,
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic techniques(dynamic response) => getJsonField(
        response,
        r'''$.techniques''',
        true,
      );
  dynamic objectives(dynamic response) => getJsonField(
        response,
        r'''$.objectives''',
        true,
      );
}

class CreateWorkoutSheetCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    final exercise = _serializeJson(params);
    final body = '''
${exercise}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateWorkoutSheet',
      apiUrl: '${BaseGroup.baseUrl}/workout-sheet/create-workout-sheet', // ok
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class UpdateWorkoutSheetCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    final exercise = _serializeJson(params);
    final body = '''
${exercise}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateWorkoutSheet',
      apiUrl: '${BaseGroup.baseUrl}/workout-sheet/update-workout-sheet', // ok
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class TrainingSheetContentCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'TrainingSheetContent',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/create-training-sheet-content',
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {
        'personalId': currentUserUid,
        'workoutId': params['workoutId'],
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic objectives(dynamic response) => getJsonField(
        response,
        r'''$.objectives''',
        true,
      );

  dynamic workouts(dynamic response) => getJsonField(
        response,
        r'''$.workouts''',
        true,
      );
}

/// End Base Group Code

class GetExercisesContentCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'getExercisesContent',
      apiUrl: '${BaseGroup.baseUrl}/exercise-content', // ok
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  static dynamic categories(dynamic response) => getJsonField(
        response,
        r'''$.categories''',
        true,
      );
  static dynamic categoryName(dynamic response) => getJsonField(
        response,
        r'''$.categories[:].name''',
        true,
      );
}

class UploadVideoCall {
  static Future<http.Response> call(String videoFilePath) async {
    // Comprimir o vídeo antes de fazer o upload
    final compressedVideoPath = videoFilePath;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${BaseGroup.baseUrl}/personal-app/upload-video'),
    );

    // final token = ApiManager.getAccessToken();
    // request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath('video', compressedVideoPath),
    );

    var response = await request.send();
    return http.Response.fromStream(response);
  }
}

class UploadImageCall {
  static Future<http.Response> call(String imageFilePath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${BaseGroup.baseUrl}/personal-app/upload-image'));

    final token = await ApiManager.getAccessToken();
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFilePath));

    var response = await request.send();
    return http.Response.fromStream(response);
  }
}

class GetExercisePumpCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'getExercisePump',
      apiUrl: '${BaseGroup.baseUrl}/setup/exercises',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  static dynamic exercises(dynamic response) => getJsonField(
        response,
        r'''$''',
        true,
      );
  static dynamic name(dynamic response) => getJsonField(
        response,
        r'''$[:].name''',
        true,
      );
  static dynamic id(dynamic response) => getJsonField(
        response,
        r'''$[:]._id''',
        true,
      );
  static dynamic nameEnglish(dynamic response) => getJsonField(
        response,
        r'''$[:].nameEnglish''',
        true,
      );
  static dynamic imageUrl(dynamic response) => getJsonField(
        response,
        r'''$[:].imageUrl''',
        true,
      );
  static dynamic videoUrl(dynamic response) => getJsonField(
        response,
        r'''$[:].videoUrl''',
        true,
      );
  static dynamic streamingURL(dynamic response) => getJsonField(
        response,
        r'''$[:].streamingURL''',
        true,
      );
  static dynamic personalId(dynamic response) => getJsonField(
        response,
        r'''$[:].personalId''',
        true,
      );
  static dynamic categoryid(dynamic response) => getJsonField(
        response,
        r'''$[:].category._id''',
        true,
      );
  static dynamic categoryname(dynamic response) => getJsonField(
        response,
        r'''$[:].category.name''',
        true,
      );
  static dynamic equipmentName(dynamic response) => getJsonField(
        response,
        r'''$[:].equipament.name''',
        true,
      );
}

class PersonalDetailsCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'PersonalDetails',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/personal-details',
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {
        'uid': currentUserUid,
      },
      returnBody: true,
      encodeBodyUtf8: false,
    );
  }

  dynamic name(dynamic response) => getJsonField(
        response,
        r'''$.response.firstName''',
      );
  dynamic email(dynamic response) => getJsonField(
        response,
        r'''$.response.email''',
      );
  dynamic imageUrl(dynamic response) => getJsonField(
        response,
        r'''$.response.personalImageUrl''',
      );
  dynamic instagramUser(dynamic response) => getJsonField(
        response,
        r'''$.response.instagramUsername''',
      );
  dynamic description(dynamic response) => getJsonField(
        response,
        r'''$.response.description''',
      );
  dynamic instagramUrl(dynamic response) => getJsonField(
        response,
        r'''$.response.instagramUrl''',
      );
}

class HomeCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'HomeCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/home',
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
    );
  }
}

class CustomersCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'CustomersCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/customers',
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
    );
  }
}

class InviteCustomersCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final json = _serializeJson(params);
    final body = '''
$json''';
    return ApiManager.instance.makeApiCall(
      callName: 'InviteCustomersCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/add-customer',
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      body: body,
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class EditCustomerTagCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final json = _serializeJson(params);
    final body = '''
$json''';
    return ApiManager.instance.makeApiCall(
      callName: 'EditCustomerTagCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/edit-customer-tags',
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      body: body,
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class ChangeCustomerStatusCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final json = _serializeJson(params);
    final body = '''
$json''';
    return ApiManager.instance.makeApiCall(
      callName: 'ChangeCustomerStatusCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/customer-status',
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      body: body,
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class RemoveCustomerCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final json = _serializeJson(params);
    final body = '''
$json''';
    return ApiManager.instance.makeApiCall(
      callName: 'RemoveCustomerCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/remove-customer',
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      body: body,
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class PersonalTagsCall extends Requestable {
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'PersonalTagsCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/personal-tags',
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
    );
  }
}

class CustomerHomeCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final email = params['email'];
    return ApiManager.instance.makeApiCall(
      callName: 'CustomerHomeCall',
      apiUrl: '${BaseGroup.baseUrl}/home-pump/home?email=$email',
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}

class PaymentIntentCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    return ApiManager.instance.makeApiCall(
      callName: 'CustomerHomeCall',
      apiUrl: '${BaseGroup.baseUrl}/payment-sheet/personal-intent',
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
    );
  }
}


class DeleteAccountCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final json = _serializeJson(params);
    final body = '''
$json''';
    return ApiManager.instance.makeApiCall(
      callName: 'DeleteAccountCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/delete-account',
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      body: body,
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}


class CancelSubscriptionCall extends Requestable {
  @override
  Future<ApiCallResponse> call({dynamic params}) {
    final json = _serializeJson(params);
    final body = '''
$json''';
    return ApiManager.instance.makeApiCall(
      callName: 'CancelSubscriptionCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/cancel-subscription',
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
      },
      body: body,
      params: {},
      bodyType: BodyType.JSON,
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
      apiUrl: '${BaseGroup.baseUrl}/personal-app/update-fcm-token',
      callType: ApiCallType.POST,
      headers: {
        ...BaseGroup.headers,
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

class BankAccountCall extends Requestable {
  @override
  Future<ApiCallResponse> call({
    dynamic params,
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'CustomerPaymentsCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/bank-account',
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
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


class StripeOboardingLinkCall extends Requestable {
  @override
  Future<ApiCallResponse> call({
    dynamic params,
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'StripeOboardingLinkCall',
      apiUrl: '${BaseGroup.baseUrl}/personal-app/get-stripe-onboarding',
      callType: ApiCallType.GET,
      headers: {
        ...BaseGroup.headers,
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


// Paging

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

String _serializeJson(dynamic jsonVar) {
  jsonVar ??= {};
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return '{}';
  }
}
