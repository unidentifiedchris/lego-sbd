-- Cleanup script: Drop all application objects

-- Drop sequences
BEGIN
  FOR r IN (
    SELECT sequence_name 
    FROM user_sequences 
    WHERE sequence_name IN (
      'S_PAISES', 'S_CLIENTES', 'S_FANS', 'S_INSCRIPCIONES',
      'S_INSCRITOS', 'S_ENTRADAS', 'S_ESTADOS', 'S_CIUDADES',
      'S_TIENDAS', 'S_TEMAS', 'S_JUGUETES', 'S_LOTES',
      'S_DESCUENTOS', 'S_FACTURA_FISICA', 'S_DET_FACTURA_FIS',
      'S_FACTURA_ONLINE', 'S_DET_FACTURA_ONL'
    )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE "' || r.sequence_name || '"';
  END LOOP;
END;
/

-- Drop views
BEGIN
  FOR r IN (
    SELECT view_name 
    FROM user_views 
    WHERE view_name LIKE 'V_%' OR view_name LIKE '%CATALOGO%'
  ) LOOP
    EXECUTE IMMEDIATE 'DROP VIEW "' || r.view_name || '"';
  END LOOP;
END;
/

-- Drop packages
BEGIN
  FOR r IN (
    SELECT object_name
    FROM user_objects
    WHERE object_type = 'PACKAGE'
      AND object_name LIKE 'PKG_LEGO%'
  ) LOOP
    EXECUTE IMMEDIATE 'DROP PACKAGE "' || r.object_name || '"';
  END LOOP;
END;
/

-- Drop functions
BEGIN
  FOR r IN (
    SELECT object_name
    FROM user_objects
    WHERE object_type = 'FUNCTION'
      AND (object_name LIKE 'FN_%' OR object_name = 'TIENDA_ABIERTA')
  ) LOOP
    EXECUTE IMMEDIATE 'DROP FUNCTION "' || r.object_name || '"';
  END LOOP;
END;
/

-- Drop types
BEGIN
  FOR r IN (
    SELECT type_name
    FROM user_types
    WHERE type_name LIKE 'T_%'
  ) LOOP
    EXECUTE IMMEDIATE 'DROP TYPE "' || r.type_name || '" FORCE';
  END LOOP;
END;
/

-- Drop tables
BEGIN
  FOR r IN (
    SELECT table_name 
    FROM user_tables 
    WHERE table_name IN (
      'PAISES', 'INSIDE_TOURS', 'CLIENTES_LEGO', 'FANS_MENOR_LEGO',
      'INSCRIPCIONES_TOUR', 'INSCRITOS', 'ENTRADAS', 'ESTADOS',
      'CIUDADES', 'TIENDAS', 'HORARIOS', 'TEMAS', 'JUGUETES',
      'CATALOGO_PAIS', 'LOTES_INVENTARIO', 'DESCUENTOS_INVENTARIO',
      'HISTORICO_PRECIO', 'FACTURA_FISICA', 'DET_FACTURA_FIS',
      'FACTURA_ONLINE', 'DET_FACTURA_ONL'
    )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE "' || r.table_name || '" CASCADE CONSTRAINTS PURGE';
  END LOOP;
END;
/

COMMIT;
