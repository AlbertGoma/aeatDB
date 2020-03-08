DELIMITER ;;
CREATE PROCEDURE `get349`(IN exercici YEAR, IN trimestre TINYINT UNSIGNED)
BEGIN
  DECLARE inici,
          fi    date;
  
  CASE trimestre
    WHEN 1 THEN
      SET inici :=  date(concat(exercici, '-01-01')),
          fi    :=  date(concat(exercici, '-03-31'));
    WHEN 2 THEN
      SET inici :=  date(concat(exercici, '-04-01')),
          fi    :=  date(concat(exercici, '-06-30'));
    WHEN 3 THEN
      SET inici :=  date(concat(exercici, '-07-01')),
          fi    :=  date(concat(exercici, '-09-30'));
    WHEN 4 THEN
      SET inici :=  date(concat(exercici, '-10-01')),
          fi    :=  date(concat(exercici, '-12-31'));
    ELSE
      SET inici :=  date(concat(exercici, '-01-01')),
          fi    :=  date(concat(exercici, '-12-31'));
  END CASE;

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
