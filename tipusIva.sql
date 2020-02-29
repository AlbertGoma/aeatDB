DROP TABLE IF EXISTS `tipusIva`;

CREATE TABLE `tipusIva` (
  `idTipusIva` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `tipus` decimal(5,2) NOT NULL,
  PRIMARY KEY (`idTipusIva`),
  UNIQUE KEY `tipus_UNIQUE` (`tipus`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
