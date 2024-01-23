import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/firebase_auth/auth_util.dart';
import '../common/api_call_response.dart';
import '../model/uploaded_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'api_manager.dart';
export '../common/api_call_response.dart';

enum ApiCallType {
  GET,
  POST,
  DELETE,
  PUT,
  PATCH,
}

enum BodyType {
  NONE,
  JSON,
  TEXT,
  X_WWW_FORM_URL_ENCODED,
  MULTIPART,
}

class ApiCallRecord extends Equatable {
  ApiCallRecord(this.callName, this.apiUrl, this.headers, this.params,
      this.body, this.bodyType);
  final String callName;
  final String apiUrl;
  final Map<String, dynamic> headers;
  final Map<String, dynamic> params;
  final String? body;
  final BodyType? bodyType;

  @override
  List<Object?> get props =>
      [callName, apiUrl, headers, params, body, bodyType];
}

class ApiManager {
  ApiManager._();

  // Cache that will ensure identical calls are not repeatedly made.
  static Map<ApiCallRecord, ApiCallResponse> _apiCache = {};

  static ApiManager? _instance;
  static ApiManager get instance => _instance ??= ApiManager._();

  // If your API calls need authentication, populate this field once
  // the user has authenticated. Alter this as needed.
  static User? _user;

  static Future<String?> getAccessToken() async {
    return await _user?.getIdToken(true);
  }

  static void setFirebaseUser(User? user) async {
    _user = user;
    final storage = await SharedPreferences.getInstance();
    await storage.setString('uid', currentUserUid);
  }

  static User? getFirebaseUser() {
    return _user;
  }

  // You may want to call this if, for example, you make a change to the
  // database and no longer want the cached result of a call that may
  // have changed.
  static void clearCache(String callName) => _apiCache.keys
      .toSet()
      .forEach((k) => k.callName == callName ? _apiCache.remove(k) : null);

  static Map<String, String> toStringMap(Map map) =>
      map.map((key, value) => MapEntry(key.toString(), value.toString()));

  static String asqueryParameters(Map<String, dynamic> map) =>
      map.entries.map((e) => "${e.key}=${e.value}").join('&');

  static Future<ApiCallResponse> urlRequest(
    ApiCallType callType,
    String apiUrl,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    bool returnBody,
    bool decodeUtf8,
  ) async {
    if (params.isNotEmpty) {
      final lastUriPart = apiUrl.split('/').last;
      final needsParamSpecifier = !lastUriPart.contains('?');
      apiUrl =
          '$apiUrl${needsParamSpecifier ? '?' : ''}${asqueryParameters(params)}';
    }
    final makeRequest = callType == ApiCallType.GET ? http.get : http.delete;
    final response =
        await makeRequest(Uri.parse(apiUrl), headers: toStringMap(headers))
            .timeout(Duration(seconds: 60));
    return ApiCallResponse.fromHttpResponse(response, returnBody, decodeUtf8);
  }

  static Future<ApiCallResponse> requestWithBody(
    ApiCallType type,
    String apiUrl,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    String? body,
    BodyType? bodyType,
    bool returnBody,
    bool encodeBodyUtf8,
    bool decodeUtf8,
  ) async {
    assert(
      {ApiCallType.POST, ApiCallType.PUT, ApiCallType.PATCH}.contains(type),
      'Invalid ApiCallType $type for request with body',
    );
    final postBody =
        createBody(headers, params, body, bodyType, encodeBodyUtf8);

    if (bodyType == BodyType.MULTIPART) {
      return multipartRequest(
          type, apiUrl, headers, params, returnBody, decodeUtf8);
    }

    final requestFn = {
      ApiCallType.POST: http.post,
      ApiCallType.PUT: http.put,
      ApiCallType.PATCH: http.patch,
    }[type]!;
    final response = await requestFn(Uri.parse(apiUrl),
        headers: toStringMap(headers), body: postBody);
    return ApiCallResponse.fromHttpResponse(response, returnBody, decodeUtf8);
  }

  static Future<ApiCallResponse> multipartRequest(
    ApiCallType? type,
    String apiUrl,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    bool returnBody,
    bool decodeUtf8,
  ) async {
    assert(
      {ApiCallType.POST, ApiCallType.PUT, ApiCallType.PATCH}.contains(type),
      'Invalid ApiCallType $type for request with body',
    );
    bool Function(dynamic) _isFile = (e) =>
        e is FFUploadedFile ||
        e is List<FFUploadedFile> ||
        (e is List && e.firstOrNull is FFUploadedFile);

    final nonFileParams = toStringMap(
        Map.fromEntries(params.entries.where((e) => !_isFile(e.value))));

    List<http.MultipartFile> files = [];
    params.entries.where((e) => _isFile(e.value)).forEach((e) {
      final param = e.value;
      final uploadedFiles = param is List
          ? param as List<FFUploadedFile>
          : [param as FFUploadedFile];
      uploadedFiles.forEach((uploadedFile) => files.add(
            http.MultipartFile.fromBytes(
              e.key,
              uploadedFile.bytes ?? Uint8List.fromList([]),
              filename: uploadedFile.name,
              contentType: _getMediaType(uploadedFile.name),
            ),
          ));
    });

    final request = http.MultipartRequest(
        type.toString().split('.').last, Uri.parse(apiUrl))
      ..headers.addAll(toStringMap(headers))
      ..files.addAll(files);
    nonFileParams.forEach((key, value) => request.fields[key] = value);

    final response = await http.Response.fromStream(await request.send())
        .timeout(Duration(seconds: 60));
    return ApiCallResponse.fromHttpResponse(response, returnBody, decodeUtf8);
  }

