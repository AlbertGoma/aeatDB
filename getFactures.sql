DELIMITER ;;
CREATE PROCEDURE `getFactures`(IN exercici YEAR, IN trimestre TINYINT UNSIGNED, IN esRebuda TINYINT)
BEGIN
  DECLARE inici,
          fi    date;
          
  CALL periode(exercici, trimestre, inici, fi);

  CASE esRebuda
    WHEN true THEN
      SELECT f.data, p.raoSocial, f.ref, c.iso pais, if(f.esServei, 'Sí', 'No') servei, p.nif, f.import, d.iso divisa, f.baseImp
      FROM factura f, proveidor p, divisa d, pais c, config cg
      WHERE f.idProveidor =   p.idProveidor
        AND p.idPais      =   c.idPais
        AND f.idDivisa    =   d.idDivisa
        AND cg.k          =   'NIF'
        AND   (p.nif      !=  cg.v
          OR  p.nif       IS  NULL)
        AND f.data BETWEEN inici AND fi
      ORDER BY f.data ASC;
    ELSE
      SELECT f.data, p.raoSocial, f.ref, c.iso pais, if(f.esServei, 'Sí', 'No') servei, p.nif, f.import, d.iso divisa, f.baseImp
      FROM factura f, proveidor p, divisa d, pais c, config cg
      WHERE f.idProveidor =   p.idProveidor
        AND p.idPais      =   c.idPais
        AND f.idDivisa    =   d.idDivisa
        AND cg.k          =   'NIF'
        AND p.nif         =   cg.v
        AND f.data BETWEEN inici AND fi
      ORDER BY f.data ASC;
  END CASE;
END ;;
DELIMITER ;
