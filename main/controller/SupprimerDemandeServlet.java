package controller;

import dao.demandeDAo;
import dao.Imp.demandeDAOImp;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/SupprimerDemandeServlet")
public class SupprimerDemandeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        new demandeDAOImp().delete(id);
        resp.sendRedirect("DemandesServlet");
    }
}
