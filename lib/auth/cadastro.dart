import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  var nomeCompletoController = TextEditingController();

  var emailController = TextEditingController();

  var senhaController = TextEditingController();

  var phoneController = TextEditingController();
  var phoneMask = new MaskTextInputFormatter(mask: '(##) #####-####', filter: { "#": RegExp(r'[0-9]') });

  var dataController = TextEditingController();
  var dataMask = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Cadastro"),
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
                    controller: nomeCompletoController,
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
                      hintText: 'Nome completo',
                      hintStyle: TextStyle(fontSize: 18),
                      prefixIcon: Icon(Icons.person, color: Colors.black,),
                      prefixText: '',
                    ),
                    validator: _validarNome
                ),
                SizedBox(height: 25),
                TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
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
                      hintText: 'Email',
                      hintStyle: TextStyle(fontSize: 18),
                      prefixIcon: Icon(Icons.mail, color: Colors.black,),
                      prefixText: '',
                    ),
                    validator: _validarEmail
                ),
                SizedBox(height: 25),
                TextFormField(
                    controller: phoneController,
                    inputFormatters: [phoneMask],
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
                      hintText: 'Celular',
                      hintStyle: TextStyle(fontSize: 18),
                      prefixIcon: Icon(Icons.phone, color: Colors.black,),
                      prefixText: '',
                    ),
                    validator: (value) {
                      if (value.length!=15) {
                        return 'Preencha o telefone corretamente';
                      }
                      return null;
                    }
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
                      enabledBorder : OutlineInputBorder(
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
                      hintText: 'Senha',
                      hintStyle: TextStyle(fontSize: 18),
                      prefixIcon: Icon(Icons.lock, color: Colors.black,),
                      prefixText: '',
                    ),
                    validator: (value) {
                      if (value.length<8) {
                        return 'Senha precisa ter no mínimo 8 caracteres';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 25),
                DateTimeField(
                  controller: dataController,
                  format: DateFormat("dd/MM/yyyy"),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.black54,
                            width: 2
                        )
                    ),
                    enabledBorder : OutlineInputBorder(
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
                    hintText: 'Data de Nascimento',
                    hintStyle: TextStyle(fontSize: 18),
                    prefixIcon: Icon(Icons.lock, color: Colors.black,),
                    prefixText: '',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Preencha a data de nascimento';
                    }
                    return null;
                  },
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime.now(),
                    );
                  },
                ),
                SizedBox(height: 25),
                SizedBox(
                  height: 50,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                    onPressed: (){
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> userData = {
                          "name": nomeCompletoController.text,
                          "email": emailController.text,
                          "phone": phoneController.text,
                          "dataNasc": dataController.text
                        };
                        model.signUp(userData, senhaController.text, onSucess, onError);
                      }
                    },
                    textColor: Colors.white,
                    color: Color.fromARGB(255, 214, 56, 41),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person_add, size: 18),
                        Text(
                            " Cadastrar",
                            style: TextStyle(fontSize: 18)
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
  onSucess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Usuário criado com sucesso"),
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
          content: Text("Erro ao criar usuário"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
String _validarNome(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Informe o nome";
  } else if (!regExp.hasMatch(value)) {
    return "O nome deve conter caracteres de a-z ou A-Z";
  }
  return null;
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
