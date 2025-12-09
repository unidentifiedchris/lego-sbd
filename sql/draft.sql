CREATE OR REPLACE PROCEDURE SP_GENERAR_DESCUENTOS_DIARIOS(
    p_fecha IN DATE DEFAULT SYSDATE
) IS
BEGIN
    -- 1. Se insertan más columnas para cumplir con la nueva estructura de DESCUENTOS_INVENTARIO.
    INSERT INTO DESCUENTOS_INVENTARIO (
        ID_TIENDA,       -- NUEVA COLUMNA REQUERIDA
        ID_JUGUETE,
        NUMERO_LOTE,     -- NUEVA COLUMNA REQUERIDA
        ID_DESCUENTO,
        FECHA,
        CANTIDAD
    )
    SELECT
        vista_agrupada.ID_TIENDA,   -- Se selecciona ID_TIENDA
        vista_agrupada.ID_JUGUETE,
        vista_agrupada.NUMERO_LOTE, -- Se selecciona NUMERO_LOTE
        S_DESCUENTOS.NEXTVAL,
        TRUNC(p_fecha),
        vista_agrupada.TOTAL_VENDIDO
    FROM (
        -- Subconsulta: Agrupa las ventas físicas por la combinación (TIENDA, JUGUETE, LOTE)
        SELECT
            dff.ID_TIENDA,
            dff.ID_JUGUETE,
            dff.NUMERO_LOTE,
            COUNT(*) AS TOTAL_VENDIDO
        FROM
            FACTURA_FISICA ff
        JOIN
            DET_FACTURA_FIS dff 
            ON ff.ID_TIENDA = dff.ID_TIENDA 
            AND ff.NUM_FACTURA = dff.NUM_FACTURA
        WHERE
            TRUNC(ff.FECHA_EMISION) = TRUNC(p_fecha)
        GROUP BY
            dff.ID_TIENDA,
            dff.ID_JUGUETE,
            dff.NUMERO_LOTE
    ) vista_agrupada;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Descuentos generados exitosamente para el día ' || TO_CHAR(p_fecha, 'YYYY-MM-DD'));

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20110, 'Error en SP_GENERAR_DESCUENTOS_DIARIOS: ' || SQLERRM);
END SP_GENERAR_DESCUENTOS_DIARIOS;
/


SET SERVEROUTPUT ON;

