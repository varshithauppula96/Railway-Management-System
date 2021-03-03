create database Railway_management;
use Railway_management;
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

INSERT INTO `UserAccount` VALUES ('1','UppulaV','Varshitha','Uppula','varsjn@gmail.com','1996-06-02','Female','eba094d4d15bc478cdc9','Old airport road,bangalore'),
('2','yadlaSai','srihitha','yadlapalli','varsjfdn@gmail.com','1996-06-02','Female','wefwefwefgef','New York'),
('3','atishay','ashika','qwerty','efersjn@gmail.com','1994-07-01','Female','jewhfewfef','Rangmahal Mall, Panna'),
('4','divyam310','divya','manasa','mansjn@gmail.com','1991-12-22','Other','goyal1002','Kota, Rajasthan'),
('5','goku446','prajwal','goku','prajn@gmail.com','2001-03-13','Male','dejavu','Kota, Rajasthan'),
('6','prateek1996','prateek','reddy','prateekr@gmail.com','1998-08-02','Male','ronaldoisgreat','New Delhi'),
('7','priyamv','vidya','priya','vidyprn@gmail.com','1996-02-09','Male','eba094d4d15bc478cdc9','Madhya Pradesh');

CREATE TABLE `ContactDetails` (
  `UserID` int NOT NULL,
  `Phone_No` char(10) NOT NULL UNIQUE,
  PRIMARY KEY (`UserID`,`Phone_No`),
  CONSTRAINT `Contact_fk_1` FOREIGN KEY (`UserID`) REFERENCES `UserAccount` (`UserID`) ON DELETE CASCADE
);

INSERT INTO `ContactDetails` VALUES ('1','8899887766'),('1','9876543210'),('2','7071475380'),('3','8009224040'),('3','9650367698'),('3','9968254144'),('4','8989786765'),('5','9232453425'),('6','9989786756'),('7','9898342565'),('7','7071475390');
SELECT * FROM ContactDetails;

CREATE TABLE `Station` (
  `Station_Code` char(5) ,
  `Station_Name` varchar(25) NOT NULL,
  PRIMARY KEY (`Station_Code`)
);
INSERT INTO `Station` VALUES ('ALD','ALLAHABAD JUNCTION'),('CNB','KANPUR CENTRAL'),('GYN','GYANPUR ROAD'),('GZB','GHAZIABAD JUNCTION'),('BLR','BANGALORE'),('NDLS','NEW DELHI');

CREATE TABLE `Train` (
  `Train_No` int,
  `Train_Name` varchar(25) NOT NULL,
  `Sleeper` int(4) NOT NULL,
  `First_Class` int(4) ,
  `Second_Class` int(4) ,
  `Third_Class` int(4) ,
 `Running_On_Sunday` char(1) NOT NULL,
  `Running_On_Monday` char(1) NOT NULL,
  `Running_On_Tuesday` char(1) NOT NULL,
  `Running_On_Wednesday` char(1) NOT NULL,
  `Running_On_Thursday` char(1) NOT NULL,
  `Running_On_Friday` char(1) NOT NULL,
  `Running_On_Saturday` char(1) NOT NULL,
   `Wifi` char(1) NOT NULL,
  `Food` char(1) NOT NULL,
  PRIMARY KEY (`Train_No`)
);

