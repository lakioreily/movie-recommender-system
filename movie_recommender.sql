-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 14, 2026 at 08:21 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `movie_recommender`
--

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `movie_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `genres` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`movie_id`, `title`, `genres`, `description`, `created_at`) VALUES
(1, 'The Matrix', 'Action Sci-Fi', 'ACTION SCIFI. A computer hacker learns from mysterious rebels about the true nature of his reality. KEYWORDS: FUTURE, WAR, FIGHT.', '2026-02-14 18:56:10'),
(2, 'John Wick', 'Action Thriller', 'ACTION THRILLER. An ex-hitman comes out of retirement to track down gangsters. KEYWORDS: REVENGE, FIGHT, GUNS.', '2026-02-14 18:56:10'),
(3, 'Terminator 2', 'Action Sci-Fi', 'ACTION SCIFI. A cyborg, identical to the one who failed to kill Sarah Connor, must now protect her teenage son. KEYWORDS: FUTURE, FIGHT, WAR.', '2026-02-14 18:56:10'),
(4, 'Inception', 'Action Sci-Fi', 'ACTION SCIFI. A thief who steals corporate secrets through the use of dream-sharing technology. KEYWORDS: DREAM, MIND, THRILLER.', '2026-02-14 18:56:10'),
(5, 'Toy Story', 'Animation Kids', 'ANIMATION KIDS FAMILY. A cowboy doll is profoundly threatened and jealous when a new spaceman figure supplants him as top toy.', '2026-02-14 18:56:10'),
(6, 'Lion King', 'Animation Kids', 'ANIMATION KIDS FAMILY. Lion prince flees his kingdom only to learn the true meaning of responsibility and bravery. KEYWORDS: ANIMALS, FAMILY.', '2026-02-14 18:56:10'),
(7, 'Finding Nemo', 'Animation Kids', 'ANIMATION KIDS FAMILY. After his son is captured, a timid clownfish sets out on a journey. KEYWORDS: FISH, OCEAN, FAMILY.', '2026-02-14 18:56:10'),
(8, 'Shrek', 'Animation Comedy', 'ANIMATION COMEDY FAMILY. A mean lord exiles fairytale creatures to the swamp of a grumpy ogre. KEYWORDS: FAIRY TALE, COMEDY.', '2026-02-14 18:56:10'),
(9, 'Frozen', 'Animation Kids', 'ANIMATION KIDS FAMILY. When the newly crowned Queen accidentally uses her power to turn things into ice. KEYWORDS: PRINCESS, SNOW, MAGIC.', '2026-02-14 18:56:10'),
(10, 'The Godfather', 'Crime Drama', 'CRIME DRAMA. The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son. KEYWORDS: MAFIA, GANGSTER, FAMILY.', '2026-02-14 18:56:10'),
(11, 'The Shawshank Redemption', 'Drama Crime', 'DRAMA CRIME. Two imprisoned men bond over a number of years, finding solace and redemption. KEYWORDS: PRISON, HOPE, FRIENDSHIP.', '2026-02-14 18:56:10'),
(12, 'Pulp Fiction', 'Crime Drama', 'CRIME DRAMA. The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in tales of violence. KEYWORDS: GANGSTER, VIOLENCE, MAFIA.', '2026-02-14 18:56:10'),
(13, 'The Dark Knight', 'Action Crime', 'ACTION CRIME DRAMA. When the menace known as the Joker wreaks havoc and chaos on the people of Gotham. KEYWORDS: HERO, VILLAIN, DARK.', '2026-02-14 18:56:10'),
(14, 'Casablanca', 'Romance Drama', 'CLASSIC ROMANCE DRAMA WAR. A cynical expatriate American cafe owner struggles to decide whether or not to help his former lover and her fugitive husband escape the Nazis in French Morocco. KEYWORDS: LOVE, WAR, CLASSIC.', '2026-02-14 18:56:10'),
(15, '12 Angry Men', 'Drama Crime', 'CLASSIC DRAMA CRIME. A jury holdout attempts to prevent a miscarriage of justice by forcing his colleagues to reconsider the evidence. KEYWORDS: COURT, JUSTICE, CLASSIC.', '2026-02-14 18:56:10'),
(16, 'Citizen Kane', 'Drama Mystery', 'CLASSIC DRAMA MYSTERY. Following the death of publishing tycoon Charles Foster Kane, reporters scramble to uncover the meaning of his final utterance; Rosebud. KEYWORDS: NEWSPAPER, WEALTH, CLASSIC.', '2026-02-14 18:56:10');

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `rating_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `movie_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`rating_id`, `user_id`, `movie_id`, `rating`, `timestamp`) VALUES
(1, 1, 1, 5, '2026-02-14 18:56:10'),
(2, 1, 2, 4, '2026-02-14 18:56:10'),
(3, 1, 6, 5, '2026-02-14 18:56:10'),
(4, 1, 3, 2, '2026-02-14 18:56:10'),
(5, 2, 5, 5, '2026-02-14 18:56:10'),
(6, 2, 6, 5, '2026-02-14 18:56:10'),
(7, 2, 8, 4, '2026-02-14 18:56:10'),
(8, 2, 1, 2, '2026-02-14 18:56:10'),
(9, 3, 1, 5, '2026-02-14 18:56:10'),
(10, 3, 4, 5, '2026-02-14 18:56:10'),
(11, 3, 2, 4, '2026-02-14 18:56:10'),
(12, 3, 6, 2, '2026-02-14 18:56:10'),
(13, 4, 1, 5, '2026-02-14 18:56:10'),
(14, 4, 4, 5, '2026-02-14 18:56:10'),
(15, 4, 3, 4, '2026-02-14 18:56:10'),
(16, 5, 6, 5, '2026-02-14 18:56:10'),
(17, 5, 9, 5, '2026-02-14 18:56:10'),
(18, 5, 8, 4, '2026-02-14 18:56:10'),
(19, 5, 10, 1, '2026-02-14 18:56:10'),
(20, 6, 10, 5, '2026-02-14 18:56:10'),
(21, 6, 12, 5, '2026-02-14 18:56:10'),
(22, 6, 14, 5, '2026-02-14 18:56:10'),
(23, 6, 15, 5, '2026-02-14 18:56:10'),
(24, 7, 1, 4, '2026-02-14 18:56:10'),
(25, 7, 8, 5, '2026-02-14 18:56:10'),
(26, 7, 10, 3, '2026-02-14 18:56:10');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `created_at`) VALUES
(1, 'student_master', 'student@test.com', '2026-02-14 18:56:10'),
(2, 'filmofil_01', 'film@test.com', '2026-02-14 18:56:10'),
(3, 'Marko', 'marko@test.com', '2026-02-14 18:56:10'),
(4, 'Aladin', 'aladin@test.com', '2026-02-14 18:56:10'),
(5, 'Emin', 'emin@test.com', '2026-02-14 18:56:10'),
(6, 'Isa', 'isa@test.com', '2026-02-14 18:56:10'),
(7, 'Dzan', 'dzan@test.com', '2026-02-14 18:56:10'),
(8, 'Emir', 'emir@test.com', '2026-02-14 18:56:10');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`movie_id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`rating_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `movie_id` (`movie_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `movie_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `rating_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
