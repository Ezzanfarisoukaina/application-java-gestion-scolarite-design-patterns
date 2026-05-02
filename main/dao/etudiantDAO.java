package dao;

import model.Etudiant;
import java.util.List;

public interface etudiantDAO {
    List<Etudiant> findAll();
    Etudiant findById(int id);
    List<Etudiant> findAllWithFiliere(); // jointure pour avoir la filière
}