import 'package:delivery_app/auth/login.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/pages/carrinho.dart';
import 'package:delivery_app/pages/listar_pedidos.dart';
import 'package:delivery_app/tabs/config.dart';
import 'package:delivery_app/tabs/home.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin{
  bool logado = false;
  int _currentIndex = 0;
  List<Widget> _tabList=[
    Home(),
    Carrinho(),
    ListarPedidos(),
    Config(),

  ];
  TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(vsync: this, length: _tabList.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, UserModel model){
        return Scaffold(
          backgroundColor: Colors.white,
          body: TabBarView(
              controller: _tabController,
              children: _tabList,
              physics: const NeverScrollableScrollPhysics()
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 214, 56, 41),
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(size: 35),
            fixedColor: Colors.white,
            unselectedItemColor: Colors.white,
            currentIndex: _currentIndex,
            iconSize: 20,
            onTap: (index){
              if(!model.isLoggedIn()&&(index==1 || index==2 || index==3)){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              }else{
                setState(() {
                  _currentIndex = index;
                });
                _tabController.animateTo(_currentIndex);
              }
            },
            items: [
              BottomNavigationBarItem(
                title: Text("Início"),
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                title: Text("Carrinho"),
                icon: Icon(Icons.shopping_cart),
              ),
              BottomNavigationBarItem(
                title: Text("Pedidos"),
                icon: Icon(Icons.format_list_bulleted),
              ),
              BottomNavigationBarItem(
                title: Text("Configurações"),
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        );
      },
    );
  }
}
