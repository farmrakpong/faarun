import 'package:pref_dessert/pref_dessert.dart';
import 'package:json_annotation/json_annotation.dart';

class Carts {
  String productId;
  String productName;
  String productImgThumb;
  String productSku;
  String productPrice;
  String qty;
  String productCatId;

  Carts({
    this.productId,
    this.productName,
    this.productImgThumb,
    this.productSku,
    this.productPrice,
    this.qty,
    this.productCatId
  } );

//  factory Carts.fromJson(Map<String, dynamic> json) => Carts(
//        productId: json["productId"],
//        productName: json["productName"],
//        productImgThumb: json["productImgThumb"],
//        productSku: json["productSku"],
//        productPrice: json["productPrice"],
//        qty: json["qty"],
//      );
}



