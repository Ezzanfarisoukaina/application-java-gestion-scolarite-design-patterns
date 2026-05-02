package controller;
import util.DBConnection;
import java.io.IOException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;


@WebServlet("/ApprouverServlet")
public class ApprouverServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ApprouverServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		   String id = request.getParameter("id");
	        try (Connection conn = DBConnection.getConnection()) {
	            String sql = "UPDATE demande SET statut = 'Approuvée' WHERE id = ?";
	            PreparedStatement stmt = conn.prepareStatement(sql);
	            stmt.setInt(1, Integer.parseInt(id));
	            stmt.executeUpdate();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        response.sendRedirect("demande.jsp"); // retour vers la liste
	    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
