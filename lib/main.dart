import 'package:delivery_app/models/cart_model.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/tabs/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
  //Firestore.instance.collection("col").document().setData({'texto':'daniel'});

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, UserModel model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: 'App',
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: [const Locale('pt', 'BR')],
              theme: ThemeData(
                primaryColor: Color.fromARGB(255, 214, 56, 41),
                primarySwatch: Colors.red,
              ),
              debugShowCheckedModeBanner: false,
              home: Tabs(),
            ),
          );
        },
      )
    );
  }
}
