import 'dart:async';
import 'dart:convert';
//import 'dart:math';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home()
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future retornaFrase() async {
      var url = "https://api.adviceslip.com/advice";
      var response = await http.get(Uri.parse(url));
      var json = jsonDecode(response.body);
      var urlTraducao = "https://api.mymemory.translated.net/get?q=${json["slip"]["advice"]}&langpair=en|pt-br";
      var responseTraducao = await http.get(Uri.parse(urlTraducao));
      json = jsonDecode(responseTraducao.body);
      return json;
  }

  //Variavel que vai armazenar o caminho da imagem do biscoito
  var imgBiscoito = "images/biscoito_inteiro.png";

  //variavel que guarda a frase da sorte
  var frasedasorte = "Clique no botao para gerar a frase!";

  //metdo que quebra o biscoito
  Future quebraBiscoito() async {
    final frase = await retornaFrase();
    setState(() {
      //Gerando a frase da sorte
      frasedasorte = frase["responseData"]["translatedText"];

      //troca a imagem do biscoito
      imgBiscoito = "images/biscoito_quebrado.png";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Biscoito da Sorte!"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center (
        child: Padding (
          padding: EdgeInsets.all(80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(imgBiscoito),
                radius: 80,
                backgroundColor: Colors.white,
              ),

              Text(frasedasorte, 
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Pacifico"
                  )
              ),

              ElevatedButton(
                child: Text("QUEBRAR BISCOITO!"),
                onPressed: () {
                    quebraBiscoito();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                  )
                )
              )
            ]
          ),
        )
      ),
    );
  }
}