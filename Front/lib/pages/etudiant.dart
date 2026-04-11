
class Etudiant {
  int? id;
  String nom = "";
  String prenom = "";
  String email = "";
  Etudiant ( {
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,}
  );
  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
    );
  }
}