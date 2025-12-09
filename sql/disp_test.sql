CREATE OR REPLACE FUNCTION FN_CALCULAR_STOCK_NETO (
    p_id_tienda IN NUMBER,
    p_id_juguete IN NUMBER
)
RETURN NUMBER
IS
    v_total_en_lotes NUMBER(6) := 0;
    v_total_descontado NUMBER(6) := 0;
    v_stock_neto NUMBER(6);
BEGIN
    -- 1. Sumar la cantidad total del juguete en todos los LOTES (NUMERO_LOTE) de la tienda.
    SELECT NVL(SUM(CANTIDAD), 0)
    INTO v_total_en_lotes
    FROM LOTES_INVENTARIO
    WHERE ID_TIENDA = p_id_tienda
      AND ID_JUGUETE = p_id_juguete;

    -- Si no hay stock en lotes, retornamos 0 inmediatamente.
    IF v_total_en_lotes = 0 THEN
        RETURN 0;
    END IF;

    -- 2. Sumar la cantidad total registrada en DESCUENTOS_INVENTARIO 
    --    para ese juguete y tienda.
    --    (Esta suma agrupa todos los descuentos de TODOS los lotes de ese juguete en esa tienda)
    SELECT NVL(SUM(CANTIDAD), 0)
    INTO v_total_descontado
    FROM DESCUENTOS_INVENTARIO
    WHERE ID_TIENDA = p_id_tienda
      AND ID_JUGUETE = p_id_juguete;
    
    -- 3. Calcular el stock neto (Lotes - Descuentos)
    v_stock_neto := v_total_en_lotes - v_total_descontado;

    -- 4. Devolver el resultado, asegurando que el stock neto nunca sea negativo.
    RETURN CASE 
               WHEN v_stock_neto < 0 THEN 0 
               ELSE v_stock_neto 
           END;

EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de otros errores generales.
        RAISE_APPLICATION_ERROR(-20040, 'Error al calcular el stock neto: ' || SQLERRM);
END FN_CALCULAR_STOCK_NETO;
/


SET SERVEROUTPUT ON;

