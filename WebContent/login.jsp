<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" %>

<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Scolarité - Connexion</title>
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="login-body">
 <!-- Colonne droite : illustration -->
    <div class="login-illustration">
        <img src="images/login.jpeg" alt="Illustration connexion">
        <p>Gérez vos demandes d’attestations simplement.</p>
    </div>
<div class="login-card">
    <h1>Scolarité</h1>
    <p>Plateforme de gestion des attestations</p>

    <% if(request.getParameter("error") != null) { %>
        <div class="error">Identifiants incorrects. Veuillez réessayer.</div>
    <% } %>

   <form action="LoginServlet" method=post>

        <div class="input-group">
            <label>Adresse Email</label>
            <input type="email" name="email" placeholder="admin@ucd.ma" >
        </div>
        <div class="input-group">
            <label>Mot de passe</label>
            <input type="password" name="password" placeholder="password" >
        </div>
        <button type="submit">Se connecter</button>
           <a href="signup.jsp">vous avez pas de compte ? créer </a>
    </form>

   
</div>
</body>
</html>