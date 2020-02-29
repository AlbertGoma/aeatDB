DELIMITER ;;
CREATE PROCEDURE `get390`(IN exercici YEAR)
BEGIN
  DECLARE  inici,
           fi    date;

  DECLARE  regimOrd,        -- 05
                            -- 06
           importExempt,    -- 110
           intraServ,       -- 551, 637
                            -- 552, 638
           intraBens,       -- 25,  629
                            -- 26,  630
           nacionalsRed,    -- 603
           nacionals,       -- 605
                            -- 606
           importBens,      -- 621
                            -- 622
           volRegGral,      -- 99
           volUeExempt,     -- 103
           export           -- 110
                            decimal(10,2);

  SET  inici  :=  date(concat(exercici, '-01-01')),
       fi     :=  date(concat(exercici, '-12-31'));

  SELECT sum(baseImp)
  INTO regimOrd
  FROM factura f, proveidor c, pais pc, proveidor v, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  c.idPais       =  pc.idPais
    AND  f.idProveidor  =  v.idProveidor
    AND  pc.iso         =  'ES'
    AND  cg.k           =  'NIF'
    AND  v.nif          =  cg.v
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(baseImp)
  INTO volRegGral
  FROM factura f, proveidor v, config cg
  WHERE  f.idProveidor  =  v.idProveidor
    AND  cg.k           =  'NIF'
    AND  v.nif          =  cg.v
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(baseImp)
  INTO volUeExempt
  FROM factura f, proveidor c, pais pc, proveidor v, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  c.idPais       =  pc.idPais
    AND  f.idProveidor  =  v.idProveidor
    AND  pc.iso         != 'ES'
    AND  pc.ue          =  true
    AND  f.iva          =  false
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
    AND  f.iva          =  false
    AND  cg.k           =  'NIF'
    AND  v.nif          =  cg.v
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(baseImp)
  INTO intraServ
  FROM factura f, proveidor c, proveidor v, pais pv, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  pv.iso         != 'ES'
    AND  pv.ue          =  true
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  f.esServei     =  true
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(baseImp)
  INTO intraBens
  FROM factura f, proveidor c, proveidor v, pais pv, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  pv.iso         != 'ES'
    AND  pv.ue          =  true
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  f.esServei     =  false
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(baseImp)
  INTO nacionals
  FROM factura f, proveidor c, proveidor v, pais pv, tipusIva t, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  f.idTipusIva   =  t.idTipusIva
    AND  t.tipus        =  0.21
    AND  pv.iso         =  'ES'
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(baseImp)
  INTO nacionalsRed
  FROM factura f, proveidor c, proveidor v, pais pv, tipusIva t, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  f.idTipusIva   =  t.idTipusIva
    AND  t.tipus        =  0.10
    AND  pv.iso         =  'ES'
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(baseImp)
  INTO importBens
  FROM factura f, proveidor c, proveidor v, pais pv, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  pv.ue          =  false
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  f.esServei     =  false
    AND  f.data         BETWEEN inici AND fi;

  SELECT sum(baseImp)
  INTO importExempt
  FROM factura f, proveidor c, proveidor v, pais pv, config cg
  WHERE  f.idComprador  =  c.idProveidor
    AND  f.idProveidor  =  v.idProveidor
    AND  v.idPais       =  pv.idPais
    AND  pv.ue          =  false
    AND  cg.k           =  'NIF'
    AND  c.nif          =  cg.v
    AND  f.iva          =  false
    AND  f.data         BETWEEN inici AND fi;

  SELECT  regimOrd                       'Régimen Ord. [05]',
          round(regimOrd * 0.21, 2)      'Cuota [06]',
          importExempt                   'Import. Exentas [110]',
          nacionalsRed                   'Op. Corrientes [603]',
          round(nacionalsRed * 0.10, 2)  'Cuota [604]',
          nacionals                      'Op. Corrientes [605]',
          round(nacionals * 0.21, 2)     'Cuota [606]',
          intraBens                      'Bienes Intracom. [25][629]',
          round(intraBens * 0.21, 2)     'Cuota [26][630]',
          intraServ                      'Servicios Intracom. [551][637]',
          round(intraServ * 0.21, 2)     'Cuota [552][638]',
          importBens                     'Import. Bienes [621]',
          round(importBens * 0.21, 2)    'Cuota [622]',
          volRegGral                     'Op. Régimen Gral. [99]',
          volUeExempt                    'Entr. Intracom. Exentas [103]',
          export                         'Op. Invers. Suj. Pasivo [110]';
END ;;
DELIMITER ;
