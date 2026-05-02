package model;

public class Etudiant {
    private int id;
    private String nom, prenom, cne, email, anneeInscription;
    private Filiere filiere;

    public Etudiant() {}
    // Getters/setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public String getCne() { return cne; }
    public void setCne(String cne) { this.cne = cne; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getAnneeInscription() { return anneeInscription; }
    public void setAnneeInscription(String anneeInscription) { this.anneeInscription = anneeInscription; }
    public Filiere getFiliere() { return filiere; }
    public void setFiliere(Filiere filiere) { this.filiere = filiere; }

    public String getInitiales() {
        if (nom == null || prenom == null) return "?";
        return (nom.substring(0,1) + prenom.substring(0,1)).toUpperCase();
    }
}