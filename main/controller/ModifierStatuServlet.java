package controller;

import dao.demandeDAo;
import dao.Imp.demandeDAOImp;


import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ModifierStatutServlet")
public class ModifierStatuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String statut = req.getParameter("statut");
        new demandeDAOImp().updateStatut(id, statut);
        resp.setContentType("text/plain");
        resp.getWriter().write("ok");
    }
}