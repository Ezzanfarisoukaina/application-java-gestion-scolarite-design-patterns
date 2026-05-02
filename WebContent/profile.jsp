<%@ page session="true" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mon Profil</title>
    <link rel="stylesheet" href="profile.css">
</head>
<body>
    <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        
        String email = (String) session.getAttribute("email");
        String nom = "";
        String prenom = "";
        String role = (String) session.getAttribute("role");
        
        if (role == null) role = "admin";
        
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT * FROM utilisateur WHERE email = ?"
            );
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                nom = rs.getString("nom") != null ? rs.getString("nom") : "";
                prenom = rs.getString("prenom") != null ? rs.getString("prenom") : "";
                role = rs.getString("role") != null ? rs.getString("role") : role;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        String initiale = "";
        if (nom != null && !nom.isEmpty()) {
            initiale = nom.substring(0, 1).toUpperCase();
        } else {
            initiale = "A";
        }
    %>
    
    <div class="sidebar">
        <h2>MENU PRINCIPAL</h2>
        <a href="dashboard.jsp">Tableau de bord</a>
        <a href="demande.jsp">Demandes</a>
        <a href="profile.jsp" class="active">Profil</a>
        <div class="user-info">
            <p><%= nom %> <%= prenom %></p>
            <p class="role"><%= role %></p>
            <a href="login.jsp" class="logout">Déconnexion</a>
        </div>
    </div>

    <div class="content">
        <h1>Mon Profil</h1>
        
        <% if (success != null && success.equals("1")) { %>
            <div class="success-message">✅ Profil mis à jour avec succès !</div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="error-message">❌ Erreur lors de la mise à jour du profil.</div>
        <% } %>

        <div class="profile-card">
            <div class="avatar">
                <span><%= initiale %></span>
            </div>
            <div class="profile-info">
                <h2><%= nom %> <%= prenom %></h2>
                <p class="role"><%= role %></p>
                <p class="email"><%= email %></p>
            </div>
        </div>

        <div class="academic-info">
            <h3>Informations Académiques</h3>
            <p><strong>Nom Complet :</strong> <%= nom %> <%= prenom %></p>
            <p><strong>Email :</strong> <%= email %></p>
            <p><strong>Rôle :</strong> <%= role %></p>
            
            <a href="editProfile.jsp" class="edit-profile-btn">✏️ Modifier mon profil</a>
        </div>
    </div>
</body>
</html>