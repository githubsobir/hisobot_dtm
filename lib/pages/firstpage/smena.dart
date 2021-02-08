import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hisobot_dtm/pages/second/secondpage.dart';
import 'package:hisobot_dtm/strings.dart';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';



class SmenaTanlash extends StatefulWidget {
  static final String id = "SmenaTanlash";

  @override
  _SmenaTanlashState createState() => _SmenaTanlashState();
}

class _SmenaTanlashState extends State<SmenaTanlash> {
  var boxs = Hive.box("online");

  String getDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd.MM.yyyy');
    String formattedDate = formatter.format(now);
    print(formattedDate);
    boxs.delete("date");
    boxs.put("date",formattedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    double sized = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(getDate().toString()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          width: sized,
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.only(topLeft: Radius.circular(sized * 0.74)),
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
                  for (int i = 0; i < Strings.smenaString.length; i++)
                    exampleBtn(
                        named: Strings.smenaString[i],
                        sized: sized,
                        id: (i+1)
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget exampleBtn({String named, double sized, int id}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.2, 0.2),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            named,
            style: TextStyle(
              color: Colors.black,
              fontSize: sized * 0.05,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      onTap: () {
        boxs.delete("smena");
        boxs.put("smena", (id));
        Navigator.pushReplacementNamed(context, SecondPage.id);
      },
    );
  }
}
