<%@ page import="java.util.List, model.Etudiant" %>
<%
    List<Etudiant> etudiants = (List<Etudiant>) request.getAttribute("etudiants");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Annuaire étudiants</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="sideBar.jsp" />
    <main class="main-content">
        <h1>Étudiants</h1>
        <p>Annuaire des étudiants inscrits.</p>
        <div class="cards-container">
            <% for(Etudiant e : etudiants) { %>
            <div class="student-card">
                <div class="avatar"><%= e.getInitiales() %></div>
                <h4><%= e.getNom() %> <%= e.getPrenom() %></h4>
                <p><%= e.getEmail() %></p>
                <p><%= e.getFiliere().getNom() %> (<%= e.getFiliere().getNiveau() %>)</p>
                <p>Inscription <%= e.getAnneeInscription() %></p>
            </div>
            <% } %>
        </div>
    </main>
</div>
</body>
</html>