import 'package:delivery_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;
  List products = [];
  CartModel(this.user);

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(produto){
    products.add(produto);
    notifyListeners();
  }
  void clearCart(){
    products = [];
  }

  removeCartItem(produto){
    products.removeAt(products.indexOf(produto));
    notifyListeners();
  }
  void total(){
    var total = 0;
    products.forEach((d)=>{

    });
  }
}