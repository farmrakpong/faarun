import 'package:flutter/material.dart';

class MenuSlide extends StatefulWidget {
  @override
  _MenuSlideState createState() => _MenuSlideState();
}

class _MenuSlideState extends State<MenuSlide> {
  double screenWidth, screenHeight;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0,top: 28),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(

            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset("assets/images/logo_menu.png",width: 0.5*screenWidth,)
                ],
              ),
              Text(
                "ประวัติการสั่งซื้อสินค้าของฉัน",
                style: TextStyle(color:Colors.black,fontSize: 25),
              ),
              SizedBox(height: 10),
              Text(
                "เกี่ยวกับเรา",
                style: TextStyle(color:Colors.black,fontSize: 25),
              ),
              SizedBox(height: 10),
              Text(
                "ติดต่อเรา",
                style: TextStyle(color:Colors.black,fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
