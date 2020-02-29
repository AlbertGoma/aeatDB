DELIMITER ;;
CREATE PROCEDURE `get347`(IN exercici YEAR)
BEGIN
  DROP TABLE IF EXISTS tbl347;

  CREATE TEMPORARY TABLE tbl347 (
    id           int(10) unsigned,
    pais         char(2),
    nif          varchar(45),
    raoSocial    varchar(150),
    claveOp      char(1),
    importAnual  decimal(10,2),
    import1T     decimal(10,2),
    import2T     decimal(10,2),
    import3T     decimal(10,2),
    import4T     decimal(10,2));

  INSERT INTO tbl347 (id, pais, nif, raoSocial, importAnual, claveOp)
  SELECT v.idProveidor, pv.iso, v.nif, v.raoSocial, ROUND(SUM(f.baseImp + (f.baseImp * f.iva * i.tipus)), 2) bi, 'A'
  FROM factura f, proveidor v, pais pv, tipusIva i, config c
  WHERE  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  f.idTipusIva   =  i.idTipusIva
    AND  c.k            =  'NIF'
    AND  v.nif          != c.v
    AND  f.data
      BETWEEN  cast(concat(exercici, '-01-01') AS date)
        AND    cast(concat(exercici, '-12-31') AS date)
  GROUP BY v.idProveidor
  HAVING bi  >=  3005.06;

  UPDATE tbl347 t
  LEFT JOIN (
    SELECT v.idProveidor id, SUM(f.baseImp + (f.baseImp * f.iva * i.tipus)) imp
    FROM factura f, proveidor v, pais pv, tipusIva i, config c
    WHERE  f.idProveidor  =  v.idProveidor
      AND  v.idPais       =  pv.idPais
      AND  f.idTipusIva   =  i.idTipusIva
      AND  c.k            =  'NIF'
      AND  v.nif          != c.v
      AND  f.data
        BETWEEN  cast(concat(exercici, '-01-01') AS date)
          AND    cast(concat(exercici, '-03-31') AS date)
    GROUP BY v.idProveidor
    ) as pt ON t.id = pt.id
  LEFT JOIN (
    SELECT v.idProveidor id, SUM(f.baseImp + (f.baseImp * f.iva * i.tipus)) imp
    FROM factura f, proveidor v, pais pv, tipusIva i, config c
    WHERE  f.idProveidor  =  v.idProveidor
      AND  v.idPais       =  pv.idPais
      AND  f.idTipusIva   =  i.idTipusIva
      AND  c.k            =  'NIF'
      AND  v.nif          != c.v
      AND  f.data
        BETWEEN  cast(concat(exercici, '-04-01') AS date)
          AND    cast(concat(exercici, '-06-30') AS date)
    GROUP BY v.idProveidor
    ) as st ON t.id = st.id
  LEFT JOIN (
    SELECT v.idProveidor id, SUM(f.baseImp + (f.baseImp * f.iva * i.tipus)) imp
    FROM factura f, proveidor v, pais pv, tipusIva i, config c
    WHERE  f.idProveidor	=  v.idProveidor
      AND  v.idPais       =  pv.idPais
      AND  f.idTipusIva   =  i.idTipusIva
      AND  c.k            =  'NIF'
      AND  v.nif          != c.v
      AND  f.data
        BETWEEN  cast(concat(exercici, '-07-01') AS date)
          AND    cast(concat(exercici, '-09-30') AS date)
    GROUP BY v.idProveidor
    ) as tt ON t.id = tt.id
  LEFT JOIN (
    SELECT v.idProveidor id, SUM(f.baseImp + (f.baseImp * f.iva * i.tipus)) imp
    FROM factura f, proveidor v, pais pv, tipusIva i, config c
    WHERE  f.idProveidor  =  v.idProveidor
      AND  v.idPais       =  pv.idPais
      AND  f.idTipusIva   =  i.idTipusIva
      AND  c.k            =  'NIF'
      AND  v.nif          != c.v
      AND  f.data
        BETWEEN  cast(concat(exercici, '-10-01') AS date)
          AND    cast(concat(exercici, '-12-31') AS date)
    GROUP BY v.idProveidor
    ) as qt ON t.id = qt.id
  SET t.import1T = pt.imp, t.import2T = st.imp, t.import3T = tt.imp, t.import4T = qt.imp
  WHERE t.claveOp = 'A';


  INSERT INTO tbl347 (id, pais, nif, raoSocial, importAnual, claveOp)
  SELECT c.idProveidor, pc.iso, c.nif, c.raoSocial, ROUND(SUM(f.baseImp + (f.baseImp * f.iva * i.tipus)), 2) bi, 'B'
  FROM factura f, proveidor c, pais pc, tipusIva i, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  c.idPais       =  pc.idPais
    AND  f.idTipusIva   =  i.idTipusIva
    AND  cg.k           =  'NIF'
    AND  c.nif          != cg.v
    AND  f.data
      BETWEEN  cast(concat(exercici, '-01-01') AS date)
        AND    cast(concat(exercici, '-12-31') AS date)
  GROUP BY c.idProveidor
  HAVING bi >= 3005.06;

  UPDATE tbl347 t
  LEFT JOIN (
    SELECT v.idProveidor id, SUM(f.baseImp + (f.baseImp * f.iva * i.tipus)) imp
    FROM factura f, proveidor v, pais pv, tipusIva i, config c
    WHERE  f.idComprador  =  v.idProveidor
      AND  v.idPais       =  pv.idPais
      AND  f.idTipusIva   =  i.idTipusIva
      AND  c.k            =  'NIF'
      AND  v.nif          != c.v
      AND  f.data
        BETWEEN  cast(concat(exercici, '-01-01') AS date)
          AND    cast(concat(exercici, '-03-31') AS date)
    GROUP BY v.idProveidor
    ) as pt ON t.id = pt.id
  LEFT JOIN (
    SELECT v.idProveidor id, SUM(f.baseImp + (f.baseImp * f.iva * i.tipus)) imp
    FROM factura f, proveidor v, pais pv, tipusIva i, config c
    WHERE	f.idComprador  =  v.idProveidor
      AND	v.idPais       =  pv.idPais
      AND	f.idTipusIva   =  i.idTipusIva
      AND c.k            =  'NIF'
      AND v.nif          != c.v
      AND	f.data
        BETWEEN  cast(concat(exercici, '-04-01') AS date)
          AND    cast(concat(exercici, '-06-30') AS date)
    GROUP BY v.idProveidor
    ) as st ON t.id = st.id
  LEFT JOIN (
    SELECT v.idProveidor id, SUM(f.baseImp + (f.baseImp * f.iva * i.tipus)) imp
    FROM factura f, proveidor v, pais pv, tipusIva i, config c
    WHERE  f.idComprador  =  v.idProveidor
      AND  v.idPais       =  pv.idPais
      AND  f.idTipusIva   =  i.idTipusIva
      AND  c.k            =  'NIF'
      AND  v.nif          != c.v
      AND  f.data
        BETWEEN  cast(concat(exercici, '-07-01') AS date)
          AND    cast(concat(exercici, '-09-30') AS date)
    GROUP BY v.idProveidor
    ) as tt ON t.id = tt.id
  LEFT JOIN (
    SELECT v.idProveidor id, SUM(f.baseImp + (f.baseImp * f.iva * i.tipus)) imp
    FROM factura f, proveidor v, pais pv, tipusIva i, config c
    WHERE  f.idComprador  =  v.idProveidor
      AND  v.idPais       =  pv.idPais
      AND  f.idTipusIva   =  i.idTipusIva
      AND  c.k            =  'NIF'
      AND  v.nif          != c.v
      AND  f.data
        BETWEEN  cast(concat(exercici, '-10-01') AS date)
          AND    cast(concat(exercici, '-12-31') AS date)
    GROUP BY v.idProveidor
    ) as qt ON t.id = qt.id
  SET t.import1T = pt.imp, t.import2T = st.imp, t.import3T = tt.imp, t.import4T = qt.imp
  WHERE t.claveOp = 'B';

  SELECT * from tbl347;
  DROP TABLE tbl347;
END ;;
DELIMITER ;
