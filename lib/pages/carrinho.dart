import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/cart_model.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/pages/cardapio.dart';
import 'package:delivery_app/pages/confirm_pedido.dart';
import 'package:delivery_app/pages/listar-enderecos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Carrinho"),
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, CartModel model){
          if(model.products.length==0){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart, size: 80),
                  SizedBox(height: 10,),
                  Text("Nenhum item no carrinho", style: TextStyle(fontSize: 20),),
                  SizedBox(height: 10,),
                  OutlineButton(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Cardapio()));
                      },
                      textColor: Colors.black,
                      highlightColor: Colors.white,
                      child:
                        new Text(
                            "Ver cardápio",
                            style: TextStyle(fontSize: 15)
                        ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.only(top:10, bottom: 10, left: 10, right: 10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      children: model.products.map<Widget>((product){
                        return itemCart(product, model);
                      }).toList()
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: RaisedButton(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                      onPressed: ()async{
                        Firestore.instance.collection("users").document(UserModel.of(context).firebaseUser.uid).collection("endereços").where('ativo',isEqualTo: true).getDocuments().then(
                          (result){
                            if(result.documents.length==0){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => listarEndereco()));
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmarPedido()));
                            }
                          }
                        );
                      },
                      textColor: Colors.white,
                      color: Color.fromARGB(255, 214, 56, 41),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Finalizar pedido",
                            style: TextStyle(fontSize: 18)
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }
  itemCart(product, CartModel model){
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${product["quantidade"]}x ${product["produto"]["nome"]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  SizedBox(height: 10,),
                  product["opçãoEscolhida"]!=null ?
                  Text("Opção: ${product["opçãoEscolhida"]}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)) : Container(),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("R\$ ${product["precoTotal"].toStringAsFixed(2)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green)),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Tem certeza?"),
                            content: Text("Deseja realmente remover esse produto do carrinho?"),
                            actions: [
                              FlatButton(
                                child: Text("Cancelar", style: TextStyle(color: Colors.black),),
                                onPressed:  () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Sim"),
                                onPressed:  () {
                                  model.removeCartItem(product);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.remove_circle_outline, size: 40, color: Color.fromARGB(255, 214, 56, 41),),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 5,),
        Container(
          height:1.0,
          color:Colors.grey,
        ),
        SizedBox(height: 5,),
      ],
    );
  }
}
