CREATE DATABASE IF NOT EXISTS accounts;
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost' IDENTIFIED BY 'admin123';
FLUSH PRIVILEGES;
USE accounts;
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
LOCK TABLES `role` WRITE;
INSERT INTO `role` VALUES (1,'ROLE_USER');
UNLOCK TABLES;
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `userEmail` varchar(255) DEFAULT NULL,
  `profileImg` varchar(255) DEFAULT NULL,
  `profileImgPath` varchar(255) DEFAULT NULL,
  `dateOfBirth` varchar(255) DEFAULT NULL,
  `fatherName` varchar(255) DEFAULT NULL,
  `motherName` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `maritalStatus` varchar(255) DEFAULT NULL,
  `permanentAddress` varchar(255) DEFAULT NULL,
  `tempAddress` varchar(255) DEFAULT NULL,
  `primaryOccupation` varchar(255) DEFAULT NULL,
  `secondaryOccupation` varchar(255) DEFAULT NULL,
  `skills` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `secondaryPhoneNumber` varchar(255) DEFAULT NULL,
  `nationality` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `workingExperience` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
LOCK TABLES `user` WRITE;
INSERT INTO `user` VALUES (7,'admin_vp','admin@hkhinfo.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'$2a$11$0a7VdTr4rfCQqtsvpng6GuJnzUmQ7gZiHXgzGPgm5hkRa3avXgBLK')
,(8,'Abrar Nirban','abrar.nirban74@gmail.com',NULL,NULL,'27/01/2002','A nirban','T nirban','male','unMarried','Dubai,UAE','Dubai,UAE','Software Engineer','Software Engineer','Java HTML CSS ','8888888888','8888888888','Indian','english','2 ','$2a$11$UgG9TkHcgl02LxlqxRHYhOf7Xv4CxFmFEgS0FpUdk42OeslI.6JAW'),
(9,'Amayra Fatima','amayra@gmail.com',NULL,NULL,'20/06/1993','K','L','female','unMarried','Dubai,UAE','Dubai,UAE','Software Engineer','Software Engineer','Java HTML CSS ','9999999999','9999999999','India','english','5','$2a$11$gwvsvUrFU.YirMM1Yb7NweFudLUM91AzH5BDFnhkNzfzpjG.FplYO'),
(10,'Aron','aron.DSilva@gmail.com',NULL,NULL,'27/01/2002','M nirban','R nirban','male','unMarried','Dubai,UAE','Dubai,UAE','Software Engineer','Software Engineer','Java HTML CSS ','7777777777','777777777','India','english','7','$2a$11$6oZEgfGGQAH23EaXLVZ2WOSKxcEJFnBSw2N2aghab0s2kcxSQwjhC'),
(11,'Kiran Kumar','kiran@gmail.com',NULL,NULL,'8/12/1993','K K','RK','male','unMarried','SanFrancisco','James Street','Software Engineer','Software Engineer','Java HTML CSS ','1010101010','1010101010','India','english','10','$2a$11$EXwpna1MlFFlKW5ut1iVi.AoeIulkPPmcOHFO8pOoQt1IYU9COU0m'),
(12,'Balbir Singh','balbir@gmail.com',NULL,NULL,'20/06/1993','balbir RK','balbir AK','male','unMarried','SanFrancisco','US','Software Engineer','Software Engineer','Java HTML CSS AWS','8888888111','8888888111','India','english','8','$2a$11$pzWNzzR.HUkHzz2zhAgqOeCl0WaTgY33NxxJ7n0l.rnEqjB9JO7vy'),
(4,'Hibo Prince','hibo.prince@gmail.com',NULL,NULL,'6/09/2000','Abara','Queen','male','unMarried','Electronic City,UAE','Electronic City,UAE','Tester','Freelancing','Python PHP ','9146389863','9146389871','Indian','hindi','3 ','$2a$11$UgG9TkHcgl02LxlqxRHYhOf7Xv4CxFmFEgS0FpUdk42OeslI.6JAR'),
(5,'Aejaaz Habeeb','aejaaz.habeeb@gmail.com',NULL,NULL,'16/02/2001','Imran','Ziya','male','unMarried','AbuDhabi,UAE','AbuDhabi,UAE','Developer','Developer','Azure Devops ','9566489863','9566489863','Indian','hindi','4 ','$2a$11$UgG9TkHcgl02LxlqxRHYhOf7Xv4CxFmFEgS0FpUdk42OeslI.6JAR'),
(6,'Jackie','jackie.chan@gmail.com',NULL,NULL,'28/09/1992','Charles','Chan','male','Married','HongKong,China','HongKong,China','MartialArtist','MartialArtist','KungFu ','9246488863','9246488863','Chinese','Mandrian','1 ','$2a$11$UgG9TkHcgl02LxlqxRHYhOf7Xv4CxFmFEgS0FpUdk42OeslI.6RAR'),
(13,'Srinath Goud','sgoud@gmail.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'$2a$11$6BSmYPrT8I8b9yHmx.uTRu/QxnQM2vhZYQa8mR33aReWA4WFihyGK');
UNLOCK TABLES;
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_user_role_roleid_idx` (`role_id`),
  CONSTRAINT `fk_user_role_roleid` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_role_userid` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
LOCK TABLES `user_role` WRITE;
INSERT INTO `user_role` VALUES (4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1);
UNLOCK TABLES;

