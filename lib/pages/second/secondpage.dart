import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hisobot_dtm/models/modelloginpage1.dart';
import 'package:hisobot_dtm/services/httpnetwork.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sortedmap/sortedmap.dart';

import '../../strings.dart';

class SecondPage extends StatefulWidget {
  static final String id = "SecondPage";

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var boxs = Hive.box("online");
  bool checkEmp = true;
  SaveTitleData saveDataa;
  SaveTitleData saveDataa2;

  List<ModelGetTest2> items;
  List<TextEditingController> textEditCont = [];
  List<TextEditingController> textTitleEditCont = [];
  ArsProgressDialog progressDialog;
  ModelStatusParse parseStatus;
  Map<dynamic, dynamic> map77 = new Map();
  int statusCode1 = 0;
  int statusCode2 = 0;
  bool noInternet = false;

  String getDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd.MM.yyyy');
    String formattedDate = formatter.format(now);
    print(formattedDate);
    boxs.delete("date");
    boxs.put("date", formattedDate);
    return formattedDate;
  }

  String getDate2() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(formattedDate);
    return formattedDate;
  }

  String getDate3() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy_MM_dd');
    String formattedDate = formatter.format(now);
    print(formattedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    double sized = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(getDate().toString() +
            " " +
            boxs.get("smena").toString() +
            "-smena"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          width: sized,
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.only(topRight: Radius.circular(sized * 0.74)),
            color: Colors.grey[300],
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  left: sized * 0.1,
                  right: sized * 0.1,
                  bottom: sized * 0.05,
                  top: sized * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    boxs.get("harbiyName"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: sized * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.grey,
                    indent: sized * 0.2,
                    endIndent: sized * 0.2,
                  ),
                  for (int i = 0; i < Strings.titleString.length; i++)
                    showTitleItems(
                        name: Strings.titleString[i], id: i, screenSize: sized),
                  infoRed(sized: sized),
                  Divider(color: Colors.grey),
                  for (int i = 0; i < items.length; i++)
                    showItems(
                        name: map77[i + 1].toString(),
                        id: i,
                        screenSize: sized),
                  FlatButton(
                      height: sized * 0.14,
                      minWidth: sized * 0.6,
                      color: Colors.black,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      splashColor: Colors.red,
                      onPressed: () {
                        checkEmp = true;
                        for (int i = 0; i < Strings.titleString.length; i++)
                          if (textTitleEditCont[i].text.isEmpty) {
                            print("kkkkkkk");
                            errorDialog("Malumot kiritilmadi");
                            checkEmp = false;
                            break;
                          }
                        if (checkEmp) {
                          print("lllllllllll");
                          customDialog(sized: sized);
                        }
                        print(checkEmp);
                        for (int i = 0; i < items.length; i++) {
                          if (textEditCont[i].text.toString().trim().isEmpty) {
                            textEditCont[i].text = "0";
                          }
                        }
                      },
                      child: Text(
                        Strings.current,
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    parseJson();
    Future.delayed(Duration(milliseconds: 400), () {
      checkEdit();
    });

    // customDialog2();
  }

  void parseJson() {
    ModelGetTest1 modelGetTest1 = HttpNetworks.parseEmplist(boxs.get("sobir2"));
    items = modelGetTest1.data;
    map77 = new SortedMap(Ordering.byKey());
    for (int i = 0; i < items.length; i++) {
      map77[items[i].id] = items[i].name;
    }
    print("map77");
    print("${map77.toString()}");
  }

  void checkEdit() {
    try {
      SaveTitleData data1 = new SaveTitleData();
      SentServerDataBody dataBody = new SentServerDataBody();
      String title;
      String body;
      title = boxs.get(
          "${"title" + boxs.get("smena").toString() + boxs.get("harbiyId").toString()}");
      body = boxs.get(
          "${"body" + boxs.get("smena").toString() + boxs.get("harbiyId").toString()}");
      if (title == null || title.length < 1) {
      } else {
        print("DATABASE TITLE");
        // saveTitleData(title);
        print("777");
        print(title);
        print(textTitleEditCont.length);
        print("777");
        data1 = saveTitleData(title);
        setState(() {
          print("000");
          textTitleEditCont[0] =
          new TextEditingController(text: "${data1.all}");
          textTitleEditCont[1] =
          new TextEditingController(text: "${data1.cnt}");
        });

        print(data1.date);
        print(data1.id);
        print(data1.smenaId);
        print(data1.all);
        print(data1.cnt);
      }
      if (body == null || body.length < 1) {
      } else {
        print("DATABASE BODY GGG");
        dataBody = saveBodyData(body);
        setState(() {
          for (int i = 1; i <= items.length; i++) {
            textEditCont[i - 1] = new TextEditingController(
                text: dataBody.myMap["$i"].toString());
          }
        });

        print(dataBody.smena);
        print(dataBody.date);
        print(dataBody.type);
        print(dataBody.typeId);
        print(dataBody.myMap);
      }
    } catch (e) {
      print("$e");
    }
  }

  static SaveTitleData saveTitleData(String values) {
    dynamic json = jsonDecode(values);
    print("saveTitleData");

    var data = SaveTitleData.fromJson(json);
    return data;
  }

  static SentServerDataBody saveBodyData(String values) {
    dynamic json = jsonDecode(values);
    print("saveTitleData");

    var data = SentServerDataBody.fromJson(json);
    return data;
  }

  Widget showTitleItems({String name, int id, double screenSize}) {
    if (textTitleEditCont.length <= Strings.titleString.length) {
      textTitleEditCont.add(TextEditingController());
    }

    return Container(
      height: screenSize * 0.24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: screenSize * 0.04),
                  )),
              Expanded(
                  flex: 1,
                  child: TextField(
                    controller: textTitleEditCont[id],
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget showItems({String name, int id, double screenSize}) {
    if (textEditCont.length <= items.length) {
      textEditCont.add(TextEditingController());
    }

    print("$name ~~~~~~~~~~~~~~~ " + id.toString());
    return Container(
      height: screenSize * 0.24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: screenSize * 0.04),
                  )),
              Expanded(
                  flex: 1,
                  child: TextField(
                    controller: textEditCont[id],
                    maxLength: 2,
                    decoration: InputDecoration(hintText: "0"),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget infoRed({double sized}) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            Strings.removeText,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: sized * 0.04),
          ),
        ),
        // SizedBox(width: sized*0.05,),
        Expanded(
          flex: 1,
          child: Icon(
            Icons.arrow_downward_sharp,
            color: Colors.red,
            size: sized * 0.06,
          ),
        ),
      ],
    );
  }

  void errorDialog(String text) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: false,
        dismissOnTouchOutside: false,
        title: 'Xatolik',
        desc: "$text",
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }

  void successDialogOfflinie() async {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: 'DTM',
        dismissOnTouchOutside: false,
        desc: "Ma'lumotlar offline saqlandi",

        btnOkOnPress: () {

          debugPrint('OnClcik');
          boxs.delete("resultOffline");
          Navigator.of(context).pop(false);
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        })
      ..show();
  }

  void successDialog() async {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: 'DTM',
        dismissOnTouchOutside: false,
        desc: "Ma'lumotlar saqlandi",
        btnOkOnPress: () {
          debugPrint('OnClcik');
          Navigator.of(context).pop(false);
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        })
      ..show();
  }

  void customDialog({double sized}) async {
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.NO_HEADER,
      dismissOnTouchOutside: false,
      body: Center(
          child: Container(
            padding: EdgeInsets.all(sized * 0.025),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    await boxs.get("harbiyName"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: sized * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: sized * 0.01,
                  ),
                  for (int i = 0; i < Strings.titleString.length; i++)
                    showTitleItems2(
                        name: Strings.titleString[i],
                        number: textTitleEditCont[i].text.toString().isEmpty
                            ? "0"
                            : textTitleEditCont[i].text.toString(),
                        screenSize: sized * 0.95),
                  Divider(
                    color: Colors.grey,
                  ),
                  infoRed(sized: sized * 0.8),
                  Divider(
                    color: Colors.grey,
                  ),
                  for (int i = 0; i < textEditCont.length - 1; i++)
                    showItems2(
                        name: map77[i + 1].toString(),
                        id: i,
                        number: textEditCont[i].text.toString().isEmpty
                            ? "0"
                            : textEditCont[i].text.toString(),
                        screenSize: sized),
                  SizedBox(
                    height: sized * 0.1,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                          minWidth: sized * 0.3,
                          height: sized * 0.1,
                          color: Colors.grey,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            Strings.lose,
                            style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(
                        width: sized * 0.02,
                      ),
                      FlatButton(
                          minWidth: sized * 0.3,
                          height: sized * 0.1,
                          color: Colors.black,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          onPressed: () {
                            /////////////////////////////////////////////////////////////  Tasdiqlash SAQALASH Button bosildi
                            checkInternet();
                          },
                          child: Text(
                            Strings.current,
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  )
                ],
              ),
            ),
          )),
    )..show();
  }

  void saveLocal() async {
    try {
      Map<String,String> _map11 = {"X-Access-Token":  boxs.get("token").toString().trim()};

      print("LOCAL SAVED");
      print("LOCAL SAVED");
      print("LOCAL SAVED");
      print("LOCAL SAVED");
      print("LOCAL SAVED");
      print("LOCAL SAVED");

      print(jsonEncode(_map11));


      /// sent title
      saveDataa2 = new SaveTitleData(
        id: int.parse(boxs.get("harbiyId")),
        smenaId: boxs.get("smena"),
        cnt: int.parse(textTitleEditCont[1].text.toString()),
        date: getDate2(),
        all: int.parse(textTitleEditCont[0].text.toString()),
      );
      print(jsonEncode(saveDataa2));
      ///////////////////////////////////////////////////////////////////////////////////////////
      var map = Map<String, int>();
      for (int i = 0; i < items.length; i++) {
        // print("WWWWWWWWW  -> ${items[i].id}");
        map["${i + 1}"] = int.parse(textEditCont[i].text);
      }
      SentServerDataBody dataBody = new SentServerDataBody(
        typeId: int.parse(boxs.get("harbiyId")),
        type: 1,
        date: getDate2(),
        smena: int.parse(boxs.get("smena").toString()),
        myMap: map,
      );

      print(jsonEncode(dataBody));
      String offlineTokens = jsonEncode(_map11).toString().trim();
      String offlineTitle = jsonEncode(saveDataa2).toString().trim();
      String offlineBody = jsonEncode(dataBody).toString().trim();
      boxs.put("offlineToken", offlineTokens);
      boxs.put("offlineTitle", offlineTitle);
      boxs.put("offlineBody", offlineBody);
      //////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////// Save local database
      //////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////

      Navigator.of(context).pop(false);
      successDialogOfflinie();
    } catch (e) {
      print(e.toString());
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    }
  }

  void checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      noInternet = false;
      progressDialog = ArsProgressDialog(context,
          blur: 2,
          dismissable: false,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));
      progressDialog.show();
      sentDataServerTitle();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      noInternet = false;
      // I am connected to a wifi network.
    } else if (connectivityResult == ConnectivityResult.none) {
      noInternet = true;
      saveLocal();
    }
  }

  Widget showTitleItems2({String name, String number, double screenSize}) {
    if (textTitleEditCont.length <= Strings.titleString.length) {
      textTitleEditCont.add(TextEditingController());
    }

    return Container(
      height: screenSize * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: screenSize * 0.04),
                  )),
              Expanded(flex: 1, child: Text(number)),
            ],
          ),
        ],
      ),
    );
  }

  Widget showItems2({String name, String number, int id, double screenSize}) {
    if (textEditCont.length <= items.length) {
      textEditCont.add(TextEditingController());
    }

    return Container(
      height: screenSize * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: screenSize * 0.04),
                  )),
              Expanded(flex: 1, child: Text(number)),
            ],
          ),
        ],
      ),
    );
  }