DECLARE
    v_id_juguete      NUMBER;
    v_id_tienda_ue    NUMBER := 3;  
    v_id_tienda_noue  NUMBER := 4;  
    v_id_cliente_ue   NUMBER := 2;  
    v_id_cliente_noue NUMBER := 4;  
    v_lote_id_3       NUMBER;
    v_lote_id_4       NUMBER;

    v_fecha_prueba    DATE := TRUNC(SYSDATE); 
    
    v_conteo_total    NUMBER;
    v_descuento_ue    NUMBER;
    v_descuento_noue  NUMBER;
    
    -- CORRECCIÓN: Usar el tipo de colección GLOBAL T_NUMBER_ARRAY
    v_carrito_1 T_NUMBER_ARRAY := T_NUMBER_ARRAY(); 
    v_carrito_2 T_NUMBER_ARRAY := T_NUMBER_ARRAY();
    
    -- Variables para la limpieza
    v_num_factura_1 FACTURA_FISICA.NUM_FACTURA%TYPE;
    v_num_factura_2 FACTURA_FISICA.NUM_FACTURA%TYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- REINICIANDO PRUEBAS SP_GENERAR_DESCUENTOS_DIARIOS ---');

    -- 0.1. Obtener ID del juguete ('City Police Car')
    BEGIN
        SELECT ID_JUGUETE INTO v_id_juguete FROM JUGUETES 
        WHERE NOMBRE_JUGUETE = 'City Police Car' FETCH FIRST 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: No se encontró el juguete "City Police Car". Abortando pruebas.');
            RETURN;
    END;
    
    -- =========================================================
    -- PASO 1: LIMPIEZA Y RECREACIÓN DE VENTAS FÍSICAS
    -- =========================================================

    DBMS_OUTPUT.PUT_LINE('1. Limpiando y Recreando datos de Venta y Lotes (Fecha: ' || TO_CHAR(v_fecha_prueba, 'YYYY-MM-DD') || ')');

    -- Limpieza Profunda antes de re-insertar
    DELETE FROM Det_Factura_Fis WHERE ID_TIENDA IN (v_id_tienda_ue, v_id_tienda_noue) AND ID_JUGUETE = v_id_juguete;
    DELETE FROM Factura_Fisica ff WHERE ff.id_tienda IN (v_id_tienda_ue, v_id_tienda_noue);
    DELETE FROM DESCUENTOS_INVENTARIO WHERE ID_TIENDA IN (v_id_tienda_ue, v_id_tienda_noue) AND ID_JUGUETE = v_id_juguete AND TRUNC(FECHA) = v_fecha_prueba;
    DELETE FROM LOTES_INVENTARIO WHERE ID_TIENDA IN (v_id_tienda_ue, v_id_tienda_noue) AND ID_JUGUETE = v_id_juguete;
    COMMIT;
    
    -- 1.1. Re-crear Lotes (Mínimo requerido para que REGISTRAR_VENTA funcione)
    v_lote_id_3 := S_LOTES.nextval;
    INSERT INTO LOTES_INVENTARIO (NUMERO_LOTE, ID_TIENDA, ID_JUGUETE, CANTIDAD) VALUES (v_lote_id_3, v_id_tienda_ue, v_id_juguete, 5); -- Lote Tienda 3
    v_lote_id_4 := S_LOTES.nextval;
    INSERT INTO LOTES_INVENTARIO (NUMERO_LOTE, ID_TIENDA, ID_JUGUETE, CANTIDAD) VALUES (v_lote_id_4, v_id_tienda_noue, v_id_juguete, 5); -- Lote Tienda 4
    COMMIT;

    -- 1.2. Registrar Venta 1 (Tienda 3 / Dublin / UE)
    v_carrito_1.EXTEND(1);
    v_carrito_1(1) := v_id_juguete;
    -- Llamada correcta usando T_NUMBER_ARRAY:
    REGISTRAR_VENTA_LEGO_FISICA(v_id_cliente_ue, v_id_tienda_ue, v_carrito_1);
    
    -- 1.3. Registrar Venta 2 (Tienda 4 / El Trébol / Non-UE)
    v_carrito_2.EXTEND(1);
    v_carrito_2(1) := v_id_juguete;
    -- Llamada correcta usando T_NUMBER_ARRAY:
    REGISTRAR_VENTA_LEGO_FISICA(v_id_cliente_noue, v_id_tienda_noue, v_carrito_2);
    
    DBMS_OUTPUT.PUT_LINE('-> Dos ventas físicas recreadas para hoy.');

    -- =========================================================
    -- PASO 2: EJECUCIÓN Y VALIDACIÓN DE DESCUENTOS
    -- =========================================================
    
    -- 2.1. Ejecución del Procedimiento (usando la fecha de hoy)
    DBMS_OUTPUT.PUT_LINE('2. Ejecutando SP_GENERAR_DESCUENTOS_DIARIOS...');
    SP_GENERAR_DESCUENTOS_DIARIOS(v_fecha_prueba);

    -- 2.2. Validar Conteo Total
    SELECT COUNT(*) INTO v_conteo_total
    FROM DESCUENTOS_INVENTARIO
    WHERE TRUNC(FECHA) = v_fecha_prueba;
    
    IF v_conteo_total = 2 THEN
        DBMS_OUTPUT.PUT_LINE('  -> OK. Conteo total: ' || v_conteo_total || ' registros creados (Esperado: 2).');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  -> FALLO. Conteo total incorrecto: ' || v_conteo_total || ' (Esperado: 2).');
    END IF;

    -- 2.3. Verificar Descuento para Tienda UE (ID 3)
    SELECT NVL(SUM(CANTIDAD), 0) INTO v_descuento_ue
    FROM DESCUENTOS_INVENTARIO
    WHERE ID_TIENDA = v_id_tienda_ue AND TRUNC(FECHA) = v_fecha_prueba;
      
    IF v_descuento_ue = 1 THEN
        DBMS_OUTPUT.PUT_LINE('  -> OK. Descuento Tienda ' || v_id_tienda_ue || ' (Dublin): ' || v_descuento_ue || ' unidad(es) (Esperado: 1).');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  -> FALLO. Descuento Tienda ' || v_id_tienda_ue || ' (Dublin): ' || v_descuento_ue || ' (Esperado: 1).');
    END IF;

    -- 2.4. Verificar Descuento para Tienda Non-UE (ID 4)
    SELECT NVL(SUM(CANTIDAD), 0) INTO v_descuento_noue
    FROM DESCUENTOS_INVENTARIO
    WHERE ID_TIENDA = v_id_tienda_noue AND TRUNC(FECHA) = v_fecha_prueba;
      
    IF v_descuento_noue = 1 THEN
        DBMS_OUTPUT.PUT_LINE('  -> OK. Descuento Tienda ' || v_id_tienda_noue || ' (El Trébol): ' || v_descuento_noue || ' unidad(es) (Esperado: 1).');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  -> FALLO. Descuento Tienda ' || v_id_tienda_noue || ' (El Trébol): ' || v_descuento_noue || ' (Esperado: 1).');
    END IF;
    
    -- 3. Limpieza final de la prueba de descuentos
    DELETE FROM DESCUENTOS_INVENTARIO WHERE TRUNC(FECHA) = v_fecha_prueba;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- PRUEBAS COMPLETADAS ---');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR FATAL DURANTE LA PRUEBA: ' || SQLERRM);
END;
/