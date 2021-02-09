import 'package:delivery_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scoped_model/scoped_model.dart';

class EditarDados extends StatefulWidget {
  @override
  _EditarDadosState createState() => _EditarDadosState();
}

class _EditarDadosState extends State<EditarDados> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  var phoneMask = new MaskTextInputFormatter(mask: '(##) #####-####', filter: { "#": RegExp(r'[0-9]') });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Editar dados"),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          var nomeCompletoController = TextEditingController(text: model.userData["name"]);

          var emailController = TextEditingController(text: model.userData["email"]);

          var senhaController = TextEditingController();
          var senhaController2 = TextEditingController();

          var phoneController = TextEditingController(text: model.userData["phone"]);
          if(model.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                TextFormField(
                  controller: nomeCompletoController,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.text,
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
                    hintText: 'Digite seu nome',
                    hintStyle: TextStyle(fontSize: 18),
                    prefixIcon: const Icon(Icons.mail, color: Colors.black,),
                    prefixText: '',
                  ),
                  validator: _validarNome

                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: emailController,
                  enabled: false,
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
                ),
                SizedBox(height: 20,),
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
                SizedBox(height: 20,),
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
                    hintText: 'Antiga senha',
                    hintStyle: TextStyle(fontSize: 18),
                    prefixIcon: Icon(Icons.lock, color: Colors.black,),
                    prefixText: '',
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: senhaController2,
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
                    hintText: 'Nova senha',
                    hintStyle: TextStyle(fontSize: 18),
                    prefixIcon: Icon(Icons.lock, color: Colors.black,),
                    prefixText: '',
                  ),
                ),
                SizedBox(height: 20,),
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
                          "dataNasc": model.userData["dataNasc"]
                        };
                        model.editDados(userData, senhaController.text, senhaController2.text, onSucess, onError);
                      }
                    },
                    textColor: Colors.white,
                    color: Color.fromARGB(255, 214, 56, 41),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person_add, size: 18),
                        Text(
                            " Salvar",
                            style: TextStyle(fontSize: 18)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          );
        },

      ),
    );
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
  onSucess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Dados salvos com sucesso"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        )
    );
  }
  onError(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Erro ao salvar dados"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
