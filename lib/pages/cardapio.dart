import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/pages/produto.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:delivery_app/custom_expansion_tile.dart' as custom;

class Cardapio extends StatefulWidget {
  @override
  _CardapioState createState() => _CardapioState();
}

class _CardapioState extends State<Cardapio> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Cardápio"),
      ),
      body: SingleChildScrollView(
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, UserModel){
            return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("categorias").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot ){
                if (!snapshot.hasData ) return Center(child: CircularProgressIndicator(),);
                return Container(
                  child: Column(
                    children: getCategorias(snapshot),
                  ),
                );
              }
            );
          },
        ),
      )
    );
  }
  getCategorias(AsyncSnapshot<QuerySnapshot> snapshot){
    return snapshot.data.documents.map<Widget>((doc) =>
      FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("produtos").where("codigoCategoria", isEqualTo: doc.documentID.toString()).getDocuments(),
        builder: (context, snapshot){
          if (!snapshot.hasData ) return Container();
          return Padding(
            padding: EdgeInsets.only(top: 2),
            child: custom.ExpansionTile(
                trailing: Icon(Icons.arrow_drop_down, color: Colors.white),
                headerBackgroundColor: Color.fromARGB(255, 214, 56, 41),
                title: Text(doc["nome"].toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                children: getSubCategorias(snapshot)
            ),
          );
        },
      )
    ).toList();
  }
  getSubCategorias(AsyncSnapshot<QuerySnapshot> snapshot){
    return snapshot.data.documents.map((doc)=>
      Column(
        children: <Widget>[
          ListTile(
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Produto(doc)));
            },
            title: Text(doc["nome"].toString().toUpperCase()),
            subtitle: Text(doc["descrição"]),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("A partir de"),
                Text("R\$ ${doc["preco"].toStringAsFixed(2)}")
              ],
            ),
          ),
          Container(
            height:1.0,
            color:Colors.grey,
          ),
        ],
      )
    ).toList();
  }
}
