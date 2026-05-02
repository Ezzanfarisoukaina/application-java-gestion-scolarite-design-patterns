package controller;

import util.DBConnection;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;


@WebServlet("/AttestationPDFServlet")
public class AttestationPDFServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AttestationPDFServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

    	// Récupérer l'ID de la demande
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("demande.jsp?error=missing_id");
            return;
        }
        
        int demandeId = Integer.parseInt(idParam);
        String nom = "", prenom = "", filiere = "", annee = "", cne = "", numeroInscription = "";
        String statut = "";

        try (Connection conn = DBConnection.getConnection()) {
            // Ajouter le statut dans la requête
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT e.nom, e.prenom, e.cne, e.id as numero_inscription, f.nom AS filiere, f.niveau AS annee, d.statut " +
                "FROM demande d " +
                "JOIN etudiant e ON d.etudiant_id = e.id " +
                "JOIN filiere f ON e.filiere_id = f.id " +
                "WHERE d.id = ?"
            );
            stmt.setInt(1, demandeId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                statut = rs.getString("statut");
                nom = rs.getString("nom");
                prenom = rs.getString("prenom");
                cne = rs.getString("cne");
                numeroInscription = String.valueOf(rs.getInt("numero_inscription"));
                filiere = rs.getString("filiere");
                annee = rs.getString("annee");
            } else {
                response.sendRedirect("demande.jsp?error=not_found");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("demande.jsp?error=database");
            return;
        }
        
        // VÉRIFICATION DU STATUT : UNIQUEMENT SI APPROUVÉE
        if (!"Approuvée".equals(statut)) {
            // Rediriger vers la page des demandes avec un message d'erreur
            response.sendRedirect("demande.jsp?error=not_approved");
            return;
        }

        // Formatage de la date
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy", Locale.FRENCH);
        String dateFormatee = sdf.format(new Date());

        // Configuration de la réponse HTTP
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=attestation_" + demandeId + ".pdf");

        try (OutputStream out = response.getOutputStream()) {
            // Page A4 avec marges
            Document doc = new Document(PageSize.A4, 50, 50, 70, 50);
            PdfWriter.getInstance(doc, out);
            doc.open();

            // ==================== EN-TÊTE ====================
            Font headerBoldFont = new Font(Font.FontFamily.HELVETICA, 13, Font.BOLD);
            Font headerNormalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);
            Font headerSmallFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);
            
            // En-tête
            Paragraph header = new Paragraph();
            header.add(new Phrase("ROYAUME DU MAROC\n", headerBoldFont));
            header.add(new Phrase("Université Chouaib Doukkali\n", headerNormalFont));
            header.add(new Phrase("Faculté des Sciences - El Jadida\n", headerNormalFont));
            header.add(new Phrase("Service des Affaires Estudiantines\n", headerSmallFont));
            header.setAlignment(Element.ALIGN_LEFT);
            doc.add(header);
            
            // Ligne de séparation
            LineSeparator line = new LineSeparator();
            line.setLineWidth(1f);
            doc.add(new Chunk(line));
            
            // Espace après la ligne
            doc.add(new Paragraph("\n\n"));

            // ==================== TITRE ====================
            Font titreFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
            Paragraph titre = new Paragraph("ATTESTATION D'INSCRIPTION", titreFont);
            titre.setAlignment(Element.ALIGN_CENTER);
            doc.add(titre);
            doc.add(new Paragraph("\n\n"));

            // ==================== CONTENU ====================
            Font corpsFont = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.NORMAL);
            Font corpsBoldFont = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD);
            
            // Première phrase
            doc.add(new Paragraph("Je soussigné(e), Doyen de la Faculté des Sciences de l'Université Chouaib Doukkali, certifie que :", corpsFont));
            doc.add(new Paragraph("\n"));
            
            // Nom de l'étudiant (centré)
            Paragraph studentName = new Paragraph("M./Mlle " + nom.toUpperCase() + " " + prenom, corpsBoldFont);
            studentName.setAlignment(Element.ALIGN_CENTER);
            doc.add(studentName);
            doc.add(new Paragraph("\n"));
            
            // Informations
            doc.add(new Paragraph("N° d'inscription : " + numeroInscription, corpsFont));
            doc.add(new Paragraph("CNE : " + cne, corpsFont));
            doc.add(new Paragraph("Est régulièrement inscrit(e) en " + filiere + " - " + annee, corpsFont));
            doc.add(new Paragraph("pour l'année universitaire 2024-2025.", corpsFont));
            doc.add(new Paragraph("\n"));
            
            doc.add(new Paragraph("La présente attestation est délivrée à l'intéressé(e) pour servir et valoir ce que de droit.", corpsFont));
            doc.add(new Paragraph("\n\n\n"));

            // ==================== SIGNATURE ====================
            Font signatureFont = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.NORMAL);
            
            Paragraph signature = new Paragraph();
            signature.add(new Phrase("Fait à El Jadida, le " + dateFormatee + "\n\n", signatureFont));
            signature.add(new Phrase("Le Doyen de la Faculté des Sciences,\n\n\n\n\n", signatureFont));
            signature.add(new Phrase("(Signature et cachet)", new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.ITALIC)));
            signature.setAlignment(Element.ALIGN_RIGHT);
            doc.add(signature);
            
            doc.add(new Paragraph("\n\n"));
            doc.add(new Paragraph("\n\n\n"));
            doc.add(new Paragraph("\n\n\n"));
           
            // ==================== PIED DE PAGE ====================
            LineSeparator footerLine = new LineSeparator();
            doc.add(new Chunk(footerLine));
            
            Font footerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.DARK_GRAY);
            Paragraph footer = new Paragraph(
                "Faculté des Sciences, B.P. 20, 24000 El Jadida\n" +
                "Tél.: +212 523 34 21 45 - Email: contact@fs.ucd.ac.ma", 
                footerFont
            );
            footer.setAlignment(Element.ALIGN_CENTER);
            doc.add(footer);

            doc.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("demande.jsp?error=pdf_generation");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}