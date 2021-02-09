import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  bool isLoading = false;

  Map<String, dynamic> userData = Map();

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signUp(Map<String, dynamic> userData, String pass, VoidCallback onSucess, VoidCallback onError)  {

    isLoading = true;
    notifyListeners();
    _auth.createUserWithEmailAndPassword(email: userData["email"], password: pass)
    .then((result) async {
      firebaseUser = result.user;

      await _saveUserData(userData);

      onSucess();

      isLoading = false;
      notifyListeners();

    }).catchError((e){
      onError();

      isLoading = false;
      notifyListeners();

    }
    );
}

  void signIn(String email, String pass, VoidCallback onSucess, VoidCallback onError){
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: pass)
    .then((result) async {
      firebaseUser = result.user;
      onSucess();

      await _loadCurrentUser();

      isLoading = false;
      notifyListeners();
    })
    .catchError((e){
      onError();
      isLoading = false;
      notifyListeners();
    });
  }

  void recoverPass(email, VoidCallback onSucess, VoidCallback onError){
    isLoading = true;
    notifyListeners();
    _auth.sendPasswordResetEmail(email: email).then((result){
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onError();
      isLoading = false;
      notifyListeners();
    });
  }

  void editDados(userData, senhaAntiga, senhaNova, VoidCallback onSucess, VoidCallback onError) async {
    isLoading = true;
    notifyListeners();
    if(senhaNova!=null&&senhaNova!=""){
      var credential = EmailAuthProvider.getCredential(email: userData["email"], password: senhaAntiga);
      firebaseUser.reauthenticateWithCredential(credential).then((result){
        firebaseUser.updatePassword(senhaNova).then((result) async {
          await _saveUserData(userData);
          onSucess();
          isLoading = false;
          notifyListeners();
        }).catchError((e){
          print(e);
          onError();
          isLoading = false;
          notifyListeners();
        });
      }).catchError((e){
        print(e);
        onError();
        isLoading = false;
        notifyListeners();
      });
    }
    else{
      await _saveUserData(userData);
      onSucess();
      isLoading = false;
      notifyListeners();
    }

  }

  void signOut() async{
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }
  Future<Null> _saveUserData(Map<String, dynamic> userData) async{
    this.userData = userData;
    print(userData);
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }
  Future<Null> saveEndereco(Map<String, dynamic> endereco, VoidCallback onSucess, VoidCallback onError) async {
    isLoading = true;
    notifyListeners();
    await Firestore.instance.collection("users").document(firebaseUser.uid).collection("endereços").add(endereco).then((result) async {
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onError();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> savePedido(Map<String, dynamic> pedido, VoidCallback onSucess, VoidCallback onError) async {
    isLoading = true;
    notifyListeners();
    await Firestore.instance.collection("pedidos").add(pedido).then((result) async {
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onError();
      isLoading = false;
      notifyListeners();
    });
  }

  void excluirEndereco(id) async{
    await Firestore.instance.collection("users").document(firebaseUser.uid).collection("endereços").document(id).delete();
  }

  void ativarEndereco(id) async{
    await Firestore.instance.collection("users").document(firebaseUser.uid).collection("endereços").getDocuments().then(
                (result) async {
          result.documents.forEach((document) async {
            document.reference.updateData(<String, dynamic>{
              'ativo': false
            });
          });
          await Firestore.instance.collection("users").document(firebaseUser.uid).collection("endereços").document(id).updateData({'ativo': true});
        }
    );
  }


  Future<Null> _loadCurrentUser() async {
    if(firebaseUser == null){
      firebaseUser = await _auth.currentUser();
    }
    if(firebaseUser != null){
      firebaseUser = await _auth.currentUser();
      if(userData["name"]==null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
        notifyListeners();
      }
    }
  }
  bool isLoggedIn(){
    return firebaseUser!=null;
  }
  FirebaseUser returnUser(){
    return firebaseUser;
  }
}