package controller;

import util.DBConnection;


import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    	  String email = request.getParameter("email");
          String password = request.getParameter("password");

          try (Connection conn = DBConnection.getConnection()) {
              String sql = "SELECT * FROM utilisateur WHERE email = ? AND mot_de_passe = ?";
              PreparedStatement stmt = conn.prepareStatement(sql);
              stmt.setString(1, email);
              stmt.setString(2, password);

              ResultSet rs = stmt.executeQuery();

              if (rs.next()) {
                  // Authentification réussie
                  HttpSession session = request.getSession();
                  session.setAttribute("user", rs.getString("nom") + " " + rs.getString("prenom"));
                  session.setAttribute("role", rs.getString("role"));
                  session.setAttribute("etudiantId", rs.getInt("id"));
                  session.setAttribute("email", rs.getString("email")); 

                  // Vérifier le rôle
                  String role = rs.getString("role");
                  if ("admin".equalsIgnoreCase(role)) {
                      response.sendRedirect("dashboard.jsp"); // espace admin
                  } else if ("etudiant".equalsIgnoreCase(role)) {
                      response.sendRedirect("espaceEtudiant.jsp"); // espace étudiant
                  } else {
                      // rôle inconnu → retour login
                      response.sendRedirect("login.jsp?error=role");
                  }
              } else {
                  // Échec
                  response.sendRedirect("login.jsp?error=1");
              }
          } catch (Exception e) {
              e.printStackTrace();
              response.sendRedirect("login.jsp?error=2");
          }
      }

    
  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("dashboard.jsp");
    }

}
