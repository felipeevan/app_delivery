import 'package:delivery_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Recovery extends StatefulWidget {
  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 214, 56, 41),
      title: Text("Cadastro"),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, UserModel model) {
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
                SizedBox(
                  height: 50,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                    onPressed: (){
                      if (_formKey.currentState.validate()) {
                        model.recoverPass(emailController.text, onSucess, onError);
                      }
                    },
                    textColor: Colors.white,
                    color: Color.fromARGB(255, 214, 56, 41),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Recuperar senha",
                          style: TextStyle(fontSize: 18)
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
          );
        }
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
          content: Text("Email de recuperação enviado"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds:2)).then((_){
      Navigator.of(context).pop();
    });
  }
  onError(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Erro ao tentar recuperar senha"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
