import 'package:delivery_app/auth/editar_dados.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/pages/endereco.dart';
import 'package:delivery_app/pages/listar-enderecos.dart';
import 'package:delivery_app/pages/listar_pedidos.dart';
import 'package:delivery_app/tabs/tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class Config extends StatefulWidget {
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();

  double wallet = 0.00;
  int pontos = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 214, 56, 41),
          title: Text("Configurações"),
        ),
        body: ScopedModelDescendant<UserModel>(

          builder: (context,build,UserModel model){
            signOut(){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Tabs()));
              return model.signOut();
            }
            toDados(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditarDados()));
            }
            toPedidos(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ListarPedidos()));
            }

            return ListView(
              padding: EdgeInsets.all(15),
              children: <Widget>[
                createListTile(Icons.person, 'Meus dados', toDados),
                SizedBox(height: 10,),
                createListTile(Icons.location_on, 'Meus endereços', irParaEndereco),
                SizedBox(height: 10,),
                createListTile(Icons.format_list_bulleted, 'Meus pedidos', toPedidos),
                SizedBox(height: 10,),
                ListTile(
                  leading: Icon(Icons.account_balance_wallet, color: Colors.black,size: 40,),
                  title: Row(
                    children: <Widget>[
                      Text('Minha Carteira: ', style: TextStyle(fontSize: 20),),
                      Text('R\$ ${wallet.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 214, 56, 41)),),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.ticketAlt, color: Colors.black,size: 40,),
                  title: Row(
                    children: <Widget>[
                      Text('Meus pontos: ', style: TextStyle(fontSize: 20),),
                      Text('${pontos.toString()} pontos', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 214, 56, 41)),),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                createListTile(Icons.info, 'Perguntas frequentes', null),
                SizedBox(height: 10,),
                createListTile(Icons.exit_to_app, 'Sair', signOut),
              ],
            );
          },
        )
    );
  }
  createListTile(icon, text, action){
    return ListTile(
      onTap: action,
      leading: Icon(icon, color: Colors.black,size: 40,),
      title: Text(text, style: TextStyle(fontSize: 20),),
    );
  }
  irParaEndereco(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => listarEndereco()));

  }

}