DROP TABLE IF EXISTS `proveidor`;

CREATE TABLE `proveidor` (
  `idProveidor` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nif` varchar(45) DEFAULT NULL,
  `raoSocial` varchar(150) NOT NULL,
  `idPais` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`idProveidor`),
  UNIQUE KEY `NIF_UNIQUE` (`nif`),
  KEY `fk_proveidor_pais1_idx` (`idPais`),
  CONSTRAINT `fk_proveidor_pais1` FOREIGN KEY (`idPais`) REFERENCES `pais` (`idPais`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
