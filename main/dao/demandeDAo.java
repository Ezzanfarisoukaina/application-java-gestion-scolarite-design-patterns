package dao;

import model.Demande;
import java.util.List;

public interface demandeDAo {
    List<Demande> findAll();
    List<Demande> findRecentes(int limit);
    Demande findById(int id);
    void save(Demande demande);
    void updateStatut(int id, String statut);
    void delete(int id);
    int countByStatut(String statut);
    int countTotal();
    List<Demande> filtrer(String nomEtudiant, String statut);
}
