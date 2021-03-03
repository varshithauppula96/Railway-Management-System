create database Railway_management;
use Railway_managemetn;
CREATE TABLE `UserAccount` (
  `userID` int,
  `User_name` varchar(15) NOT NULL,
  `First_name` varchar(15) NOT NULL,
  `Last_name` varchar(15) NOT NULL,
`Email_id` varchar(20) UNIQUE,
  `DOB` date NOT NULL,
  `Gender` ENUM('Male', 'Female', 'Other'),
  `Password` varchar(20) NOT NULL,
  `Address` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`UserID`)
);
