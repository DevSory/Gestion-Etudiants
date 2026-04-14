package com.example.demo.entity;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;

@Entity
@Table( name = "etudiants" )
public class Etudiant {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;
    private String nom;
    private String prenom;
    private String email;
    public Etudiant () {}
    public Etudiant (String nom, String prenom, String email){
        this.email = email;
        this.nom = nom;
        this.prenom = prenom;
    }
    public void setNom (String nom){
        this.nom = nom;
    }
    public String getNom(){
        return this.nom;
    }
    public void setPrenom (String prenom){
        this.prenom = prenom;
    }
    public String getPrenom(){
        return this.prenom;
    }
    public void setEmail (String email){
        this.email = email;
    }
    public String getEmail(){
        return this.email;
    }
    public Long getId() {
        return id;
    }
}
