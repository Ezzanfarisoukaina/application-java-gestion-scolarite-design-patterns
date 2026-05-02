package controller;

import util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;


@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    public SignupServlet() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		   String nom = request.getParameter("nom");
	        String prenom = request.getParameter("prenom");
	        String email = request.getParameter("email");
	        String motDePasse = request.getParameter("password");

	        try (Connection conn = DBConnection.getConnection()) {
	            // Verifier si l'email existe deja
	            String checkSql = "SELECT id FROM utilisateur WHERE email = ?";
	            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
	            checkStmt.setString(1, email);
	            ResultSet rs = checkStmt.executeQuery();

	            if (rs.next()) {
	                // Email deja utilise
	                response.sendRedirect("signup.jsp?error=1");
	            } else {
	                // Ins�rer le nouvel utilisateur
	                String insertSql = "INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, role) VALUES (?, ?, ?, ?, 'etudiant')";
	                PreparedStatement stmt = conn.prepareStatement(insertSql);
	                stmt.setString(1, nom);
	                stmt.setString(2, prenom);
	                stmt.setString(3, email);
	                stmt.setString(4, motDePasse);
	                stmt.executeUpdate();

	                // Redirection vers la connexion
	                response.sendRedirect("login.jsp");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("signup.jsp?error=1");
	        }
		
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
