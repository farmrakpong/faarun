import 'dart:async';


import 'package:faarun/constant/constant.dart';
import 'package:faarun/services/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class RecomendPage extends StatefulWidget {
  @override
  _RecomendPageState createState() => _RecomendPageState();
}

class _RecomendPageState extends State<RecomendPage> {
  double screenWidth, screenHeight;
  final _formKey = GlobalKey<FormState>();
  final _focusNodeInputCodeSale = FocusNode();
  String userCodeSale;
  TextEditingController _codeSaleInput = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    userCodeSale = await UserData().getUserData(key: KEY_USER_CODESALE);
//    print('userCodeSale');
//    print(userCodeSale);
    setState(() {
      _codeSaleInput.text = userCodeSale;
//      recomendform();
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    screenWidth = size.width;
    screenHeight = size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          content(context),
        ],
      ),
      bottomNavigationBar: footer(),
    );
  }

  Widget content(context){

    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        child: Stack(
          children: <Widget>[
            Container(
              child: Image.asset(
                "assets/images/bg_top.png",
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              height: screenHeight,
              padding: const EdgeInsets.only(left: 0, right: 0, top: 48),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          child: Icon(
                            Icons.chevron_left,
                            color: Hexcolor('#43701B'),
                            size: 50,
                          ),
                          onTap: () {
                            Navigator.pop(context);
//                            Navigator.pushReplacementNamed(
//                                context, HOME_PAGE);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(TITLE,
                                  style: TextStyle(
                                      fontSize: 27,
                                      color: Hexcolor('#43701B'),
                                      height: 0.8,
                                      fontWeight: FontWeight.bold)),
                              Text(DISCRIPTION,
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Hexcolor('#43701B'),
                                      height: 0.8)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                height: screenHeight,
                margin: EdgeInsets.only(top: 180),
                child: _listContent(),
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget _listContent(){
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.only(left: 16.0,right: 16.0),
          child: recomendform(),
        ),
      ],
    );
  }
  Widget recomendform(){
//    print(userCodeSale);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19.0),
      ),
      child: Form(
        autovalidate: true,
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 30, bottom: 20),
              child: Center(
                child: Text(
                  "กรอกรหัสพนักงานขาย",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0,left: 16,right: 16),
              child: TextFormField(
                controller: _codeSaleInput,
//                initialValue: userCodeSale,
                focusNode: _focusNodeInputCodeSale,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Hexcolor("#E8E8E8"),
                    ),
                  ),
                  hintText: 'รหัสพนักงานขาย',
                  contentPadding:
                  EdgeInsets.only(left: 10, top: 0, bottom: 0),
                ),
                validator: (value) {
                  return value.isEmpty ? "กรุณากรอกรหัสพนักงานขายด้วยค่ะ" : null;
                },
                textInputAction: TextInputAction.done,

                onSaved: (newValue) {
                  print('save code sale $newValue');
                  userCodeSale = newValue;
                  UserData().setUserData(
                      key: KEY_USER_CODESALE, data: newValue.toString());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              child: Container(
                width: 0.5 * screenWidth,
                height: 35,
                padding:
                EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  gradient: LinearGradient(
                      colors: [Hexcolor("#45962D"), Hexcolor("#94C35C")]),
                ),
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "บันทึก",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  onPressed: () {
                    _formKey.currentState.save();
                    _showAlertSaved();
//                    Navigator.pop(context);
//                          Navigator.pushReplacementNamed(context, HOME_PAGE);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showAlertSaved(){
    showDialog(
      context: context,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19.0),
          ),
          elevation: 5,
          child: Container(
            width: 0.8 * screenWidth,
            height: 225,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: FaIcon(
                    FontAwesomeIcons.solidSave,
                    size: 50,
                    color: Hexcolor("#509D34"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "ระบบบันทึกรหัสพนักงานเรียบร้อยแล้ว",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child: Container(
                        width: 70,
                        height: 30,
                        padding: EdgeInsets.only(
                            left: 0, right: 0, top: 5, bottom: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          gradient: LinearGradient(colors: [
                            Hexcolor("#45962D"),
                            Hexcolor("#94C35C")
                          ]),
                        ),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            "ตกลง",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget footer() {
    return Container(
      height: screenHeight*0.25,
//      color: Colors.amber,
      child: Stack(
        children: <Widget>[
          Container(
//          color: Colors.amber,
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/bg_footer.png",
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Padding(
              padding:  EdgeInsets.only(left: (0.12 * screenWidth), top: (0.27 * screenWidth), bottom:(0.03 * screenWidth) ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 0.6 * screenWidth,
                    child: Text(
                      COMPANY_NAME,
                      style: TextStyle(
                          fontSize: 18,
                          color: Hexcolor("#43701B"),
                          height: 1,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Container(
                    width: 0.6 * screenWidth,
                    child: Text(
                      COMPANY_ADDRESS1,
                      style: TextStyle(
                        fontSize: 18,
                        color: Hexcolor("#43701B"),
                        height: 1,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Container(
                    width: 0.6 * screenWidth,
                    child: Text(
                      COMPANY_ADDRESS2,
                      style: TextStyle(
                        fontSize: 18,
                        color: Hexcolor("#43701B"),
                        height: 1,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Container(
                    width: 0.6 * screenWidth,
                    child: InkWell(
                      onTap: _callPhone,
                      child: Text(
                        'โทรศัพท์ ' + COMPANY_PHONE,
                        style: TextStyle(
                            fontSize: 19,
                            color: Hexcolor("#43701B"),
                            height: 1,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
  _callOther(String phone) async {
    var url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _callPhone() async {
    var url = 'tel:' + COMPANY_PHONE;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
