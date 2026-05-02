package controller;

import util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/modifierProfileServlet")
public class modifierProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public modifierProfileServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
        String currentEmail = (String) session.getAttribute("email"); // email actuel
        String newEmail = request.getParameter("email");
        String newPassword = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Utilisation de ta classe DBConnection
            conn = DBConnection.getConnection();

            // Requête SQL pour mettre à jour l'utilisateur
            String sql = "UPDATE utilisateur SET email=?, mot_de_passe=? WHERE email=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, newEmail);
            ps.setString(2, newPassword);
            ps.setString(3, currentEmail);

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                // Mise à jour de la session
                session.setAttribute("email", newEmail);
                session.setAttribute("mot_de_passe", newPassword);

                response.sendRedirect("profile.jsp"); // retour au profil
            } else {
                response.getWriter().println("Erreur : profil non trouvé.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Erreur lors de la mise à jour : " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
	}

}
