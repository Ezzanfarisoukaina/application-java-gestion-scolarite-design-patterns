<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Etudiant Demande</title>
    <link rel="stylesheet" href="dashboard.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>MENU PRINCIPAL</h2>
        <a href="espaceEtudiant.jsp">Tableau de bord</a>
        
        <a href="profilEtudiant.jsp">Profil</a>
        <div class="user-info">
            <p><%= session.getAttribute("user") %></p>
            <p class="role"><%= session.getAttribute("role") %></p>
            <a href="login.jsp" class="logout">Déconnexion</a>
        </div>
    </div>

    <!-- Contenu principal -->
    <div class="content">
        <h1>Nouvelle Demande</h1>
        <p>Remplissez le formulaire pour soumettre votre demande.</p>

        <%
            // Charger les filières depuis la base
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                conn = DBConnection.getConnection();
                stmt = conn.prepareStatement("SELECT id, nom, niveau FROM filiere");
                rs = stmt.executeQuery();
        %>

        <form method="post" action="AjouterDemandeServlet" class="form-request">
            <label>Nom :</label>
            <input type="text" name="nom" required>

            <label>Prénom :</label>
            <input type="text" name="prenom" required>

            <label>CNE :</label>
            <input type="text" name="cne" required>

            <label>Email :</label>
            <input type="email" name="email" required>

            <label>Filière :</label>
            <select name="filiereId" required>
                <option value="">-- Sélectionnez une filière --</option>
                <% while (rs.next()) { %>
                    <option value="<%= rs.getInt("id") %>">
                        <%= rs.getString("nom") %> - <%= rs.getString("niveau") %>
                    </option>
                <% } %>
            </select>

            <label>Année universitaire :</label>
            <input type="text" name="annee" value="2025/2026" required>

            <label>Motif de la demande :</label>
            <select name="motif" required>
                <option value="">-- Sélectionnez un motif --</option>
                <option value="Attestation de scolarité">Attestation de scolarité</option>
         
            </select>

            <button type="submit">Soumettre la demande</button>
  
            <a href="espaceEtudiant.jsp" class="btn cancel">Annuler</a>
        </form>

        <%
            } catch (Exception e) {
                out.println("<p style='color:red'>Erreur lors du chargement des filières : " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
</body>
</html>
    