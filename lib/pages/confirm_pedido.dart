import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/cart_model.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/pages/endereco.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scoped_model/scoped_model.dart';

import 'listar-enderecos.dart';
import 'listar_pedidos.dart';

class ConfirmarPedido extends StatefulWidget {
  @override
  _ConfirmarPedidoState createState() => _ConfirmarPedidoState();
}

class _ConfirmarPedidoState extends State<ConfirmarPedido> {
  var cupomController = TextEditingController();
  var cpfController = TextEditingController();
  var cpfMask = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });
  var obsController = TextEditingController();
  var tipoPagamento = "";
  var endereco;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var cart = CartModel.of(context);
    precoTotal(){
      var preco = 0;
      cart.products.forEach((d){
        preco+=d["precoTotal"];
      });
      return preco;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Finalizar pedido"),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, UserModel model){
          if(model.firebaseUser==null || model.isLoading){
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder(
                      future: Firestore.instance.collection("users").document(model.firebaseUser.uid).collection("endereços").where('ativo',isEqualTo: true).getDocuments(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if (!snapshot.hasData ) return Container();
                        if (snapshot.hasData) endereco=snapshot.data.documents[0].data;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${snapshot.data.documents[0].data["logradouro"]} ${snapshot.data.documents[0].data["numero"]}"),
                              snapshot.data.documents[0].data["complemento"]=="" ? Container(): Text("${snapshot.data.documents[0].data["complemento"]}"),
                              Text("Bairro ${snapshot.data.documents[0].data["bairro"]}"),
                              Text("${snapshot.data.documents[0].data["cep"]}"),
                            ]),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => listarEndereco()));
                              },
                              child: Icon(Icons.edit_location, size: 50),
                            )
                          ]
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height:1.0,
                      color:Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [cpfMask],
                            controller: cpfController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.black54,
                                      width: 2
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.black26,
                                      width: 2
                                  )
                              ),
                              border: OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.black26,
                                      width: 2
                                  )
                              ),
                              hintText: 'CPF na nota?',
                              prefixText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /*Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: cupomController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.black54,
                                      width: 2
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.black26,
                                      width: 2
                                  )
                              ),
                              border: OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.black26,
                                      width: 2
                                  )
                              ),
                              hintText: 'Cupom?',
                              prefixText: '',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Color.fromARGB(255, 214, 56, 41),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.check),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),*/
                    Divider(),
                    Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: obsController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration.collapsed(hintText: "Observações do pedido"),
                          ),
                        )
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height:1.0,
                      color:Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Escolher forma de pagamento", style: TextStyle(fontSize: 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        OutlineButton(
                          onPressed: (){
                            setState(() {
                              tipoPagamento = "Dinheiro";
                            });
                          },
                          borderSide: tipoPagamento=="Dinheiro" ? BorderSide(color: Colors.red): null,
                          textColor: Colors.black,
                          highlightColor: Colors.white,
                          child:
                          new Text(
                              "Dinheiro",
                              style: TextStyle(fontSize: 15)
                          ),
                        ),
                        OutlineButton(
                          onPressed: (){
                            setState(() {
                              tipoPagamento = "Crédito";
                            });
                          },
                          borderSide: tipoPagamento=="Crédito" ? BorderSide(color: Colors.red): null,
                          textColor: Colors.black,
                          highlightColor: Colors.white,
                          child:
                          new Text(
                              "Crédito",
                              style: TextStyle(fontSize: 15)
                          ),
                        ),
                        OutlineButton(
                          onPressed: (){
                            setState(() {
                              tipoPagamento = "Débito";
                            });
                          },
                          borderSide: tipoPagamento=="Débito" ? BorderSide(color: Colors.red): null,
                          textColor: Colors.black,
                          highlightColor: Colors.white,
                          child:
                          new Text(
                              "Débito",
                              style: TextStyle(fontSize: 15)
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height:1.0,
                      color:Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Valor do pedido:", style: TextStyle(fontSize: 20)),
                        Text("R\$ ${precoTotal().toStringAsFixed(2)}", style: TextStyle(fontSize: 20))
                      ],
                    ),
                    /*Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Total a pagar:", style: TextStyle(fontSize: 20),),
                        Text("R\$ ${precoTotal().toStringAsFixed(2)}", style: TextStyle(fontSize: 20))
                      ],
                    ),*/
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height:1.0,
                      color:Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: RaisedButton(
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                          onPressed: (){
                            if(tipoPagamento!=""){
                              Map<String, dynamic> pedido = {
                                "endereco":endereco,
                                "cpf":cpfController.text,
                                "tipoPagamento":tipoPagamento,
                                "observação":obsController.text,
                                "pedidos":cart.products,
                                "precoTotal":precoTotal(),
                                "idUsuario":model.firebaseUser.uid,
                                "dataPedido":DateTime.now().toUtc(),
                                "statusAtual":"pendente",
                                "historicoPedido":[{"data":DateTime.now(),"status":"pendente"}]
                              };

                              model.savePedido(pedido, onSucess, onError);
                            }
                            else{
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text("Preencha opção de pagamento"),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  )
                              );
                            }

                          },
                          textColor: Colors.white,
                          color: Color.fromARGB(255, 214, 56, 41),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  "Confirmar pedido",
                                  style: TextStyle(fontSize: 18)
                              ),
                            ],
                          )
                      ),
                    ),
                  ],
                )
            ),
          );
        }
      )
    );
  }
  onSucess(){
    CartModel.of(context).clearCart();
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Pedido efetuado com sucesso"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds:2)).then((_){
      Navigator.of(context).popUntil((r)=>r.isFirst);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ListarPedidos()));
    });
  }
  onError(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Erro ao realizar pedido"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
