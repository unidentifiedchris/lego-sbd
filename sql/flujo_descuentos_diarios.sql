-- =================================================================
-- flujo_descuentos_diarios.sql
--
-- Plantilla para probar el procedimiento de generación de descuentos
-- diarios de inventario (SP_GENERAR_DESCUENTOS_DIARIOS).
--
-- Este script simula ventas físicas para un día específico, ejecuta
-- el procedimiento de descuentos y luego verifica que los descuentos
-- se hayan creado correctamente.
--
-- El script está diseñado para no dejar datos de prueba en la base de datos.
-- =================================================================

SET SERVEROUTPUT ON;

DECLARE
    p_fecha_prueba    DATE   := DATE(&p_fecha);

BEGIN

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- EJECUCIÓN: Generando descuentos ---');

    SP_GENERAR_DESCUENTOS_DIARIOS(p_fecha_prueba);
    DBMS_OUTPUT.PUT_LINE(' -> ÉXITO: El procedimiento SP_GENERAR_DESCUENTOS_DIARIOS se ejecutó para la fecha ' || TO_CHAR(p_fecha_prueba, 'YYYY-MM-DD') || '.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No se encontraron descuentos posibles para esta fecha.');
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
        ROLLBACK;
END;
/

SELECT * FROM V_DESCUENTOS_DIARIOS;
--WHERE FECHA_DESCUENTO = DATE(&p_fecha);
/