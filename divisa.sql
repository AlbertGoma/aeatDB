DROP TABLE IF EXISTS `divisa`;

CREATE TABLE `divisa` (
  `idDivisa` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `iso` char(3) NOT NULL,
  PRIMARY KEY (`idDivisa`),
  UNIQUE KEY `iso_UNIQUE` (`iso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
