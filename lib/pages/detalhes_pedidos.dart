import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalhesPedidos extends StatefulWidget {
  final dynamic pedido;
  DetalhesPedidos(this.pedido);


  @override
  _DetalhesPedidosState createState() => _DetalhesPedidosState();
}

class _DetalhesPedidosState extends State<DetalhesPedidos> {

  @override
  Widget build(BuildContext context) {
    var pedido = widget.pedido;

    var listHistorico = pedido["historicoPedido"].map<TableRow>((item) =>
      TableRow(children: [
        Container(
          alignment: Alignment.center ,
          child: Text("${DateFormat('dd/MM/yyyy HH:mm').format(item["data"].toDate().add(Duration(hours: -3)))}", style: TextStyle(fontSize: 20),),
        ),
        Container(
          alignment: Alignment.center ,
          child: Text(item["status"], style: TextStyle(fontSize: 20),),
        ),
      ])
    ).toList();
    listHistorico.insert(0,
      TableRow(children: [
        Container(
          color: Colors.black12,
          alignment: Alignment.center ,
          child: Text("Data/Hora", style: TextStyle(fontSize: 20),),
        ),
        Container(
          color: Colors.black12,
          alignment: Alignment.center ,
          child: Text("Status", style: TextStyle(fontSize: 20),),
        ),
      ])
    );



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 56, 41),
        title: Text("Detalhes do Pedido"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Histórico do pedido", style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 10,),
            Table(
              border: TableBorder.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 1.0,
              ),
              children: listHistorico
            ),
            SizedBox(height: 10),
            Text("Detalhes do pedido", style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 10,),
            Table(
              border: TableBorder.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 1.0,
              ),
              children: [
                tableRow("Endereço de entrega","${pedido["endereco"]["logradouro"]} ${pedido["endereco"]["numero"]}"),
                tableRow("Valor","R\$ ${pedido["precoTotal"].toStringAsFixed(2)}"),
                tableRow("Forma de pagamento","${pedido["tipoPagamento"]}"),
                TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text("Itens", style: TextStyle(fontSize: 20),),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pedido["pedidos"].map<Widget>((item){
                            return Text("${item["quantidade"]}x ${item["produto"]["nome"]}", style: TextStyle(fontSize: 20),);
                          }).toList(),
                        )
                      ),
                    ]
                )
              ],
            )
          ],
        ),
      )
    );
  }
  tableRow(titulo, valor){
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(titulo, style: TextStyle(fontSize: 20),),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(valor, style: TextStyle(fontSize: 20),),
        ),
      ]
    );
  }
}
