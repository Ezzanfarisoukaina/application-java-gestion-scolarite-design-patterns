package dao;

import model.Utilisateur;

public interface utilisateurDAO {
    Utilisateur findByEmailAndPassword(String email, String password);
}