import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/pages/endereco-complete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class Endereco extends StatefulWidget {
  @override
  _EnderecoState createState() => _EnderecoState();
}

class _EnderecoState extends State<Endereco> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var cepController = TextEditingController();
  var cepMask = new MaskTextInputFormatter(mask: '#####-###', filter: { "#": RegExp(r'[0-9]') });
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Cadastrar Endereço"),
      ),
      body: ScopedModelDescendant<UserModel>(

        builder: (context, child, UserModel model){
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                Icon(Icons.map, size: 100),
                SizedBox(height: 20,),
                Center(child:Text("Onde você está?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                SizedBox(height: 20,),
                TextFormField(
                  controller: cepController,
                  inputFormatters: [cepMask],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
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
                    hintText: 'Insira o CEP',
                    hintStyle: TextStyle(fontSize: 20),
                  ),
                  validator: (value) {
                    if (value.length!=9) {
                      return 'Informe corretamente o CEP';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 60,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        var url = 'https://viacep.com.br/ws/${cepMask.getMaskedText()}/json/';
                        var response = await http.get(url);
                        if (response.statusCode == 200) {
                          var jsonResponse = json.decode(response.body);
                          if(jsonResponse["erro"]==true){
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Erro CEP não encontrado"),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          }
                          else{
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CadastrarEndereco(jsonResponse)));
                          }
                        } else {
                          print('Request failed with status: ${response.statusCode}.');
                        }
                      }
                    },
                    textColor: Colors.white,
                    color: Color.fromARGB(255, 214, 56, 41),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.arrow_forward_ios, size: 25),
                        Text(
                            " Continuar",
                            style: TextStyle(fontSize: 20)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }
}
