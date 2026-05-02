package controller;

import util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;


@WebServlet("/NouvelleDemandeServlet")
public class NouvelleDemandeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String cne = request.getParameter("cne");
        String email = request.getParameter("email");
        int filiereId = Integer.parseInt(request.getParameter("filiereId"));
        String annee = request.getParameter("annee");
        String motif = request.getParameter("motif");

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Vérifier si l'étudiant existe déjà via son CNE
            int etudiantId = -1;
            String checkSql = "SELECT id FROM etudiant WHERE cne = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, cne);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                etudiantId = rs.getInt("id");
            } else {
                // 2. Insérer un nouvel étudiant
                String insertEtudiant = "INSERT INTO etudiant (nom, prenom, cne, email, filiere_id, annee_inscription) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement stmtEtudiant = conn.prepareStatement(insertEtudiant, Statement.RETURN_GENERATED_KEYS);
                stmtEtudiant.setString(1, nom);
                stmtEtudiant.setString(2, prenom);
                stmtEtudiant.setString(3, cne);
                stmtEtudiant.setString(4, email);
                stmtEtudiant.setInt(5, filiereId);
                stmtEtudiant.setString(6, annee);
                stmtEtudiant.executeUpdate();

                ResultSet keys = stmtEtudiant.getGeneratedKeys();
                if (keys.next()) {
                    etudiantId = keys.getInt(1);
                }
            }

            // 3. Insérer la demande
            String insertDemande = "INSERT INTO demande (etudiant_id, motif, statut, date_demande) VALUES (?, ?, 'En attente', NOW())";
            PreparedStatement stmtDemande = conn.prepareStatement(insertDemande);
            stmtDemande.setInt(1, etudiantId);
            stmtDemande.setString(2, motif);
            stmtDemande.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Retour vers la liste des demandes
        response.sendRedirect("demande.jsp");
    }
}
