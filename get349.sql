DELIMITER ;;
CREATE PROCEDURE `get349`(IN exercici YEAR, IN trimestre TINYINT UNSIGNED)
BEGIN
  DECLARE inici,
          fi    DATE;
  
  CALL periode(exercici, trimestre, inici, fi);

  SELECT pv.iso 'Código País', v.nif 'NIF comunitario', v.raoSocial 'Razón social', SUM(f.baseImp) 'Base imponible'
  FROM factura f, proveidor v, pais pv, proveidor c, config cg
  WHERE  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  f.idComprador  =  c.idProveidor
    AND  pv.iso         != 'ES'
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  pv.ue          =  true
    AND  f.data
      BETWEEN  inici
        AND    fi
  GROUP BY v.idProveidor;
END ;;
DELIMITER ;
