-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: mysql112.unoeuro.com
-- Generation Time: Apr 25, 2024 at 08:07 AM
-- Server version: 8.0.36-28
-- PHP Version: 8.1.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ddu_gram_dk_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `nonces`
--

CREATE TABLE `nonces` (
  `ip_address` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `nonce` char(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `nonces`
--

INSERT INTO `nonces` (`ip_address`, `nonce`) VALUES
('::1', 'b4a08a2c5800284e62b4e5c620b88023d54da4361917e92e3d8e5b34ed3f8c78'),
('::1', 'a940c63ec28395efe11e15af82492c875b10468b14dbbe29489047b93c20db07'),
('::1', '407107f7f7992aa2a819e0d1c09ef0a47128bfea467b8e910fe800dedc810a6f'),
('::1', '3247fbf5dc632a60a78f8bd430557e39707912b0501a60da26088906d5464d58'),
('::1', '9d1d5daccd27a8e65b35bc4d0f0116de33ce6f3876cffe917ee6f4505fc6abdf');

-- --------------------------------------------------------

--
-- Table structure for table `scores`
--

CREATE TABLE `scores` (
  `username` varchar(12) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `score` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `scores`
--

INSERT INTO `scores` (`username`, `score`) VALUES
('test1', 500000),
('', 501150),
('Gustav', 550),
('', 501400),
('Personen', 43250),
('Tyefighter', 59450),
('gigachad', 307677),
('Gustav', 202052),
('AMoger', 3695),
('Gustav', 500),
('XQC', 853463),
('dinmor', 535),
('MainCharactr', 1820),
('amgogongus', 6625),
('amgogongus', 6625),
('amgogongus', 6625);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
