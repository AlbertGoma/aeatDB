DROP TABLE IF EXISTS `amort`;

CREATE TABLE `amort` (
  `idAmort` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) NOT NULL,
  `max` decimal(5,4) NOT NULL,
  PRIMARY KEY (`idAmort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
