package controller;

import util.DBConnection;


import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
@WebServlet("/AttestationServlet")
public class AttestationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    public AttestationServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 HttpSession session = request.getSession();
	        String email = (String) session.getAttribute("email");

	        String nom = "";
	        String prenom = "";
	        String filiere = "";
	        String annee = "";

	        try (Connection conn = DBConnection.getConnection()) {
	            PreparedStatement stmt = conn.prepareStatement(
	                "SELECT nom, prenom, filiere, annee FROM utilisateur WHERE email=?"
	            );
	            stmt.setString(1, email);
	            ResultSet rs = stmt.executeQuery();
	            if (rs.next()) {
	                nom = rs.getString("nom");
	                prenom = rs.getString("prenom");
	                filiere = rs.getString("filiere");
	                annee = rs.getString("annee");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        // Passer les donn�es � la JSP
	        request.setAttribute("nom", nom);
	        request.setAttribute("prenom", prenom);
	        request.setAttribute("filiere", filiere);
	        request.setAttribute("annee", annee);

	        request.getRequestDispatcher("attestation.jsp").forward(request, response);
	    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
