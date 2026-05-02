<%@ page session="true" %>
<%@ page import="java.sql.*, util.DBConnection, java.util.Date, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier la demande</title>
    <link rel="stylesheet" href="modifierDemande.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/fr.js"></script>
    <style>
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        .info-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            border: 1px solid #e0e7ff;
        }
        .info-section h3 {
            color: #003366;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e7ff;
            font-size: 1.1rem;
        }
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }
        .form-group {
            flex: 1;
            min-width: 200px;
        }
        .form-group label {
            display: block;
            color: #003366;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #cbd5e0;
            border-radius: 6px;
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #003366;
            box-shadow: 0 0 0 3px rgba(0, 51, 102, 0.1);
        }
        .date-group {
            margin-top: 15px;
        }
        .date-input-wrapper {
            position: relative;
        }
        .calendar-icon {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 1.1rem;
        }
        .form-buttons {
            margin-top: 25px;
            display: flex;
            gap: 15px;
        }
        .btn-submit {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 6px;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-submit:hover {
            background-color: #218838;
            transform: translateY(-2px);
        }
        .btn-cancel {
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            display: inline-block;
            padding: 10px 25px;
            border-radius: 6px;
            font-size: 0.95rem;
            font-weight: 500;
            transition: all 0.2s ease;
            text-align: center;
        }
        .btn-cancel:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
        }
        .sidebar {
            width: 280px;
            background: linear-gradient(135deg, #003366 0%, #001f3f 100%);
            color: white;
            padding: 30px 20px;
            position: fixed;
            height: 100vh;
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 35px;
            font-size: 1.4rem;
        }
        .sidebar a {
            display: block;
            color: rgba(255,255,255,0.85);
            text-decoration: none;
            padding: 12px 20px;
            margin: 5px 0;
            border-radius: 8px;
        }
        .sidebar a.active {
            background: #ffffff;
            color: #003366;
        }
        .user-info {
            position: absolute;
            bottom: 30px;
            left: 20px;
            right: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.2);
        }
        .logout {
            background: rgba(220, 53, 69, 0.8);
            text-align: center;
            margin-top: 15px;
            padding: 10px;
            border-radius: 6px;
        }
        .content {
            margin-left: 280px;
            padding: 35px 40px;
            flex: 1;
        }
        @media (max-width: 768px) {
            .sidebar { width: 100%; height: auto; position: relative; }
            .content { margin-left: 0; padding: 20px; }
            .form-row { flex-direction: column; gap: 10px; }
            .form-buttons { flex-direction: column; }
        }
    </style>
