package model;

public class Filiere {
    private int id;
    private String nom, niveau;

    public Filiere() {}
    public Filiere(int id, String nom, String niveau) {
        this.id = id;
        this.nom = nom;
        this.niveau = niveau;
    }
    // Getters/setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getNiveau() { return niveau; }
    public void setNiveau(String niveau) { this.niveau = niveau; }
}