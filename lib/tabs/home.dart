import 'package:delivery_app/auth/login.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/pages/cardapio.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool logado = false;


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, UserModel model){
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 214, 56, 41),
                title: GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(model.isLoggedIn() ? Icons.person : Icons.account_circle),
                      Padding(padding: EdgeInsets.only(right: 10.0),),
                      Text(
                        model.isLoggedIn() ? "Olá, ${model.userData["name"]}":"Clique para Entrar",
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  onTap: model.isLoggedIn() ? null : (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                )
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background-home.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Image.asset('images/faca_pedido_topo.png'),
                  ),
                  SizedBox(
                    width: 240,
                    child: RaisedButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                        onPressed: (){
                          model.isLoggedIn() ?
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Cardapio())):
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                        },
                        textColor: Colors.white,
                        color: Color.fromARGB(255, 214, 56, 41),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.fastfood, size: 20),
                            new Text(
                                " │ DELIVERY",
                                style: TextStyle(fontSize: 20)
                            ),
                          ],
                        )
                    ),
                  )

                ],
              ),
            )
        );
      },
    );
  }
}
