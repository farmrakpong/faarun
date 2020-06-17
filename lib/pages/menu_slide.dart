import 'package:faarun/pages/about_page.dart';
import 'package:faarun/pages/history_page.dart';
import 'package:faarun/pages/home_page.dart';
import 'package:faarun/pages/recommend_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'contact_page.dart';

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
      body: Container(
        width: screenWidth*0.6,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0,top: 28),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset("assets/images/logo_puiya.jpg",width: 0.5*screenWidth,)
                  ],
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryPage(),
                      ),
                    ).then((value){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    });
//                    Navigator.pushReplacement(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => HistoryPage(),
//                      ),
//                    );
                  },
                  child: Text(
                    "ประวัติการสั่งซื้อ",
                    style: TextStyle(color:Colors.black,fontSize: 25),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecomendPage(),
                      ),
                    ).then((value){

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    });
                  },
                  child: Text(
                    "เจ้าหน้าที่",
                    style: TextStyle(color:Colors.black,fontSize: 25),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutPage(),
                        ),
                      ).then((value){

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      });
//                      Navigator.pushReplacement(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => AboutPage(),
//                        ),
//                      );
                    },
                    child: Text(
                      "เกี่ยวกับเรา",
                      style: TextStyle(color:Colors.black,fontSize: 25),
                      textAlign: TextAlign.left,
                    ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactPage(),
                      ),
                    ).then((value){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    });
//                    Navigator.pushReplacement(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => ContactPage(),
//                      ),
//                    );
                  },
                  child: Text(
                    "ติดต่อเรา",
                    style: TextStyle(color:Colors.black,fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
