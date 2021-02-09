import 'package:delivery_app/auth/cadastro.dart';
import 'package:delivery_app/auth/recovery_pass.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();

  var senhaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Login"),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, UserModel model){
          if(model.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(25.0),
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.emailAddress,
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
                    hintText: 'Digite seu email',
                    hintStyle: TextStyle(fontSize: 18),
                    prefixIcon: const Icon(Icons.mail, color: Colors.black,),
                    prefixText: '',
                  ),
                  validator: _validarEmail,
                ),
                SizedBox(height: 25),
                TextFormField(
                    controller: senhaController,
                    obscureText: true,
                    style: TextStyle(fontSize: 18),
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
                      hintText: 'Digite sua senha',
                      hintStyle: TextStyle(fontSize: 18),
                      prefixIcon: const Icon(Icons.lock, color: Colors.black,),
                      prefixText: '',
                    ),
                    validator: (value) {
                      if (value.length==0) {
                        return 'Informe a Senha';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 25),
                SizedBox(
                  height: 50,
                  child: RaisedButton(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                      onPressed: (){
                        if (_formKey.currentState.validate()) {
                          model.signIn(emailController.text, senhaController.text, onSucess, onError);
                        }
                      },
                      textColor: Colors.white,
                      color: Color.fromARGB(255, 214, 56, 41),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.email, size: 18),
                          Text(
                              " Entrar com email e senha",
                              style: TextStyle(fontSize: 18)
                          ),
                        ],
                      )
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height:1.0,
                      width:130.0,
                      color:Colors.grey,
                    ),
                    Text(
                      "OU",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Container(
                      height:1.0,
                      width:130.0,
                      color:Colors.grey,
                    ),
                  ],
                ),
                SizedBox(height: 25),
                SizedBox(
                  height: 50,
                  child: RaisedButton(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                      onPressed: (){
                        showDialog(context: context,builder:(context){
                          return AlertDialog(
                            title: Text("Funcionalidade em breve"),
                            actions: [
                              OutlineButton(
                                child: Text('OK'),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                      },
                      textColor: Colors.white,
                      color: Color.fromARGB(255, 65, 88, 147),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.facebookSquare, size: 18),
                          Text(
                              " Entrar com facebook",
                              style: TextStyle(fontSize: 18)
                          ),
                        ],
                      )
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Recovery()));
                        },
                        textColor: Colors.white,
                        color: Color.fromARGB(255, 214, 56, 41),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FaIcon(FontAwesomeIcons.key, size: 15),
                            new Text(
                                " Esqueci a senha",
                                style: TextStyle(fontSize: 15)
                            ),
                          ],
                        )
                    ),
                    RaisedButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro()));
                        },
                        textColor: Colors.white,
                        color: Color.fromARGB(255, 214, 56, 41),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.person_add, size: 15),
                            new Text(
                                " Cadastrar",
                                style: TextStyle(fontSize: 15)
                            ),
                          ],
                        )
                    ),

                  ],
                )

              ],
            ),
          );
        },
      )
    );
  }
  String _validarEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o Email";
    } else if(!regExp.hasMatch(value)){
      return "Email inválido";
    }else {
      return null;
    }
  }
  onSucess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário logado com sucesso"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      )
    );
    Future.delayed(Duration(seconds:2)).then((_){
      Navigator.of(context).popUntil((r)=>r.isFirst);
    });
  }
  onError(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Erro ao logar usuário"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
