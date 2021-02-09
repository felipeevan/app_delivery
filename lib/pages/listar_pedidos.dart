import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/pages/detalhes_pedidos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'cardapio.dart';

class ListarPedidos extends StatefulWidget {
  @override
  _ListarPedidosState createState() => _ListarPedidosState();
}

class _ListarPedidosState extends State<ListarPedidos> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Meus pedidos"),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context,child, UserModel model){
          if(model.firebaseUser==null){ return Center(child:CircularProgressIndicator()); }
          return Padding(
            padding: EdgeInsets.all(10),
            child: StreamBuilder(
              stream: Firestore.instance.collection("pedidos").where("idUsuario", isEqualTo: model.firebaseUser.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData){ return Center(child:CircularProgressIndicator()); }
                if(snapshot.data.documents.length==0){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.forum, size: 80),
                        SizedBox(height: 10,),
                        Text("Você ainda não fez pedidos", style: TextStyle(fontSize: 20),),
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
                return Column(
                  children: snapshot.data.documents.map((d){
                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  color: Color.fromARGB(255, 212, 175, 55),
                                  child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Text("${d["statusAtual"].toString().toUpperCase()}", style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text("Total do pedido: R\$ ${d["precoTotal"].toStringAsFixed(2)}"),
                                SizedBox(height: 5,),
                                Text("Data: ${DateFormat('dd/MM/yyyy HH:mm').format(
                                    d["dataPedido"].toDate().add(Duration(hours: -3))
                                )}"),
                              ],
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DetalhesPedidos(d)));
                              },
                              child: Icon(Icons.search, size: 40, color: Color.fromARGB(255, 214, 56, 41)),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                        )
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          );
        },
      )
    );
  }
}
