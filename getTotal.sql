DELIMITER ;;
CREATE PROCEDURE `getTotal`(IN exercici YEAR, IN trimestre TINYINT UNSIGNED, IN esRebuda TINYINT)
BEGIN
  DECLARE inici,
          fi    DATE;

  CALL periode(exercici, trimestre, inici, fi);

  CASE esRebuda
    WHEN true THEN
      SELECT SUM(f.baseImp) 
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
      SELECT SUM(f.baseImp)
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
