import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:faarun/constant/constant.dart';
import 'package:faarun/models/Carts.dart';
import 'package:faarun/models/Promotions.dart';
import 'package:faarun/pages/finish_page.dart';
import 'package:faarun/services/CartsData.dart';
import 'package:faarun/services/UserData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:transparent_image/transparent_image.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  Completer<GoogleMapController> _controllerGooglemap = Completer();

  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  List<TextEditingController> _controllers = new List();
  List<TextEditingController> _controllersItemSum = new List();
  TextEditingController _controllerSum = new TextEditingController();
  List<Promotions> _conditionPromotion = new List();

  final _formKey = GlobalKey<FormState>();
  final _focusNodeInputName = FocusNode();
  final _focusNodeInputPhone = FocusNode();
  final _focusNodeInputAddress = FocusNode();

  final ScrollController _scrollController = new ScrollController();

  int sumCurrentCarts = 0;
  String sumCurrentCartsString = "0";
  bool checkedAll = false;

  double lat = 0.0, long = 0.0, latChange = 0.0, longChange = 0.0;
  String userName, userPhone, userAddress, userCodeSale;

  List<String> _currentCartsProductId,
      _currentCartsQty,
      _currentCartsProductPrice,
      _currentCartsProductImgThumb,
      _currentCartsProductName,
      _currentCartsProductCatId;

  List<String> _currentCartGiftProductId,
      _currentCartGiftQty,
      _currentCartGiftProductName,
      _currentCartGiftProductImgThumb,
      _currentCartGirtProductType;

  @override
  void initState() {

    // TODO: implement initState
    calculateCarts();
    getPromotions();
    getLatLongSave();
    getUserData();
    super.initState();
  }

  getUserData() async {
    userName = await UserData().getUserData(key: KEY_USER_NAME);
    userPhone = await UserData().getUserData(key: KEY_USER_PHONE);
    userAddress = await UserData().getUserData(key: KEY_USER_ADDRESS);
    userCodeSale = await UserData().getUserData(key: KEY_USER_CODESALE);
  }

  getLatLongSave() async {
    String _latSave = await UserData().getUserData(key: KEY_USER_LAT);
    String _longSave = await UserData().getUserData(key: KEY_USER_LONG);
    print(_latSave);
    if (_latSave != null) {
      lat = double.parse(_latSave);
      long = double.parse(_longSave);
    }
    if (lat == 0.0) {
      print("lat new");
      findLatLong();
    }
  }

  Future<Null> findLatLong() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      long = locationData.longitude;
    });
    print('lat = $lat, long=$long');
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    print("screenHeight");
    print(screenHeight);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          content(context),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
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
                                Text("รถเข็น",
                                    style: TextStyle(
                                        fontSize: 27,
                                        color: Hexcolor('#43701B'),
                                        height: 0.8,
                                        fontWeight: FontWeight.bold)),
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
                  margin: EdgeInsets.only(top: 100),
                  child: _listViewContent(),
                ),
              ),
            ],
          )),
    );
  }

  calculateCarts() async {
    var _listCurrentCartsQty =
        await CartsData().getCartWithKey(KEY_CURRENT_CARTS_QTY);
    _currentCartsQty = _listCurrentCartsQty;

    var _listCurrentCartsProductPrice =
        await CartsData().getCartWithKey(KEY_CURRENT_CARTS_PRODUCT_PRICE);
    _currentCartsProductPrice = _listCurrentCartsProductPrice;

    _currentCartsProductId =
        await CartsData().getCartWithKey(KEY_CURRENT_CARTS_PRODUCT_ID);
    _currentCartsProductImgThumb =
        await CartsData().getCartWithKey(KEY_CURRENT_CARTS_PRODUCT_IMGTHUMB);
    _currentCartsProductName =
        await CartsData().getCartWithKey(KEY_CURRENT_CARTS_PRODUCT_NAME);
    _currentCartsProductCatId =
        await CartsData().getCartWithKey(KEY_CURRENT_CARTS_PRODUCT_CATID);

    if (_listCurrentCartsQty != null) {
      if (_listCurrentCartsQty.length != 0) {
        var _tmpSumCart = 0;
        for (var i = 0; i < _listCurrentCartsQty.length; i++) {
          _tmpSumCart += (int.parse(_listCurrentCartsQty[i]) *
              int.parse(_listCurrentCartsProductPrice[i]));
        }
        setState(() {
          sumCurrentCarts = _tmpSumCart;
          if (sumCurrentCarts != null) {
            FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
              amount: sumCurrentCarts.toDouble(),
              settings: MoneyFormatterSettings(
                fractionDigits: 0,
              ),
            );
            sumCurrentCartsString = fmf.output.nonSymbol;
            _controllerSum.text = sumCurrentCartsString + " บาท";
          }
        });
      } else {
        _controllerSum.text = "0 บาท";
      }
    } else {
      _controllerSum.text = "0 บาท";
    }
  }

  Widget _listViewContent() {
//    print(_currentCartsProductId);
    if (_currentCartsProductId != null) {
      return ListView(
        controller: _scrollController,
        padding: EdgeInsets.only(left: 16, right: 16),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              " รายการที่ท่านสั่งซื้อ",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: _listItemInCart(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: _displayPromotion(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: _inputInfo(),
          )
        ],
      );
    } else {
      return ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 45, bottom: 10),
                    width: 0.1 * screenWidth,
                    child: Image.asset(
                      "assets/images/icon_cart.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "ไม่พบสินค้าในรถเข็นของคุณ",
                    style: TextStyle(
                      fontSize: 28,
//                          fontWeight: FontWeight.bold
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
                          BTN_TXT_GOSHOPING,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
//                          Navigator.popUntil(context, ModalRoute.withName(HOME_PAGE));
//                          Navigator.pushReplacementNamed(context, HOME_PAGE);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  Widget _listItemInCart() {
    List<Widget> widgets = List<Widget>();
    for (var i = 0; i < _currentCartsProductId.length; i++) {
      _controllers.add(new TextEditingController());
      _controllersItemSum.add(new TextEditingController());
      _controllers[i].text = _currentCartsQty[i];
      var _tmpItemSum = (int.parse(_currentCartsQty[i]) *
          int.parse(_currentCartsProductPrice[i]));
      FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: _tmpItemSum.toDouble(),
        settings: MoneyFormatterSettings(
          fractionDigits: 0,
        ),
      );
      _controllersItemSum[i].text = "ราคารวม " + fmf.output.nonSymbol + " บาท";

      widgets.add(_cardProduct(i));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _cardProduct(index) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
//          Checkbox(
//            value: checkedAll,
//            onChanged: (value) {
//              setState(() {
//                checkedAll = value;
//              });
//            },
//            activeColor: Hexcolor("#41942B"),
//          ),
          itemsImage(index: index),
          itemsDetail(index: index),
        ],
      ),
    );
  }

  Widget itemsImage({int index}) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, right: 30, left: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          placeholder: (context, url){
            return Container(
              width: 0.28 * screenWidth,
              child: Center(
                child: Image.asset('assets/images/loading_300x300_1.gif'),
              ),
            );
          },
          errorWidget: (context, url, error){
            return Container(
              width: 0.28 * screenWidth,
              child: Center(
                child: Text(
                  "ไม่สามารถเชื่อมต่อ\nอินเทอร์เน็ตได้",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          imageUrl: _currentCartsProductImgThumb[index],
          width: 0.28 * screenWidth,
        ),
//        FadeInImage.assetNetwork(
//          placeholder: 'assets/images/loading_300x300_1.gif',
//          image: _currentCartsProductImgThumb[index],
//          width: 0.28 * screenWidth,
//        ),
      ),
    );
  }

  Widget itemsDetail({int index}) {
    //เช็คว่าเป็นกระสอบหรือขวด
    String _textCatType = (_currentCartsProductCatId[index] == '1')
        ? "ราคากระสอบละ "
        : "ราคาขวดละ ";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 0.44 * screenWidth,
          child: Text(
            _currentCartsProductName[index],
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: 0.44 * screenWidth,
          padding: EdgeInsets.only(bottom: 0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _textCatType + _currentCartsProductPrice[index] + " บาท",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Hexcolor("#509D34")),
              textAlign: TextAlign.left,
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.only(bottom: 0,top: 0),
          width: 0.44 * screenWidth,
//          color: Colors.amberAccent,
          alignment: Alignment.topLeft,
          child: TextField(
            readOnly: true,
            style: TextStyle(
              color: Hexcolor("#509D34"),
              fontSize: 25,
              height: 0,
              fontWeight: FontWeight.bold,
            ),
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(0.0),
            ),
            controller: _controllersItemSum[index],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    removeCurrentCartItem(index);
                    print("click trash");
                  },
                  child: FaIcon(
                    FontAwesomeIcons.solidTrashAlt,
                    color: Hexcolor("#6A6A6A"),
                    size: 22,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  var tmp = (int.parse(_controllers[index].text) - 1);
                  if (tmp > 0) {
                    _controllers[index].text = tmp.toString();
                    reduceCurrentCartQty(index);
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
                  child: FaIcon(
                    FontAwesomeIcons.minus,
                    color: Hexcolor("#6A6A6A"),
                    size: 19,
                  ),
                ),
              ),
              Container(
                width: 50,
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
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 11, bottom: 11, left: 0, right: 0),
                    border: InputBorder.none,
                  ),
                  controller: _controllers[index],
                  keyboardType: TextInputType.number,
                  enabled: false,
                ),
              ),
              InkWell(
                onTap: () {
                  _controllers[index].text =
                      (int.parse(_controllers[index].text) + 1).toString();
                  addCurrentCartQty(index);
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
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget addCurrentCartQty(index) {
    var newQty = _controllers[index].text;
    CartsData().changeCartItemQty(index, newQty);

    //ผลรวมทั้งหมด
    sumCurrentCarts =
        sumCurrentCarts + int.parse(_currentCartsProductPrice[index]);
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
      amount: sumCurrentCarts.toDouble(),
      settings: MoneyFormatterSettings(
        fractionDigits: 0,
      ),
    );
    _controllerSum.text = fmf.output.nonSymbol + " บาท";

    //หาผลรวมของแต่ละรายการสินค้า
    var _tmpSumCurrentCartsItem =
        int.parse(newQty) * int.parse(_currentCartsProductPrice[index]);
    FlutterMoneyFormatter fmfItem = FlutterMoneyFormatter(
      amount: _tmpSumCurrentCartsItem.toDouble(),
      settings: MoneyFormatterSettings(
        fractionDigits: 0,
      ),
    );
    _controllersItemSum[index].text =
        "ราคารวม " + fmfItem.output.nonSymbol + " บาท";
    setState(() {
      calculateCarts();
    });
  }

  Widget reduceCurrentCartQty(index) {
    var newQty = _controllers[index].text;
    CartsData().changeCartItemQty(index, newQty);
    sumCurrentCarts =
        sumCurrentCarts - int.parse(_currentCartsProductPrice[index]);

    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
      amount: sumCurrentCarts.toDouble(),
      settings: MoneyFormatterSettings(
        fractionDigits: 0,
      ),
    );
    _controllerSum.text = fmf.output.nonSymbol + " บาท";

    //หาผลรวมของแต่ละรายการสินค้า
    var _tmpSumCurrentCartsItem =
        int.parse(newQty) * int.parse(_currentCartsProductPrice[index]);
    FlutterMoneyFormatter fmfItem = FlutterMoneyFormatter(
      amount: _tmpSumCurrentCartsItem.toDouble(),
      settings: MoneyFormatterSettings(
        fractionDigits: 0,
      ),
    );
    _controllersItemSum[index].text =
        "ราคารวม " + fmfItem.output.nonSymbol + " บาท";
    setState(() {
      calculateCarts();
    });
  }

  removeCurrentCartItem(index) {
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
            height: 200,
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
                    "คุณแน่ใจว่าต้องการลบหรือไม่?",
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
                            print("click No");
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            BTN_TXT_NO,
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
                            print("click yes");
                            CartsData().removeCartItem(index);
                            Navigator.of(context).pop();
                            if (_currentCartsQty.length == 1) {
                              print("_currentCartsQty.length");
                              print(_currentCartsQty.length);
                              CartsData().removeAllCart();
                              setState(() {
                                calculateCarts();
                              });
//                              Navigator.pushReplacement(
//                                context,
//                                MaterialPageRoute(
//                                  builder: (context) => SummaryPage(),
//                                ),
//                              );
                            } else {
                              setState(() {
                                calculateCarts();
                              });
                            }
                          },
                          child: Text(
                            BTN_TXT_YES,
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

  Widget _bottomNavigationBar() {
    return Container(
      padding: EdgeInsets.all(0),
      color: Hexcolor("#E5E5E5"),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          Expanded(
//              flex: 3,
//              child: Row(
//                mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Checkbox(
//                    value: checkedAll,
//                    onChanged: (value) {
//                      setState(() {
//                        checkedAll = value;
//                      });
//                    },
//                    activeColor: Hexcolor("#41942B"),
//                  ),
//                  Text(
//                    "เลือกทั้งหมด",
//                    textAlign: TextAlign.right,
//                    style: TextStyle(
//                      fontSize: 18,
//                    ),
//                  ),
//                ],
//              )),
          Expanded(
            flex: 4,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
//                  color: Colors.red,
                      child: Text(
                        "รวมทั้งหมด",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 30,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.only(left: 5),
//                      color: Colors.amber,
                      child: TextField(
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlignVertical: TextAlignVertical.bottom,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.all(0)),
                        controller: _controllerSum,
                        enabled: false,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Hexcolor("#41942B"),
                  Hexcolor("#A6CE67"),
                ]),
              ),
              child: FlatButton(
                child: Text(
                  "ยืนยันสั่งซื้อ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  if (_currentCartsProductId != null) {
                    _scrollController
                        .animateTo(screenHeight,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut)
                        .then((value) {
                        if (_formKey.currentState.validate()) {
                          if (lat != 0.0 && long != 0.0) {
                            _formKey.currentState.save();
                            print('click confirm buy');
                            UserData().setUserData(
                                key: KEY_USER_LAT, data: lat.toString());
                            UserData().setUserData(
                                key: KEY_USER_LONG, data: long.toString());
                            insertDataToFireStore();
                          } else {
                            showAlertNotHaveMap();
                          }
                        } else {
                          FocusScope.of(context)
                              .requestFocus(_focusNodeInputName);
                          print('not validate');
                        }
                        print(_formKey.currentWidget);
                      });
                  }

//                  CartsData().removeAllCart();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  getPromotions() async {
    Firestore.instance
        .collection("Promotions")
        .where('status', isEqualTo: "1")
        .snapshots()
        .listen((result) {
      result.documents.forEach((result) {
        Promotions _promotion = new Promotions(
          product_id: result.data["product_id"],
          condition_price: result.data["condition_price"],
          condition_qty: result.data["condition_qty"],
          gift_product_id: result.data["gift_product_id"],
          gift_product_name: result.data["gift_product_name"],
          gift_qty: result.data["gift_qty"],
          id: result.data["id"],
          status: result.data["status"],
          gift_product_img_thumb: result.data["gift_product_img_thumb"],
          gift_product_type: result.data['gift_product_type'],
        );

        _conditionPromotion.add(_promotion);
      });
    });
  }

  Widget _displayPromotion() {
    List<Widget> widgets = new List<Widget>();
    bool checkHaveCartPromotion = false;
    _currentCartGiftProductId = new List();
    _currentCartGiftQty = new List();
    _currentCartGiftProductName = new List();
    _currentCartGiftProductImgThumb = new List();
    _currentCartGirtProductType = new List();
    //เช็คก่อนว่าสินค้าในตระกร้ามีรายการสินค้าโปรโมชั่นหรือไม่
    for (var i = 0; i < _currentCartsProductId.length; i++) {
      var tmpConditionPromotions = _conditionPromotion.firstWhere(
          (promotions) => (promotions.product_id == _currentCartsProductId[i]),
          orElse: () => null);
      if (tmpConditionPromotions != null) {
        //ถ้ามีข้อมูลตรงตามโปรโมชั่น
        var _conditionQty = int.parse(tmpConditionPromotions.condition_qty);
        var _currentCartsBuyQty = int.parse(_currentCartsQty[i]);
        if (_currentCartsBuyQty >= _conditionQty) {
          //ถ้าซื้อครบตามเงื่อนไข
          var _currentGiftSet =
              (_currentCartsBuyQty / _conditionQty).floor(); //หาว่าได้กี่เซต
          var _currentGiftQty = _currentGiftSet *
              int.parse(tmpConditionPromotions
                  .gift_qty); //เอาจำนวนเซตที่ได้คูณจำนวนขี่แจก
          widgets.add(_cardProductPormotions(
              tmpConditionPromotions, i, _currentGiftQty));
          checkHaveCartPromotion = true;
          _currentCartGiftProductId.add(tmpConditionPromotions.gift_product_id);
          _currentCartGiftQty.add(_currentGiftQty.toString());
          _currentCartGiftProductName
              .add(tmpConditionPromotions.gift_product_name);
          _currentCartGiftProductImgThumb
              .add(tmpConditionPromotions.gift_product_img_thumb);
          _currentCartGirtProductType
              .add(tmpConditionPromotions.gift_product_type);
        }
      }
    }
//    print(widgets.length);
    Text widgetTitlePromotion = new Text(
      " รายการของแถม",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
    );
    if (!checkHaveCartPromotion) {
      //ถ้าไม่มีรายการแถมไม่ต้องแสดงหัวข้อ
      widgetTitlePromotion = new Text("");
      return widgetTitlePromotion;
    } else {
//      return ListView.builder(
//          itemCount:widgets.length+1 ,
//          itemBuilder: (context,index){
//            return widgets[index];
//          },
//
//      );

    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widgetTitlePromotion,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ],
    );
  }

  Widget _cardProductPormotions(
      Promotions promotions, int indexInCarts, int _currentGiftQty) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          itemsImagePromotion(promotions, indexInCarts),
          itemsDetailPromotion(promotions, indexInCarts, _currentGiftQty),
        ],
      ),
    );
  }

  Widget itemsImagePromotion(Promotions promotions, int indexInCarts) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, right: 30, left: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          placeholder: (context, url){
            return Container(
              width: 0.28 * screenWidth,
              child: Center(
                child: Image.asset('assets/images/loading_300x300_1.gif'),
              ),
            );
          },
          errorWidget: (context, url, error){
            return Container(
              width: 0.28 * screenWidth,
              child: Center(
                child: Text(
                  "ไม่สามารถเชื่อมต่อ\nอินเทอร์เน็ตได้",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          imageUrl: promotions.gift_product_img_thumb,
          width: 0.28 * screenWidth,
        ),
//        FadeInImage.assetNetwork(
//          placeholder: 'assets/images/loading_300x300_1.gif',
//          image: promotions.gift_product_img_thumb,
//          width: 0.28 * screenWidth,
//        ),
      ),
    );
  }

  Widget itemsDetailPromotion(
      Promotions promotions, int indexInCarts, int _currentGiftQty) {
    //เช็คว่าเป็นกระสอบหรือขวด
    String _textCatType =
        (_currentCartsProductCatId[indexInCarts] == '1') ? " กระสอบ" : " ขวด";

    return Container(
//      color: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
//            color: Colors.red,
            width: 0.44 * screenWidth,
            child: Text(
              promotions.gift_product_name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 0),
            child: Text(
              "แถมฟรี",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Hexcolor("#509D34")),
            ),
          ),
          Container(
            width: 0.44*screenWidth,
            padding: EdgeInsets.only(bottom: 0),
            child: Text(
              "จำนวน " + _currentGiftQty.toString() + _textCatType,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Hexcolor("#509D34")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          " ข้อมูลติดต่อ",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
          child: Form(
            autovalidate: true,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(
                    initialValue: userName,
                    focusNode: _focusNodeInputName,
                    style: TextStyle(fontSize: 25),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Hexcolor("#E8E8E8"),
                        ),
                      ),
                      hintText: 'ชื่อ',
                      contentPadding:
                          EdgeInsets.only(left: 10, top: 0, bottom: 0),
                    ),
                    validator: (value) {
                      return value.isEmpty ? "กรุณากรอกชื่อด้วยค่ะ" : null;
                    },
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(_focusNodeInputPhone);
                    },
                    onSaved: (newValue) {
                      print('save user name $newValue');
                      userName = newValue;
                      UserData().setUserData(
                          key: KEY_USER_NAME, data: newValue.toString());
                    },
                  ),
                ),
                TextFormField(
                  initialValue: userPhone,
                  focusNode: _focusNodeInputPhone,
                  style: TextStyle(fontSize: 25),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Hexcolor("#E8E8E8"),
                      ),
                    ),
                    hintText: 'เบอร์โทรศัพท์',
                    contentPadding:
                        EdgeInsets.only(left: 10, top: 0, bottom: 0),
                  ),
                  validator: (value) {
                    return value.isEmpty
                        ? "กรุณากรอกเบอร์โทรศัพท์ด้วยค่ะ"
                        : null;
                  },
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_focusNodeInputAddress);
                  },
                  onSaved: (newValue) {
                    print('save user phone $newValue');
                    userPhone = newValue;
                    UserData().setUserData(
                        key: KEY_USER_PHONE, data: newValue.toString());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    initialValue: userAddress,
                    focusNode: _focusNodeInputAddress,
                    style: TextStyle(fontSize: 25),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Hexcolor("#E8E8E8"),
                        ),
                      ),
                      hintText: 'ที่อยู่',
                      contentPadding:
                          EdgeInsets.only(left: 10, top: 0, bottom: 0),
                    ),
                    textInputAction: TextInputAction.done,
                    onSaved: (newValue) {
                      print('save user Address $newValue');
                      userAddress = newValue;
                      UserData().setUserData(
                          key: KEY_USER_ADDRESS, data: newValue.toString());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              " ปักหมุดแผนที่",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Container(
                width: 120,
                height: 30,
                padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  gradient: LinearGradient(
                      colors: [Hexcolor("#45962D"), Hexcolor("#94C35C")]),
                ),
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    print("click get location");
//                    findLatLong();
                    _dialogMapChange();
                  },
                  child: Text(
                    "เปลี่ยนที่อยู่จัดส่ง",
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
        lat == 0.0 ? Center(child: CircularProgressIndicator()) : _showMap(),
      ],
    );
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myLocation'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
          title: "ที่อยู่ของฉัน",
          snippet: '',
        ),
        draggable: false,
        onDragEnd: (value) {
          print("ondrag map");
        },
        onTap: () {
          print('get');
        },
      )
    ].toSet();
  }

  Widget _showMap() {
    LatLng latLng = LatLng(lat, long);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 300.0,
        child: GoogleMap(
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controllerGooglemap.complete(controller);
          },
          markers: myMarker(),
          indoorViewEnabled: true,
        ),
      ),
    );
  }

  _dialogMapChange() {
    print("click _dialogMapChange");
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
            width: screenWidth,
            height: 0.65 * screenHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 0),
                  child: Text(
                    "หากคุณต้องการเปลี่ยนที่อยู่จัดส่ง",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  child: Text(
                    "ให้ทำการกดหมุดค้างไว้แล้วลาก",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                _showMapPopUp(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
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
                              print("click No edit map");
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "ไม่แก้ไข",
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
                              print("click yes edit map");
                              _formKey.currentState.save();
                              lat = latChange;
                              long = longChange;
                              UserData().setUserData(
                                  key: KEY_USER_LAT, data: lat.toString());
                              UserData().setUserData(
                                  key: KEY_USER_LONG, data: long.toString());

                              Navigator.of(context).pop();
                              _goToEditLocation(lat,long);
                              setState(() {
                                calculateCarts();
                                getPromotions();
                                getLatLongSave();
                                getUserData();
                              });
//                              Navigator.pushReplacement(
//                                context,
//                                MaterialPageRoute(
//                                  builder: (context) => SummaryPage(),
//                                ),
//                              );
//                              if(_currentCartsQty.length == 1){
//

//                              }
                            },
                            child: Text(
                              "ยืนยันแก้ไข",
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
        );
      },
    );
  }

  Set<Marker> myEditMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myLocationEdit'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
          title: "กดค้างแล้วลาก",
          snippet: 'เพื่อเปลี่ยนที่อยู่จัดส่ง',
        ),
        draggable: true,
        onDragEnd: (value) {
          print("ondrag map ");
          latChange = value.latitude;
          longChange = value.longitude;
        },
        onTap: () {
          print('get');
        },
      )
    ].toSet();
  }

  Widget _showMapPopUp() {
    LatLng latLng = LatLng(lat, long);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 0.45 * screenHeight,
        child: GoogleMap(
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (controller) {},
          markers: myEditMarker(),
          zoomControlsEnabled: true,
        ),
      ),
    );
  }

  showAlertNotHaveMap() {
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
            height: 200,
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
                    "หมุดบนแผนที่ของคุณไม่ถูกต้อง กดปุ่มเปลี่ยนที่อยู่จัดส่งใหม่",
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
                            print("click yes");
                            Navigator.of(context).pop();
//                            Navigator.pushNamed(context, SUMMARY_PAGE);
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

  insertDataToFireStore() async {
    Firestore firestore = Firestore.instance;
    Map<String, dynamic> map = Map();
    map['CustomerName'] = userName;
    map['CustomerPhone'] = userPhone;
    map['CustomerAddress'] = userAddress;
    map['CustomerLat'] = lat;
    map['CustomerLong'] = long;
    map['CodeSale'] = userCodeSale;
    map['Status'] = '1';
    map['OrderProductId'] = _currentCartsProductId;
    map['OrderQty'] = _currentCartsQty;
    map['OrderProductPrice'] = _currentCartsProductPrice;
    map['OrderProductImgThumb'] = _currentCartsProductImgThumb;
    map['OrderProductCatId'] = _currentCartsProductCatId;
    map['OrderProductName'] = _currentCartsProductName;
    map['OrderGiftProductId'] = _currentCartGiftProductId;
    map['OrderGiftProductName'] = _currentCartGiftProductName;
    map['OrderGiftProductImgThumb'] = _currentCartGiftProductImgThumb;
    map['OrderGiftQty'] = _currentCartGiftQty;
    map['OrderGiftProductType'] = _currentCartGirtProductType;
    map['DateCreate'] = new DateTime.now();

//    await firestore.collection("Customers").add(map).then((value){
//      print(value.documentID);
//    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      print("Connected to  Network");
      await firestore.collection("Customers").document().setData(map).then(
            (value) {
          print("success insert");
          CartsData().removeAllCart();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinishPage(),
            ),
          ).then((value){
            setState(() {
              calculateCarts();
              getPromotions();
              getLatLongSave();
              getUserData();
            });
          });
        },
      );
    } else {
      print("Unable to connect. Please Check Internet Connection");
      _alertNoInternet();
    }


  }

  _alertNoInternet(){
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
                      FontAwesomeIcons.exclamationCircle,
                      size: 50,
                      color: Hexcolor("#509D34"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "กรุณาตรวจสอบอินเทอร์เน็ต\nแล้วกดปุ่มยืนยังสั่งซื้ออีกครั้ง",
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

  Future<void> _goToEditLocation(double _lat,double _long) async {
    LatLng latLng = LatLng(_lat, _long);
    CameraPosition _cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    final GoogleMapController controller = await _controllerGooglemap.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }
}
