
import 'package:faarun/constant/constant.dart';
import 'package:faarun/models/Carts.dart';
import 'package:shared_preferences/shared_preferences.dart';
//
class CartsData{
      String _keyCurrentCartsProductId = KEY_CURRENT_CARTS_PRODUCT_ID;
      String _keyCurrentCartsQty = KEY_CURRENT_CARTS_QTY;
      String _keyCurrentCartsProductPrice = KEY_CURRENT_CARTS_PRODUCT_PRICE;
      String _keyCurrentCartsProductImgThumb = KEY_CURRENT_CARTS_PRODUCT_IMGTHUMB;
      String _keyCurrentCartsProductName = KEY_CURRENT_CARTS_PRODUCT_NAME;
      String _keyCurrentCartsProductCatId = KEY_CURRENT_CARTS_PRODUCT_CATID;

    Future<bool> addCart({Carts carts}) async{
      SharedPreferences _prefsCart = await SharedPreferences.getInstance();

      var _getListOld = _prefsCart.getStringList(_keyCurrentCartsProductId);
      var _getListQtyOld = _prefsCart.getStringList(_keyCurrentCartsQty);
      var _getListPriceOld = _prefsCart.getStringList(_keyCurrentCartsProductPrice);
      var _getListImgThumbOld = _prefsCart.getStringList(_keyCurrentCartsProductImgThumb);
      var _getListNameOld = _prefsCart.getStringList(_keyCurrentCartsProductName);
      var _getListProductCatIdOld = _prefsCart.getStringList(_keyCurrentCartsProductCatId);

      if(_getListOld == null){//เช็คก่อนว่าถ้าไม่มีค่า ให้เพิ่มสินค้าในตระกร้า
          print("addCart is null ");

          List<String> _cartItemProductId = new List<String>();
          _cartItemProductId.add(carts.productId);

          List<String> _cartItemQty = new List<String>();
          _cartItemQty.add(carts.qty);

          List<String> _cartItemProductPrice = new List<String>();
          _cartItemProductPrice.add(carts.productPrice);

          List<String> _cartItemProductImgThumb = new List<String>();
          _cartItemProductImgThumb.add(carts.productImgThumb);

          List<String> _cartItemProductName = new List<String>();
          _cartItemProductName.add(carts.productName);

          List<String> _cartItemProductCatId = new List<String>();
          _cartItemProductCatId.add(carts.productCatId);



          var _result  = await _prefsCart.setStringList(_keyCurrentCartsProductId, _cartItemProductId);
              _result  = await _prefsCart.setStringList(_keyCurrentCartsQty,_cartItemQty);
              _result  = await _prefsCart.setStringList(_keyCurrentCartsProductPrice,_cartItemProductPrice);
              _result  = await _prefsCart.setStringList(_keyCurrentCartsProductImgThumb,_cartItemProductImgThumb);
              _result  = await _prefsCart.setStringList(_keyCurrentCartsProductName,_cartItemProductName);
              _result  = await _prefsCart.setStringList(_keyCurrentCartsProductCatId,_cartItemProductCatId);

          return _result;

      }else{

        print("addCart not is null ");
        var _haveIndex = _getListOld.indexOf(carts.productId);
          print(_haveIndex);

        if(_haveIndex>=0){ //ถ้ามีในตระกร้าแล้ว
          print("have index");
          _getListQtyOld[_haveIndex] = (int.parse(carts.qty)+int.parse(_getListQtyOld[_haveIndex])).toString();

        }else{//ถ้าไม่มีในตระกร้าแล้ว
          _getListOld.add(carts.productId);
          _getListQtyOld.add(carts.qty);
          _getListPriceOld.add(carts.productPrice);
          _getListImgThumbOld.add(carts.productImgThumb);
          _getListNameOld.add(carts.productName);
          _getListProductCatIdOld.add(carts.productCatId);

        }
        var _result =  _prefsCart.setStringList(_keyCurrentCartsProductId, _getListOld);
            _result =  _prefsCart.setStringList(_keyCurrentCartsQty,_getListQtyOld);
            _result =  _prefsCart.setStringList(_keyCurrentCartsProductPrice,_getListPriceOld);
            _result =  _prefsCart.setStringList(_keyCurrentCartsProductImgThumb,_getListImgThumbOld);
            _result =  _prefsCart.setStringList(_keyCurrentCartsProductName,_getListNameOld);
            _result =  _prefsCart.setStringList(_keyCurrentCartsProductCatId,_getListProductCatIdOld);
        return _result;
      }


    }

