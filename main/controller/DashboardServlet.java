package controller;

import dao.demandeDAo;
import dao.Imp.demandeDAOImp;

import model.Demande;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private demandeDAo demandeDAO = new demandeDAOImp();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // R�cup�ration des statistiques
       // int total = demandeDAO.countAll();
        int enAttente = demandeDAO.countByStatut("En attente");
        int approuvees = demandeDAO.countByStatut("Approuv�e");
        int rejetees = demandeDAO.countByStatut("Rejet�e");

        // R�cup�ration des demandes r�centes (par exemple les 5 derni�res)
        List<Demande> recentes = demandeDAO.findRecentes(5);

        // Passage des donn�es � la JSP
        //req.setAttribute("total", total);
        req.setAttribute("enAttente", enAttente);
        req.setAttribute("approuvees", approuvees);
        req.setAttribute("rejetees", rejetees);
        req.setAttribute("demandesRecentes", recentes);

        // Redirection vers la vue
        req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
    }
}
