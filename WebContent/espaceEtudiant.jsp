<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Espace Étudiant</title>
    <link rel="stylesheet" href="dashboard.css">
    <style>
        .cards {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
        }
        .card {
            background: #fff;
            padding: 15px;
            border-radius: 8px;
            width: 320px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .card:hover { transform: translateY(-5px); }
        .card.en_attente { border-left: 5px solid orange; }
        .card.approuvée { border-left: 5px solid green; }
        .card.rejetée { border-left: 5px solid red; }
        .card h3 { margin-top: 0; font-size: 18px; color: #2c3e50; }
        .commentaire { margin-top: 10px; font-style: italic; color: #555; }
        .new-request {
            display: inline-block;
            margin-bottom: 20px;
            padding: 8px 15px;
            background: #2c3e50;
            color: #fff;
            border-radius: 5px;
            text-decoration: none;
        }
        .new-request:hover { background: #1a242f; }
    </style>
</head>
<body>
    <!-- Vérification du rôle -->
    <%
        String role = (String) session.getAttribute("role");
        if (role == null || !"etudiant".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }
    %>

    <!-- Sidebar -->
    <div class="sidebar">
        <h2>MENU PRINCIPAL</h2>
        <a href="espaceEtudiant.jsp" class="active">Mon Espace</a>
        <a href="profilEtudiant.jsp">Profil</a>
        <div class="user-info">
            <p><%= session.getAttribute("user") %></p>
            <p class="role">Étudiant</p>
            <a href="login.jsp" class="logout">Déconnexion</a>
        </div>
    </div>

    <!-- Contenu principal -->
    <div class="content">
        <h1>Mes Demandes</h1>
        <a href="ajouterDemande.jsp" class="new-request">+ Nouvelle Demande</a>

        <div class="cards">
            <%
                try (Connection conn = DBConnection.getConnection()) {
                    int etudiantId = (int) session.getAttribute("etudiantId");

                    String sql = "SELECT d.id, d.motif, d.statut, d.date_demande, e.annee_inscription " +
                                 "FROM demande d " +
                                 "JOIN etudiant e ON d.etudiant_id = e.id " +
                                 "WHERE d.etudiant_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, etudiantId);
                    ResultSet rs = stmt.executeQuery();

                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
                        String statut = rs.getString("statut");
            %>
                        <div class="card <%= statut.toLowerCase().replace(" ", "_") %>">
                            <h3>Référence: ATT-<%= rs.getInt("id") %></h3>
                            <p><strong>Motif:</strong> <%= rs.getString("motif") %></p>
                            <p><strong>Année:</strong> <%= rs.getString("annee_inscription") %></p>
                            <p><strong>Date:</strong> <%= rs.getTimestamp("date_demande") %></p>
                            <p><strong>Status:</strong> <%= statut %></p>
                            <% if ("Approuvée".equals(statut)) { %>
                                <p class="commentaire">Demande approuvée. Attestation disponible.</p>
                            <% } else if ("Rejetée".equals(statut)) { %>
                                <p class="commentaire">Votre demande a été rejetée.</p>
                            <% } else { %>
                                <p class="commentaire">Votre demande est en attente de traitement.</p>
                            <% } %>
                        </div>
            <%
                    }
                    if (!hasData) {
                        out.println("<p>Aucune demande trouvée.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red'>Erreur : " + e.getMessage() + "</p>");
                }
            %>
        </div>
    </div>
</body>
</html>
