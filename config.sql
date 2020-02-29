DROP TABLE IF EXISTS `config`;

CREATE TABLE `config` (
  `k` varchar(45) NOT NULL,
  `v` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
