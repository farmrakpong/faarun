import 'dart:async';

import 'package:faarun/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:faarun/pages/menu_slide.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_listview/easy_listview.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  List<String> items = List<String>.generate(10, (index) => "Row: ${index}");
  List<TextEditingController> _controllers = new List();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          MenuSlide(),
          dashboard(context),
        ],
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.4 * screenWidth,
      child: Material(
          elevation: 8.0,
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
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            child: FaIcon(
                              FontAwesomeIcons.bars,
                              color: Hexcolor('#43701B'),
                              size: 40,
                            ),
                            onTap: () {
                              setState(() {
                                isCollapsed = !isCollapsed;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
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
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 0.62 * screenWidth,
                            padding: const EdgeInsets.only(left: 7),
                            margin: const EdgeInsets.only(top: 20),
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              gradient: LinearGradient(colors: [
                                Hexcolor("#41942B"),
                                Hexcolor("#BBDA74")
                              ]),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  " รวมทั้งหมด " + SUM_CART.toString() + " บาท",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      height: 1.4),
                                ),
                                InkWell(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 6, bottom: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      gradient: LinearGradient(colors: [
                                        Hexcolor("#499D34"),
                                        Hexcolor("#3F560D")
                                      ]),
                                    ),
                                    child: Text(
                                      BTN_TXT_CHECKBILL,
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    print("Tap check bill");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight,
                margin: EdgeInsets.only(top: 170),
                child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: items.length + 1,
                    itemBuilder: (context, index) {
                      _controllers.add(new TextEditingController());
                      _controllers[index].text="1";
                      if (items.length == index) {
                        return footer();
                      } else {
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 16, right: 0, top: 0),
                          child: IntrinsicHeight(
                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                itemsImage(),
                                itmesDetail(index)
//                                Expanded(child: itemsImage()),
//                                Expanded(child: itmesDetail(index)),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ],
          )),
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

  Widget itemsImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 0, bottom: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          "assets/images/product_moc.jpg",
          width: 0.4 * screenWidth,
        ),
      ),
    );
  }

  Widget itmesDetail(index) {
//    print(index);
    return Container(
        padding: EdgeInsets.only(left: 25, right: 20, top: 10, bottom: 18),
//        color: Colors.red,
        width: 0.54 * screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "ปุ๋ยฟ้าอรุณ",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                "ขยายขนาดของผลให้ใหญ่ ป้องกันผลพืชแตก ลดปัญหาผลหลุดร่วง",
                style: TextStyle(
                  fontSize: 23,
                  height: 0.9,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              "น้ำหนักสุทธิ 50 กิโลกรัม",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "690 บาท",
              style: TextStyle(
                fontSize: 30,
                color: Hexcolor("#509D34"),
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                      color: Hexcolor("#6A6A6A"),
                    ),
                    shape: BoxShape.rectangle,
                  ),
                  padding: EdgeInsets.all(2),
                  child: InkWell(
                    onTap: (){
                      var tmp = (int.parse(_controllers[index].text)-1);
                      if(tmp>0){
                        _controllers[index].text=tmp.toString();
                      }
                      print("ลด "+index.toString());
                    },
                    child: FaIcon(
                      FontAwesomeIcons.minus,
                      color: Hexcolor("#6A6A6A"),
                      size: 15,
                    ),
                  ),
                ),
                Container(
                  width: 35,
                  height: 22,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1.0,
                        color: Hexcolor("#6A6A6A"),
                      ),
                      bottom: BorderSide(
                        width: 1.0,
                        color: Hexcolor("#6A6A6A"),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 26,left: 2),
                    child: TextField(
                      style: TextStyle(color: Hexcolor("#509D34"),fontSize: 24,fontWeight: FontWeight.bold),
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,

                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                      color: Hexcolor("#6A6A6A"),
                    ),
                    shape: BoxShape.rectangle,
                  ),
                  padding: EdgeInsets.all(2),
                  child: InkWell(
                    onTap: (){
                      _controllers[index].text=(int.parse(_controllers[index].text)+1).toString();
                      print("เพิ่ม "+_controllers[index].text);
                    },
                    child: FaIcon(
                      FontAwesomeIcons.plus,
                      color: Hexcolor("#6A6A6A"),
                      size: 15,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        gradient: LinearGradient(colors: [
                          Hexcolor("#41942B"),
                          Hexcolor("#A0CA64")
                        ]),
                      ),
                      child: Text(
                        BTN_TXT_BUY,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                    onTap: () {
                      print("Tap Buy");
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget footer() {
    return Stack(
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
            padding: const EdgeInsets.only(left: 84, top: 130, bottom: 20),
            child: Column(
              children: <Widget>[
                Container(
                  width: 0.5 * screenWidth,
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
                  width: 0.5 * screenWidth,
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
                  width: 0.5 * screenWidth,
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
                    width: 0.5 * screenWidth,
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

  Widget _header() {
    return Container(
      height: 500,
      color: Colors.red,
    );
  }

  Widget _detail() {
    return Container(
      height: 800,
      color: Colors.blue,
    );
  }
}
