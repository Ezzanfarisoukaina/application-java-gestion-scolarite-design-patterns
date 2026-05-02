package dao.Imp;



import dao.demandeDAo;
import model.*;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class demandeDAOImp implements demandeDAo {

    private Etudiant extractEtudiant(ResultSet rs) throws SQLException {
        Etudiant e = new Etudiant();
        e.setId(rs.getInt("etudiant_id"));
        e.setNom(rs.getString("enom"));
        e.setPrenom(rs.getString("eprenom"));
        e.setCne(rs.getString("cne"));
        e.setEmail(rs.getString("eemail"));
        e.setAnneeInscription(rs.getString("annee_inscription"));
        Filiere f = new Filiere();
        f.setId(rs.getInt("filiere_id"));
        f.setNom(rs.getString("filiere_nom"));
        f.setNiveau(rs.getString("niveau"));
        e.setFiliere(f);
        return e;
    }

    @Override
    public List<Demande> findAll() {
        List<Demande> list = new ArrayList<>();
        String sql = "SELECT d.*, e.nom as enom, e.prenom as eprenom, e.cne, e.email as eemail, e.annee_inscription, " +
                     "f.id as filiere_id, f.nom as filiere_nom, f.niveau " +
                     "FROM demande d JOIN etudiant e ON d.etudiant_id=e.id " +
                     "JOIN filiere f ON e.filiere_id=f.id ORDER BY d.date_demande DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Demande d = new Demande();
                d.setId(rs.getInt("id"));
                d.setMotif(rs.getString("motif"));
                d.setStatut(rs.getString("statut"));
                d.setDateDemande(rs.getTimestamp("date_demande"));
                d.setEtudiant(extractEtudiant(rs));
                list.add(d);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Demande> findRecentes(int limit) {
        List<Demande> list = new ArrayList<>();
        String sql = "SELECT d.*, e.nom as enom, e.prenom as eprenom, e.cne, e.email as eemail, e.annee_inscription, " +
                     "f.id as filiere_id, f.nom as filiere_nom, f.niveau " +
                     "FROM demande d JOIN etudiant e ON d.etudiant_id=e.id " +
                     "JOIN filiere f ON e.filiere_id=f.id ORDER BY d.date_demande DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Demande d = new Demande();
                d.setId(rs.getInt("id"));
                d.setMotif(rs.getString("motif"));
                d.setStatut(rs.getString("statut"));
                d.setDateDemande(rs.getTimestamp("date_demande"));
                d.setEtudiant(extractEtudiant(rs));
                list.add(d);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public Demande findById(int id) {
        String sql = "SELECT d.*, e.nom as enom, e.prenom as eprenom, e.cne, e.email as eemail, e.annee_inscription, " +
                     "f.id as filiere_id, f.nom as filiere_nom, f.niveau " +
                     "FROM demande d JOIN etudiant e ON d.etudiant_id=e.id " +
                     "JOIN filiere f ON e.filiere_id=f.id WHERE d.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Demande d = new Demande();
                d.setId(rs.getInt("id"));
                d.setMotif(rs.getString("motif"));
                d.setStatut(rs.getString("statut"));
                d.setDateDemande(rs.getTimestamp("date_demande"));
                d.setEtudiant(extractEtudiant(rs));
                return d;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public void save(Demande demande) {
        String sql = "INSERT INTO demande (etudiant_id, motif, statut, date_demande) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, demande.getEtudiant().getId());
            ps.setString(2, demande.getMotif());
            ps.setString(3, demande.getStatut());
            ps.setTimestamp(4, new Timestamp(demande.getDateDemande().getTime()));
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public void updateStatut(int id, String statut) {
        String sql = "UPDATE demande SET statut=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statut);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public void delete(int id) {
        String sql = "DELETE FROM demande WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public int countByStatut(String statut) {
        String sql = "SELECT COUNT(*) FROM demande WHERE statut=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statut);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM demande";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public List<Demande> filtrer(String nomEtudiant, String statut) {
        List<Demande> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT d.*, e.nom as enom, e.prenom as eprenom, e.cne, e.email as eemail, e.annee_inscription, " +
            "f.id as filiere_id, f.nom as filiere_nom, f.niveau " +
            "FROM demande d JOIN etudiant e ON d.etudiant_id=e.id " +
            "JOIN filiere f ON e.filiere_id=f.id WHERE 1=1"
        );
        if (nomEtudiant != null && !nomEtudiant.isEmpty()) {
            sql.append(" AND (e.nom LIKE ? OR e.prenom LIKE ?)");
        }
        if (statut != null && !statut.isEmpty() && !"tous".equals(statut)) {
            sql.append(" AND d.statut = ?");
        }
        sql.append(" ORDER BY d.date_demande DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (nomEtudiant != null && !nomEtudiant.isEmpty()) {
                String like = "%" + nomEtudiant + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (statut != null && !statut.isEmpty() && !"tous".equals(statut)) {
                ps.setString(idx++, statut);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Demande d = new Demande();
                d.setId(rs.getInt("id"));
                d.setMotif(rs.getString("motif"));
                d.setStatut(rs.getString("statut"));
                d.setDateDemande(rs.getTimestamp("date_demande"));
                d.setEtudiant(extractEtudiant(rs));
                list.add(d);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}