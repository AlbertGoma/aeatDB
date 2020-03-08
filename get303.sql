DELIMITER ;;
CREATE PROCEDURE `get303`(IN exercici YEAR, IN trimestre TINYINT UNSIGNED)
BEGIN
  DECLARE inici,
          fi   date;
  DECLARE regGral,                    -- Casella 07
          entrUe,                     -- Casella 59
          export,                     -- Casella 60
          adqUe,                      -- Caselles 10 i 36
          adqUeQ,                     -- Caselles 11 i 37
          nacionals,                  -- Casella 28
          nacionalsQ,                 -- Casella 29
          importacio,                 -- Casella 32
          importacioQ,                -- Casella 33
          importExempt decimal(10,2); -- Casella 61

  CALL periode(exercici, trimestre, inici, fi);

  SELECT sum(baseImp)
  INTO regGral
  FROM factura f, proveidor c, pais pc, proveidor v, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  c.idPais       =  pc.idPais
    AND  f.idProveidor  =  v.idProveidor
    AND  pc.iso         =  'ES'
    AND  cg.k           =  'NIF'
    AND  v.nif          =  cg.v
    AND  f.data         BETWEEN inici AND fi;
        
  SELECT sum(baseImp)
  INTO entrUe
  FROM factura f, proveidor c, pais pc, proveidor v, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  c.idPais       =  pc.idPais
    AND  f.idProveidor  =  v.idProveidor
    AND  pc.iso         != 'ES'
    AND  pc.ue          =  true
    AND  cg.k           =  'NIF'
    AND  v.nif          =  cg.v
    AND  f.data         BETWEEN inici AND fi;
        
  SELECT sum(baseImp)
  INTO export
  FROM factura f, proveidor c, pais pc, proveidor v, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  c.idPais       =  pc.idPais
    AND  f.idProveidor  =  v.idProveidor
    AND  pc.iso         != 'ES'
    AND  pc.ue          =  false
    AND  cg.k           =  'NIF'
    AND  v.nif          =  cg.v
    AND  f.data         BETWEEN inici AND fi;
    
  SELECT sum(f.baseImp), round(sum(f.baseImp * t.tipus), 2)
  INTO adqUe, adqUeQ
  FROM factura f, proveidor c, proveidor v, pais pv, tipusIva t, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  f.idTipusIva   =  t.idTipusIva
    AND  pv.iso         != 'ES'
    AND  pv.ue          =  true
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(f.baseImp), round(sum(f.baseImp * t.tipus), 2)
  INTO nacionals, nacionalsQ
  FROM factura f, proveidor c, proveidor v, pais pv, tipusIva t, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  f.idTipusIva   =  t.idTipusIva
    AND  pv.iso         =  'ES'
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(f.baseImp), round(sum(f.baseImp * t.tipus), 2)
  INTO importacio, importacioQ
  FROM factura f, proveidor c, proveidor v, pais pv, tipusIva t, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  f.idTipusIva   =  t.idTipusIva
    AND  pv.ue          =  false
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  f.esServei     =  false
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(f.baseImp)
  INTO importExempt
  FROM factura f, proveidor c, proveidor v, pais pv, tipusIva t, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  f.idTipusIva   =  t.idTipusIva
    AND  pv.ue          =  false
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  f.iva          =  false
    AND  f.data         BETWEEN inici AND fi;
        
  SELECT  regGral                   'Régimen Gral. [07]',
          round(regGral * 0.21, 2)  'Cuota [09]',
          nacionals                 'Op. Corrientes [28]',
          nacionalsQ                'Cuota Corr. [29]',
          adqUe                     'Adq. Intrac. [10][36]',
          adqUeQ                    'Cuota Intr. [11][37]',
          importExempt              'Op. Inv. Suj. Pasivo [61]',
          importacio                'Import. [32]',
          importacioQ               'Cuota Import. [33]',
          entrUe                    'Entregas Intrac. [59]',
          export                    'Exportaciones [60]';
END ;;
DELIMITER ;
