package model;

import java.util.Date;
import java.text.SimpleDateFormat;

public class Demande {
    private int id;
    private Etudiant etudiant;
    private String motif;
    private String statut;
    private Date dateDemande;

    public Demande() {}
    // Getters/setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Etudiant getEtudiant() { return etudiant; }
    public void setEtudiant(Etudiant etudiant) { this.etudiant = etudiant; }
    public String getMotif() { return motif; }
    public void setMotif(String motif) { this.motif = motif; }
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    public Date getDateDemande() { return dateDemande; }
    public void setDateDemande(Date dateDemande) { this.dateDemande = dateDemande; }

    public String getDateFormatee() {
        if (dateDemande == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, HH:mm");
        return sdf.format(dateDemande);
    }
}
