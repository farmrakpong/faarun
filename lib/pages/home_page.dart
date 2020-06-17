import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faarun/constant/constant.dart';
import 'package:faarun/models/Carts.dart';
import 'package:faarun/pages/product_page.dart';
import 'package:faarun/pages/summary_page.dart';
import 'package:faarun/services/CartsData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:faarun/pages/menu_slide.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  bool isAnima = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  List<String> items = List<String>.generate(10, (index) => "Row: ${index}");
  List<TextEditingController> _controllers = new List();
  List<GlobalKey> _keyListButtonBuy = new List();

  List<Carts> _listCarts = new List<Carts>();

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
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

//    Network.fatchProducts();

    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c){
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19.0),
                ),
                elevation: 5,
                child: Container(
                  width: 0.8 * screenWidth,
                  height: 0.27 * screenHeight,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: FaIcon(
                          FontAwesomeIcons.exclamationCircle,
                          size: 50,
                          color: Hexcolor("#509D34"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "คุณแน่ใจว่าต้องการออกจาก \n แอปพลิเคชันปุ๋ยยา ใช่หรือไม่?",
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
                            padding: const EdgeInsets.only(left: 0, right: 15),
                            child: Container(
                              width: 70,
                              height: 30,
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, top: 5, bottom: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(
                                  color: Hexcolor('#A5A5A5'),
                                  width: 1.0,
                                ),
                              ),
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  print("click Yes");
                                  Navigator.of(c).pop(true);
                                },
                                child: Text(
                                  BTN_TXT_YES,
                                  style: TextStyle(
                                    fontSize: 20,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
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
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  print("click No");
                                  Navigator.of(c).pop(false);
                                },
                                child: Text(
                                  BTN_TXT_NO,
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

//          return AlertDialog(
//            content: Container(
//              width: 0.8 * screenWidth,
//              height: 0.25 * screenHeight,
//              child: Column(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.only(top: 30),
//                    child: FaIcon(
//                      FontAwesomeIcons.exclamationCircle,
//                      size: 50,
//                      color: Hexcolor("#509D34"),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(top: 10, bottom: 10),
//                    child: Text(
//                      "คุณแน่ใจว่าจะออกจาก \n แอปพลิเคชันปุ๋ยยา ใช่หรือไม่?",
//                      style: TextStyle(
//                        fontSize: 23,
//                        fontWeight: FontWeight.w200,
//                      ),
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            actions: [
//              FlatButton(
//                child: Text('ใช่',
//                  style: TextStyle(
//                    fontSize: 20,
//                  ),
//                ),
//                onPressed: () => Navigator.pop(c, true),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(left: 0, right: 0),
//                child: Container(
//                  width: 70,
//                  height: 30,
//                  padding: EdgeInsets.only(
//                      left: 0, right: 0, top: 5, bottom: 4),
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(11),
//                    gradient: LinearGradient(colors: [
//                      Hexcolor("#45962D"),
//                      Hexcolor("#94C35C")
//                    ]),
//                  ),
//                  child: FlatButton(
//                    padding: EdgeInsets.all(0),
//                    onPressed: () {
//                      print("click No");
//                      Navigator.pop(context, false);
//                    },
//                    child: Text(
//                      BTN_TXT_NO,
//                      style: TextStyle(
//                        fontSize: 20,
//                        color: Colors.white,
//                        height: 1,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          );
        }
      ),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            MenuSlide(),
            dashboard(context),
          ],
        ),
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
//                                  " รวมทั้งหมด " +
//                                      sumCurrentCartsString +
//                                      " บาท",
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
                                      fit: BoxFit.scaleDown,
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SummaryPage(),
                                      ),
                                    ).then((value) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ),
                                      );
                                    });
