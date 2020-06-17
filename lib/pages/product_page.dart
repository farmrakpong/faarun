import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faarun/constant/constant.dart';
import 'package:faarun/models/Carts.dart';
import 'package:faarun/pages/summary_page.dart';
import 'package:faarun/services/CartsData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bubble/bubble.dart';

class ProductPage extends StatefulWidget {
  final DocumentSnapshot productItem;

  ProductPage({this.productItem});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  DocumentSnapshot _producItem;
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);

  TextEditingController _controllers = new TextEditingController();

  int sumCurrentCarts = 0;
  String sumCurrentCartsString = "0";

  @override
  void initState() {
    // TODO: implement initState
    calculateCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _producItem = widget.productItem;
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    _controllers.text = "1";

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
//                              Navigator.pushReplacementNamed(
//                                  context, HOME_PAGE);
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
                                Container(
                                    width: 0.4*screenWidth,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        " รวมทั้งหมด " +
                                            sumCurrentCartsString +
                                            " บาท",
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            height: 1.2),
                                      ),
                                    )
                                ),
//                                Text(
//                                  " รวมทั้งหมด " + sumCurrentCartsString + " บาท",
//                                  style: TextStyle(
//                                      fontSize: 24,
//                                      color: Colors.white,
//                                      height: 1.4),
//                                ),
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
                                    child: FittedBox(
                                      child: Text(
                                        BTN_TXT_CHECKBILL,
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    print("Tap check bill");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SummaryPage(),
                                      ),
                                    ).then((value){
                                      print("คลิกเช็คบิลจากหน้า product");
                                      setState(() {
                                        calculateCarts();
                                      });
                                    });
