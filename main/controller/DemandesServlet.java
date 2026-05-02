package controller;

import dao.demandeDAo;
import dao.etudiantDAO;
import dao.Imp.demandeDAOImp;
import dao.Imp.etudiantDAOImp;
import model.Demande;
import model.Etudiant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/DemandesServlet")
public class DemandesServlet extends HttpServlet {
    private demandeDAo demandeDAO = new demandeDAOImp();
    private etudiantDAO etudiantDAO = new etudiantDAOImp();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        String statut = req.getParameter("statut");
        List<Demande> demandes = demandeDAO.filtrer(search, statut);
        List<Etudiant> etudiants = etudiantDAO.findAll();
        req.setAttribute("demandes", demandes);
        req.setAttribute("etudiants", etudiants);
        req.getRequestDispatcher("demandes.jsp").forward(req, resp);
    }
}