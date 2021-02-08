import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hisobot_dtm/models/modelloginpage1.dart';
import 'package:hisobot_dtm/pages/firstpage/smena.dart';
import 'package:hisobot_dtm/services/httpnetwork.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class FirstPage extends StatefulWidget {
  static final String id = "myid";
  static String nameStatic;
  static String idStatic;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  ModelGetTest1 modelGetTest1;
  var boxs = Hive.box("online");

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  var contrText = TextEditingController();
  ArsProgressDialog progressDialog;

  String getDate() {
    final String formatted = formatter.format(now);
    return formatted; // something like 2013-04-20.
  }

  int getName() {
    modelGetTest1 = HttpNetworks.parseEmplist(boxs.get("sobir"));
    return modelGetTest1.data.length;
  }

  @override
  Widget build(BuildContext context) {
    // parse

    double sizeWidth = MediaQuery.of(context).size.width;
    Future<bool> _onBackPressed() {
      return showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: true,
          builder: (context) => new CupertinoAlertDialog(
                title: Container(
                  margin: EdgeInsets.only(top: 2, bottom: sizeWidth * 0.04),
                  child: Text(
                    "DTM",
                    style: TextStyle(
                        color: Colors.indigo.shade700,
                        fontSize: sizeWidth * 0.06),
                  ),
                ),
                content: Container(
                  margin: EdgeInsets.only(top: 5, bottom: sizeWidth * 0.04),
                  child: Text(
                    "Dasturdan chiqmoqchimisiz?",
                    style: TextStyle(
                        color: Colors.black, fontSize: sizeWidth * 0.045),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Yoq",
                      style: TextStyle(fontSize: sizeWidth * 0.04),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Xa",
                      style: TextStyle(fontSize: sizeWidth * 0.04),
                    ),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      exit(0);
                    },
                  )
                ],
              ));
    }

    return new WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          title: Text(
            "Hudud nomi ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _onBackPressed();
              }),
          // backwardsCompatibility: true,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(sizeWidth * 0.01),
            height: MediaQuery.of(context).size.height,
            width: sizeWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                // topLeft: Radius.circular(sizeWidth * 0.74),
                topRight: Radius.circular(sizeWidth * 0.74),
                // bottomLeft: Radius.circular(sizeWidth * 0.74),
              ),
              color: Colors.grey[300],
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(sizeWidth * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < getName(); i++)
                      myWidgetModel(
                        name: modelGetTest1.data[i].name,
                        id: modelGetTest1.data[i].id.toString(),
                        sized: sizeWidth,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myWidgetModel({String name, String id, double sized}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sized * 0.02),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.2, 0.2),
                spreadRadius: 1,
                blurRadius: 10,
              )
            ]),
        child: Center(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      onTap: () {
        boxs.delete("harbiyId");
        boxs.delete("harbiyName");
        boxs.put("harbiyId", id);
        boxs.put("harbiyName", name);
        Navigator.pushNamed(context, SmenaTanlash.id);
      },
    );
  }
}
