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
    -- =================================================================
    -- PARÁMETROS DE LA PRUEBA (MODIFICAR ESTOS VALORES)
    -- =================================================================
    p_fecha_prueba    DATE   := TRUNC(SYSDATE); -- << Fecha para la cual se generarán las ventas y descuentos.
    p_id_tienda_1     NUMBER := 3;              -- << ID de la primera tienda de prueba.
    p_id_tienda_2     NUMBER := 4;              -- << ID de la segunda tienda de prueba.
    p_id_cliente_1    NUMBER := 2;              -- << ID del cliente para la primera venta.
    p_id_cliente_2    NUMBER := 4;              -- << ID del cliente para la segunda venta.
    p_id_juguete      NUMBER := 9022;           -- << ID del juguete que se venderá.

    -- Variables internas de la prueba
    v_lote_id_1       NUMBER;
    v_lote_id_2       NUMBER;
    v_carrito         T_NUMBER_ARRAY := T_NUMBER_ARRAY();
    v_conteo_esperado NUMBER := 2; -- << Número de registros de descuento que se espera crear.
    v_conteo_actual   NUMBER;
    v_descuento_1     NUMBER;
    v_descuento_2     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('Iniciando prueba para SP_GENERAR_DESCUENTOS_DIARIOS...');
    DBMS_OUTPUT.PUT_LINE('Fecha de prueba: ' || TO_CHAR(p_fecha_prueba, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('=================================================================');

    -- =================================================================
    -- BLOQUE 1: Configuración de datos de prueba
    -- Se crean lotes y se registran ventas para la fecha de prueba.
    -- =================================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- SETUP: Insertando datos de prueba (Lotes y Ventas) ---');

    -- Crear lotes con stock para el juguete en las tiendas de prueba.
    v_lote_id_1 := S_LOTES.nextval;
    INSERT INTO LOTES_INVENTARIO (NUMERO_LOTE, ID_TIENDA, ID_JUGUETE, CANTIDAD)
    VALUES (v_lote_id_1, p_id_tienda_1, p_id_juguete, 10);

    v_lote_id_2 := S_LOTES.nextval;
    INSERT INTO LOTES_INVENTARIO (NUMERO_LOTE, ID_TIENDA, ID_JUGUETE, CANTIDAD)
    VALUES (v_lote_id_2, p_id_tienda_2, p_id_juguete, 10);

    -- Simular ventas para el día de hoy.
    v_carrito.EXTEND(1);
    v_carrito(1) := p_id_juguete;

    -- Venta 1: 1 unidad del juguete en la tienda 1.
    REGISTRAR_VENTA_LEGO_FISICA(p_id_cliente_1, p_id_tienda_1, v_carrito);

    -- Venta 2: 1 unidad del juguete en la tienda 2.
    REGISTRAR_VENTA_LEGO_FISICA(p_id_cliente_2, p_id_tienda_2, v_carrito);

    DBMS_OUTPUT.PUT_LINE(' -> ÉXITO: Se crearon 2 lotes y se registraron 2 ventas.');

    -- =================================================================
    -- BLOQUE 2: Ejecución y Verificación
    -- =================================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- EJECUCIÓN: Generando descuentos ---');

    SP_GENERAR_DESCUENTOS_DIARIOS(p_fecha_prueba);

    -- Verificar que se crearon el número esperado de registros de descuento.
    SELECT COUNT(*) INTO v_conteo_actual FROM DESCUENTOS_INVENTARIO WHERE TRUNC(FECHA) = p_fecha_prueba;
    DBMS_OUTPUT.PUT_LINE(' -> VERIFY: Se crearon ' || v_conteo_actual || ' registros de descuento (Esperado: ' || v_conteo_esperado || ').');

    -- =================================================================
    -- BLOQUE 3: Limpieza
    -- =================================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '=================================================================');
    DBMS_OUTPUT.PUT_LINE('Prueba finalizada. Revirtiendo todos los cambios.');
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Rollback completado.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: La prueba falló inesperadamente.');
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
        ROLLBACK;
END;
/