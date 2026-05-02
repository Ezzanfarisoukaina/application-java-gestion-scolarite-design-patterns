-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : sam. 02 mai 2026 à 02:53
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `scolarite`
--

-- --------------------------------------------------------

--
-- Structure de la table `demande`
--

CREATE TABLE `demande` (
  `id` int(11) NOT NULL,
  `etudiant_id` int(11) DEFAULT NULL,
  `motif` varchar(200) DEFAULT NULL,
  `statut` enum('En attente','Approuvée','Rejetée') DEFAULT 'En attente',
  `date_demande` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `demande`
--

INSERT INTO `demande` (`id`, `etudiant_id`, `motif`, `statut`, `date_demande`) VALUES
(21, 12, 'Attestation de rÃ©ussite', 'Rejetée', '2026-03-31 19:12:10'),
(22, 13, 'Attestation de scolaritÃ©', 'Approuvée', '2026-04-01 12:14:20'),
(24, 15, 'Attestation de rÃ©ussite', 'Approuvée', '2026-04-01 18:05:37'),
(25, 16, 'Attestation de scolaritÃ©', 'Approuvée', '2026-04-02 13:58:01'),
(26, 17, 'Attestation de reussite', 'Rejetée', '2026-04-04 22:30:05'),
(27, 18, 'Attestation de rÃ©ussite', 'En attente', '2026-04-05 00:00:00'),
(28, 19, 'Demande de stage', 'En attente', '2026-04-06 00:00:00');

-- --------------------------------------------------------

--
-- Structure de la table `etudiant`
--

CREATE TABLE `etudiant` (
  `id` int(11) NOT NULL,
  `nom` varchar(50) DEFAULT NULL,
  `prenom` varchar(50) DEFAULT NULL,
  `cne` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `filiere_id` int(11) DEFAULT NULL,
  `annee_inscription` varchar(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `etudiant`
--

INSERT INTO `etudiant` (`id`, `nom`, `prenom`, `cne`, `email`, `filiere_id`, `annee_inscription`) VALUES
(12, 'Rifla', 'Fatima', 'K5683I986', 'riflafatima@ucd.ma', 4, '2025/2026'),
(13, 'Ezzanfari ', 'Soukaina', 'K135158502', 'soukainaezzanfari@gmail.com', 4, '2025/2026'),
(14, 'Khomssi', 'Hajar', 'K1234567', 'hajar@ucd.ma', 4, '2025/2026'),
(15, 'Natij', 'Fatima', 'K876443899', 'fatima@ucd.ma', 5, '2025/2026'),
(16, 'Sahnoun', 'Imane', 'K346887643', 'sahnon@ucd.ma', 6, '2025/2026'),
(17, 'Ezzanfari ', 'Maroua', 'K879563425', 'maroua@ezz.com', 5, '2025/2026'),
(18, 'CHAHMI', 'Nouhaila', 'M45678976543', 'nouhaila@ucd.ma', 4, '2025/2026'),
(19, 'Othman', 'Ezzanfari', 'M12345678', 'oth@ucd.ma', 6, '2025/2026');

-- --------------------------------------------------------

--
-- Structure de la table `filiere`
--

CREATE TABLE `filiere` (
  `id` int(11) NOT NULL,
  `nom` varchar(50) DEFAULT NULL,
  `niveau` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `filiere`
--

INSERT INTO `filiere` (`id`, `nom`, `niveau`) VALUES
(1, 'SMI', 'Licence 3'),
(2, 'SMI', 'Licence 2'),
(3, 'SMI', 'Licence 1'),
(4, 'Informatique', 'Master 1'),
(5, 'Mathématiques', 'Licence 3'),
(6, 'Physique', 'Licence 2');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id` int(11) NOT NULL,
  `nom` varchar(50) DEFAULT NULL,
  `prenom` varchar(50) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `mot_de_passe` varchar(100) NOT NULL,
  `role` varchar(20) DEFAULT 'admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `nom`, `prenom`, `email`, `mot_de_passe`, `role`) VALUES
(1, 'Admin', 'Admin', 'admin@ucd.ma', '1234', 'admin'),
(6, 'soso1', 'soso1', 'soso@ucd.ma', '1234', 'admin');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `demande`
--
ALTER TABLE `demande`
  ADD PRIMARY KEY (`id`),
  ADD KEY `etudiant_id` (`etudiant_id`);

--
-- Index pour la table `etudiant`
--
ALTER TABLE `etudiant`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cne` (`cne`),
  ADD KEY `filiere_id` (`filiere_id`);

--
-- Index pour la table `filiere`
--
ALTER TABLE `filiere`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `demande`
--
ALTER TABLE `demande`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT pour la table `etudiant`
--
ALTER TABLE `etudiant`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `filiere`
--
ALTER TABLE `filiere`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `demande`
--
ALTER TABLE `demande`
  ADD CONSTRAINT `demande_ibfk_1` FOREIGN KEY (`etudiant_id`) REFERENCES `etudiant` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `etudiant`
--
ALTER TABLE `etudiant`
  ADD CONSTRAINT `etudiant_ibfk_1` FOREIGN KEY (`filiere_id`) REFERENCES `filiere` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
