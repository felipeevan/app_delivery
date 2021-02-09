import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/pages/endereco.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class listarEndereco extends StatefulWidget {
  @override
  _listarEnderecoState createState() => _listarEnderecoState();
}

class _listarEnderecoState extends State<listarEndereco> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Meus endereços"),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, UserModel model){
          excluir(id){
            model.excluirEndereco(id);
          }
          ativarEndereco(id){
            model.ativarEndereco(id);
          }
          if(model.firebaseUser==null){
            return Center(child: CircularProgressIndicator(),);
          }
          return Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("users").document(model.firebaseUser.uid).collection("endereços").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot ){
                if (!snapshot.hasData ) return Center(child: CircularProgressIndicator(),);
                if(snapshot.data.documents.length==0) return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_off, size: 70),
                    Text("Nenhum endereço cadastrado", style: TextStyle(fontSize: 20),)
                  ],
                );
                return  new ListView(
                  padding: EdgeInsets.all(5),
                  children: getExpenseItems(snapshot, excluir, ativarEndereco)
                );
              },
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Endereco()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot, excluir, ativarEndereco) {
    return snapshot.data.documents.map((doc) =>
        Card(
          elevation: 5,
          child: ListTile(
              leading: Icon(Icons.location_on, size: 40,),
              title: Text("${doc["logradouro"]}, ${doc["numero"]}"),
              subtitle: Text("${doc["bairro"]}, ${doc["localidade"]} - ${doc["uf"]}"),
              trailing: doc.data["ativo"] ?
              Icon(Icons.check_circle, color: Colors.green) :
              PopupMenuButton<int>(
                onSelected: (result) {
                  if (result == 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Tem certeza?"),
                          content: Text("Deseja realmente excluir esse endereço?"),
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
                                excluir(doc.documentID);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  if(result == 1){
                    ativarEndereco(doc.documentID);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.delete),
                        Text(" Excluir"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.beenhere),
                        Text(" Ativar"),
                      ],
                    ),
                  ),
                ],
              )
          ),
        ),
    ).toList();
  }
}
