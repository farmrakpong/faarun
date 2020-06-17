import 'package:faarun/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
    );
  }

  Widget content(context) {
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
//                            Navigator.pushReplacementNamed(context, HOME_PAGE);
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
                margin: EdgeInsets.only(top: 130),
                child: _listContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listContent() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 22, bottom: 15),
          child: Text(
            'ติดต่อเรา',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19.0),
            child: Stack(
              children: <Widget>[
                Center(child: Image.asset("assets/images/about_918x522.jpg")),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 20, right: 20),
          child: Text(
            "บริษัทฟ้าอรุณพืชผลเพื่อไทยจำกัด",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 25, height: 1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 0, right: 20),
          child: Text(
            "888 ม.14 ต.จรเข้สามพัน อ.อู่ทอง\nจ.สุพรรณบุรี 72160",
            style: TextStyle(fontSize: 25, height: 1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 20, right: 20),
          child: Container(
            width: 0.95*screenWidth,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Row(
                children: <Widget>[
                  Text(
                    "เว็บไซต์ : ",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      _openLink('http://www.faaruncompany.com/');
                    },
                    child: Text(
                      ' http://www.faaruncompany.com ',
                      style: TextStyle(fontSize: 25, height: 1.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 0, right: 20),
          child: Row(
            children: <Widget>[
              Text(
                "อีเมล : ",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  _openLink('mailto:faarunthai@gmail.com');
                },
                child: Text(
                  ' faarunthai@gmail.com',
                  style: TextStyle(fontSize: 25, height: 1.2),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 0, right: 20),
          child: Row(
            children: <Widget>[
              Text(
                "Facebook Page : ",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  _openLink('https://www.facebook.com/FaarunThailand/');
                },
                child: Text(
                  ' FaarunThailand',
                  style: TextStyle(fontSize: 25, height: 1.2),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 0, right: 20),
          child: Row(
            children: <Widget>[
              Text(
                "Line : ",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  _openLink('https://lin.ee/2EFSPmkUR');
                },
                child: Text(
                  ' @faarun888',
                  style: TextStyle(fontSize: 25, height: 1.2),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 0, right: 20),
          child: Row(
            children: <Widget>[
              Text(
                "เบอร์โทรศัพท์ : ",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  _callOther('035-969-696');
                },
                child: Text(
                  ' 035-969-696 ',
                  style: TextStyle(fontSize: 25, height: 1.2),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 20, right: 20),
          child: Row(
            children: <Widget>[
//              Text(
//                "สายตรง : ",
//                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//              ),
              InkWell(
                onTap: () {
                  _callOther('06-3706-4444');
                },
                child: Image.asset(
                    "assets/images/hotline1.png",
                    width: screenWidth-42,
                ),
//                Text(
//                  ' 06-3706-4444 ',
//                  style: TextStyle(fontSize: 25, height: 1),
//                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 10, right: 20,bottom: 10),
          child: Row(
            children: <Widget>[
//              Text(
//                "สายด่วน : ",
//                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//              ),
              InkWell(
                onTap: () {
                  _callOther('083-547-2222');
                },
                child: Image.asset(
                  "assets/images/hotline2.png",
                  width: screenWidth-42,
                ),
//                Text(
//                  ' 083-547-2222 ',
//                  style: TextStyle(fontSize: 25, height: 1),
//                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: footer(),
        ),
      ],
    );
  }

  Widget footer() {
    return Stack(
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
    );
  }

  _openLink(String link) async {
    var url = link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
