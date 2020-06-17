

import 'package:faarun/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
                margin: EdgeInsets.only(top: 130),
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
          padding: const EdgeInsets.only(left: 22,bottom: 15),
          child: Text(
            'เกี่ยวกับเรา แอปพลิเคชันปุ๋ยยา',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19.0),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Image.asset("assets/images/about_918x522.jpg")
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22,top: 20,right: 20),
          child: Text(
            'ปันจุบันนั้นช่องทางซื้อขายของเกษตรกรไทยได้เปลี่ยนไปมาก หลังจากมีสื่อโซเชียลมีเดียเข้ามา ทำให้การซื้อขายนั้น สะดวกมากยิ่งขึ้น ',
            style: TextStyle(
              fontSize: 25,
              height: 1
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22,top: 20,right: 20),
          child: Text(
            'และเพื่อเป็นสื่อกลางในการทำการตลาดครบทุกรูปแบบ ในช่องทางโซเชียลมีเดียดังที่กล่าวมานั้น จำเป็นต้องใช้มืออาชีพ ในการบริหารจัดการสื่อ และช่องทางการขายใหม่อย่างถูกต้อง',
            style: TextStyle(
              fontSize: 25,
                height: 1
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22,top: 20,right: 20),
          child: Text(
            'แอปพลิเคชันปุ๋ยยา จึงขอเป็นตัวแทนสำหรับพี่น้องชาวโรงงานปุ๋ย ที่ผลิตปุ๋ยในประเทศไทย ทุกสูตร ทุกชนิด เพื่อเป็นสื่อกลาง ในการจัดจำหน่ายปุ๋ย ยา ของท่าน ในรูปแบบสื่อสมัยใหม่อย่าง แอปพลิเคชัน',
            style: TextStyle(
                fontSize: 25,
                height: 1
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22,top: 20,right: 20),
          child: Text(
            'สำหรับเพื่อนพี่น้องโรงงานปุ๋ย - ยา ที่สนใจ อยากนำสินค้า ของท่านเข้ามาวางจำหน่ายใน “แอปพลิเคชันปุ๋ยยา” ขอให้ท่านติดต่อได้ที่',
            style: TextStyle(
                fontSize: 25,
                height: 1
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22,top: 20,right: 20),
          child: InkWell(
            onTap: (){
              _callOther("06-3706-4444");
            },
            child: Text(
              'สายตรง  : 06-3706-4444',
              style: TextStyle(
                  fontSize: 25,
                  height: 1
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22,top: 0,right: 20,bottom: 20),
          child: InkWell(
            onTap: (){
              _callOther("083-547-2222");
            },
            child: Text(
              'สายด่วน  : 083-547-2222',
              style: TextStyle(
                  fontSize: 25,
                  height: 1
              ),
            ),
          ),
        ),
        footer(),
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
