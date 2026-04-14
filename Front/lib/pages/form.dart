import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studentds_managements/pages/liste.dart';

String nom = "", prenom = "", email = "";

class FormPage extends StatefulWidget {
  const FormPage({super.key});
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  bool isLoading = false;
Future<void> envoyerEtudiant() async {

  setState(() {
    isLoading = true;
  });

  try {

    final url = Uri.parse('http://192.168.137.1:8080/etudiants');

    final body = jsonEncode({
      "nom": nom,
      "prenom": prenom,
      "email": email
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201 ) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Étudiant ajouté avec succès"),
          backgroundColor: Colors.green,
        ),
      );
      _formkey.currentState!.reset();
    setState(() {
      nom = "";
      prenom = "";
      email = "";
  });

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors de l'ajout"),
           backgroundColor: Colors.red,
        ),
      );

    }

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Impossible de contacter le serveur"),
         backgroundColor: Colors.red,
      ),
    );

  } finally {

    setState(() {
      isLoading = false;
    });

  }
}

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Ajouter un étudiant"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 15),
                      Text("Saisir ses informations", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 300,
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "nom",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onSaved: (value) {
                              nom = value!;
                            },
                            validator: (value) {
                              if (value == null || value == "") {
                                return 'veuillez entrez un nom';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "prenom",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onSaved: (value) {
                              prenom = value!;
                            },
                            validator: (value) {
                              if (value == null || value == "") {
                                return 'veuillez entrez un prenom';
                              } else {
                                return null;
                              }
                            },
                          ),

                          SizedBox(height: 15),

                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "eamil",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.email,
                                color: Colors.red,
                              ),
                            ),
                            onSaved: (value) {
                              email = value!;
                            },
                            validator: (value) {
                              if (value == null ||
                                  !value.contains("@") ||
                                  value == "@") {
                                return 'veuillez entrez un email valide';
                              } else {
                                return null;
                              }
                            },
                          ),

                          SizedBox(height: 15),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey[100],
                                foregroundColor: Colors.black,
                                elevation: 5,
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                              if (_formkey.currentState!.validate()) {
                                _formkey.currentState!.save();
                                envoyerEtudiant();
                              }
                            },
                            child: isLoading
                                ? CircularProgressIndicator(
                              color: Colors.blueGrey,
                              strokeWidth: 2,
                            )
                                : Text("Ajouter"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[100],
                  foregroundColor: Colors.black,
                  elevation: 8,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListPage()),
                  );
                },
                child:
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list),
                    SizedBox(width: 5,),
                    Text("la liste des étudiants"),
                  ],
                )
            ),
                ],
              ),
            ),
          ],
        )
      ),
      )
    );
  }
}