  static MediaType? _getMediaType(String? filename) {
    final contentType = mime(filename);
    if (contentType == null) {
      return null;
    }
    final parts = contentType.split('/');
    if (parts.length != 2) {
      return null;
    }
    return MediaType(parts.first, parts.last);
  }

  static dynamic createBody(
    Map<String, dynamic> headers,
    Map<String, dynamic>? params,
    String? body,
    BodyType? bodyType,
    bool encodeBodyUtf8,
  ) {
    String? contentType;
    dynamic postBody;
    switch (bodyType) {
      case BodyType.JSON:
        contentType = 'application/json';
        postBody = body ?? json.encode(params ?? {});
        break;
      case BodyType.TEXT:
        contentType = 'text/plain';
        postBody = body ?? json.encode(params ?? {});
        break;
      case BodyType.X_WWW_FORM_URL_ENCODED:
        contentType = 'application/x-www-form-urlencoded';
        postBody = toStringMap(params ?? {});
        break;
      case BodyType.MULTIPART:
        contentType = 'multipart/form-data';
        postBody = params;
        break;
      case BodyType.NONE:
      case null:
        break;
    }
    // Set "Content-Type" header if it was previously unset.
    if (contentType != null &&
        !headers.keys.any((h) => h.toLowerCase() == 'content-type')) {
      headers['Content-Type'] = contentType;
    }
    return encodeBodyUtf8 && postBody is String
        ? utf8.encode(postBody)
        : postBody;
  }

  Future<ApiCallResponse> makeApiCall({
    required String callName,
    required String apiUrl,
    required ApiCallType callType,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> params = const {},
    String? body,
    BodyType? bodyType,
    bool returnBody = true,
    bool encodeBodyUtf8 = false,
    bool decodeUtf8 = false,
    bool cache = false,
  }) async {
    final callRecord =
        ApiCallRecord(callName, apiUrl, headers, params, body, bodyType);

    // Refresh token and retry logic
    ApiCallResponse? result;
    for (var retry = 0; retry < 3; retry++) {
      if (_user != null) {
        final accessToken = await _user?.getIdToken(true);
        if (accessToken != null && accessToken.isNotEmpty) {
          headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
        }
      } else if (_user == null) {
        final storage = await SharedPreferences.getInstance();
        final localUserUid = storage.getString('uid');

        if (localUserUid != null && localUserUid.isEmpty) {
          headers['uid'] = localUserUid;
        }
      }

      if (!apiUrl.startsWith('http')) {
        apiUrl = 'https://$apiUrl';
      }

      // If we've already made this exact call before and caching is on,
      // return the cached result.
      if (cache && _apiCache.containsKey(callRecord)) {
        return _apiCache[callRecord]!;
      }

      switch (callType) {
        case ApiCallType.GET:
        case ApiCallType.DELETE:
          result = await urlRequest(
            callType,
            apiUrl,
            headers,
            params,
            returnBody,
            decodeUtf8,
          );
          break;
        case ApiCallType.POST:
        case ApiCallType.PUT:
        case ApiCallType.PATCH:
          result = await requestWithBody(
            callType,
            apiUrl,
            headers,
            params,
            body,
            bodyType,
            returnBody,
            encodeBodyUtf8,
            decodeUtf8,
          );
          break;
      }

      // If the response is successful, return the result
      if (result.statusCode >= 200 && result.statusCode < 300) {
        // If caching is on, cache the result (if present).
        if (cache) {
          _apiCache[callRecord] = result;
        }
        return result;
      }

      // If the response is 401 (unauthorized), refresh the token and retry the API call
      if (result.statusCode == 401) {
        if (_user == null && result.jsonBody['refreshToken'] != null) {
          String localUserToken = result.jsonBody['refreshToken'];
          if (localUserToken.isNotEmpty) {
            final UserCredential userCredential = await FirebaseAuth.instance
                .signInWithCustomToken(localUserToken);
            _user = userCredential.user;
          }
        } else if (result.jsonBody['refreshToken'] == null) {
          authManager.signOut();
          break;
        }

        if (_user == null) {
          authManager.signOut();
          break;
        }

        continue;
      }

      // If it's not a token expiration error, return the error response
      return result;
    }

    // If all retries fail, return an error response
    return ApiCallResponse(null, {}, 500);
  }
}
