

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faarun/constant/constant.dart';
import 'package:faarun/models/Historys.dart';
import 'package:faarun/services/UserData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {


  double screenWidth, screenHeight;
  String userPhone;
  List<Historys> _historyOrder = new List();

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    initializeDateFormatting('th_TH', null);
    super.initState();
  }

  getUserData() async{
    userPhone = await UserData().getUserData(key: KEY_USER_PHONE);

    if(userPhone != null){
        print(userPhone);
        getHistorys(userPhone);
    }
  }

  getHistorys(String _userPhone) async{
    Firestore.instance
        .collection("Customers")
        .where('CustomerPhone', isEqualTo: _userPhone)
        .orderBy('DateCreate',descending: true)
        .snapshots()
        .listen((result) {
          print(result);
      result.documents.forEach((result) {
        Historys _historys = new Historys(
          CustomerName: result.data["CustomerName"],
          CustomerPhone: result.data["CustomerPhone"],
          CustomerLat: result.data["CustomerLat"],
          CustomerLong: result.data["CustomerLong"],
          OrderProductId: result.data["OrderProductId"],
          OrderProductName: result.data["OrderProductName"],
          OrderQty: result.data["OrderQty"],
          OrderProductPrice: result.data["OrderProductPrice"],
          OrderProductImgThumb: result.data["OrderProductImgThumb"],
          OrderProductCatId: result.data["OrderProductCatId"],
          OrderGiftProductId: result.data["OrderGiftProductId"],
          OrderGiftProductName: result.data["OrderGiftProductName"],
          OrderGiftProductType: result.data["OrderGiftProductType"],
          OrderGiftQty: result.data["OrderGiftQty"],
          DateCreate: result.data["DateCreate"],
        );
        _historyOrder.add(_historys);
      });
      setState(() {
        _listOrder();
      });
    });
  }


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
    if(_historyOrder.length !=0){
      return ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "ประวัติการสั่งซื้อสินค้าของฉัน",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _listOrder(),
          footer(),
        ],
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 50,bottom: 100),
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
                    "ไม่พบประวัติการสั่งซื้อของคุณ",
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
                          Navigator.pop(context);
//                          Navigator.pushReplacementNamed(context, HOME_PAGE);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          footer(),
        ],
      );
    }
  }

  Widget _listOrder(){
    print("listOrder");
    print(_historyOrder.length);
    List<Widget> widget = new List();
    for(var i=0; i<_historyOrder.length;i++){
      print(new DateFormat.yMMMd("th_TH").add_Hm().format(_historyOrder[i].DateCreate.toDate()));
//      print(_historyOrder[i].OrderProductId);
      widget.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _listOrderItem(_historyOrder[i]),
        ),
      );
    }

  return Padding(
    padding: EdgeInsets.only(left: 16,right: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget,
    ),
  );
  }

  Widget _listOrderItem(Historys historys){

    return Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20,top: 10),
            child: Text(
                'วันที่สั่งสินค้า '+DateFormat.yMMMd("th_TH").add_Hm().format(historys.DateCreate.toDate()),
              style: TextStyle(
                fontSize: 25,
//              fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5,left: 20),
            child:Text(
              "รายการที่สั่ง",
              style: TextStyle(
                fontSize: 25,
              fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _itemProductDetail(historys),
        ],
      ),
    );
  }

  Widget _itemProductDetail(Historys historys){
    int _countcheck = historys.OrderProductId.length;
    List<Widget> _widget = new List();
    double sumMoney = 0;
    for(var i=0;i<historys.OrderProductId.length;i++){
      String _typeProduct = (historys.OrderProductCatId[i] == "1")?" กระสอบ":" ขวด";
      double _sumMoneyItem = (int.parse(historys.OrderQty[i])*int.parse(historys.OrderProductPrice[i])).toDouble();
      sumMoney += _sumMoneyItem;
      FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: _sumMoneyItem,
        settings: MoneyFormatterSettings(
          fractionDigits: 0,
        ),
      );
      String _sumOrderItem = fmf.output.nonSymbol + " บาท";
      _widget.add(
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text( (i+1).toString()+".",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    historys.OrderProductName[i].toString(),
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              ],
            ),
            Row(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 38),
                      child: Text(
                        "จำนวน",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(historys.OrderQty[i],
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text( _typeProduct,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "ราคา",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text( _sumOrderItem,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),

          ],
        )
      );
    }
    FlutterMoneyFormatter fmfSummoney = FlutterMoneyFormatter(
      amount: sumMoney,
      settings: MoneyFormatterSettings(
        fractionDigits: 0,
      ),
    );
    _widget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          "รวมทั้งสิ้น "+fmfSummoney.output.nonSymbol + " บาท",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );

    List<Widget> _widgetGift = new List();
    if(historys.OrderGiftProductId.length != 0){
      _widgetGift.add(
        Padding(
          padding: const EdgeInsets.only(top: 20,left: 20),
          child: Text(
            "รายการของแถมที่ได้",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      );
      for(var i=0; i<historys.OrderGiftProductId.length; i++){
//        print(historys.OrderGiftProductName);

        _widgetGift.add(
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text( (i+1).toString()+".",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      historys.OrderGiftProductName[i].toString(),
                      style: TextStyle(
                        fontSize: 25,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Text( "จำนวน ",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      historys.OrderGiftQty[i].toString() +" "+historys.OrderGiftProductType[i].toString(),
                      style: TextStyle(
                        fontSize: 25,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),

        );
      }

      _widgetGift.add(
        SizedBox(
          height: 20,
        ),
      );
    }else{
      _widgetGift.add(
        SizedBox(
          height: 20,
        ),
      );
    }

    if(_countcheck == 0){
      setState(() {
        _listOrder();
      });
    }

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _widget,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _widgetGift,
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