/////////////////////////////////////////////////////////////////////////////////////////////////// Ma'lumot serverga yuborish
  void sentDataServerTitle() async {
    print(getDate3());

    Map<String, String> _map1 = {"X-Access-Token": await boxs.get("token")};

    /// sent title
    saveDataa = new SaveTitleData(
      id: int.parse(boxs.get("harbiyId")),
      smenaId: boxs.get("smena"),
      cnt: int.parse(textTitleEditCont[1].text.toString()),
      date: getDate2(),
      all: int.parse(textTitleEditCont[0].text.toString()),
    );
    print("8888888");
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    print(saveDataa.toJson());
    HttpNetworks.postKelganAskar(
        HttpNetworks.setTestAllURL,
        _map1,
        HttpNetworks.postKelganAskarParam1(
          id: int.parse(boxs.get("harbiyId")),
          smena: boxs.get("smena").toString(),
          kelganSoni: textTitleEditCont[1].text.toString(),
          date: getDate2(),
          all: textTitleEditCont[0].text.toString(),
        ))
        .then((value) => {
      print(value),
      parseStatus = HttpNetworks.parseStatusCode(value),
      if (parseStatus.status == 1)
        {
          statusCode1 = 1,
          print("Sobir"),
          print("Sobir"),

          print("jsonEncode(saveDataa)"),

          ///

          boxs.delete(
              "${"title" + boxs.get("smena").toString() + boxs.get("harbiyId")}"),
          boxs.put(
              "${"title" + boxs.get("smena").toString() + boxs.get("harbiyId")}",
              jsonEncode(saveDataa)),
          print("Sobir"),
          print("Sobir"),
        }
      else
        {
          statusCode1 = 0,
        },
    })
        .catchError((e) {
      statusCode1 = 0;
    });

    /// sent body

    var map = Map<String, int>();
    for (int i = 0; i < items.length; i++) {
      print("WWWWWWWWW  -> ${items[i].id}");
      map["${i + 1}"] = int.parse(textEditCont[i].text);
    }
    SentServerDataBody dataBody = new SentServerDataBody(
      typeId: int.parse(boxs.get("harbiyId")),
      type: 1,
      date: getDate2(),
      smena: int.parse(boxs.get("smena").toString()),
      myMap: map,
    );
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
    await boxs.delete(
        "${"body" + boxs.get("smena").toString() + boxs.get("harbiyId")}");
    await boxs.put(
        "${"body" + boxs.get("smena").toString() + boxs.get("harbiyId")}",
        jsonEncode(dataBody));

    HttpNetworks.postSetChet(HttpNetworks.setChetUrl, _map1, dataBody)
        .then((value) => {
      print(value),
      parseStatus = HttpNetworks.parseStatusCode(value),
      // statusCode2 = parseStatus.status,
      if (parseStatus.status == 1)
        {
          statusCode2 = 1,
        }
      else
        {
          statusCode2 = 0,
        },
    })
        .catchError((e) {
      statusCode2 = 0;
    });
    Future.delayed(Duration(seconds: 5), () {
      if (statusCode1 + statusCode2 == 2) {
        progressDialog.dismiss();
        Navigator.of(context).pop(false);
        successDialog();
      } else {
        progressDialog.dismiss();
        Navigator.of(context).pop(false);
        errorDialog("Xatolik qayta urunib ko'ring");
      }
    });
  }

  void getdata() {
    HttpNetworks.postaccToken(
        HttpNetworks.getData,
        HttpNetworks.postAccesstokenParam2(
            authorizationCode: HttpNetworks.getData))
        .then((value) => {
      print(value),
      // tokenParse(value),
    });
  }
}