    Future<bool> changeCartItemQty(int index,String newQty) async{
      SharedPreferences _prefsCart = await SharedPreferences.getInstance();
      var _getListQtyOld = _prefsCart.getStringList(_keyCurrentCartsQty);
      _getListQtyOld[index] = newQty.toString();
      var _result =  _prefsCart.setStringList(_keyCurrentCartsQty,_getListQtyOld);
      return _result;
    }

    Future<bool> removeCartItem(int index) async{

      SharedPreferences _prefsCart = await SharedPreferences.getInstance();

      var _getListOld = _prefsCart.getStringList(_keyCurrentCartsProductId);
      var _getListQtyOld = _prefsCart.getStringList(_keyCurrentCartsQty);
      var _getListPriceOld = _prefsCart.getStringList(_keyCurrentCartsProductPrice);
      var _getListImgThumbOld = _prefsCart.getStringList(_keyCurrentCartsProductImgThumb);
      var _getListNameOld = _prefsCart.getStringList(_keyCurrentCartsProductName);
      var _getListProductCatIdOld = _prefsCart.getStringList(_keyCurrentCartsProductCatId);

      _getListOld.removeAt(index);
      _getListQtyOld.removeAt(index);
      _getListPriceOld.removeAt(index);
      _getListImgThumbOld.removeAt(index);
      _getListNameOld.removeAt(index);
      _getListProductCatIdOld.removeAt(index);

      var _result =  _prefsCart.setStringList(_keyCurrentCartsProductId, _getListOld);
          _result =  _prefsCart.setStringList(_keyCurrentCartsQty,_getListQtyOld);
          _result =  _prefsCart.setStringList(_keyCurrentCartsProductPrice,_getListPriceOld);
          _result =  _prefsCart.setStringList(_keyCurrentCartsProductImgThumb,_getListImgThumbOld);
          _result =  _prefsCart.setStringList(_keyCurrentCartsProductName,_getListNameOld);
          _result =  _prefsCart.setStringList(_keyCurrentCartsProductCatId,_getListProductCatIdOld);
      return _result;

    }

    Future<List<String>> getCartWithKey(String _key) async{
      print("call getCartWithKey"+_key);
      SharedPreferences _prefsCart = await SharedPreferences.getInstance();
      return _prefsCart.getStringList(_key);
    }

      Future removeAllCart() async{
        SharedPreferences _prefsCart = await SharedPreferences.getInstance();
        _prefsCart.remove(_keyCurrentCartsProductId);
        _prefsCart.remove(_keyCurrentCartsQty);
        _prefsCart.remove(_keyCurrentCartsProductPrice);
        _prefsCart.remove(_keyCurrentCartsProductImgThumb);
        _prefsCart.remove(_keyCurrentCartsProductName);
        _prefsCart.remove(_keyCurrentCartsProductCatId);
        print("IN RemoveAllCart ");
      }




}
//class CartsdesSer extends DesSer<Carts>{
//  @override
//  Carts deserialize(String s) {
//    var split = s.split(",");
//    return new Carts(split[0], split[1], split[2], split[3], split[4], split[5]);
//  }
//
//  @override
//  String serialize(Carts t) {
//    return "${t.productId},${t.productName},${t.productImgThumb},${t.productSku},${t.productPrice},${t.qty}";
//  }
//
//  @override
//  // TODO: implement key
//  String get key => throw UnimplementedError();
//}