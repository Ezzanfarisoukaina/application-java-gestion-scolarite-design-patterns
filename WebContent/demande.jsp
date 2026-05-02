<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBConnection, java.text.SimpleDateFormat" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Demandes</title>
    <link rel="stylesheet" href="demandes.css">
    <style>
        /* Style pour le bouton télécharger désactivé */
        .btn-download-disabled {
            display: inline-block;
            padding: 5px 10px;
            background-color: #6c757d;
            color: white;
            border-radius: 4px;
            font-size: 0.75rem;
            text-decoration: none;
            cursor: not-allowed;
            opacity: 0.6;
        }
        .btn-download-disabled:hover {
            background-color: #6c757d;
            transform: none;
        }
    </style>
    
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>MENU PRINCIPAL</h2>
        <a href="dashboard.jsp">Tableau de bord</a>
        <a href="demande.jsp" class="active">Demandes</a>
        <a href="profile.jsp">Profil</a>
        <div class="user-info">
            <p><%= session.getAttribute("user") %></p>
            <p class="role"><%= session.getAttribute("role") %></p>
            <a href="login.jsp" class="logout">Déconnexion</a>
        </div>
    </div>

    <!-- Contenu principal -->
    <div class="content">
        <h1>Gestion des Demandes</h1>

        <!-- Messages d'erreur/succès -->
        <%
            String error = request.getParameter("error");
            if ("not_approved".equals(error)) {
        %>
            <div class="alert alert-error">✗ Téléchargement non disponible : La demande doit être approuvée d'abord.</div>
        <%
            }
        %>

        <!-- Barre de recherche -->
        <form method="get" class="search-bar">
            <input type="text" name="search" placeholder="Rechercher par nom, prénom ou CNE..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <select name="statut">
                <option value="">Tous les statuts</option>
                <option value="En attente" <%= "En attente".equals(request.getParameter("statut")) ? "selected" : "" %>>En attente</option>
                <option value="Approuvée" <%= "Approuvée".equals(request.getParameter("statut")) ? "selected" : "" %>>Approuvée</option>
                <option value="Rejetée" <%= "Rejetée".equals(request.getParameter("statut")) ? "selected" : "" %>>Rejetée</option>
            </select>
            <button type="submit">Filtrer</button>
            <a href="nouvelleDemande.jsp" class="new-request">+ Nouvelle demande</a>
        </form>

        <!-- Tableau -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Étudiant</th>
                        <th>CNE</th>
                        <th>Motif</th>
                        <th>Statut</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection conn = DBConnection.getConnection()) {
                            String search = request.getParameter("search");
                            String statut = request.getParameter("statut");

                            String sql = "SELECT d.id, e.nom, e.prenom, e.cne, f.nom AS filiere, f.niveau, " +
                                         "d.motif, d.statut, d.date_demande " +
                                         "FROM demande d " +
                                         "JOIN etudiant e ON d.etudiant_id = e.id " +
                                         "JOIN filiere f ON e.filiere_id = f.id " +
                                         "WHERE 1=1 ";

                    if (search != null && !search.isEmpty()) {
                        sql += " AND (e.nom LIKE ? OR e.prenom LIKE ? OR e.cne LIKE ?)";
                    }
                    if (statut != null && !statut.isEmpty()) {
                        sql += " AND d.statut = ?";
                    }
                    
                    sql += " ORDER BY d.date_demande DESC";

                    PreparedStatement stmt = conn.prepareStatement(sql);

                    int index = 1;
                    if (search != null && !search.isEmpty()) {
                        stmt.setString(index++, "%" + search + "%");
                        stmt.setString(index++, "%" + search + "%");
                        stmt.setString(index++, "%" + search + "%");
                    }
                    if (statut != null && !statut.isEmpty()) {
                        stmt.setString(index++, statut);
                    }

                    ResultSet rs = stmt.executeQuery();
                    boolean hasData = false;
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                    while (rs.next()) {
                        hasData = true;
                        java.sql.Timestamp ts = rs.getTimestamp("date_demande");
                        String dateOnly = (ts != null) ? sdf.format(ts) : "";
                        String statutValue = rs.getString("statut");
                        int demandeId = rs.getInt("id");
                    %>
                        <tr>
                            <td><%= rs.getString("nom") %> <%= rs.getString("prenom") %></td>
                            <td><%= rs.getString("cne") %></td>
                            <td><%= rs.getString("motif") %></td>
                            <td>
                                <span class="status-badge status-<%= statutValue.toLowerCase().replace(" ", "").replace("é", "e") %>">
                                    <%= statutValue %>
                                </span>
                            </td>
                            <td><%= dateOnly %></td>
                            <td>
                                <!-- Boutons conditionnels -->
                                <% if ("En attente".equals(statutValue)) { %>
                                    <a href="ApprouverServlet?id=<%= demandeId %>" class="btn approve">✔</a>
                                    <a href="RejeterServlet?id=<%= demandeId %>" class="btn reject">✖</a>
                                    <a href="modifierDemande.jsp?id=<%= demandeId %>" class="btn edit">✎</a>
                                <% } %>
                                
                                <!-- Bouton Supprimer (toujours visible) -->
                                <a href="SupprimerServlet?id=<%= demandeId %>" class="btn delete" onclick="return confirm('Voulez-vous vraiment supprimer cette demande ?');">🗑</a>
                                
                                <!-- Bouton Télécharger : visible UNIQUEMENT si le statut est Approuvée -->
                                <% if ("Approuvée".equals(statutValue)) { %>
                                    <a href="AttestationPDFServlet?id=<%= demandeId %>" class="btn download">⬇ Télécharger</a>
                                <% } else { %>
                                    <span class="btn-download-disabled" title="Téléchargement disponible uniquement pour les demandes approuvées">⬇ Non disponible</span>
                                <% } %>
                            </td>
                        </tr>
                    <%
                            }
                            if (!hasData) {
                                out.println("<tr><td colspan='6' style='text-align: center; padding: 40px;'>Aucune demande trouvée.</td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' style='text-align: center; padding: 40px; color: red;'>Erreur : " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>