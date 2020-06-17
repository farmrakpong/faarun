

import 'package:faarun/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class FinishPage extends StatefulWidget {
  @override
  _FinishPageState createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {

  double screenWidth, screenHeight;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
    return Stack(
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
                        Navigator.pushNamedAndRemoveUntil(context, HOME_PAGE, (Route<dynamic> route) => false);
//                        Navigator.pushNamed(context, HOME_PAGE);
//                        Navigator.pop(context);
//                          Navigator.popUntil(context, ModalRoute.withName(HOME_PAGE));
//                        Navigator.pushReplacementNamed(
//                            context, HOME_PAGE);
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
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
                child: Container(
                  width: 0.95*screenWidth,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: FaIcon(
                            FontAwesomeIcons.solidCheckCircle,
                            size: 50,
                            color: Hexcolor("#509D34"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "สั่งซื้อสินค้าเสร็จสิ้น",
                            style: TextStyle(
                              fontSize: 30,
                            fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            "เจ้าหน้าที่จะติดต่อหาท่านโดยเร็วที่สุด",
                            style: TextStyle(
                              fontSize: 28,
//                          fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 45),
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
                                "เรียบร้อย",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, HOME_PAGE, (Route<dynamic> route) => false);
//                                Navigator.pushNamed(context, HOME_PAGE);
//                                Navigator.pop(context);
//                                Navigator.pushReplacementNamed(context, HOME_PAGE);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),

      ],
    );
  }

  Widget footer() {
    return Container(
//      color: Colors.amber,
      height: 0.275*screenHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            width: screenWidth,
            bottom: 0,
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
              padding:  EdgeInsets.only(left: (0.12 * screenWidth), bottom: 20 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
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
  _callPhone() async {
    var url = 'tel:' + COMPANY_PHONE;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