DECLARE
    v_id_tienda_ue      NUMBER := 3;  
    v_id_juguete        NUMBER;       
    
    v_lote_inicial      NUMBER := 5;
    v_descuento_prueba  NUMBER := 2;
    v_lote_id           NUMBER;       
    
    v_resultado NUMBER;
    v_total_lotes_actual NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- INICIANDO PRUEBAS FN_CALCULAR_STOCK_NETO ---');

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
    -- PASO 0: LIMPIEZA CORRECTA (Hijo antes que Padre)
    -- =========================================================
    
    -- Limpiar detalles de factura y facturas (para evitar ORA-02292 en LOTES_INVENTARIO)
    DELETE FROM Det_Factura_Fis WHERE ID_TIENDA = v_id_tienda_ue AND ID_JUGUETE = v_id_juguete;
    DELETE FROM Factura_Fisica ff WHERE ff.id_tienda = v_id_tienda_ue AND ff.num_factura IN (SELECT num_factura FROM Det_Factura_Fis dff WHERE dff.id_tienda = v_id_tienda_ue AND dff.id_juguete = v_id_juguete);
    
    -- Limpiar descuentos
    DELETE FROM DESCUENTOS_INVENTARIO WHERE ID_TIENDA = v_id_tienda_ue AND ID_JUGUETE = v_id_juguete;
      
    -- Limpiar lotes
    DELETE FROM LOTES_INVENTARIO WHERE ID_TIENDA = v_id_tienda_ue AND ID_JUGUETE = v_id_juguete;
      
    COMMIT;
    
    -- =========================================================
    -- CASO 1: Stock Normal (Lotes: 5, Descuentos: 0)
    -- =========================================================
    DBMS_OUTPUT.PUT_LINE('1. Caso Stock Normal (5 - 0)');

    v_lote_id := S_LOTES.nextval;
    INSERT INTO LOTES_INVENTARIO (NUMERO_LOTE, ID_TIENDA, ID_JUGUETE, CANTIDAD)
    VALUES (v_lote_id, v_id_tienda_ue, v_id_juguete, v_lote_inicial);
    COMMIT;
    
    v_resultado := FN_CALCULAR_STOCK_NETO(v_id_tienda_ue, v_id_juguete);
    
    IF v_resultado = v_lote_inicial THEN
        DBMS_OUTPUT.PUT_LINE('  -> OK. Stock Neto: ' || v_resultado);
    ELSE
        DBMS_OUTPUT.PUT_LINE('  -> FALLO. Stock Neto: ' || v_resultado || ' (Esperado: ' || v_lote_inicial || ')');
    END IF;

    -- =========================================================
    -- CASO 2: Con Descuentos (Lotes: 5, Descuentos: 2)
    -- =========================================================
    DBMS_OUTPUT.PUT_LINE('2. Caso Con Descuentos (' || v_lote_inicial || ' - ' || v_descuento_prueba || ')');
    
    -- Insertar descuento, referenciando el lote creado
    INSERT INTO DESCUENTOS_INVENTARIO (ID_TIENDA, ID_JUGUETE, NUMERO_LOTE, ID_DESCUENTO, FECHA, CANTIDAD)
    VALUES (v_id_tienda_ue, v_id_juguete, v_lote_id, S_DESCUENTOS.nextval, SYSDATE, v_descuento_prueba);
    COMMIT;
    
    v_resultado := FN_CALCULAR_STOCK_NETO(v_id_tienda_ue, v_id_juguete);
    
    v_total_lotes_actual := v_lote_inicial - v_descuento_prueba;
    IF v_resultado = v_total_lotes_actual THEN
        DBMS_OUTPUT.PUT_LINE('  -> OK. Stock Neto: ' || v_resultado);
    ELSE
        DBMS_OUTPUT.PUT_LINE('  -> FALLO. Stock Neto: ' || v_resultado || ' (Esperado: ' || v_total_lotes_actual || ')');
    END IF;
    
    -- =========================================================
    -- CASO 3: Stock Cero (Tienda/Juguete sin lotes)
    -- =========================================================
    DBMS_OUTPUT.PUT_LINE('3. Caso Stock Cero (Tienda 8, Juguete ' || v_id_juguete || ')');
    
    v_resultado := FN_CALCULAR_STOCK_NETO(8, v_id_juguete);
    
    IF v_resultado = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  -> OK. Stock Neto: ' || v_resultado || ' (Esperado: 0)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  -> FALLO. Stock Neto: ' || v_resultado || ' (Esperado: 0)');
    END IF;

    -- =========================================================
    -- Caso 4: Descuento mayor al Lote (Resultado negativo)
    -- =========================================================
    DBMS_OUTPUT.PUT_LINE('4. Caso Lote vs Descuento (5 - 10 = 0)');
    
    -- Insertar descuento masivo (referenciando el lote creado)
    INSERT INTO DESCUENTOS_INVENTARIO (ID_TIENDA, ID_JUGUETE, NUMERO_LOTE, ID_DESCUENTO, FECHA, CANTIDAD)
    VALUES (v_id_tienda_ue, v_id_juguete, v_lote_id, S_DESCUENTOS.nextval, SYSDATE, 8); 
    COMMIT;
    
    v_resultado := FN_CALCULAR_STOCK_NETO(v_id_tienda_ue, v_id_juguete);
    
    IF v_resultado = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  -> OK. El stock neto es 0 (Esperado: 0)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  -> FALLO. Stock Neto: ' || v_resultado || ' (Esperado: 0)');
    END IF;
    
    -- =========================================================
    -- LIMPIEZA FINAL
    -- =========================================================
    DELETE FROM Det_Factura_Fis 
    WHERE ID_TIENDA = v_id_tienda_ue 
      AND ID_JUGUETE = v_id_juguete;
      
    DELETE FROM Factura_Fisica ff
    WHERE ff.id_tienda = v_id_tienda_ue 
      AND ff.num_factura IN (SELECT num_factura FROM Det_Factura_Fis dff 
                             WHERE dff.id_tienda = v_id_tienda_ue AND dff.id_juguete = v_id_juguete);
    
    DELETE FROM DESCUENTOS_INVENTARIO WHERE ID_TIENDA = v_id_tienda_ue AND ID_JUGUETE = v_id_juguete;
    DELETE FROM LOTES_INVENTARIO WHERE ID_TIENDA = v_id_tienda_ue AND ID_JUGUETE = v_id_juguete;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('--- PRUEBAS COMPLETADAS ---');

END;
/