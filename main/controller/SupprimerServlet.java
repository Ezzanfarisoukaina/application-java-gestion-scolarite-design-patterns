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


@WebServlet("/SupprimerServlet")
public class SupprimerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public SupprimerServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 String id = request.getParameter("id");
	        try (Connection conn = DBConnection.getConnection()) {
	            PreparedStatement stmt = conn.prepareStatement(
	                "DELETE FROM demande WHERE id = ?");
	            stmt.setInt(1, Integer.parseInt(id));
	            stmt.executeUpdate();
	        } catch (Exception e) { e.printStackTrace(); }
	        response.sendRedirect("demande.jsp");
	    }
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
