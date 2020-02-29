DELIMITER ;;
CREATE PROCEDURE `get349`(IN exercici YEAR)
BEGIN
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
      BETWEEN  cast(concat(exercici, '-01-01') AS date)
        AND    cast(concat(exercici, '-12-31') AS date)
  GROUP BY v.idProveidor;
END ;;
DELIMITER ;
