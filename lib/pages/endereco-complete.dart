import 'package:delivery_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CadastrarEndereco extends StatefulWidget {
  final dynamic endereco;
  CadastrarEndereco(this.endereco);

  @override
  _CadastrarEnderecoState createState() => _CadastrarEnderecoState();
}

class _CadastrarEnderecoState extends State<CadastrarEndereco> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    var endereco = widget.endereco;
    var bairroController = TextEditingController(text: endereco["bairro"]);
    var logradouroController = TextEditingController(text: endereco["logradouro"]);
    var numeroController = TextEditingController();
    var complementoController = TextEditingController();
    var referenciaController = TextEditingController();
    print(endereco);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Cadastro de Endereço"),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, UserModel model){
          if(model.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                SizedBox(
                  child: Column(
                   children: <Widget>[
                     Text("Informações do Cep: ${endereco["cep"]}", style: TextStyle(fontSize: 20),),
                     Text("${endereco["localidade"]} - ${endereco["uf"]}", style: TextStyle(fontSize: 20),)
                   ],
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  enabled: false,
                  controller: bairroController,
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
                    hintText: 'Digite o bairro',
                    hintStyle: TextStyle(fontSize: 18),
                  ),

                ),
                SizedBox(height: 20),
                TextFormField(
                  enabled: false,
                  controller: logradouroController,
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
                    hintText: 'Digite o logradouro',
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: numeroController,
                  style: TextStyle(fontSize: 18),
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
                    hintText: 'Digite o número do endereço',
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                  validator: (value) {
                    if (value.length==0) {
                      return 'Informe o número';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: complementoController,
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
                    hintText: 'Digite o complemento',
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: referenciaController,
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
                    hintText: 'Digite o ponto de referencia',
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                  validator: (value) {
                    if (value.length==0) {
                      return 'Informe o ponto de referência';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25),
                SizedBox(
                  height: 50,
                  child: RaisedButton(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          Map<String, dynamic> enderecoMAP = {
                            "cep": endereco["cep"],
                            "localidade": endereco["localidade"],
                            "uf": endereco["uf"],
                            "bairro": bairroController.text,
                            "logradouro": logradouroController.text,
                            "numero": numeroController.text,
                            "complemento": complementoController.text,
                            "referencia": referenciaController.text,
                            "ativo": false
                          };
                          model.saveEndereco(enderecoMAP, onSucess, onError);
                        }
                      },
                      textColor: Colors.white,
                      color: Color.fromARGB(255, 214, 56, 41),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.save, size: 18),
                          Text(
                            " Salvar",
                            style: TextStyle(fontSize: 18)
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),
          );
        },

      ),
    );
  }
  onSucess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Endereço salvo com sucesso"),
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
          content: Text("Erro ao cadastrar endereço"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
