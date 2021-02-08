import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:hisobot_dtm/models/modelloginpage1.dart';
import 'package:hisobot_dtm/pages/firstpage/firtspage1.dart';
import 'package:hisobot_dtm/services/httpnetwork.dart';
import 'package:hive/hive.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static final String id = "login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var contrLogin = TextEditingController();
  var contrPassword = TextEditingController();
  bool _passwordVisible = false;
  var boxs = Hive.box("online");
  ModelData1 modelData1;

  ArsProgressDialog progressDialog;

  String logi;
  String passw;

  String logins;
  bool noInternet = true;
  int statusCode1 = 0;
  int statusCode2 = 0;
  ModelStatusParse parseStatus;
  List<ModelGetTest2> items;
  bool result = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("0000");
    Future.delayed(Duration(microseconds: 300), () {
      checkCheckBox();
    });
    print("0111");
    Future.delayed(Duration(seconds: 3), () {
      if (boxs.get("resultOffline").toString().trim() != "a1") {
        sentDataS1();
      }

    });
  }

  void sentDataS1() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (result) {
        print("~ +");
        senOfflineData();
       Future.delayed(Duration(seconds: 3),(){
         if (result) sentDataS2();
       });
      }
    });
  }

  void sentDataS2() {
    Future.delayed(Duration(seconds: 5), () {
      if (result) {
        print("~ -");
        senOfflineData();
        if (result) sentDataS1();
      }
    });
  }

  void senOfflineData() async {
    print("0");
    var connectivityResult2 = await (Connectivity().checkConnectivity());
    if (connectivityResult2 == ConnectivityResult.mobile) {
      print(boxs.get("offlineTitle").toString().trim().length);
      if (boxs.get("offlineTitle").toString().trim().length > 5) {
        print("2");
        Map<dynamic, dynamic> param = jsonDecode(boxs.get("offlineTitle"));
        Map<String, dynamic> offHeader = jsonDecode(boxs.get("offlineToken"));
        Map<String, String> offHeader2 =
            offHeader.map((key, value) => MapEntry(key, value?.toString()));

        HttpNetworks.postKelganAskarOffline(
          HttpNetworks.setTestAllURL,
          offHeader2,
          param,
        )
            .then((value) => {
                  parseStatus = HttpNetworks.parseStatusCode(value),
                  statusCode1 = 1,
                  if (parseStatus.status == 1)
                    {
                      print("3"),
                      print("++++++++++++++++++++++"),
                      print(value),
                      statusCode1 = 1,
                    }
                  else
                    {
                      print("-----------------------"),
                      print("0 3"),
                      statusCode1 = 0,
                    },
                })
            .catchError((e) {
          statusCode1 = 0;
          print("-----------------------");
          print("0 0 3");
        });
        /////////////////////////////////////////////////////////////////////////////////// sent body
        print("4");
        Map<String, dynamic> header = jsonDecode(boxs.get("offlineToken"));
        Map<String, String> header2 =
            header.map((key, value) => MapEntry(key, value?.toString()));

        HttpNetworks.postSetChetOffline(
                HttpNetworks.setChetUrl, header2, boxs.get("offlineBody"))
            .then((value) => {
                  print(value),
                  parseStatus = HttpNetworks.parseStatusCode(value),
                  statusCode2 = 1,
                  if (parseStatus.status == 1)
                    {
                      print("5"),
                      print("++++++++++++++++++++"),
                      print(value),
                      statusCode2 = 1,
                    }
                  else
                    {
                      statusCode2 = 0,
                      print("---------------------------"),
                      print("0 5"),
                    },
                })
            .catchError((e) {
          print("---------------------------");
          print("0 0 5");
        });
        Future.delayed(Duration(seconds: 5), () {
          if (statusCode1 + statusCode2 == 2) {
            if(result)
            successDialog();
            setState(() {
              result = false;
            });

            boxs.put("resultOffline", "a1");
            boxs.delete("offlineTitle");
            boxs.delete("offlineBody");
            boxs.delete("offlineToken");
          } else {
            errorDialog(
                "Xatolik ma'lumotlar serverga yuborilmadi \n internet sozlamalaringizni tekshirib ko'ring");
          }
        });
      }
    } else if (connectivityResult2 == ConnectivityResult.wifi) {
      // kirishButtonAction1();
    } else if (connectivityResult2 == ConnectivityResult.none) {}
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

  void successDialog() async {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: 'DTM',
        dismissOnTouchOutside: false,
        desc: "Ma'lumotlar serverga saqlandi",
        btnOkOnPress: () {
          debugPrint('OnClcik');
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        })
      ..show();
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      kirishButtonAction1();
      noInternet = false;
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      noInternet = false;
      // kirishButtonAction1();
    } else if (connectivityResult == ConnectivityResult.none) {
      offlineAction();
    }
  }

  void checkCheckBox() {
    ////

    try {
      int a = int.parse(boxs.get("getCheckBox").toString().trim());
      if (a == 1) {
        setState(() {
          contrLogin.text = boxs.get("getLogin");
          contrPassword.text = boxs.get("getPass");
          _checkBox = true;
        });
      }
    } catch (e) {}
  }

  void kirishButtonAction1() {
    setState(() {
      logi = contrLogin.text.toString().trim();
      passw = contrPassword.text.toString().trim();

      if (logi.length == 0 || passw.length == 0) {
      }
      else if (logi.length < 5 || passw.length < 7) {
        contrLogin.clear();
        contrPassword.clear();
        iphoneDialog();
      } else {
        progressDialog = ArsProgressDialog(context,
            blur: 2,
            backgroundColor: Color(0x33000000),
            animationDuration: Duration(milliseconds: 500));
        progressDialog.show();

        HttpNetworks.postAuthorize1(
          HttpNetworks.authorizeUrl1,
          HttpNetworks.postAuthorizeParam1(username: logi, password: passw),
        ).then((value) => {
              print(value),
              kirishButtonAction2(value),
              logins = value,
            });
      }
      Future.delayed(
          Duration(seconds: 10),
          () => {
                progressDialog.dismiss(),
                iphoneDialog(),
                contrLogin.clear(),
                contrPassword.clear(),
              });
    });
  }

  void offlineAction() {
    ///////////////////////////////////////////////////////////////////////////////////// (offline) ma'lumot borligiga tekshirish
    if (boxs.get("sobir").toString().length > 5) {
      Future.delayed(Duration(seconds: 7), () {
        Navigator.of(context).pop(false);
        dialogNoInternet(
          contentText:
              "\nSizda internet yoq!!!\n\nOffline ishlashni davov etirish ",
          textButton1: "Yoq",
          textButton2: "Xa",
          visibleButton1: true,
          visibleButton2: true,
        );
      });
      dialogNoInternet(
        contentText:
            "\nSizda internet yoq!!!\n\nMa'lumotlar dastur internetga ulanganda serverga vatomatik yuboriladi ",
        textButton1: "Yoq",
        textButton2: "Xa",
        visibleButton1: false,
        visibleButton2: false,
      );
    } else {
      dialogNoInternet(
        contentText: "\nMa'lumotlaringiz telefon xotirasida yoq",
        textButton1: "Yoq",
        textButton2: "Xa",
        visibleButton1: false,
        visibleButton2: false,
      );
      Future.delayed(Duration(seconds: 7), () {
        dialogNoInternet(
          contentText: "\nKeyinroq urunib ko'rish",
          textButton1: "Yoq",
          textButton2: "Xa",
          visibleButton1: false,
          visibleButton2: false,
        );
      });
      Future.delayed(Duration(seconds: 9), () {
        exit(0);
      });
      dialogNoInternet(
        contentText:
            "\nSizda internet yoq!!!\n\nMa'lumotlaringiz telefon xotirasidan topilmadi keyinroq yana urinib ko'ring",
        textButton1: "Yoq",
        textButton2: "Xa",
        visibleButton1: false,
        visibleButton2: false,
      );
    }
  }

  void dialogNoInternet({
    String contentText,
    String textButton1,
    String textButton2,
    bool visibleButton1,
    bool visibleButton2,
  }) {
    showDialog(
        barrierColor: Colors.white,
        barrierDismissible: false,
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text(
                "DTM",
                style: TextStyle(color: Colors.indigo.shade700),
              ),
              content: new Text(
                contentText,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              actions: <Widget>[
                Visibility(
                  child: FlatButton(
                    child: Text(textButton1),
                    onPressed: () {
                      Navigator.of(context).pop();
                      dialogNoInternet(
                        contentText: "\nKeyinroq yana urunib ko'ring!!!\n",
                        textButton1: "Yoq",
                        textButton2: "Xa",
                        visibleButton1: false,
                        visibleButton2: false,
                      );
                      Future.delayed(Duration(seconds: 3), () {
                        exit(0);
                      });
                    },
                  ),
                  visible: visibleButton1,
                ),
                Visibility(
                  child: FlatButton(
                    child: Text(textButton2),
                    onPressed: () {
                      Navigator.of(context).pop();
                      /////////////////////////////////////////////////////////////////////// Offline ishlashda login parol tekshirish
                      try {
                        if (contrLogin.text.toString().trim() ==
                                boxs.get("checkLogin").toString().trim() &&
                            contrPassword.text.toString().trim() ==
                                boxs.get("checkPassword").toString().trim()) {
                          /////////////////////////////////////////////////
                          Navigator.pushReplacementNamed(context, FirstPage.id);
                        } else {
                          iphoneDialog();
                        }
                      } catch (e) {
                        iphoneDialog();
                      }
                      ///////////////////////////////////////////////////////////////////// Login Parol offline tekshirildi
                    },
                  ),
                  visible: visibleButton2,
                ),
              ],
            ));
  }

  void iphoneDialog() {
    showDialog(
        barrierColor: Colors.white.withOpacity(0.9),
        barrierDismissible: false,
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text(
                "DTM",
                style: TextStyle(
                    color: Colors.indigo.shade700,
                    fontSize: MediaQuery.of(context).size.width * 0.06),
              ),
              content: Container(
                margin: EdgeInsets.only(top: 15, bottom: 10),
                child: new Text(
                  "login yoki parolda xatolik",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Yana urunib ko'rish", style: TextStyle(color: Colors.blue.shade800),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

              ],
            ));
  }

  void kirishButtonAction2(String response) {
    ModelLogin1 modelLogin1 = HttpNetworks.postAuthorizeParse(response);
    modelData1 = modelLogin1.data1;
    print(modelLogin1.status.toString());
    try {
      if (modelLogin1.status == 1 && _checkBox) {
        boxs.delete("getLogin");
        boxs.delete("getPass");
        boxs.delete("getCheckBox");
        boxs.delete("checkLogin");
        boxs.delete("checkPassword");

        ///
        boxs.put("getLogin", contrLogin.text.toString());
        boxs.put("getPass", contrPassword.text.toString());

        boxs.put("checkLogin", contrLogin.text.toString());
        boxs.put("checkPassword", contrPassword.text.toString());

        boxs.put("getCheckBox", "1");
      }
      if (!_checkBox && modelLogin1.status == 1) {
        boxs.delete("getLogin");
        boxs.delete("getPass");
        boxs.delete("getCheckBox");
      }
    } catch (e) {}
    print(modelData1.authorizationCode);
    print(modelData1.expiresAt);
    print(modelData1.active);

    HttpNetworks.postaccToken(
            HttpNetworks.accesstoken1,
            HttpNetworks.postAccesstokenParam2(
                authorizationCode: modelData1.authorizationCode))
        .then((value) => {
              print(value),
              tokenParse(value),
            });
  }

  void tokenParse(String response) {
    ModelGetToken1 modelGetToken1 = HttpNetworks.postParseToken(response);
    ModelGetToken2 modelGetToken2 = modelGetToken1.modelGetToken2;
    print("//////////////////////");
    print(modelGetToken2.accessToken);
    // print(modelGetToken2.expires_at);
    getTestPost(modelGetToken2.accessToken);
  }

  void getTestPost(String vareable) {
    boxs.put("token", vareable);
    Map<String, String> _map1 = {"X-Access-Token": vareable};
    HttpNetworks.postGetTest(
            HttpNetworks.getTestURL, _map1, HttpNetworks.emptParam())
        .then((value) => {
              print("|||||||||||||||||||||||"),
              print(value),
              getUserValue(value),
            });
  }

  void getChet() {
    String vareable = boxs.get("token").toString().trim();
    Map<String, String> _map1 = {"X-Access-Token": vareable};
    HttpNetworks.postGetTest(
            HttpNetworks.getChetType, _map1, HttpNetworks.typeID())
        .then((value) => {
              boxs.put("sobir2", value),
              print("77777"),
              print(boxs.get('sobir2')),
            });
  }

  void getUserValue(String response) {
    boxs.delete("sobir");
    boxs.put("sobir", response);
    getChet();
    progressDialog.dismiss();
    print(response);
    boxs.put("login", logi);
    boxs.put("password", passw);

    Navigator.pushReplacementNamed(context, FirstPage.id);
  }

  static bool _checkBox = false;

  void forCheckBox() {}

  /// UI
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size,
        // height: MediaQuery.of(context).size.height,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.3,
              ),
              Image.asset(
                "assets/images/gerb1.jpg",
                height: MediaQuery.of(context).size.width * 0.24,
                width: MediaQuery.of(context).size.width * 0.24,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Davlat test markazi".toUpperCase(),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: size * 0.1,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1,
                    size * 0.1,
                    size * 0.1,
                    size * 0.1),
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topRight, colors: [
                    Colors.grey[200],
                    Colors.grey[100],
                  ]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size * 0.4),
                    // bottomLeft: Radius.circular(size * 0.4),
                    // topRight:  Radius.circular(size * 0.4),
                    bottomRight: Radius.circular(size * 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size * 0.05,
                    ),
                    Container(
                      // height: size * 0.5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(size * 0.03),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(171, 171, 171, 0.6),
                              blurRadius: 20,
                              offset: Offset(0.2, 0.2),
                            ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: size * 0.05,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: size * 0.03,
                                right: size * 0.03,
                                top: size * 0.03),
                            child: TextField(
                              // cursorHeight: 100,
                              controller: contrLogin,
                              maxLength: 12,
                              maxLines: 1,
                              // maxLengthEnforced: true,
                              decoration: InputDecoration(
                                  // border: InputBorder.none,
                                  hintText: 'Login',
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: size * 0.03),
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(color: Colors.white),
                            )),
                            child: TextField(
                              controller: contrPassword,
                              maxLength: 12,
                              maxLines: 1,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                  // border: InputBorder.none,

                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Eslab qolish",
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                              Checkbox(
                                value: _checkBox,
                                onChanged: (bool value) {
                                  setState(() {
                                    if (_checkBox) {
                                      _checkBox = false;
                                    } else {
                                      _checkBox = true;
                                    }
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size * 0.1,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          checkInternet();

                          // Navigator.pushReplacementNamed(context, Bosh.id);
                        });
                      },
                      child: Container(
                        height: size * 0.13,
                        width: size * 0.7,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  offset: Offset(0.2, 0.2),
                                  spreadRadius: 1)
                            ],
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blueGrey),
                        child: GestureDetector(
                          onTap: () {},
                          child: Center(
                              child: Text(
                            'Kirish',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size * 0.14,
                    ),
                    Text(
                      'Dasturiy texnik ta\'minot',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade300),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