//                                    Navigator.pushReplacement(
//                                      context,
//                                      MaterialPageRoute(
//                                        builder: (context) => SummaryPage(),
//                                      ),
//                                    );
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
              Center(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('Products')
                        .where("status", isEqualTo: "1")
                        .orderBy("sequence")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          height: screenHeight,
                          margin: EdgeInsets.only(top: 170),
                          child: listViewProduct(product: snapshot.data),
                        );
                      } else if (snapshot.hasError) {
                        return Text("ดึงข้อมูล Firebase Error");
                      }
                      return CircularProgressIndicator();
                    }),
              ),
            ],
          )),
    );
  }

  calculateCarts() async {
//    CartsData().removeAllCart();
    var _listCurrentCartsQty =
        await CartsData().getCartWithKey(KEY_CURRENT_CARTS_QTY);

    var _listCurrentCartsProductPrice =
        await CartsData().getCartWithKey(KEY_CURRENT_CARTS_PRODUCT_PRICE);

    print(_listCurrentCartsQty);
    print(_listCurrentCartsProductPrice);

    if (_listCurrentCartsQty != null) {
      //เช็คว่าในตระกร้าว่างหรือไม่
      var _tmpSumCart = 0;
      for (var i = 0; i < _listCurrentCartsQty.length; i++) {
        _tmpSumCart += (int.parse(_listCurrentCartsQty[i]) *
            int.parse(_listCurrentCartsProductPrice[i]));
      }

      setState(() {
        print(_tmpSumCart);
        sumCurrentCarts = _tmpSumCart;
        if (_tmpSumCart != null) {
          FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
            amount: _tmpSumCart.toDouble(),
            settings: MoneyFormatterSettings(
              fractionDigits: 0,
            ),
          );
          sumCurrentCartsString = fmf.output.nonSymbol;
        }
      });
    }else{
      sumCurrentCartsString = "0";
    }
  }

  addItemAnima(dynamic img, dynamic position) {
    print(position);
    var yyDialog = YYDialog().build(context)
      ..width = 180
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
                width: 180,
                child: Center(
                  child: Text(
                    "ไม่สามารถเชื่อมต่อ\nอินเทอร์เน็ตได้",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            imageUrl: img,
            width: 180,
          ),


//          FadeInImage.assetNetwork(
//            placeholder: 'assets/images/loading_300x300_1.gif',
//            image: img,
//            width: 180,
//          ),
        ),
      ))
      ..animatedFunc = (child, animation) {
        var start_dy = 0.0;
        if (position.dy >= 0 && position.dy < 300) {
          start_dy = -0.1;
        } else if (position.dy >= 300 && position.dy < 600) {
          start_dy = (position.dy / 5000);
        } else if (position.dy >= 600) {
          start_dy = 0.3;
        }

        return TweenAnimationBuilder(
          tween: Tween<Offset>(
              begin: Offset(-0.3, start_dy), end: Offset(-0.3, -0.35)),
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
                      opacity: Tween(begin: 0.3,end: 1.0).animate(animation),
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

  _callPhone() async {
    var url = 'tel:' + COMPANY_PHONE;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget listViewProduct({dynamic product}) {
    return ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: product.documents.length + 1,
        itemBuilder: (context, index) {
          _keyListButtonBuy.add(new GlobalKey());
          _controllers.add(new TextEditingController());
          _controllers[index].text = "1";
          if (product.documents.length == index) {
            return footer();
          } else {
            var item = product.documents[index];

            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 0, top: 0),
              child: IntrinsicHeight(
                child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    itemsImage(
                      productItem: item,
                      index: index,
                    ),
                    itmesDetail(index: index, productItem: item),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget itemsImage({DocumentSnapshot productItem, int index}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(productItem: productItem),
          ),
        ).then((value) {
          print("กลับมาจากหน้า products");
          setState(() {
            calculateCarts();
          });
        });
//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//            builder: (context) => ProductPage(productItem: productItem),
//          ),
//        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 0, bottom: 15),
        child: Stack(
          children: <Widget>[
//              Container(
//                width: 0.4 * screenWidth,
//                child: Center(
//                  child: CircularProgressIndicator(),
//                ),
//              ),
            Center(
              key: _keyListButtonBuy[index],
              child: ClipRRect(

                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  placeholder: (context, url){
                    return Container(
                      width: 0.4 * screenWidth,
                      child: Center(
                        child: Image.asset('assets/images/loading_300x300_1.gif'),
                      ),
                    );
                  },
                  errorWidget: (context, url, error){
                    return Container(
                      width: 0.4 * screenWidth,
                      child: Center(
                        child: Text(
                          "ไม่สามารถเชื่อมต่อ\nอินเทอร์เน็ตได้",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                  imageUrl: productItem['img_thumb'],
                  width: 0.4 * screenWidth,
                ),


//                FadeInImage.assetNetwork(
//                  placeholder: 'assets/images/loading_300x300_1.gif',
//                  image: productItem['img_thumb'],
//                  width: 0.4 * screenWidth,
//                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itmesDetail({DocumentSnapshot productItem, int index}) {
//      print(indexlist);
//      print(productItem['name']);

    return Container(
        padding: EdgeInsets.only(left: 25, right: 10, top: 10, bottom: 18),
        width: 0.54 * screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Text(
                productItem['name'],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
//            SizedBox(
//              height: 0.04 * screenHeight,
////              child: AutoSizeText(
////                productItem['name'],
////                style: TextStyle(
////                  fontSize: 28,
////                  fontWeight: FontWeight.bold,
////                  height: 1,
////                ),
////                maxFontSize: 30,
////                maxLines: 1,
////              ),
//            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Container(
//                color: Colors.amber,
                child: Text(
                  productItem['shot_discription'],
                  style: TextStyle(
                    fontSize: 25,
                    height: 0.9,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
//              SizedBox(
//                height: 0.07 * screenHeight,
//                child: AutoSizeText(
//                  productItem['shot_discription'],
//                  style: TextStyle(
//                    fontSize: 25,
//                    height: 0.9,
//                  ),
//                  maxFontSize: 30,
//                  textAlign: TextAlign.left,
//                  maxLines: 3,
//                ),
//              ),
            ),
            Text(
              productItem['net_weight'],
              style: TextStyle(fontSize: 18),
            ),
            Text(
              productItem['price'] + " บาท",
              style: TextStyle(
                fontSize: 30,
                color: Hexcolor("#509D34"),
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        var tmp = (int.parse(_controllers[index].text) - 1);
                        if (tmp > 0) {
                          _controllers[index].text = tmp.toString();
                        }
                        print("ลด " + index.toString());
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
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              top: 9, bottom: 9, left: 0, right: 0),
                        ),
                        controller: _controllers[index],
                        keyboardType: TextInputType.number,
                        enabled: false,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _controllers[index].text =
                            (int.parse(_controllers[index].text) + 1)
                                .toString();
                        print("เพิ่ม " + _controllers[index].text);
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
                        child: FaIcon(
                          FontAwesomeIcons.plus,
                          color: Hexcolor("#6A6A6A"),
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 70,
                  height: 30,
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
                      BTN_TXT_BUY,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    onPressed: () {
//                        var repo = new FuturePreferencesRepository<Carts>(new CartsdesSer());
//                        repo.save(new Carts(
//                          productItem.id,
//                          productItem.name,
//                          productItem.imgThumb,
//                          productItem.sku,
//                          productItem.price,
//                          _controllers[index].text,
//                        ));
//                        var list = repo.findAll();
//                        print(list);

                      Carts _cartitem = new Carts();
                      _cartitem.productId = productItem['id'];
                      _cartitem.productSku = productItem['sku'];
                      _cartitem.productName = productItem['name'];
                      _cartitem.productPrice = productItem['price'];
                      _cartitem.productImgThumb = productItem['img_thumb'];
                      _cartitem.qty = _controllers[index].text;
                      _cartitem.productCatId = productItem['cat_id'];

                      var _checkReturn = CartsData().addCart(carts: _cartitem);

                      _controllers[index].text = "1";

                      _checkReturn.then((value) => calculateCarts());
                      final RenderBox renderBox = _keyListButtonBuy[index]
                          .currentContext
                          .findRenderObject();
                      final positionOffset =
                          renderBox.localToGlobal(Offset.zero);

                      addItemAnima(productItem['img_thumb'], positionOffset);
                      print("click buy");
                    },
                  ),
                )
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
            padding: EdgeInsets.only(
                left: (0.12 * screenWidth),
                top: (0.27 * screenWidth),
                bottom: (0.03 * screenWidth)),
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


}
