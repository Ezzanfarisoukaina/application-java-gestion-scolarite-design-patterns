<%@ page session="true" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier mon profil</title>
    <link rel="stylesheet" href="editProfile.css">
</head>
<body>
    <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        
        String email = (String) session.getAttribute("email");
        String nom = "";
        String prenom = "";
        String role = "";
        
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT * FROM utilisateur WHERE email = ?"
            );
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                nom = rs.getString("nom") != null ? rs.getString("nom") : "";
                prenom = rs.getString("prenom") != null ? rs.getString("prenom") : "";
                role = rs.getString("role") != null ? rs.getString("role") : "";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    
    <div class="sidebar">
        <h2>MENU PRINCIPAL</h2>
        <a href="dashboard.jsp">Tableau de bord</a>
        <a href="demande.jsp">Demandes</a>
        <a href="profile.jsp">Profil</a>
        <div class="user-info">
            <p><%= session.getAttribute("user") %></p>
            <p class="role"><%= session.getAttribute("role") %></p>
            <a href="login.jsp" class="logout">Déconnexion</a>
        </div>
    </div>

    <div class="content">
        <h1>Modifier mon profil</h1>
        
        <% if (success != null && success.equals("1")) { %>
            <div class="success-message">✅ Profil mis à jour avec succès !</div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="error-message">❌ Erreur lors de la mise à jour du profil.</div>
        <% } %>
        
        <div class="form-card">
            <form action="EditProfileServlet" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label for="nom">Nom </label>
                        <input type="text" id="nom" name="nom" value="<%= nom %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="prenom">Prénom </label>
                        <input type="text" id="prenom" name="prenom" value="<%= prenom %>" >
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email </label>
                        <input type="email" id="email" name="email" value="<%= email %>" >
                    </div>
                    
                    <div class="form-group">
                        <label for="role">Rôle </label>
                        <select id="role" name="role" >
                            <option value="admin" <%= role.equals("admin") ? "selected" : "" %>>Administrateur</option>
                            <option value="etudiant" <%= role.equals("etudiant") ? "selected" : "" %>>Étudiant</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Nouveau mot de passe</label>
                    <input type="password" id="password" name="password" placeholder="Laisser vide pour ne pas modifier">
                </div>
                
                <div class="form-group">
                    <label for="confirm_password">Confirmer le mot de passe</label>
                    <input type="password" id="confirm_password" name="confirm_password" placeholder="Laisser vide pour ne pas modifier">
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn-submit">💾 Enregistrer les modifications</button>
                    <a href="profile.jsp" class="btn-cancel">Annuler</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>