import 'dart:core';

class ModelLogin1 {
  int status;
  ModelData1 data1;

  ModelLogin1.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        data1 = ModelData1.fromJson(json["data"]);

  Map<String, dynamic> toJson() => {"status": status, "data": data1.toJson()};
}

class ModelData1 {
  String authorizationCode;
  int expiresAt;
  bool active;

  ModelData1.fromJson(Map<String, dynamic> json)
      : authorizationCode = json["authorization_code"],
        expiresAt = json["expires_at"],
        active = json["active"];

  Map<String, dynamic> toJson() => {
        "authorization_code": authorizationCode,
        "expires_at": expiresAt,
        "active": active,
      };
}

/// access toKen
class ModelAccessToken1 {
  int status;
  ModelAccToData1 data;

  ModelAccessToken1.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        data = ModelAccToData1.fromJson(json["status"]);
}

class ModelAccToData1 {
  String accessToken;
  double expiresAt;

  ModelAccToData1.fromJson(Map<String, dynamic> json)
      : accessToken = json["access_token"],
        expiresAt = json["expires_at"];

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_at": expiresAt,
      };
}

class ModelGetToken1 {
  int status;
  ModelGetToken2 modelGetToken2;

  ModelGetToken1.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        modelGetToken2 = ModelGetToken2.fromJson(json["data"]);

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": modelGetToken2.toJson(),
      };
}

class ModelGetToken2 {
  String accessToken;
  int expiresAt;

  ModelGetToken2.fromJson(Map<String, dynamic> json)
      : accessToken = json["access_token"],
        expiresAt = json["expires_at"];

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_at": expiresAt,
      };
}

class ModelGetTest1 {
  int status;
  List<ModelGetTest2> data;

  ModelGetTest1.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        data = List<ModelGetTest2>.from(
          json["data"].map((x) => ModelGetTest2.fromJson(x)),
        );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": new List<dynamic>.from(
          data.map((x) => x.toJson()),
        ),
      };
}

class ModelGetTest2 {
  dynamic id;
  dynamic name;

  ModelGetTest2.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ModelStatusParse {
  int status;

  ModelStatusParse.fromJSon(Map<String, dynamic> json)
      : status = json["status"];

  Map<String, dynamic> toJson() => {
        "status": status.toString(),
      };
}

class SentServerDataBody {
  String date;
  int typeId;
  int type;
  int smena;
  Map<dynamic, dynamic> myMap;

  SentServerDataBody(
      {int typeId,
      dynamic type,
      String date,
      int smena,
      Map<String, dynamic> myMap}) {
    this.typeId = typeId;
    this.type = type;
    this.date = date;
    this.smena = smena;
    this.myMap = myMap;
  }

  SentServerDataBody.fromJson(Map<String, dynamic> json)
      : typeId = json["type_id"],
        type = json["type"],
        date = json["date"],
        smena = json["smena_id"],
        myMap = json["chet"];

  Map<String, dynamic> toJson() => {
        "type_id": typeId,
        "type": type,
        "date": date,
        "smena_id": smena,
        "chet": myMap
      };
}

class SentServerDataBody2 {
  List<dynamic> myList;

  SentServerDataBody2.fromJson(Map<dynamic, dynamic> json)
      : myList = json["chet"];

  Map<dynamic, dynamic> toJson() => {
        "chet": myList,
      };
}

class SaveTitleData {
  int id;
  int cnt;
  int smenaId;
  int all;
  String date;

  SaveTitleData({
    int id,
    int cnt,
    int smenaId,
    int  all,
    String date,
  }) {
    this.id = id;
    this.cnt = cnt;
    this.smenaId = smenaId;
    this.all = all;
    this.date = date;
  }

  SaveTitleData.fromJson(Map<String, dynamic> json)
      : id = json["type_id"],
        cnt = json["cnt"],
        smenaId = json["smena_id"],
        all = json["all"],
        date = json["date"];

  Map<String, dynamic> toJson() => {
        "type_id": id,
        "cnt": cnt,
        "smena_id": smenaId,
        "all": all,
        "date": date,
      };
}
