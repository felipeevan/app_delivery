import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/cart_model.dart';
import 'package:delivery_app/pages/carrinho.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/custom_expansion_tile.dart' as custom;

class Produto extends StatefulWidget {
  final dynamic produto;
  Produto(this.produto);

  @override
  _ProdutoState createState() => _ProdutoState();
}

class _ProdutoState extends State<Produto> {
  var valorOption = null;
  var qtdProduto = 1;
  var detalhesPedidoController = TextEditingController();
  var selectedOptions = [];
  var optionsIniciado = null;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var adicionais = [];

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot produto = widget.produto;
    qtdVezes(nome){
      if(selectedOptions.length==0){
        return 0;
      }
      else{
        var count = 0;
        selectedOptions.forEach((v){
          if(v==nome){
            count++;
          }
        });
        return count;
      }
    }
    qtdVezesAdicionais(adicional){
      if(adicionais.length==0){
        return 0;
      }
      else{
        var count = 0;
        adicionais.forEach((v){
          if(v["nome"]==adicional["nome"]){
            count++;
          }
        });
        return count;
      }
    }
    precoProduto(){
      if(adicionais.length==0){
        return produto["preco"];
      }
      else{
        var preco = 0;
        adicionais.forEach((v){
          preco += v["preco"];
        });
        preco += produto["preco"];
        return preco;
      }

    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Detalhes do produto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.network(produto["foto"].toString(),height: 120),
                  Padding(
                    padding: EdgeInsets.only(left:30, right:30),
                    child: Column(
                      children: <Widget>[
                        Text(produto["nome"].toString().toUpperCase(), style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 214, 56, 41)),),
                        Text(produto["descrição"].toString(), style: TextStyle(fontSize: 15),),
                      ],
                    ),
                  ),
                  Divider(height: 20,color: Colors.black87,),
                  FutureBuilder<QuerySnapshot>(
                    future: produto.reference.collection("opções").getDocuments(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(!snapshot.hasData || snapshot.data.documents.length==0) return Container();
                      optionsIniciado = 0;
                      if(produto.data["qtdMaxOption"]!=null){
                        return Column(
                          children: <Widget>[
                            custom.ExpansionTile(
                              initiallyExpanded: true,
                              trailing: Icon(Icons.arrow_drop_down, color: Colors.white),
                              headerBackgroundColor: Color.fromARGB(255, 214, 56, 41),
                              title: Text(produto.data["textoOpções"].toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                              children: snapshot.data.documents.map((doc2){
                                return ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: (){
                                          if(selectedOptions.indexOf(doc2["nome"])!=-1){
                                            setState(() {
                                              selectedOptions.removeAt(selectedOptions.indexOf(doc2["nome"]));
                                            });
                                          }
                                        },
                                        child: Icon(Icons.remove_circle, size: 20, color: Colors.red),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(qtdVezes(doc2["nome"]).toString(), style: TextStyle(fontSize: 15),),
                                      SizedBox(width: 5,),
                                      GestureDetector(
                                        onTap: (){
                                          if(selectedOptions.length<produto["qtdMaxOption"]){
                                            setState(() {
                                              selectedOptions.add(doc2["nome"]);
                                            });
                                            print(selectedOptions);
                                          }
                                        },
                                        child: Icon(Icons.add_circle, size: 20, color: Colors.blue)
                                      ),
                                      SizedBox(width: 10),
                                      Text(doc2["nome"].toString(), style: TextStyle(fontSize: 15),),
                                    ],
                                  ),
                                );
                              }).toList()
                            ),
                            SizedBox(height: 15)
                          ]
                        );
                      }
                      optionsIniciado = 1;
                      return Column(
                        children: <Widget>[
                          custom.ExpansionTile(
                              initiallyExpanded: true,
                              trailing: Icon(Icons.arrow_drop_down, color: Colors.white),
                              headerBackgroundColor: Color.fromARGB(255, 214, 56, 41),
                              title: Text(produto.data["textoOpções"].toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                              children: snapshot.data.documents.map((doc2){
                                return ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Radio(
                                        value: doc2.data["nome"],
                                        groupValue: valorOption,
                                        onChanged: (value) {
                                          setState(() { valorOption = value; });
                                        },
                                      ),
                                      Text(
                                        doc2.data["nome"],
                                        style: new TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              ).toList()
                          ),
                          SizedBox(height: 15)
                        ],
                      );
                    },
                  ),
                  FutureBuilder(
                    future: produto.reference.collection("adicionais").getDocuments(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(!snapshot.hasData || snapshot.data.documents.length==0) return Container();
                      return Column(
                          children: <Widget>[
                            custom.ExpansionTile(
                                initiallyExpanded: true,
                                trailing: Icon(Icons.arrow_drop_down, color: Colors.white),
                                headerBackgroundColor: Color.fromARGB(255, 214, 56, 41),
                                title: Text("Adicionais".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                children: snapshot.data.documents.map((doc3){
                                  return ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap:(){
                                                if(adicionais.indexWhere((v)=>v["nome"]==doc3["nome"])!=-1){
                                                  setState(() {
                                                    adicionais.removeAt(adicionais.indexWhere((v)=>v["nome"]==doc3["nome"]));
                                                  });
                                                }
                                              },
                                              child: Icon(Icons.remove_circle, size: 20, color: Colors.red),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(qtdVezesAdicionais(doc3.data).toString(), style: TextStyle(fontSize: 15),),
                                            SizedBox(width: 5,),
                                            GestureDetector(
                                                onTap:(){
                                                  setState(() { adicionais.add(doc3.data); });
                                                },
                                                child: Icon(Icons.add_circle, size: 20, color: Colors.blue)
                                            ),
                                            SizedBox(width: 10),
                                            Text(doc3["nome"].toString(), style: TextStyle(fontSize: 15),),
                                          ],
                                        ),
                                        Text("R\$ ${doc3["preco"].toStringAsFixed(2)}")
                                      ],
                                    ),
                                  );
                                }).toList()
                            ),
                            SizedBox(height: 15)
                          ]
                      );
                    }
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10,left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Selecione a quantidade", style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10,),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    if(qtdProduto>1){
                                      setState(() {
                                        qtdProduto-=1;
                                      });
                                    }
                                  },
                                  child: Icon(Icons.remove_circle, size: 40, color: Colors.red),
                                ),
                                SizedBox(width: 10,),
                                Text(qtdProduto.toString(), style: TextStyle(fontSize: 30),),
                                SizedBox(width: 10,),
                                GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        qtdProduto+=1;
                                      });
                                    },
                                    child: Icon(Icons.add_circle, size: 40, color: Colors.blue)
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text("Valor unitário", style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10,),
                            Text(precoProduto().toStringAsFixed(2), style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 214, 56, 41)),),
                            SizedBox(height: 10,),
                            Text("Valor total", style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10,),
                            Text((precoProduto()*qtdProduto).toStringAsFixed(2), style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 214, 56, 41)),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: detalhesPedidoController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration.collapsed(hintText: "Detalhes do pedido"),
                      ),
                    )
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                      onPressed: () async {
                        var Error = false;
                        Map<String, dynamic> pedidoProduto = {};
                        pedidoProduto = {
                          "produto":produto.data,
                          "produtoID":produto.documentID,
                          "quantidade":qtdProduto,
                          "detalhePedido":detalhesPedidoController.text,
                          "precoUnitario":precoProduto(),
                          "precoTotal": precoProduto()*qtdProduto,
                        };
                        if(optionsIniciado==1){
                          if(valorOption!=null){
                            pedidoProduto.addAll({"opçãoEscolhida":valorOption});
                          }
                          else{
                            Error = true;
                          }
                        }
                        if(optionsIniciado==0){
                          if(selectedOptions.length<produto["qtdMinOption"]){
                            Error = true;
                          }
                          else{
                            pedidoProduto.addAll({"opçãoEscolhida":selectedOptions.join("-")});
                          }
                        }
                        if(adicionais.length>0){
                          pedidoProduto.addAll({"adicionais":adicionais});
                        }
                        if(Error){
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Preencha corretamente"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              )
                          );
                        }
                        else{
                          CartModel.of(context).addCartItem(pedidoProduto);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Carrinho()));
                        }
                      },
                      textColor: Colors.white,
                      color: Color.fromARGB(255, 214, 56, 41),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add_shopping_cart, size: 18),
                          Text(
                            " Adicionar o carrinho",
                            style: TextStyle(fontSize: 18)
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            )
        ),
      )
    );
  }
}
