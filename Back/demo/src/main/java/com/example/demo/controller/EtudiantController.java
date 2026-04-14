package com.example.demo.controller;

import com.example.demo.entity.Etudiant;
import com.example.demo.repository.EtudiantRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.List;
import org.springframework.web.bind.annotation.PutMapping;




@RestController
@RequestMapping("/etudiants")
@CrossOrigin(origins = "*")
public class EtudiantController {
    @Autowired
    private EtudiantRepo etudiantRepo;
    @PostMapping
    public Etudiant ajouterEtudiant(@RequestBody Etudiant etudiant) {
        //TODO: process POST request
        
        return etudiantRepo.save(etudiant);
    }
    @DeleteMapping ("/{id}")
    public void supprimerEtudiant (@PathVariable Long id){
        try {
            etudiantRepo.deleteById(id);
        } catch (Exception e) {
            System.err.println("error:"+ e.getMessage());
        }
    }
    @GetMapping
    public List<Etudiant> liste() {
        return etudiantRepo.findAll();
    }
    @PutMapping("/{id}")
    public Etudiant modifierEtudiant( @PathVariable Long id, @RequestBody Etudiant nouveau){
       
            Etudiant ancien =etudiantRepo.findById(id).orElse(null);
            if (ancien!=null){
                ancien.setNom(nouveau.getNom());
                ancien.setEmail(nouveau.getEmail());
                ancien.setPrenom(nouveau.getPrenom());
            return etudiantRepo.save(ancien);
            }
            return null;
    }
}
