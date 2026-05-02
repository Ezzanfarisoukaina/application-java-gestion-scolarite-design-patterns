package dao.Imp;



import dao.etudiantDAO;
import model.Etudiant;
import model.Filiere;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class etudiantDAOImp implements etudiantDAO {

    @Override
    public List<Etudiant> findAllWithFiliere() {
        List<Etudiant> list = new ArrayList<>();
        String sql = "SELECT e.*, f.id as fid, f.nom as fnom, f.niveau FROM etudiant e " +
                     "JOIN filiere f ON e.filiere_id = f.id ORDER BY e.nom";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Etudiant e = new Etudiant();
                e.setId(rs.getInt("id"));
                e.setNom(rs.getString("nom"));
                e.setPrenom(rs.getString("prenom"));
                e.setCne(rs.getString("cne"));
                e.setEmail(rs.getString("email"));
                e.setAnneeInscription(rs.getString("annee_inscription"));
                Filiere f = new Filiere();
                f.setId(rs.getInt("fid"));
                f.setNom(rs.getString("fnom"));
                f.setNiveau(rs.getString("niveau"));
                e.setFiliere(f);
                list.add(e);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Etudiant> findAll() {
        return findAllWithFiliere(); // même chose
    }

    @Override
    public Etudiant findById(int id) {
        String sql = "SELECT e.*, f.id as fid, f.nom as fnom, f.niveau FROM etudiant e " +
                     "JOIN filiere f ON e.filiere_id = f.id WHERE e.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Etudiant e = new Etudiant();
                e.setId(rs.getInt("id"));
                e.setNom(rs.getString("nom"));
                e.setPrenom(rs.getString("prenom"));
                e.setCne(rs.getString("cne"));
                e.setEmail(rs.getString("email"));
                e.setAnneeInscription(rs.getString("annee_inscription"));
                Filiere f = new Filiere();
                f.setId(rs.getInt("fid"));
                f.setNom(rs.getString("fnom"));
                f.setNiveau(rs.getString("niveau"));
                e.setFiliere(f);
                return e;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }
}