//                                    Navigator.pushReplacement(
//                                      context,
//                                      MaterialPageRoute(
//                                        builder: (context) => SummaryPage(),
//                                      ),
//                                    ).then((value){
//                                      print("คลิกเช็คบิลจากหน้า product");
//                                      setState(() {
//                                        calculateCarts();
//                                      });
//                                    });
//                                    Navigator.popUntil(context, ModalRoute.withName(HOME_PAGE));
//                                    Navigator.pushReplacement(
//                                      context,
//                                      MaterialPageRoute(
//                                        builder: (context) => SummaryPage(),
//                                      ),
//                                    );

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
              Center(
                child: Container(
                  height: screenHeight,
                  margin: EdgeInsets.only(top: 180),
                  child: _listproduct(),
                ),
              ),
            ],
          )),
    );
  }

  Widget _listproduct() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        Container(
//          color: Colors.amber,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Stack(
              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(top: 50,bottom: 50),
//                  child: Center(
//                    child: CircularProgressIndicator(),
//                  ),
//                ),
                Center(
                  child: CachedNetworkImage(
                    placeholder: (context, url){
                      return Container(
                        child: Center(
                          child: Image.asset('assets/images/loading_500x300.gif'),
                        ),
                      );
                    },
                    errorWidget: (context, url, error){
                      return Container(
                        child: Center(
                          child: Text(
                            "ไม่สามารถเชื่อมต่อ\nอินเทอร์เน็ตได้",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    imageUrl: _producItem['img_big'],
                    fit:BoxFit.fitWidth,
                  ),
//                  FadeInImage.assetNetwork(
//                    placeholder: 'assets/images/loading_500x300.gif',
//                    image: _producItem['img_big'],
//                    fit: BoxFit.fitWidth,
//                  ),
                ),
              ],
            ),


          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Text(
            _producItem['name'],
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 12, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
//                  color: Colors.amber,
                  child: Text(
                    _producItem['price'] + " บาท",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Hexcolor("#509D34"),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            var tmp = (int.parse(_controllers.text) - 1);
                            if (tmp > 0) {
                              _controllers.text = tmp.toString();
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Hexcolor("#DCDCDC"),
                                ),
                                shape: BoxShape.rectangle,
                              ),
                              padding: EdgeInsets.all(2),
                              child:Padding(
                                padding: EdgeInsets.only(left: 2,right: 2),
                                child: FaIcon(
                                        FontAwesomeIcons.minus,
                                        color: Hexcolor("#6A6A6A"),
                                        size: 19,
                                      ),
                              ),
                          ),
                        ),

                        Container(
                          width: 35,
                          height: 27,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 1.0,
                                color: Hexcolor("#DCDCDC"),
                              ),
                              bottom: BorderSide(
                                width: 1.0,
                                color: Hexcolor("#DCDCDC"),
                              ),
                            ),
                          ),
                          child: TextField(
                            style: TextStyle(
                                color: Hexcolor("#509D34"),
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top:10,bottom: 10,left: 0,right: 0),
                              border: InputBorder.none,
                            ),
                            controller: _controllers,
                            keyboardType: TextInputType.number,
                            enabled: false,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _controllers.text =
                                (int.parse(_controllers.text) + 1).toString();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Hexcolor("#DCDCDC"),
                              ),
                              shape: BoxShape.rectangle,
                            ),
                            padding: EdgeInsets.all(2),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2,right: 2),
                              child: FaIcon(
                                FontAwesomeIcons.plus,
                                color: Hexcolor("#6A6A6A"),
                                size: 19,
                              ),
                            ),
                          ),

                        ),

                      ],
                    ),
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
                        child:FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: (){
                              Carts _cartitem = new Carts();
                              _cartitem.productId = _producItem['id'];
                              _cartitem.productSku = _producItem['sku'];
                              _cartitem.productName = _producItem['name'];
                              _cartitem.productPrice = _producItem['price'];
                              _cartitem.productImgThumb = _producItem['img_thumb'];
                              _cartitem.qty = _controllers.text;
                              _cartitem.productCatId = _producItem['cat_id'];
                              var _checkReturn = CartsData().addCart(carts: _cartitem);

                              _controllers.text = "1";

                              _checkReturn.then((value) =>
                                  calculateCarts()
                              );
                              print("clidk buy");
                              addItemAnima(_producItem['img_thumb']);
                            },
                            child:Text(
                              BTN_TXT_BUY,
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
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 10, top: 10),
          child: Text(
            _producItem['discription'],
            style: TextStyle(
              fontSize: 24,
              height: 1,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 10, top: 10),
          child: Text(
            _producItem['net_weight'],
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 10, top: 15),
          child: Text(
            "ความเห็นจากผู้ซื้อ",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        Center(child: _comment(),),
        footer(),
      ],
    );
  }

  Widget _comment() {
    print(_producItem['id']);
    return StreamBuilder(
        stream: Firestore.instance.collection('Comments').where("product_id",isEqualTo: _producItem['id']).where("status",isEqualTo: "1").orderBy("sequence").snapshots(),
        builder: (context,snapshot){
          if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.only(top: 10,left: 10,right: 10),
              child: _listViewComment(comment: snapshot.data),
            );
          } else if (snapshot.hasError) {
              return AlertDialog(
                title: Text("ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้"),
                content: Text("กรุณาตรวจสอบอินเทอร์เน็ตของท่าน"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('ตกลง'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
            return CircularProgressIndicator();
        },
    );
//    return FutureBuilder<List<Comment>>(
//      future: NetworkComment.fatchComment(product_id: _producItem['id']),
//      builder: (context,snapshot){
//        if (snapshot.hasData) {
//          return Container(
//            margin: EdgeInsets.only(top: 10,left: 10,right: 10),
//            child: _listViewComment(comment: snapshot.data),
//          );
//        } else if (snapshot.hasError) {
//          return AlertDialog(
//            title: Text("ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้"),
//            content: Text("กรุณาตรวจสอบอินเทอร์เน็ตของท่าน"),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('ตกลง'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
//          );
//        }
//        return CircularProgressIndicator();
//      },
//    );
  }

  Widget _listViewComment({dynamic comment}){
    List<Widget> widgets = List<Widget>();
    for(var i =0; i<comment.documents.length; i++){
      var item = comment.documents[i];
      if(i%2==0){
        widgets.add(_commentLeft(comment: item));
      }else{
        widgets.add(_commentRight(comment: item));
      }
    }

    return Row(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ],
    );


//    return ListView.builder(
//      padding: EdgeInsets.all(0),
//      physics: NeverScrollableScrollPhysics(),
//      itemCount: comment.length,
//      itemBuilder: (context,index){
//        if(index % 2 == 0){
//          return _commentLeft(comment: comment[index]);
//        }else{
//          return _commentRight(comment: comment[index]);
//        }
//      },
//    );

  }

  Widget _commentLeft({DocumentSnapshot comment}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 0.2*screenWidth,
          child: ClipOval(
            child: CachedNetworkImage(
              errorWidget: (context, url, error){
                return Container(
                  width: 50,
                  child: Center(
                    child: Icon(Icons.error),
                  ),
                );
              },
              imageUrl: comment['image'],
              fit: BoxFit.cover,
            ),
//            FadeInImage.memoryNetwork(
//              placeholder: kTransparentImage,
//              image: comment['image'],
//              fit: BoxFit.cover,
//            ),
          ),
        ),
        Container(
          width: 0.74*screenWidth,
          child: Bubble(
            margin: BubbleEdges.only(top: 10,bottom: 10,right: 0,left: 0),
            radius: Radius.circular(20.0),
            alignment: Alignment.topLeft,
            nip: BubbleNip.leftTop,
            nipOffset: 15.00,
            nipWidth: 15,
            color: Hexcolor('#E8E8E8'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  comment['name'],
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                Text(
                  comment['comment'],
                  style: TextStyle(
                    fontSize: 18,
                    height: 1,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }

  Widget _commentRight({DocumentSnapshot comment}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 0.74*screenWidth,
          child: Bubble(
            margin: BubbleEdges.only(top: 10,bottom: 10,right: 0,left: 0),
            radius: Radius.circular(20.0),
            alignment: Alignment.topRight,
            nip: BubbleNip.rightTop,
            nipOffset: 15.00,
            nipWidth: 15,
            color: Hexcolor('#E8E8E8'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                    Text(
                      comment['name'],
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      comment['comment'],
                      style: TextStyle(
                        fontSize: 18,
                        height: 1,
                      ),
                      textAlign: TextAlign.left,
                    ),
              ],
            ),
          ),
        ),
        Container(
          width: 0.2*screenWidth,
          child: ClipOval(
              child: CachedNetworkImage(
                errorWidget: (context, url, error){
                  return Container(
                    width: 50,
                    child: Center(
                      child: Icon(Icons.error),
                    ),
                  );
                },
                imageUrl: comment['image'],
                fit: BoxFit.cover,
              ),
//              FadeInImage.memoryNetwork(
//                placeholder: kTransparentImage,
//                image: comment['image'],
//                fit: BoxFit.cover,
//              ),
          ),
        ),
      ],
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

  calculateCarts() async {
    var _listCurrentCartsQty =
    await CartsData().getCartWithKey(KEY_CURRENT_CARTS_QTY);

    var _listCurrentCartsProductPrice =
    await CartsData().getCartWithKey(KEY_CURRENT_CARTS_PRODUCT_PRICE);

    print(_listCurrentCartsQty);
    print(_listCurrentCartsProductPrice);

    if (_listCurrentCartsQty != null) {

      var _tmpSumCart = 0;
      for (var i = 0; i < _listCurrentCartsQty.length; i++) {
        _tmpSumCart += (int.parse(_listCurrentCartsQty[i]) *
            int.parse(_listCurrentCartsProductPrice[i]));
      }

        setState(() {
          print(_tmpSumCart);
          sumCurrentCarts = _tmpSumCart;
          FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
            amount: sumCurrentCarts.toDouble(),
            settings: MoneyFormatterSettings(
              fractionDigits:0,
            ),
          );
          sumCurrentCartsString  = fmf.output.nonSymbol;
        });
    }else{
      setState(() {
        sumCurrentCartsString = "0";
      });
    }
  }

  addItemAnima(dynamic img){

    var yyDialog = YYDialog().build(context)
      ..width = 0.5*screenWidth
      ..borderRadius = 10.0
      ..barrierColor = Colors.white.withOpacity(0.1)
      ..barrierDismissible = false
      ..showCallBack = () {
        print("showCallBack invoke");
      }
      ..dismissCallBack = () {
        print("dismissCallBack invoke");
      }
      ..widget(Padding(
        padding: EdgeInsets.only(top: 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            placeholder: (context, url){
              return Container(
                width: 180,
                child: Center(
                  child: Image.asset('assets/images/loading_300x300_1.gif'),
                ),
              );
            },
            errorWidget: (context, url, error){
              return Container(
                child: Center(
                  child: Text(
                    "ไม่สามารถเชื่อมต่อ\nอินเทอร์เน็ตได้",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            imageUrl: img,
            width: 0.5*screenWidth,
          ),


//          FadeInImage.assetNetwork(
//            placeholder: 'assets/images/loading_300x300_1.gif',
//            image: img,
//            width: 0.5*screenWidth,
//          ),
        ),
      ))
      ..animatedFunc = (child, animation) {

        return TweenAnimationBuilder(
          tween: Tween<Offset>(begin: Offset(0,-0.15), end: Offset(-0.15, -0.35)),
          duration: Duration(milliseconds: 400),
          curve: Curves.linear,
          builder: (context, offset, child) {

            return FractionalTranslation(
              translation: offset,
              child: Container(
                width: double.infinity,
                child: Center(
                  child: ScaleTransition(
                    scale: Tween(begin: 0.5, end: 0.9).animate(animation),
                    child: FadeTransition(
                      opacity: Tween(begin: 0.0,end: 1.0).animate(animation),
                      child: child,
                    ),
                  ), 
                ),
              ),
            );
          },
          child: child,
          onEnd: () {
            print('onEnd');
          },
        );
      }
      ..show();

    Future.delayed(Duration(milliseconds: 400), () {
      yyDialog?.dismiss();
    });

  }
}