INSERT INTO `Train` VALUES (12559,'SHIV GANGA EXP',479,47,96,192,'N','Y','Y','Y','Y','Y','Y','Y','Y'),(12560,'SHIV GANGA EXP',480,43,96,192,'N','Y','Y','Y','Y','Y','Y','Y','Y'),(12581,'BLR NDLS S F EX',432,48,80,144,'N','N','Y','Y','Y','Y','Y','Y','Y'),(12582,'BLR NDLS S F EX',432,48,80,144,'N','N','Y','Y','Y','Y','Y','Y','Y');
CREATE TABLE `Ticket` (
  `Ticket_No` int(10) AUTO_INCREMENT,
  `Train_No` int(6) NOT NULL,
  `Date_of_Journey` date NOT NULL,
  `UserID` int NOT NULL,
  `class` ENUM('Sleeper', 'First', 'Second','Third') NOT NULL,
  PRIMARY KEY (`Ticket_No`),

  KEY `Train_No` (`Train_No`),
  CONSTRAINT `Ticket_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `UserAccount` (`UserID`) ON DELETE CASCADE,
  CONSTRAINT `Ticket_ibfk_2` FOREIGN KEY (`Train_No`) REFERENCES `Train` (`Train_No`) ON UPDATE CASCADE
);
delimiter //
create trigger cancellation 
 before delete on ticket 
 for each row  
BEGIN   
  SET @trainno=old.Train_No; 
        
  SET @classSelected = old.class;
  if @classSelected='First' then    
    UPDATE Train set Train.First_Class= Train.First_Class+1 WHERE Train.Train_No = @trainno ;   
  elseif @classSelected='Sleeper' then        
    UPDATE Train set Train.Sleeper = Train.Sleeper+1 WHERE Train.Train_No = @trainno ;   
  elseif @classSelected='Second' then       
    UPDATE Train set Train.Second_Class = Train.Second_Class+1 WHERE Train.Train_No = @trainno ;    
  elseif @classSelected='Third' then        
    UPDATE Train set Train.Third_Class = Train.Third_Class+1 WHERE Train.Train_No = @trainno ;      
  end if; 
END//
delimiter ;	
INSERT INTO Ticket values ('1','12559','2021-01-12','1','First');
INSERT INTO Ticket values ('2','12559','2021-01-12','1','First');
INSERT INTO Ticket values ('3','12559','2021-01-12','1','First');
INSERT INTO Ticket values ('4','12559','2021-01-12','1','First');
INSERT INTO Ticket values ('5','12559','2021-01-12','1','First');
CREATE TABLE `Stops` (
  `Train_No` int(6) NOT NULL ,
  `Station_Code` char(5) NOT NULL,
  `Arrival_Time` time DEFAULT NULL,
  `Departure_Time` time DEFAULT NULL,
  PRIMARY KEY (`Train_No`,`Station_Code`),
  KEY `Station_Code` (`Station_Code`),
  CONSTRAINT `Stoppage_ibfk_1` FOREIGN KEY (`Train_No`) REFERENCES `Train` (`Train_No`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Stoppage_ibfk_2` FOREIGN KEY (`Station_Code`) REFERENCES `Station` (`Station_Code`) ON DELETE CASCADE ON UPDATE CASCADE
);
 alter table Stops ADD CHECK (EXTRACT(HOUR FROM Arrival_Time) <24 AND EXTRACT(HOUR FROM Departure_Time) <24);
INSERT INTO `Stops` VALUES (12559,'ALD','22:05:00','22:30:00'),(12559,'CNB','01:30:00','01:38:00'),(12559,'BLR','19:20:00','19:30:00'),(12559,'NDLS','08:10:00',NULL),(12560,'ALD','03:45:00','04:10:00'),(12560,'CNB','01:00:00','01:05:00'),(12560,'BLR','07:00:00',NULL),(12560,'NDLS','18:35:00','18:55:00'),(12581,'ALD','01:20:00','01:45:00'),(12581,'CNB','04:15:00','04:20:00'),(12581,'GYN','23:31:00','23:33:00'),(12581,'GZB','11:30:00','11:32:00'),(12581,'BLR','22:20:00','22:30:00'),(12581,'NDLS','12:20:00',NULL),(12582,'ALD','07:45:00','08:15:00'),(12582,'CNB','04:55:00','05:00:00'),(12582,'GYN','09:21:00','09:23:00'),(12582,'GZB','23:03:00','23:05:00'),(12582,'BLR','11:20:00',NULL),(12582,'NDLS','22:15:00','22:25:00');
SELECT * FROM Stops;