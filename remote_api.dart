import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteApiKullanimi extends StatefulWidget {
  @override
  _RemoteApiKullanimiState createState() => _RemoteApiKullanimiState();
}

class _RemoteApiKullanimiState extends State<RemoteApiKullanimi> {
  String strmusteriadi = "";

  Future<List<Gonderi>> _gonderiGetir() async {
    var response;
    if (strmusteriadi == "") {
      response = await http.get(
          "http://fluterapi.prismcrm.com/api/PRISM/MusteriList?A=&P=0&R=0&PC=");
    } else {
      response = await http.get(
          "http://fluterapi.prismcrm.com/api/PRISM/MusteriList?A=" +
              strmusteriadi +
              "&P=1&R=100&PC=");
    }

    if (response.statusCode == 200) {
      //return Gonderi.fromJsonMap(json.decode(response.body));
      return (json.decode(response.body) as List)
          .map((tekGonderiMap) => Gonderi.fromJsonMap(tekGonderiMap))
          .toList();
    } else {
      throw Exception("Baglanamadık ${response.statusCode}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Müşteri Listesi"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  hintText: "Lütfen Müşteri Adı Girin",
                  labelText: "Müşteri Adı Soyadı"),
              onChanged: (String value) {
                setState(() {
                  strmusteriadi = value;
                });
              },
              onSubmitted: (String value) async {
                setState(() {
                  strmusteriadi = value;
                  _gonderiGetir();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _gonderiGetir(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Gonderi>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data[index].musteriadisoyadi),
                            subtitle: Text(snapshot.data[index].ceptel1),
                            trailing:  IconButton(
                              icon: Icon(
                                Icons.arrow_right,
                                color: Colors.deepOrange,
                              ),
                              tooltip: 'Müşteri İletişim',
                              onPressed: () {
                                setState(() {
                                  _showDialog(snapshot.data[index].musteriadisoyadi);
                                });
                              },
                            ),
                            leading: IconButton(
                              icon: Icon(
                                Icons.phone,
                                color: Colors.deepOrange,
                              ),
                              tooltip: 'Ara',
                              onPressed: () {
                                setState(() {
                                  _showDialog(snapshot.data[index].ceptel1);
                                });
                              },
                            ),

                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _gonderiGetir();
          });
        },
        child: Icon(Icons.search),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  void _showDialog(String telno) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Ara"),
          content: new Text(telno),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Gonderi {
  int id;
  String musteriadisoyadi;
  String ceptel1;
  String email;

  Gonderi.fromJsonMap(Map<String, dynamic> map)
      : id = map["ID"],
        musteriadisoyadi = map["MusteriAdiSoyadi"],
        ceptel1 = map["CepTel1"],
        email = map["EMail"];
}
