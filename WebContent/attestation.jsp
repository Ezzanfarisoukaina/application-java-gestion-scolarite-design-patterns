<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Attestation de Scolarité</title>
    <link rel="stylesheet" href="attestation.css">
</head>
<body>
    <div class="attestation">
        <h1>Université Chouaib Doukkali</h1>
        <h2>Attestation de Scolarité</h2>
        <p>Nous soussignés, certifions que :</p>
        <p><strong><%= request.getAttribute("nom") %> <%= request.getAttribute("prenom") %></strong></p>
        <p>est régulièrement inscrit en <strong><%= request.getAttribute("filiere") %></strong></p>
        <p>pour l’année universitaire <strong><%= request.getAttribute("annee") %></strong>.</p>
        <br>
        <p>Fait à El Jadida, le <%= new java.util.Date() %></p>
        <p><em>Le doyen de la faculté des sciences</em></p>
    </div>
</body>
</html>
