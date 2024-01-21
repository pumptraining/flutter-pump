import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:pump/model/personal_details.dart';

class PumpSetupApi with ChangeNotifier {
  static const String _BASE_URL = "https://pump-api.herokuapp.com/";
  // static const String _BASE_URL = "http://localhost:4242/";

  Future<PersonalDetails?> getPersonalDetails(String forwardUri) {
    final url = Uri.parse('$_BASE_URL\api/v1/$forwardUri');
  return http
      .get(url)
      .then((value) {
    final json = jsonDecode(value.body);
    return PersonalDetails.fromJson(json);
  }).catchError((error) {
    // Tratamento de erro
    print("Ocorreu um erro durante a solicitação HTTP: $error");
    return error;
    // Você pode lançar uma exceção personalizada, retornar um valor padrão ou fazer qualquer outra ação de acordo com a necessidade do seu aplicativo.
  });
}
}
