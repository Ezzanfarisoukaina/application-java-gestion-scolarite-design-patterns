<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Aperçu Général</title>
    <link rel="stylesheet" href="dashboard.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>MENU PRINCIPAL</h2>
        <a href="dashboard.jsp" class="active">Tableau de bord</a>
        <a href="demande.jsp">Demandes</a>
        <a href="profile.jsp">Profil</a>
        <div class="user-info">
            <p><%= session.getAttribute("user") %></p>
            <p class="role"><%= session.getAttribute("role") %></p>
            <a href="logout.jsp" class="logout">Déconnexion</a>
        </div>
    </div>

    <!-- Header stats -->
    <div class="stats">
        <div class="card">
            <h3>Total Demandes</h3>
            <p>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) AS total FROM demande");
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next()) out.print(rs.getInt("total"));
                    } catch (Exception e) { out.print("0"); }
                %>
            </p>
        </div>
        <div class="card">
            <h3>En Attente</h3>
            <p>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) AS total FROM demande WHERE statut='En attente'");
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next()) out.print(rs.getInt("total"));
                    } catch (Exception e) { out.print("0"); }
                %>
            </p>
        </div>
        <div class="card">
            <h3>Approuvées</h3>
            <p>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) AS total FROM demande WHERE statut='Approuvée'");
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next()) out.print(rs.getInt("total"));
                    } catch (Exception e) { out.print("0"); }
                %>
            </p>
        </div>
        <div class="card">
            <h3>Rejetées</h3>
            <p>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) AS total FROM demande WHERE statut='Rejetée'");
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next()) out.print(rs.getInt("total"));
                    } catch (Exception e) { out.print("0"); }
                %>
            </p>
        </div>
    </div>

    <!-- Tableau des demandes -->
    <div class="content">
        <h2>Demandes par Étudiant</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Étudiant</th>
                <th>Motif</th>
                <th>Statut</th>
                <th>Date</th>
            </tr>
            <%
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "SELECT d.id, e.nom, e.prenom, d.motif, d.statut, d.date_demande " +
                                 "FROM demande d JOIN etudiant e ON d.etudiant_id = e.id";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
            %>
                        <tr>
                            <td><%= rs.getInt("id") %></td>
                            <td><%= rs.getString("nom") %> <%= rs.getString("prenom") %></td>
                            <td><%= rs.getString("motif") %></td>
                            <td><%= rs.getString("statut") %></td>
                            <td><%= rs.getTimestamp("date_demande") %></td>
                        </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='5'>Erreur : " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>
</body>
</html>
