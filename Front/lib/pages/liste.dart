import 'package:flutter/material.dart';
import 'etudiant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListPage extends StatefulWidget {
  const ListPage({super.key});
  @override
  State<ListPage> createState() => _ListPageState();
}

String requette = "";
final TextEditingController _controller = TextEditingController();

class _ListPageState extends State<ListPage> {
  void confirmerSuppression(BuildContext context, int id, String nomComplet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Voulez-vous vraiment supprimer l'étudiant $nomComplet ?"),
              const SizedBox(height: 15),
              const Text(
                "Attention : Cette action est irréversible et supprimera définitivement les données.",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ANNULER"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                supprimer(id);
              },
              child: const Text(
                "SUPPRIMER",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List<Etudiant>> fetchEtudiants() async {
    final response = await http.get(
      Uri.parse('http://192.168.137.1:8080/etudiants'),
    );

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List jsonResponse = json.decode(responseBody);
      return jsonResponse.map((data) => Etudiant.fromJson(data)).toList();
    } else {
      throw Exception('Erreur de chargement');
    }
  }

  Future<void> supprimer(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.137.1:8080/etudiants/$id'),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Étudiant supprimé avec succès"),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {});
    }
  }

  void modifier(Etudiant etudiant) {
    TextEditingController nomCtrl = TextEditingController(text: etudiant.nom);
    TextEditingController prenomCtrl = TextEditingController(
      text: etudiant.prenom,
    );
    TextEditingController emailCtrl = TextEditingController(
      text: etudiant.email,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Modifier l'étudiant",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextField(
              controller: nomCtrl,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: prenomCtrl,
              decoration: const InputDecoration(labelText: "Prénom"),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.black,
                elevation: 8,
              ),
              onPressed: () async {
                final response = await http.put(
                  Uri.parse('http://192.168.137.1:8080/etudiants/${etudiant.id}'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "nom": nomCtrl.text,
                    "prenom": prenomCtrl.text,
                    "email": emailCtrl.text,
                  }),
                );
                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Étudiant modifié avec succès"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text("Sauvegarder"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Liste des étudiants"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              onChanged: (value) => {
                setState(() {
                  requette = value;
                }),
              },
              controller: _controller,
              decoration: InputDecoration(
                hintText: "rechercher un étudiant",
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      requette = "";
                      _controller.clear();
                    });
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Etudiant>>(
            future: fetchEtudiants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Erreur : ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Aucun étudiant trouvé"));
              }
              List<Etudiant> complet = snapshot.data!;
              List<Etudiant> filtree = complet.where((e) {
                return ((e.nom.toLowerCase().contains(requette.toLowerCase()))|| (e.prenom.toLowerCase().contains(requette.toLowerCase())));
              }).toList();
              return ListView.builder(
                itemCount: filtree.length,
                itemBuilder: (context, index) {
                  final student = filtree[index];

                  return Card(
                    margin: const EdgeInsets.all(5),
                    child: ListTile(
                      onTap: () => modifier(student),
                      leading: const Icon(Icons.person, color: Colors.black),
                      title: Text("${student.prenom} ${student.nom}"),
                      subtitle: Text(student.email),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => confirmerSuppression(
                          context,
                          student.id!,
                          "${student.prenom} ${student.nom}",
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ),
        ],
      ),
    );
  }
}
