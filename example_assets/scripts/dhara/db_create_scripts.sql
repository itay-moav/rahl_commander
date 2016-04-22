CREATE DATABASE dhara_delta_1;
CREATE DATABASE dhara_delta_2;
CREATE DATABASE dhara_delta_3;

CREATE DATABASE dhara_views;
CREATE DATABASE dhara;



USE dhara;
-- --------------------------------------------------------

--
-- Table structure for table `first_file_members`
--

CREATE TABLE IF NOT EXISTS `first_file_members` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT,
  `member_name` varchar(255) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `rank` enum('private','corporal','sergeant','lieutenant','captain','colonel','general') NOT NULL,
  PRIMARY KEY (`member_id`),
  KEY `unit_id` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `first_file_units`
--

CREATE TABLE IF NOT EXISTS `first_file_units` (
  `unit_id` int(11) NOT NULL AUTO_INCREMENT,
  `unit_name` varchar(255) NOT NULL,
  `commander_room_id` int(11) NOT NULL,
  `commander_id` int(11) NOT NULL,
  PRIMARY KEY (`unit_id`),
  KEY `commander_room_id` (`commander_room_id`),
  KEY `commander_id` (`commander_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `people_palace`
--

CREATE TABLE IF NOT EXISTS `people_palace` (
  `room_id` int(11) NOT NULL AUTO_INCREMENT,
  `room_name` varchar(255) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;



USE dhara_delta_1;
-- --------------------------------------------------------

--
-- Table structure for table `first_file_members`
--

CREATE TABLE IF NOT EXISTS `first_file_members` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT,
  `member_name` varchar(255) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `rank` enum('private','corporal','sergeant','lieutenant','captain','colonel','general') NOT NULL,
  PRIMARY KEY (`member_id`),
  KEY `unit_id` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `first_file_units`
--

CREATE TABLE IF NOT EXISTS `first_file_units` (
  `unit_id` int(11) NOT NULL AUTO_INCREMENT,
  `unit_name` varchar(255) NOT NULL,
  `commander_room_id` int(11) NOT NULL,
  `commander_id` int(11) NOT NULL,
  PRIMARY KEY (`unit_id`),
  KEY `commander_room_id` (`commander_room_id`),
  KEY `commander_id` (`commander_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `people_palace`
--

CREATE TABLE IF NOT EXISTS `people_palace` (
  `room_id` int(11) NOT NULL AUTO_INCREMENT,
  `room_name` varchar(255) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `delta_monitor`
--
-- use table to count total delta entries

CREATE TABLE IF NOT EXISTS `delta_monitor` (
  `delta_records_stored` int(11) unsigned NOT NULL)
   ENGINE=InnoDB DEFAULT CHARSET=utf8;
