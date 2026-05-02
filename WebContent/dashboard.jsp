<%@ page import="java.sql.*, util.DBConnection, java.text.SimpleDateFormat, java.util.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Aperçu Général - Tableau de Bord</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        /* Styles académiques - Bleu et Blanc - Dashboard avec Graphiques */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', 'Roboto', 'Arial', sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 0;
            display: flex;
            color: #2c3e50;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background: linear-gradient(135deg, #003366 0%, #001f3f 100%);
            color: white;
            padding: 30px 20px;
            position: fixed;
            height: 100vh;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            z-index: 100;
            overflow-y: auto;
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 35px;
            font-size: 1.4rem;
            font-weight: 600;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(255,255,255,0.2);
        }

        .sidebar a {
            display: block;
            color: rgba(255,255,255,0.85);
            text-decoration: none;
            padding: 12px 20px;
            margin: 5px 0;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-size: 0.95rem;
            font-weight: 500;
        }

        .sidebar a:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            padding-left: 25px;
        }

        .sidebar a.active {
            background: #ffffff;
            color: #003366;
            font-weight: 600;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .user-info {
            position: absolute;
            bottom: 30px;
            left: 20px;
            right: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.2);
        }

        .user-info p {
            margin: 8px 0;
            font-size: 0.9rem;
        }

        .user-info .role {
            color: #ffd966;
            font-size: 0.85rem;
            font-weight: 500;
            font-style: italic;
        }

        .logout {
            background: rgba(220, 53, 69, 0.8);
            text-align: center;
            margin-top: 15px;
            padding: 10px;
            border-radius: 6px;
            font-weight: 500;
        }

        .logout:hover {
            background: #dc3545;
        }

        /* Conteneur principal */
        .main-container {
            margin-left: 280px;
            flex: 1;
            padding: 30px 40px;
            min-height: 100vh;
        }

        /* Stats principales */
        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid #e0e7ff;
            position: relative;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #003366, #0066cc);
        }

        .card h3 {
            color: #003366;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 12px;
        }

        .card p {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
        }

        .card-footer {
            margin-top: 8px;
            font-size: 0.7rem;
            color: #6c757d;
        }

        /* Section graphiques */
        .charts-section {
            margin-bottom: 30px;
        }

        .charts-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin-bottom: 25px;
        }

        .chart-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            border: 1px solid #e0e7ff;
            padding: 20px;
            transition: all 0.3s ease;
        }

        .chart-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        .chart-title {
            font-size: 1rem;
            font-weight: 600;
            color: #003366;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e7ff;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .chart-container {
            position: relative;
            height: 300px;
        }

        canvas {
            max-height: 300px;
            width: 100%;
        }

        /* Statistiques avancées */
        .advanced-stats {
            margin-bottom: 30px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            border: 1px solid #e0e7ff;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        .stat-icon {
            font-size: 2rem;
            background: linear-gradient(135deg, #003366 0%, #0066cc 100%);
            width: 55px;
            height: 55px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            flex-shrink: 0;
        }

        .stat-info {
            flex: 1;
        }

        .stat-info h4 {
            color: #003366;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 3px;
        }

        .stat-sub {
            font-size: 0.7rem;
            color: #6c757d;
        }

        .progress-bar {
            width: 100%;
            height: 6px;
            background-color: #e9ecef;
            border-radius: 3px;
            overflow: hidden;
            margin-top: 8px;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #28a745, #20c997);
            border-radius: 3px;
            transition: width 0.5s ease;
        }

        /* Demandes récentes */
        .recent-requests {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            border: 1px solid #e0e7ff;
            overflow: hidden;
        }

        .section-header {
            padding: 20px 25px;
            background: #f8f9fa;
            border-bottom: 1px solid #e0e7ff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #003366;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-actions select {
            padding: 6px 12px;
            border: 1px solid #cbd5e0;
            border-radius: 6px;
            font-size: 0.85rem;
            background: white;
            cursor: pointer;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            background: white;
            border-collapse: collapse;
        }

        thead {
            background-color: #003366;
            color: white;
        }

        th {
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
        }

        td {
            padding: 12px 15px;
            border-bottom: 1px solid #e9ecef;
            color: #2c3e50;
            font-size: 0.85rem;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }

        .view-all {
            padding: 15px 25px;
            text-align: center;
            background: #f8f9fa;
            border-top: 1px solid #e0e7ff;
        }

        .view-all-btn {
            display: inline-block;
            background-color: #003366;
            color: white;
            text-decoration: none;
            padding: 8px 20px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .view-all-btn:hover {
            background-color: #001f3f;
            transform: translateY(-2px);
        }

        .no-data, .error-message {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }

        .error-message {
            color: #dc3545;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .stats { grid-template-columns: repeat(2, 1fr); }
            .charts-grid { grid-template-columns: 1fr; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 1024px) {
            .sidebar { width: 250px; }
            .main-container { margin-left: 250px; padding: 25px 30px; }
        }

        @media (max-width: 768px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; position: relative; }
            .user-info { position: relative; bottom: auto; margin-top: 20px; }
            .main-container { margin-left: 0; padding: 20px; }
            .stats, .stats-grid { grid-template-columns: 1fr; }
            .chart-container { height: 250px; }
        }

        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        ::-webkit-scrollbar-track { background: #f1f1f1; border-radius: 4px; }
        ::-webkit-scrollbar-thumb { background: #003366; border-radius: 4px; }
    </style>
</head>
<body>
    <%
        // Récupération des données pour les graphiques
        java.util.List<String> moisLabels = new java.util.ArrayList<>();
        java.util.List<Integer> demandesParMois = new java.util.ArrayList<>();
        java.util.List<String> filiereNames = new java.util.ArrayList<>();
        java.util.List<Integer> demandesParFiliere = new java.util.ArrayList<>();
        
        int totalDemandes = 0, enAttente = 0, approuvees = 0, rejetees = 0;
        
        try (Connection conn = DBConnection.getConnection()) {
            // Données pour les cartes stats
            PreparedStatement stmtStats = conn.prepareStatement(
                "SELECT " +
                "COUNT(*) as total, " +
                "SUM(CASE WHEN statut='En attente' THEN 1 ELSE 0 END) as attente, " +
                "SUM(CASE WHEN statut='Approuvée' THEN 1 ELSE 0 END) as approuvees, " +
                "SUM(CASE WHEN statut='Rejetée' THEN 1 ELSE 0 END) as rejetees " +
                "FROM demande"
            );
            ResultSet rsStats = stmtStats.executeQuery();
            if (rsStats.next()) {
                totalDemandes = rsStats.getInt("total");
                enAttente = rsStats.getInt("attente");
                approuvees = rsStats.getInt("approuvees");
                rejetees = rsStats.getInt("rejetees");
            }
            
            // Données pour le graphique mensuel (12 derniers mois)
            PreparedStatement stmtMois = conn.prepareStatement(
                "SELECT DATE_FORMAT(date_demande, '%b %Y') as mois, COUNT(*) as total " +
                "FROM demande " +
                "WHERE date_demande >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) " +
                "GROUP BY YEAR(date_demande), MONTH(date_demande) " +
                "ORDER BY YEAR(date_demande), MONTH(date_demande) LIMIT 12"
            );
            ResultSet rsMois = stmtMois.executeQuery();
            while (rsMois.next()) {
                moisLabels.add(rsMois.getString("mois"));
                demandesParMois.add(rsMois.getInt("total"));
            }
            
            // Données pour le graphique par filière
            PreparedStatement stmtFiliere = conn.prepareStatement(
                "SELECT f.nom, COUNT(d.id) as total " +
                "FROM filiere f " +
                "LEFT JOIN etudiant e ON f.id = e.filiere_id " +
                "LEFT JOIN demande d ON e.id = d.etudiant_id " +
                "GROUP BY f.id, f.nom ORDER BY total DESC LIMIT 6"
            );
            ResultSet rsFiliere = stmtFiliere.executeQuery();
            while (rsFiliere.next()) {
                filiereNames.add(rsFiliere.getString("nom"));
                demandesParFiliere.add(rsFiliere.getInt("total"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        double tauxApprobation = totalDemandes > 0 ? (approuvees * 100.0 / totalDemandes) : 0;
    %>

    <!-- Sidebar -->
    <div class="sidebar">
        <h2>MENU PRINCIPAL</h2>
        <a href="dashboard.jsp" class="active">Tableau de bord</a>
        <a href="demande.jsp">Demandes</a>
        <a href="profile.jsp">Profil</a>
        <div class="user-info">
            <p><%= session.getAttribute("user") %></p>
            <p class="role"><%= session.getAttribute("role") %></p>
            <a href="login.jsp" class="logout">Déconnexion</a>
        </div>
    </div>

    <!-- Conteneur principal -->
    <div class="main-container">
        <!-- Header stats -->
        <div class="stats">
            <div class="card">
                <h3>Total Demandes</h3>
                <p><%= totalDemandes %></p>
                <div class="card-footer">Toutes les demandes</div>
            </div>
            <div class="card">
                <h3>En Attente</h3>
                <p><%= enAttente %></p>
                <div class="card-footer">À traiter</div>
            </div>
            <div class="card">
                <h3>Approuvées</h3>
                <p><%= approuvees %></p>
                <div class="card-footer">Validées</div>
            </div>
            <div class="card">
                <h3>Rejetées</h3>
                <p><%= rejetees %></p>
                <div class="card-footer">Non validées</div>
            </div>
        </div>

        <!-- Section Graphiques -->
        <div class="charts-section">
            <div class="charts-grid">
                <!-- Graphique Linéaire - Évolution mensuelle -->
                <div class="chart-card">
                    <div class="chart-title">
                        <span>📈</span> Évolution des demandes (12 mois)
                    </div>
                    <div class="chart-container">
                        <canvas id="monthlyChart"></canvas>
                    </div>
                </div>
                
                <!-- Graphique Camembert - Répartition par statut -->
                <div class="chart-card">
                    <div class="chart-title">
                        <span>🥧</span> Répartition par statut
                    </div>
                    <div class="chart-container">
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="charts-grid">
                <!-- Graphique Barres - Demandes par filière -->
                <div class="chart-card">
                    <div class="chart-title">
                        <span>📊</span> Demandes par filière
                    </div>
                    <div class="chart-container">
                        <canvas id="filiereChart"></canvas>
                    </div>
                </div>
                
                <!-- Graphique Jauge - Taux d'approbation -->
                <div class="chart-card">
                    <div class="chart-title">
                        <span>🎯</span> Taux d'approbation
                    </div>
                    <div class="chart-container">
                        <canvas id="gaugeChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistiques avancées -->
        <div class="advanced-stats">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-info">
                        <h4>Étudiants actifs</h4>
                        <div class="stat-value">
                            <%
                                int etudiantsActifs = 0;
                                try (Connection conn = DBConnection.getConnection()) {
                                    PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(DISTINCT etudiant_id) AS total FROM demande");
                                    ResultSet rs = stmt.executeQuery();
                                    if (rs.next()) etudiantsActifs = rs.getInt("total");
                                } catch (Exception e) { }
                                out.print(etudiantsActifs);
                            %>
                        </div>
                        <div class="stat-sub">ont fait une demande</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">📅</div>
                    <div class="stat-info">
                        <h4>Demandes ce mois</h4>
                        <div class="stat-value">
                            <%
                                int demandesMois = 0;
                                try (Connection conn = DBConnection.getConnection()) {
                                    PreparedStatement stmt = conn.prepareStatement(
                                        "SELECT COUNT(*) AS total FROM demande WHERE MONTH(date_demande) = MONTH(CURDATE()) AND YEAR(date_demande) = YEAR(CURDATE())"
                                    );
                                    ResultSet rs = stmt.executeQuery();
                                    if (rs.next()) demandesMois = rs.getInt("total");
                                } catch (Exception e) { }
                                out.print(demandesMois);
                            %>
                        </div>
                        <div class="stat-sub">ce mois-ci</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">⏱️</div>
                    <div class="stat-info">
                        <h4>Temps moyen traitement</h4>
                        <div class="stat-value">
                            <%
                                double tempsMoyen = 0;
                                try (Connection conn = DBConnection.getConnection()) {
                                    PreparedStatement stmt = conn.prepareStatement(
                                        "SELECT AVG(DATEDIFF(date_traitement, date_demande)) AS avg_days FROM demande WHERE statut IN ('Approuvée', 'Rejetée') AND date_traitement IS NOT NULL"
                                    );
                                    ResultSet rs = stmt.executeQuery();
                                    if (rs.next() && rs.getObject("avg_days") != null) tempsMoyen = rs.getDouble("avg_days");
                                } catch (Exception e) { }
                                out.print(String.format("%.1f", tempsMoyen) + " j");
                            %>
                        </div>
                        <div class="stat-sub">jours en moyenne</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Demandes récentes -->
        <div class="recent-requests">
            <div class="section-header">
                <div class="section-title">
                    <span>📋</span> Demandes Récentes
                </div>
                <div class="filter-actions">
                    <select id="statusFilter" onchange="filterRequests()">
                        <option value="">Tous les statuts</option>
                        <option value="En attente">En attente</option>
                        <option value="Approuvée">Approuvée</option>
                        <option value="Rejetée">Rejetée</option>
                    </select>
                </div>
            </div>
            
            <div class="table-container">
                <table id="requestsTable">
                    <thead>
                        <tr><th>Étudiant</th><th>CNE</th><th>Motif</th><th>Statut</th><th>Date</th></tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection conn = DBConnection.getConnection()) {
                                PreparedStatement stmt = conn.prepareStatement(
                                    "SELECT e.nom, e.prenom, e.cne, d.motif, d.statut, d.date_demande FROM demande d JOIN etudiant e ON d.etudiant_id = e.id ORDER BY d.date_demande DESC LIMIT 5"
                                );
                                ResultSet rs = stmt.executeQuery();
                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                boolean hasData = false;
                                while (rs.next()) {
                                    hasData = true;
                                    String statut = rs.getString("statut");
                                    String statusClass = "";
                                    if ("En attente".equals(statut)) statusClass = "status-pending";
                                    else if ("Approuvée".equals(statut)) statusClass = "status-approved";
                                    else if ("Rejetée".equals(statut)) statusClass = "status-rejected";
                        %>
                                    <tr data-status="<%= statut %>">
                                        <td><%= rs.getString("nom") %> <%= rs.getString("prenom") %></td>
                                        <td><%= rs.getString("cne") %></td>
                                        <td><%= rs.getString("motif") %></td>
                                        <td><span class="status-badge <%= statusClass %>"><%= statut %></span></td>
                                        <td><%= sdf.format(rs.getTimestamp("date_demande")) %></td>
                                    </tr>
                        <%
                                }
                                if (!hasData) out.print("<tr><td colspan='5' class='no-data'>Aucune demande trouvée</td></tr>");
                            } catch (Exception e) {
                                out.print("<tr><td colspan='5' class='error-message'>Erreur : " + e.getMessage() + "</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <div class="view-all">
                <a href="demande.jsp" class="view-all-btn">Voir toutes les demandes →</a>
            </div>
        </div>
    </div>

    <script>
        // Récupération des données JSP en JavaScript
        const moisLabels = <%= new com.google.gson.Gson().toJson(moisLabels) %>;
        const demandesParMois = <%= new com.google.gson.Gson().toJson(demandesParMois) %>;
        const filiereNames = <%= new com.google.gson.Gson().toJson(filiereNames) %>;
        const demandesParFiliere = <%= new com.google.gson.Gson().toJson(demandesParFiliere) %>;
        const enAttente = <%= enAttente %>;
        const approuvees = <%= approuvees %>;
        const rejetees = <%= rejetees %>;
        const tauxApprobation = <%= tauxApprobation %>;

        // Graphique d'évolution mensuelle
        new Chart(document.getElementById('monthlyChart'), {
            type: 'line',
            data: {
                labels: moisLabels,
                datasets: [{
                    label: 'Nombre de demandes',
                    data: demandesParMois,
                    borderColor: '#003366',
                    backgroundColor: 'rgba(0, 51, 102, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#0066cc',
                    pointRadius: 5
                }]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });

        // Graphique camembert des statuts
        new Chart(document.getElementById('statusChart'), {
            type: 'doughnut',
            data: {
                labels: ['En attente', 'Approuvées', 'Rejetées'],
                datasets: [{
                    data: [enAttente, approuvees, rejetees],
                    backgroundColor: ['#ffc107', '#28a745', '#dc3545'],
                    borderWidth: 0
                }]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });

        // Graphique barres des filières
        new Chart(document.getElementById('filiereChart'), {
            type: 'bar',
            data: {
                labels: filiereNames,
                datasets: [{
                    label: 'Nombre de demandes',
                    data: demandesParFiliere,
                    backgroundColor: 'rgba(0, 51, 102, 0.7)',
                    borderColor: '#003366',
                    borderWidth: 1
                }]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });

        // Graphique jauge
        new Chart(document.getElementById('gaugeChart'), {
            type: 'doughnut',
            data: {
                labels: ['Approuvées', 'Restantes'],
                datasets: [{
                    data: [tauxApprobation, 100 - tauxApprobation],
                    backgroundColor: ['#28a745', '#e9ecef'],
                    borderWidth: 0,
                    circumference: 180,
                    rotation: -90,
                    cutout: '70%'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { tooltip: { enabled: false }, legend: { display: false } }
            },
            plugins: [{
                afterDraw: function(chart) {
                    const ctx = chart.ctx;
                    const centerX = chart.width / 2;
                    const centerY = chart.height / 2 + 20;
                    ctx.save();
                    ctx.font = 'bold 24px "Segoe UI"';
                    ctx.fillStyle = '#003366';
                    ctx.textAlign = 'center';
                    ctx.fillText(tauxApprobation.toFixed(1) + '%', centerX, centerY);
                    ctx.font = '12px "Segoe UI"';
                    ctx.fillStyle = '#6c757d';
                    ctx.fillText("Taux d'approbation", centerX, centerY + 30);
                    ctx.restore();
                }
            }]
        });

        function filterRequests() {
            var filter = document.getElementById('statusFilter').value;
            var rows = document.querySelectorAll('#requestsTable tbody tr');
            rows.forEach(function(row) {
                if (row.cells.length > 1) {
                    var status = row.getAttribute('data-status');
                    row.style.display = (filter === "" || status === filter) ? "" : "none";
                }
            });
        }
    </script>
</body>
</html>