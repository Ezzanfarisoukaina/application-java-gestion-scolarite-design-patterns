<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Scolarité - Inscription</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="login-body">
<div class="login-card">
    <h1>Scolarité</h1>
    <p>Créer un compte étudiant</p>

    <% if(request.getParameter("error") != null) { %>
        <div class="error">Cet email existe déjà. Veuillez en choisir un autre.</div>
    <% } %>

    <form action="SignupServlet" method="post">
        <div class="input-group">
            <label>Nom</label>
            <input type="text" name="nom" required>
        </div>
        <div class="input-group">
            <label>Prénom</label>
            <input type="text" name="prenom" required>
        </div>
        <div class="input-group">
            <label>Adresse Email</label>
            <input type="email" name="email" required>
        </div>
        <div class="input-group">
            <label>Mot de passe</label>
            <input type="password" name="password" required>
        </div>
        <button type="submit">S'inscrire</button>
        <a href="login.jsp">Déjà inscrit ? Connexion</a>
    </form>
</div>
 <!-- Colonne droite : illustration -->
    <div class="login-illustration">
        <img src="images/login.jpeg" alt="Illustration connexion">
        <p>Gérez vos demandes d’attestations simplement.</p>
    </div>
</body>
</html>