</head>
<body>
    <%
        // Récupérer les attributs de la servlet
        Integer demandeId = (Integer) request.getAttribute("demandeId");
        Integer etudiantId = (Integer) request.getAttribute("etudiantId");
        String etudiantNom = (String) request.getAttribute("nom");
        String etudiantPrenom = (String) request.getAttribute("prenom");
        String etudiantCne = (String) request.getAttribute("cne");
        String etudiantEmail = (String) request.getAttribute("email");
        Integer filiereId = (Integer) request.getAttribute("filiereId");
        String anneeInscription = (String) request.getAttribute("anneeInscription");
        String motif = (String) request.getAttribute("motif");
        String statut = (String) request.getAttribute("statut");
        java.sql.Date dateDemande = (java.sql.Date) request.getAttribute("dateDemande");
        
        String dateFormatee = "";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        if (dateDemande != null) {
            dateFormatee = sdf.format(dateDemande);
        }
        
        // IMPORTANT: Si les attributs sont null, rediriger vers la servlet au lieu de fallback
        if (demandeId == null) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                // Rediriger vers la servlet pour éviter la duplication de code
                response.sendRedirect("ModifierServlet?id=" + idParam);
                return;
            } else {
                response.sendRedirect("demande.jsp?error=not_found");
                return;
            }
        }
        
        String error = request.getParameter("error");
        if ("update_failed".equals(error)) {
    %>
        <div class="error-message">✗ Erreur lors de la modification. Veuillez réessayer.</div>
    <%
        }
    %>
    
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>MENU PRINCIPAL</h2>
        <a href="dashboard.jsp">Tableau de bord</a>
        <a href="demande.jsp" class="active">Demandes</a>
        <a href="profile.jsp">Profil</a>
        <div class="user-info">
            <p><%= session.getAttribute("user") != null ? session.getAttribute("user") : "Utilisateur" %></p>
            <p class="role"><%= session.getAttribute("role") != null ? session.getAttribute("role") : "Rôle" %></p>
            <a href="login.jsp" class="logout">Déconnexion</a>
        </div>
    </div>

    <!-- Formulaire de modification -->
    <div class="content">
        <h1>Modifier la Demande</h1>
        <p>Modifiez les informations de la demande ci-dessous.</p>
        
        <form method="post" action="ModifierServlet" class="form-request">
            <input type="hidden" name="id" value="<%= demandeId %>">
            <input type="hidden" name="etudiant_id" value="<%= etudiantId %>">
            
            <div class="info-section">
                <h3>Informations de l'étudiant</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="nom">Nom *</label>
                        <input type="text" id="nom" name="nom" value="<%= etudiantNom != null ? etudiantNom : "" %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="prenom">Prénom *</label>
                        <input type="text" id="prenom" name="prenom" value="<%= etudiantPrenom != null ? etudiantPrenom : "" %>" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="cne">CNE *</label>
                        <input type="text" id="cne" name="cne" value="<%= etudiantCne != null ? etudiantCne : "" %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" value="<%= etudiantEmail != null ? etudiantEmail : "" %>" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="filiere">Filière *</label>
                        <select id="filiere" name="filiereId" required>
                            <option value="">-- Sélectionnez une filière --</option>
                            <%
                                try (Connection conn2 = DBConnection.getConnection()) {
                                    PreparedStatement stmt2 = conn2.prepareStatement("SELECT id, nom, niveau FROM filiere");
                                    ResultSet rs2 = stmt2.executeQuery();
                                    while (rs2.next()) {
                                        int idFiliere = rs2.getInt("id");
                                        String nomFiliere = rs2.getString("nom");
                                        String niveau = rs2.getString("niveau");
                                        String selected = (filiereId != null && filiereId == idFiliere) ? "selected" : "";
                            %>
                                        <option value="<%= idFiliere %>" <%= selected %>>
                                            <%= nomFiliere %> - <%= niveau %>
                                        </option>
                            <%
                                    }
                                    rs2.close();
                                    stmt2.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="annee">Année universitaire *</label>
                        <input type="text" id="annee" name="annee" value="<%= anneeInscription != null ? anneeInscription : "2025/2026" %>" required>
                    </div>
                </div>
            </div>
            
            <div class="info-section">
                <h3>Informations de la demande</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="motif">Motif de la demande *</label>
                        <select id="motif" name="motif" required>
                            <option value="">-- Sélectionnez un motif --</option>
                            <option value="Attestation de scolarité" <%= "Attestation de scolarité".equals(motif) ? "selected" : "" %>>Attestation de scolarité</option>
                            <option value="Attestation de réussite" <%= "Attestation de réussite".equals(motif) ? "selected" : "" %>>Attestation de réussite</option>
                            <option value="Relevé de notes" <%= "Relevé de notes".equals(motif) ? "selected" : "" %>>Relevé de notes</option>
                            <option value="Certificat de scolarité" <%= "Certificat de scolarité".equals(motif) ? "selected" : "" %>>Certificat de scolarité</option>
                            <option value="Demande de stage" <%= "Demande de stage".equals(motif) ? "selected" : "" %>>Demande de stage</option>
                            <option value="Autre" <%= "Autre".equals(motif) ? "selected" : "" %>>Autre</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="statut">Statut</label>
                        <select id="statut" name="statut">
                            <option value="En attente" <%= "En attente".equals(statut) ? "selected" : "" %>>En attente</option>
                            <option value="Approuvée" <%= "Approuvée".equals(statut) ? "selected" : "" %>>Approuvée</option>
                            <option value="Rejetée" <%= "Rejetée".equals(statut) ? "selected" : "" %>>Rejetée</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-group date-group">
                    <label for="date">Date de la demande</label>
                    <div class="date-input-wrapper">
                        <input type="text" id="date" name="date" value="<%= dateFormatee %>" class="datepicker-input" placeholder="Sélectionnez une date">
                        <span class="calendar-icon">📅</span>
                    </div>
                </div>
            </div>
            
            <div class="form-buttons">
                <button type="submit" class="btn-submit">💾 Enregistrer les modifications</button>
                <a href="demande.jsp" class="btn-cancel">Annuler</a>
            </div>
        </form>
    </div>
    
    <script>
        flatpickr(".datepicker-input", {
            locale: "fr",
            dateFormat: "Y-m-d",
            altInput: true,
            altFormat: "d F Y",
            allowInput: true
        });
    </script>
</body>
</html>