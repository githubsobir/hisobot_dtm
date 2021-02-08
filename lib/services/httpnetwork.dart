import 'dart:convert';
import 'package:hisobot_dtm/models/modelloginpage1.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

class HttpNetworks {
  static String baseUrl = "testapp.dtm.uz";
  static Map<String, String> headers = {
    "Content-type": "application/json; charset=UTF-8"
  };
  static String authorizeUrl1 = "/authorize";
  static String accesstoken1 = "/accesstoken";
  static String getTestURL = "/get-test";
  static String setTestAllURL = "/set-test-all";
  static String setChetlatishURL = "/set-test-all";
  static String getChetType = "/get-chet-type";
  static String setChetUrl = "/set-chet";
  static String getData = "/get-data";
  var boxs = Hive.box("online");

  // post methods 1
  static Future<String> postAuthorize1(
      String api, Map<String, dynamic> params) async {
    var uri = Uri.https(baseUrl, api);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  // post methods 1
  static Future<String> postaccToken(
      String api, Map<String, dynamic> params) async {
    var uri = Uri.https(baseUrl, api);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  /// get-data with token
  static Future<String> geDataToken(
      String api, Map<String, dynamic> params) async {
    var uri = Uri.https(baseUrl, api);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  // post methods 1
  static Future<String> postGetTest(String api, Map<String, String> header1,
      Map<String, dynamic> params) async {
    var uri = Uri.https(baseUrl, api);
    var response = await post(uri, headers: header1, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return response.body;
  }

  /// sent server online body
  static Future<String> sentServerBodyData(
      String api, Map<String, dynamic> params) async {
    var uri = Uri.https(baseUrl, api);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  // params 1
  static Map<String, String> postAuthorizeParam1(
      {String username, String password}) {
    Map<String, String> maps = {
      "username": username,
      "password": password,
    };
    return maps;
  }

  // params 2 accesstoken
  static Map<String, String> postAccesstokenParam2(
      {String authorizationCode}) {
    Map<String, String> maps = {
      "authorization_code": authorizationCode,
    };
    return maps;
  }

  // empty param
  static Map<String, dynamic> emptParam() {
    Map<String, String> maps = new Map();
    return maps;
  }

  // parse 1
  static ModelLogin1 postAuthorizeParse(String response) {
    dynamic json = jsonDecode(response);
    var data = ModelLogin1.fromJson(json);
    return data;
  }

  // parse token
  static ModelGetToken1 postParseToken(String response) {
    dynamic json = jsonDecode(response);
    var data = ModelGetToken1.fromJson(json);
    return data;
  }

  static ModelGetTest1 parseEmplist(String response) {
    dynamic json = jsonDecode(response);
    var data = ModelGetTest1.fromJson(json);
    return data;
  }

  static ModelStatusParse parseStatusCode(String response) {
    dynamic json = jsonDecode(response);
    var dataa = ModelStatusParse.fromJSon(json);
    return dataa;
  }

  static ModelGetTest2 parseEmpModel(String body) {
    dynamic json = jsonDecode(body);
    var data = ModelGetTest2.fromJson(json);
    return data;
  }

//Chetlatilgan
  static Map<String, dynamic> typeID() {
    Map<String, String> maps = {"type": "2"};
    return maps;
  }

//
  static Future<String> postKelganAskarOffline(String api,
      Map<String, String> header1, Map<dynamic, dynamic>  params) async {
    var uri = Uri.https(baseUrl, api);
    var response = await post(uri, headers: header1, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return response.body;
  }

//
  static Future<String> postKelganAskar(String api,
      Map<String, dynamic> header1, Map<String, dynamic> params) async {
    var uri = Uri.https(baseUrl, api);
    var response = await post(uri, headers: header1, body: jsonEncode(params));
    print("++++++++");
    print(header1);

    print(jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {

      return response.body;
    }
    return response.body;
  }
  ///
  static Future<String> postSetChetOffline(String api, Map<String,String> header1,
    String dataBody) async {
    var uri = Uri.https(baseUrl, api);
    var response = await post(uri, headers: header1, body:dataBody);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return response.body;
  }
  ///
  static Future<String> postSetChet(String api, Map<String, dynamic> header1,
      SentServerDataBody dataBody) async {
    var uri = Uri.https(baseUrl, api);
    var response =
    await post(uri, headers: header1, body: jsonEncode(dataBody));
    print("---------7");
    print(header1);
    print(jsonEncode(dataBody));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return response.body;
  }

  // params 1
  static Map<String, dynamic> postKelganAskarParam1(
      {int id, String kelganSoni, String smena, String all, String date}) {
    Map<String, dynamic> maps = {
      "type_id": id,
      "smena_id": int.parse(smena),
      "cnt": int.parse(kelganSoni),
      "all": int.parse(all),
      "date": date,
    };

    return maps;
  }

  static Future<String> postChetlatilganAskar(String api,
      Map<String, dynamic> header1, Map<String, dynamic> params) async {
    var uri = Uri.https(baseUrl, api);
    var response = await post(uri, headers: header1, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return response.body;
  }

  // params 1
  static Map<String, String> postChetlatilganAskarParam1(
      {String id, String date, String map}) {
    Map<String, String> maps = {
      "type_id": id,
      "type": "1",
      "date": date,
      "chet": map,
    };
    return maps;
  }
}
