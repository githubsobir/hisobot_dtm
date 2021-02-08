class ModelGetData {
  int status;
}


class Smena1{
  int all;
  int cnt;
  Chet chetClass;
}

class Chet {
  Map<dynamic, dynamic> myMaps;

  Chet.fromJson(Map<dynamic, dynamic> json) : myMaps = json["chet"];

  Map<dynamic, dynamic> toJson() => {
        "chet": myMaps,
      };
}
