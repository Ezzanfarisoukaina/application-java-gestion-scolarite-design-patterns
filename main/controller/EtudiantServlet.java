package controller;

import dao.etudiantDAO;
import dao.Imp.etudiantDAOImp;

import model.Etudiant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/EtudiantsServlet")
public class EtudiantServlet extends HttpServlet {
    private etudiantDAO etudiantDAO = new etudiantDAOImp();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Etudiant> etudiants = etudiantDAO.findAllWithFiliere();
        req.setAttribute("etudiants", etudiants);
        req.getRequestDispatcher("etudiants.jsp").forward(req, resp);
    }
}