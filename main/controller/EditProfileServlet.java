package controller;


import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.DBConnection;

@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public EditProfileServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// NE PAS rediriger vers editProfile.jsp ici !
        // Rediriger vers profile.jsp pour afficher le profil
		HttpSession session = request.getSession();
        String emailSession = (String) session.getAttribute("email");
        
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        
        // Vérifier si les mots de passe correspondent
        if (password != null && !password.isEmpty()) {
            if (!password.equals(confirmPassword)) {
                response.sendRedirect("editProfile.jsp?error=password_mismatch");
                return;
            }
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql;
            PreparedStatement stmt;
            
            if (password != null && !password.isEmpty()) {
                // Mise à jour avec mot de passe
                sql = "UPDATE utilisateur SET nom = ?, prenom = ?, email = ?, role = ?, mot_de_passe = ? WHERE email = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, nom);
                stmt.setString(2, prenom);
                stmt.setString(3, email);
                stmt.setString(4, role);
                stmt.setString(5, password);
                stmt.setString(6, emailSession);
            } else {
                // Mise à jour sans mot de passe
                sql = "UPDATE utilisateur SET nom = ?, prenom = ?, email = ?, role = ? WHERE email = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, nom);
                stmt.setString(2, prenom);
                stmt.setString(3, email);
                stmt.setString(4, role);
                stmt.setString(5, emailSession);
            }
            
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                // Mettre à jour la session
                session.setAttribute("user", nom + " " + prenom);
                session.setAttribute("email", email);
                session.setAttribute("role", role);
                
                response.sendRedirect("profile.jsp?success=1");
            } else {
                response.sendRedirect("editProfile.jsp?error=update_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("editProfile.jsp?error=" + e.getMessage());
        }
	}

}
