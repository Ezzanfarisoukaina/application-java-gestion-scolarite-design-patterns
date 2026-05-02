package controller;

import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ModifierServlet")
public class ModifierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ModifierServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("demande.jsp");
            return;
        }
        
        try {
            int demandeId = Integer.parseInt(idParam);
            
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT d.id, d.motif, d.statut, d.date_demande, " +
                             "e.id as etudiant_id, e.nom, e.prenom, e.cne, e.email, e.filiere_id, e.annee_inscription, " +
                             "f.nom as filiere_nom, f.niveau " +
                             "FROM demande d " +
                             "JOIN etudiant e ON d.etudiant_id = e.id " +
                             "LEFT JOIN filiere f ON e.filiere_id = f.id " +
                             "WHERE d.id = ?";
                
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, demandeId);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    request.setAttribute("demandeId", rs.getInt("id"));
                    request.setAttribute("etudiantId", rs.getInt("etudiant_id"));
                    request.setAttribute("motif", rs.getString("motif"));
                    request.setAttribute("statut", rs.getString("statut"));
                    request.setAttribute("dateDemande", rs.getDate("date_demande"));
                    request.setAttribute("nom", rs.getString("nom"));
                    request.setAttribute("prenom", rs.getString("prenom"));
                    request.setAttribute("cne", rs.getString("cne"));
                    request.setAttribute("email", rs.getString("email"));
                    request.setAttribute("filiereId", rs.getInt("filiere_id"));
                    request.setAttribute("anneeInscription", rs.getString("annee_inscription"));
                    
                    request.getRequestDispatcher("modifierDemande.jsp").forward(request, response);
                } else {
                    response.sendRedirect("demande.jsp?error=not_found");
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("demande.jsp?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("demande.jsp?error=database");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupération des paramètres
        String idParam = request.getParameter("id");
        String etudiantIdParam = request.getParameter("etudiant_id");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String cne = request.getParameter("cne");
        String email = request.getParameter("email");
        String filiereIdParam = request.getParameter("filiereId");
        String anneeInscription = request.getParameter("annee");
        String motif = request.getParameter("motif");
        String statut = request.getParameter("statut");
        String dateStr = request.getParameter("date");
        
        // Debug - Afficher les paramètres reçus
        System.out.println("=== MODIFICATION DEMANDE ===");
        System.out.println("idParam: " + idParam);
        System.out.println("etudiantIdParam: " + etudiantIdParam);
        System.out.println("nom: " + nom);
        System.out.println("prenom: " + prenom);
        System.out.println("cne: " + cne);
        System.out.println("email: " + email);
        System.out.println("filiereIdParam: " + filiereIdParam);
        System.out.println("anneeInscription: " + anneeInscription);
        System.out.println("motif: " + motif);
        System.out.println("statut: " + statut);
        System.out.println("dateStr: " + dateStr);
        
        // Validation
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("demande.jsp?error=missing_id");
            return;
        }
        
        if (nom == null || nom.isEmpty()) {
            response.sendRedirect("modifierDemande.jsp?id=" + idParam + "&error=missing_nom");
            return;
        }
        
        try {
            int demandeId = Integer.parseInt(idParam);
            int etudiantId = Integer.parseInt(etudiantIdParam);
            int filiereId = (filiereIdParam != null && !filiereIdParam.isEmpty()) ? Integer.parseInt(filiereIdParam) : 0;
            
            Date dateDemande = null;
            if (dateStr != null && !dateStr.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date parsedDate = sdf.parse(dateStr);
                    dateDemande = new Date(parsedDate.getTime());
                } catch (Exception e) {
                    dateDemande = new Date(System.currentTimeMillis());
                }
            }
            
            try (Connection conn = DBConnection.getConnection()) {
                conn.setAutoCommit(false);
                
                // 1. Mise à jour étudiant
                String updateEtudiantSql = "UPDATE etudiant SET nom=?, prenom=?, cne=?, email=?, filiere_id=?, annee_inscription=? WHERE id=?";
                PreparedStatement stmtEtudiant = conn.prepareStatement(updateEtudiantSql);
                stmtEtudiant.setString(1, nom);
                stmtEtudiant.setString(2, prenom);
                stmtEtudiant.setString(3, cne);
                stmtEtudiant.setString(4, email);
                stmtEtudiant.setInt(5, filiereId);
                stmtEtudiant.setString(6, anneeInscription);
                stmtEtudiant.setInt(7, etudiantId);
                int etudiantUpdated = stmtEtudiant.executeUpdate();
                System.out.println("Étudiant mis à jour: " + etudiantUpdated + " ligne(s)");
                
                // 2. Mise à jour demande
                String updateDemandeSql = "UPDATE demande SET motif=?, statut=?, date_demande=? WHERE id=?";
                PreparedStatement stmtDemande = conn.prepareStatement(updateDemandeSql);
                stmtDemande.setString(1, motif);
                stmtDemande.setString(2, statut);
                stmtDemande.setDate(3, dateDemande);
                stmtDemande.setInt(4, demandeId);
                int demandeUpdated = stmtDemande.executeUpdate();
                System.out.println("Demande mise à jour: " + demandeUpdated + " ligne(s)");
                
                conn.commit();
                System.out.println("=== MODIFICATION RÉUSSIE ===");
                
                response.sendRedirect("demande.jsp?success=modified");
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("modifierDemande.jsp?id=" + demandeId + "&error=update_failed");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("demande.jsp?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("demande.jsp?error=database");
        }
    }
}