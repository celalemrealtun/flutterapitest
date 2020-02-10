import 'package:flutter/material.dart';
import 'package:flutter_app7/remote_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PRISM CRM"),),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(child:Text("Müşteri Listesi"), color: Colors.orangeAccent, onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RemoteApiKullanimi()));
            },),
          ],
        ),
      ),
    );
  }
}

