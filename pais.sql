DROP TABLE IF EXISTS `pais`;

CREATE TABLE `pais` (
  `idPais` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `iso` char(2) NOT NULL,
  `ue` tinyint(1) NOT NULL,
  PRIMARY KEY (`idPais`),
  UNIQUE KEY `iso_UNIQUE` (`iso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
