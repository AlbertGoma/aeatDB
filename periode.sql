DELIMITER ;;
CREATE PROCEDURE `periode`(IN exercici YEAR, IN trimestre TINYINT UNSIGNED, OUT inici DATE, OUT fi DATE)
BEGIN
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
END ;;
DELIMITER ;
